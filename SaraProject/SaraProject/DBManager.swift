//
//  DBManager.swift
//  SaraProject
//
//  Created by Bilal Mughal on 13/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase


struct PaintingModel: Codable {
    var identifier: String
    var image: Data
    var title: String
    var subtitle: String
}

struct DBManager {
    
    static var shared = DBManager()
    
    private init(){}
    
    private let database = Database.database().reference()
    
    var userId: String = ""
    var email: String = ""
    
    // MARK: # --------------------- LOGIN ---------------------- # -
    
    func loginUser(email: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            print("User logged in with UID: \(authResult?.user.uid ?? "No UID")")
            completion(authResult?.user.uid ?? "No UID")
        }
    }
    
    
    // MARK: # --------------------- REGISTRATION ---------------------- # -
       
    func signUpUser(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
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
    
    
    // MARK: # --------------------- ADD PAINTING ---------------------- # -
    
    func addPainting(for userId: String, painting: PaintingModel, completion: @escaping (Error?) -> Void) {
        let paintingsRef = database.child("users").child(userId).child("paintings")
        
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

    // MARK: # --------------------- DELETE PAINTING ---------------------- # -
    
    func deletePainting(for userId: String, paintingId: String, completion: @escaping (Error?) -> Void) {
        let paintingsRef = database.child("users").child(userId).child("paintings")
        
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
        let paintingsRef = database.child("users").child(userId).child("paintings")
        
        paintingsRef.observeSingleEvent(of: .value) { snapshot in
            guard var paintingsArray = snapshot.value as? [[String: Any]] else {
                completion(NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch paintings"]))
                return
            }
            
            // Find the index of the painting to update
            if let index = paintingsArray.firstIndex(where: { $0["identifier"] as? String == identifier }) {
                do {
                    // Encode the updated painting
                    let updatedPaintingData = try JSONEncoder().encode(updatedPainting)
                    if let updatedPaintingDict = try JSONSerialization.jsonObject(with: updatedPaintingData) as? [String: Any] {
                        // Remove the "id" field if not required
                        var updatedDict = updatedPaintingDict
                        updatedDict.removeValue(forKey: "id")
                        
                        // Replace the old painting with the new one
                        paintingsArray[index] = updatedDict
                        
                        // Save the updated array
                        paintingsRef.setValue(paintingsArray) { error, _ in
                            completion(error)
                        }
                    }
                } catch {
                    completion(error)
                }
            } else {
                completion(NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "Painting not found"]))
            }
        }
    }
    
    
    // MARK: # --------------------- LIST OF PAINTING ---------------------- # -
    
    func listPaintings(for userId: String, completion: @escaping ([PaintingModel]?, Error?) -> Void) {
        let paintingsRef = database.child("users").child(userId).child("paintings")
        
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
