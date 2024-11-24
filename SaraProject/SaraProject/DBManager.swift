//
//  DBManager.swift
//  SaraProject
//
//  Created by Bilal Mughal on 13/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

struct PaintingModel: Codable {
    var identifier: String
    var image: String
    var title: String
    var subtitle: String
    var isFavourite: Bool
}

struct DBManager {
    
    static var shared = DBManager()
    
    private init(){}
    
    private let database = Database.database().reference()
    
    private let paintingDB = Firestore.firestore().collection("Paintings")
    private let favouriteDB = Firestore.firestore().collection("Favourites")
    
    var userId: String = ""
    var email: String = ""
    
    // MARK: # --------------------- LOGIN ---------------------- # -
    
    func loginUser(email: String, password: String, completion: @escaping (String) -> Void, err: @escaping (Error) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                err(error)
                return
            }
            print("User logged in with UID: \(authResult?.user.uid ?? "No UID")")
            completion(authResult?.user.uid ?? "No UID")
        }
    }
    
    
    
       
    func signUpUser(email: String, password: String, completion: @escaping () -> Void, err: @escaping (Error) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                err(error)
                return
            }
            print("User signed up with UID: \(authResult?.user.uid ?? "No UID")")
            completion()
        }
    }
    
    func storeProfileImage(_ data: String, userId: String) {
        let databaseRef = Database.database().reference().child("users").child(userId).child("profile_img")
        
        // Set the base64 string as the value in the database
        databaseRef.setValue(data) { error, _ in
            if let error = error {
                print("Failed to store image:", error.localizedDescription)
            } else {
                print("Image stored successfully in Realtime Database")
            }
        }
    }
    
    func fetchProfileImage(userId: String, completion: @escaping (Data?) -> Void) {
        let databaseRef = Database.database().reference().child("users").child(userId).child("profile_img")
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            // Ensure the value is a string (base64 format)
            if let base64String = snapshot.value as? String,
               let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                completion(imageData)
            } else {
                print("Failed to fetch image or invalid data format.")
                completion(nil)
            }
        }
    }
    
    // MARK: # --------------------- ADD FAVOURITE PAINTING ---------------------- # -
    
    func AddFavourite(for userId: String, painting: PaintingModel, completion: @escaping (Error?) -> Void) {
        let paintingsRef = database.child("users").child(userId).child("favourites")
        
        do {
            // Encode the PaintingModel instance (painting) to JSON
            let paintingData = try JSONEncoder().encode(painting)
            
            // Convert the JSON data into a dictionary that Firebase can store
            if var paintingDict = try JSONSerialization.jsonObject(with: paintingData) as? [String: Any] {
                // Remove the "id" field if you don't want it in Firebase
                paintingDict.removeValue(forKey: "id")
                
                // Push the painting as a new element in the paintings array (without unique IDs)
                paintingsRef.observeSingleEvent(of: .value) { snapshot in
                    var paintingsArray = [Any]()
                    if let currentPaintings = snapshot.value as? [Any] {
                        paintingsArray = currentPaintings
                    }
                    
                    // Append the new painting to the array
                    paintingsArray.append(paintingDict)
                    
                    // Save the updated paintings array to Firebase
                    paintingsRef.setValue(paintingsArray) { error, _ in
                        completion(error)
                    }
                }
            }
        } catch {
            completion(error)
        }
    }
    
    // MARK: # --------------------- UPLOAD IMAGE IN FIREBASE ------------------ # -
    
    func uploadImageToStorage(imageString: String, completion: @escaping (Error?) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()
        
        // Update Firestore document for the user
        let userRef = db.collection("users").document(userId)
        userRef.setData(["profileImage": imageString]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error saving profile image: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Profile image saved successfully!")
                    completion(nil)
                }
            }
        }
        
    }
    
    // MARK: # --------------------- FETCH IMAGE IN FIREBASE ------------------ # -
    
    func fetchProfileImageFromFirestore(completion: @escaping (UIImage?, Error?) -> Void) {
        // Reference to Firestore
        let db = Firestore.firestore()

        // Get user document
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching profile image: \(error.localizedDescription)")
                completion(nil, error)
            } else if let document = document, document.exists, let data = document.data(),
                      let base64Image = data["profileImage"] as? String,
                      let imageData = Data(base64Encoded: base64Image),
                      let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(image, nil)
                }
                
            } else {
                print("No profile image found.")
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
    
    // MARK: # --------------------- ADD PAINTING ---------------------- # -
    
    func addPaintingInFirestore(
        _ identifier: String,
        _ painting: PaintingModel,
        _ completion: @escaping (String) -> Void,
        _ err: @escaping (Error) -> Void) {
            
//        let base64Image = painting.image.base64EncodedString()
            
            let paintingRef = Firestore.firestore()
                .collection("users")
                .document(identifier)
                .collection("paintings")
                .document(painting.identifier)
            
            let paintingData: [String: Any] = [
                "identifier": painting.identifier,
                "image": painting.image,
                "title": painting.title,
                "subtitle": painting.subtitle,
                "favourite": painting.isFavourite
            ]
            
            paintingRef.setData(paintingData) { error in
                if let error = error {
                    print("Error saving painting: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        err(error)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("Painting saved successfully")
                    }
                    
                }
            }
    }
    

    // MARK: # --------------------- DELETE PAINTING ---------------------- # -
    
    func deletePainting(for userId: String, paintingId: String, completion: @escaping (Error?) -> Void) {
        
        // Reference to Firestore
        let db = Firestore.firestore()
        
        // Subcollection path: "users/{userID}/paintings/{paintingID}"
        let paintingRef = db.collection("users").document(userId).collection("paintings").document(paintingId)
        
        // Delete the document
        paintingRef.delete { error in
            if let error = error {
                print("Error deleting painting: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                
            } else {
                print("Painting deleted successfully!")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
    }
    
    // MARK: # --------------------- DELETE FAVOURITE PAINTING ---------------------- # -
    
    func deleteFavouritePainting(for userId: String, paintingId: String, completion: @escaping (Error?) -> Void) {
        let paintingsRef = database.child("users").child(userId).child("favourites")
        
        paintingsRef.observeSingleEvent(of: .value) { snapshot in
            guard var paintingsArray = snapshot.value as? [[String: Any]] else {
                completion(NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch paintings"]))
                return
            }
            
            // Find the index of the painting to delete
            if let index = paintingsArray.firstIndex(where: { $0["identifier"] as? String == paintingId }) {
                // Remove the painting from the array
                paintingsArray.remove(at: index)
                
                // Save the updated array
                paintingsRef.setValue(paintingsArray) { error, _ in
                    completion(error)
                }
            } else {
                completion(NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Painting not found"]))
            }
        }
    }

    
    // MARK: # --------------------- UPDATE PAINTING ---------------------- # -
    
    func updatePainting(for userId: String, identifier: String, updatedPainting: PaintingModel, completion: @escaping (Error?) -> Void) {
        
        // Reference to Firestore
           let db = Firestore.firestore()
           
           // Subcollection path: "users/{userID}/paintings/{paintingID}"
           let paintingRef = db.collection("users").document(userId).collection("paintings").document(updatedPainting.identifier)
           
           
           // Create dictionary for updated painting data
           let updatedData: [String: Any] = [
               "identifier": updatedPainting.identifier,
               "image": updatedPainting.image,
               "title": updatedPainting.title,
               "subtitle": updatedPainting.subtitle,
               "favourite": updatedPainting.isFavourite
           ]
           
           // Update the document
           paintingRef.updateData(updatedData) { error in
               if let error = error {
                   print("Error updating painting: \(error.localizedDescription)")
                   DispatchQueue.main.async {
                       completion(error)
                   }
                   
               } else {
                   print("Painting updated successfully!")
                   DispatchQueue.main.async {
                       completion(nil)
                   }
               }
           }
    
    }
    
    
    // MARK: # --------------------- LIST OF PAINTING ---------------------- # -
    
    func listPaintings(for userId: String, completion: @escaping ([PaintingModel]?, Error?) -> Void) {
        
        let db = Firestore.firestore()
            let paintingsRef = db.collection("users").document(userId).collection("paintings")
            
            paintingsRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching paintings: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                
                let paintings = documents.compactMap { doc -> PaintingModel? in
                    let data = doc.data()
                    guard
                        let identifier = data["identifier"] as? String,
                        let base64Image = data["image"] as? String,
                        let imageData = Data(base64Encoded: base64Image),
                        let title = data["title"] as? String,
                        let subtitle = data["subtitle"] as? String,
                        let favourite = data["favourite"] as? Bool
                    else { return nil }
                    
                    return PaintingModel(identifier: identifier, image: base64Image, title: title, subtitle: subtitle, isFavourite: favourite)
                }
                DispatchQueue.main.async {
                    completion(paintings, nil)
                }
               
            }
        
    }
    
    
    // MARK: # --------------------- PAINTING EXIST OR NOT ---------------------- # -
    func doesPaintingExist(paintingID: String, completion: @escaping (Bool, Bool?, Error?) -> Void) {
        // Reference to Firestore
           let db = Firestore.firestore()

           // Path to the specific painting document
           let paintingRef = db.collection("users").document(userId).collection("paintings").document(paintingID)

           // Fetch the document
           paintingRef.getDocument { document, error in
               DispatchQueue.main.async {
                   if let error = error {
                       // Return false with the error if fetching fails
                       completion(false, nil, error)
                   } else if let document = document, document.exists {
                       // Check if 'isFavourite' field exists and its value
                       if let isFavourite = document.data()?["favourite"] as? Bool {
                           completion(true, isFavourite, nil)
                       } else {
                           // If 'isFavourite' field does not exist
                           completion(true, nil, nil)
                       }
                   } else {
                       // Document does not exist
                       completion(false, nil, nil)
                   }
               }
           }
    }
    
    // MARK: # --------------------- LIST OF FAVOURITES PAINTING ---------------------- # -
    
    func listFavouritePaintings(for userId: String, completion: @escaping ([PaintingModel]?, Error?) -> Void) {
        let paintingsRef = database.child("users").child(userId).child("favourites")
        
        paintingsRef.observeSingleEvent(of: .value) { snapshot in
            guard let paintingsArray = snapshot.value as? [[String: Any]] else {
                completion(nil, NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch paintings"]))
                return
            }
            
            // Map the paintings to PaintingModel instances
            let paintings = paintingsArray.compactMap { paintingDict -> PaintingModel? in
                // Convert the dictionary to Data
                guard let data = try? JSONSerialization.data(withJSONObject: paintingDict, options: []) else {
                    return nil
                }
                
                // Decode the Data into PaintingModel
                do {
                    let painting = try JSONDecoder().decode(PaintingModel.self, from: data)
                    return painting
                } catch {
                    return nil
                }
            }
            
            completion(paintings, nil)
        }
    }

    
    var generateRandomString: String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).compactMap { _ in characters.randomElement() })
    }

}
