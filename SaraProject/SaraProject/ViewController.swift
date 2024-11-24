//
//  ViewController.swift
//  SaraProject
//
//  Created by Bilal Mughal on 13/11/2024.
//

import UIKit

struct Painting {
    var imageBase64: String?  // Base64 image string
    var title: String
    var artist: String
    var year: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagePickerCompletionHandler: ((UIImage?) -> Void)?
    
    var paintings: [PaintingModel] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        startLoading()
        fetchList(id: DBManager.shared.userId) { arr in
            self.stopLoading()
            self.paintings = arr
            self.tableView.reloadData()
        }
        
        
        emailLbl.text = DBManager.shared.email
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(openImageGallery))
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(longPressRecognizer)
        
        
//        if let imageData = Data(base64Encoded: painting.image, options: .ignoreUnknownCharacters) {
//
//        }
        startLoading()
        DBManager.shared.fetchProfileImageFromFirestore { image, error in
            self.stopLoading()
            if let error = error {
                print("Failed to fetch profile image: \(error.localizedDescription)")
            } else if let image = image {
                print("Profile image fetched successfully.")
                self.profileImg.image = image
                // Use the image (e.g., display in UIImageView)
            } else {
                print("No profile image found.")
            }
        }
        
//        DBManager.shared.fetchProfileImage(userId: DBManager.shared.userId) { data in
//            DispatchQueue.main.async {
//                if let datas = data, let imageData = UIImage(data: datas) {
//                    self.profileImg.image = imageData
//                }
//                else {
//                    self.profileImg.image = UIImage(systemName: "person.fill")
//                }
//            }
//        }
        
    }
    
 
    @objc func openImageGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func addPainting(_ sender: UIBarButtonItem) {
        barBtn()
    }
    
    @IBAction func addPaint(_ sender: Any) {
        barBtn()
    }
    

    func fetchList(id: String,  _ completion: @escaping ([PaintingModel]) -> ()) {
        DBManager.shared.listPaintings(for: id) { resp, err in
            if let _ = err {
                print("Error")
            }
            else {
                completion(resp ?? [])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail",
           let destinationVC = segue.destination as? PaintingDetailVC, // Replace with your destination VC
           let indexPath = sender as? IndexPath {
            let selectedItem = paintings[indexPath.row]
            destinationVC.paintingModel = selectedItem // Adjust according to your data model
            destinationVC.fromFavourites = false 
        }
    }
    
}



// MARK: # --------------------------- BAR BUTTON ------------------------------ # -

extension ViewController {
    func barBtn() {
        let alert = UIAlertController(title: "New Painting", message: "Enter painting details", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Subtitle" }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alert.textFields?[0].text,
                  let subtitle = alert.textFields?[1].text else { return }
            
            self.presentImagePicker { selectedImage in
                var imageBase64: String? = nil
                
                if let imageData = selectedImage?.jpegData(compressionQuality: 0.01) {
//                if let imageData = self.compressImageToLimit(image: selectedImage!, limitInMB: 0.5) {
                    imageBase64 = imageData.base64EncodedString()
                    
                    
                    let newPainting = PaintingModel(identifier: DBManager.shared.generateRandomString, image: imageBase64 ?? "", title: title, subtitle: subtitle, isFavourite: false)
                    let id = DBManager.shared.userId
                    
                    self.startLoading()
                    DBManager.shared.addPaintingInFirestore(id, newPainting) { response in
                        self.stopLoading()
                        self.showAlertAction(title: "Alert", message: "Painting added"){
                            
                            self.startLoading()
                            
                            self.fetchList(id: id) { arr in
                                
                                self.stopLoading()
                                
                                self.paintings = arr
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                        
                        
                        
                        
                    } _: { err in
                        self.stopLoading()
                        self.showAlert(title: "Error", message: "\(err.localizedDescription)")
                    }

                }
                
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}


// MARK: # --------------------------- TABLEVIEW ------------------------------ # -

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paintings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PaintingCell
        let painting = paintings[indexPath.row]
        if let imageData = Data(base64Encoded: painting.image, options: .ignoreUnknownCharacters) {
            if let image = UIImage(data: imageData) {
                cell?.cellImage?.image = image
            }
            else {
                print("Error: Could not convert data to UIImage")
            }
        }
        else {
            print("Error: Could not decode Base64 string to Data")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    // MARK: - Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            
            
            let id = DBManager.shared.userId
            let paintingId = self.paintings[indexPath.row].identifier
            
            self.startLoading()
            DBManager.shared.deletePainting(for: id, paintingId: paintingId) { err in
                self.stopLoading()
                    if let _ = err {
                        self.showAlert(title: "Error", message: "Error in deleting painting")
                    }
                    else {
                        
                        self.startLoading()
                        self.fetchList(id: id) { arr in
                            
                            self.stopLoading()
                            self.paintings = arr
                            self.tableView.reloadData()
                        }
                    }
            }
            
            self.paintings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            let painting = self.paintings[indexPath.row]
            let alert = UIAlertController(title: "Edit Painting", message: "Update painting details", preferredStyle: .alert)
            alert.addTextField { $0.text = painting.title }
            alert.addTextField { $0.text = painting.subtitle }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let title = alert.textFields?[0].text,
                      let subtitle = alert.textFields?[1].text  else { return }
                
                self.presentImagePicker { selectedImage in
                    var imageBase64: String? = painting.image
                    //                    if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                    //                        imageBase64 = imageData.base64EncodedString()
                    //                    }
                    
                    
                    if let imageData = selectedImage?.jpegData(compressionQuality: 0.01) {
                        
                        imageBase64 = imageData.base64EncodedString()
                        
                        //                    if let imageData = self.compressImageToLimit(image: selectedImage!, limitInMB: 1) {
                        let id = DBManager.shared.userId
                        let paintingId = painting.identifier
                        
                        let newPainting = PaintingModel(identifier: paintingId, image: imageBase64 ?? "", title: title, subtitle: subtitle, isFavourite: false)
                        
                        self.startLoading()
                        DBManager.shared.updatePainting(for: id, identifier: paintingId, updatedPainting: newPainting) { err in
                            self.stopLoading()
                            if let _ = err {
                                self.showAlert(title: "Error", message: "Error in updating painting")
                            }
                            else {
                                self.startLoading()
                                self.fetchList(id: id) { arr in
                                    self.stopLoading()
                                    self.paintings = arr
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            
            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
}


// MARK: # --------------------------- IMAGE PICKER ------------------------------ # -


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func presentImagePicker(completion: @escaping (UIImage?) -> Void) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.imagePickerCompletionHandler = completion
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage // Set the selected image to your imageView
            
            let id = DBManager.shared.userId
            
            if let data = selectedImage.jpegData(compressionQuality: 0.01)?.base64EncodedString() {
                startLoading()
                DBManager.shared.uploadImageToStorage(imageString: data) { _ in
                    self.stopLoading()
                }
            }
            
            
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        let selectedImage = info[.originalImage] as? UIImage
        imagePickerCompletionHandler?(selectedImage)
        imagePickerCompletionHandler = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imagePickerCompletionHandler?(nil)
        imagePickerCompletionHandler = nil
    }
    
    
}

extension ViewController {
    
//    func compressImageToLimit(image: UIImage, limitInMB: Double) -> Data? {
//        let limitInBytes = limitInMB * 1024 * 1024 // Convert MB to bytes
//        
//        var compression: CGFloat = 1.0 // Maximum quality
//        guard var imageData = image.jpegData(compressionQuality: compression) else {
//            return nil
//        }
//        
//        // Reduce quality until it fits the limit
//        while imageData.count > Int(limitInBytes) && compression > 0 {
//            compression -= 0.1 // Reduce compression quality
//            if let compressedData = image.jpegData(compressionQuality: compression) {
//                imageData = compressedData
//            }
//        }
//        
//        return imageData.count <= Int(limitInBytes) ? imageData : nil
//    }
    
    func compressImageToLimit(image: UIImage, limitInMB: Double) -> String? {
        let limitInBytes = limitInMB * 1024 * 1024 // Convert MB to bytes
        
        var compression: CGFloat = 1.0 // Maximum quality
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        // Reduce quality until it fits the limit
        while imageData.count > Int(limitInBytes) && compression > 0 {
            compression -= 0.1 // Reduce compression quality
            if let compressedData = image.jpegData(compressionQuality: compression) {
                imageData = compressedData
            }
        }
        
        // Ensure image size is within the limit
        guard imageData.count <= Int(limitInBytes) else {
            print("Failed to compress image within \(limitInMB) MB")
            return nil
        }
        
        // Convert compressed data to Base64
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        return base64String
    }
    
}

