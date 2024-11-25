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

enum imageFor {
    case painting
    case profile
}

class ViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagePickerCompletionHandler: ((UIImage?) -> Void)?
    
    var paintings: [PaintingModel] = []
    var selectedIndexPath: IndexPath?
    
    var presentationTyle: imageFor = .painting
    
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
        fetchProfile()

        
    }
    
    /// this function for getching the profile image from firebase
    
    private func fetchProfile() {
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
    }
 
    @objc func openImageGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        presentationTyle = .profile
        present(imagePickerController, animated: true, completion: {
            self.fetchProfile()
        })
    }

  
    
    @IBAction func addPaint(_ sender: Any) {
        barBtn()
    }
    
    /// fetch painting from firebase
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

/// 1. this function responsible for adding the painting in by using alert
/// 2. first add title and subtitle in tetfield
/// 3. then media source media sheet open and select option of camera and gallery
extension ViewController {
    func barBtn() {
        let alert = UIAlertController(title: "New Painting", message: "Enter painting details", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Subtitle" }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alert.textFields?[0].text,
                  let subtitle = alert.textFields?[1].text else { return }
            
            let imageSourceAlert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
            
            
            
            // Camera option
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.presentationTyle = .painting
                self.presentImagePicker2(sourceType: .camera) { selectedImage in
                    
                    self.handleImageSelection(selectedImage: selectedImage, title: title, subtitle: subtitle)
                }
            }
            
            // Gallery option
            let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                self.presentationTyle = .painting
                self.presentImagePicker2(sourceType: .photoLibrary) { selectedImage in
                   
                    self.handleImageSelection(selectedImage: selectedImage, title: title, subtitle: subtitle)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            imageSourceAlert.addAction(cameraAction)
            imageSourceAlert.addAction(galleryAction)
            imageSourceAlert.addAction(cancelAction)
            
            self.present(imageSourceAlert, animated: true)
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func handleImageSelection(selectedImage: UIImage?, title: String, subtitle: String) {
        guard let selectedImage = selectedImage else { return }
        
        if let imageData = selectedImage.jpegData(compressionQuality: 0.01) {
            let imageBase64 = imageData.base64EncodedString()
            let newPainting = PaintingModel(identifier: DBManager.shared.generateRandomString, image: imageBase64, title: title, subtitle: subtitle, isFavourite: false)
            let id = DBManager.shared.userId
            
            self.startLoading()
            DBManager.shared.addPaintingInFirestore(id, newPainting) { response in
                self.stopLoading()
                self.showAlertAction(title: "Alert", message: "Painting added") {
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
    
    func handleImageSelectionEdit(selectedImage: UIImage?, title: String, subtitle: String, model: PaintingModel) {
        guard let selectedImage = selectedImage else { return }
        if let imageData = selectedImage.jpegData(compressionQuality: 0.01) {
            
            let imageBase64 = imageData.base64EncodedString()
            
            let id = DBManager.shared.userId
            let paintingId = model.identifier
            
            let newPainting = PaintingModel(identifier: paintingId, image: imageBase64, title: title, subtitle: subtitle, isFavourite: model.isFavourite)
            
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
    
    /// delete the paiting using swipe right and after deleting fetch the list again for updating the list
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
    
    /// update the paiting using swipe left and after deleting fetch the list again for updating the list
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            let painting = self.paintings[indexPath.row]
            let alert = UIAlertController(title: "Edit Painting", message: "Update painting details", preferredStyle: .alert)
            alert.addTextField { $0.text = painting.title }
            alert.addTextField { $0.text = painting.subtitle }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let title = alert.textFields?[0].text,
                      let subtitle = alert.textFields?[1].text else { return }
                
                let imageSourceAlert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
                
                
                
                // Camera option
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                    self.presentationTyle = .painting
                    self.presentImagePicker2(sourceType: .camera) { selectedImage in
                        
//                        self.handleImageSelection(selectedImage: selectedImage, title: title, subtitle: subtitle)
                        
                        self.handleImageSelectionEdit(
                            selectedImage: selectedImage, title: title, subtitle: subtitle, model: painting)
                    }
                }
                
                // Gallery option
                let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                    self.presentationTyle = .painting
                    self.presentImagePicker2(sourceType: .photoLibrary) { selectedImage in
                       
//                        self.handleImageSelection(selectedImage: selectedImage, title: title, subtitle: subtitle)
                        
                        self.handleImageSelectionEdit(selectedImage: selectedImage, title: title, subtitle: subtitle, model: painting)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                imageSourceAlert.addAction(cameraAction)
                imageSourceAlert.addAction(galleryAction)
                imageSourceAlert.addAction(cancelAction)
                
                self.present(imageSourceAlert, animated: true)
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

/// Media source delegate functions
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker2(sourceType: UIImagePickerController.SourceType, completion: @escaping (UIImage?) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            self.showAlert(title: "Error", message: "\(sourceType == .camera ? "Camera" : "Gallery") not available.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // Optional, allow editing if required
        
        self.imagePickerCompletionHandler = completion
        self.present(imagePicker, animated: true)
    }
    
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
            
            if presentationTyle == .profile{
                if let data = selectedImage.jpegData(compressionQuality: 0.01)?.base64EncodedString() {
                    startLoading()
                    DBManager.shared.uploadImageToStorage(imageString: data) { _ in
                        self.stopLoading()
                        
                        self.fetchProfile()
                    }
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

