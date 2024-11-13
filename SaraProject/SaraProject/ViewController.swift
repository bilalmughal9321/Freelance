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
    @IBOutlet weak var tableView: UITableView!
    
    var imagePickerCompletionHandler: ((UIImage?) -> Void)?
    
    var paintings: [PaintingModel] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchList(id: DBManager.shared.userId) { arr in
            self.paintings = arr
            self.tableView.reloadData()
        }
    }
    
 

    @IBAction func addPainting(_ sender: UIBarButtonItem) {
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
                if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
                    imageBase64 = imageData.base64EncodedString()
                    
                    
                    let newPainting = PaintingModel(identifier: DBManager.shared.generateRandomString, image: imageData, title: title, subtitle: subtitle)
                    let id = DBManager.shared.userId
                    DBManager.shared.addPainting(for: id, painting: newPainting) { err in
                        DispatchQueue.main.async {
                            if let _ = err {
                                self.showAlert(title: "Error", message: "Error on adding painting")
                            }
                            else {
                                self.showAlert(title: "Alert", message: "Painting added")
                                
                                self.fetchList(id: id) { arr in
                                    self.paintings = arr
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                    
                }
                
//                self.paintings.append(newPainting)
//                self.tableView.reloadData()
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
//        cell.textLabel?.text = "\(painting.title) by \(painting.artist)"
//        cell.detailTextLabel?.text = "Year: \(painting.year)"
        
        let base64String = painting.image
        if let image = UIImage(data: base64String) {
            cell?.cellImage?.image = image
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    // MARK: - Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            
            
            let id = DBManager.shared.userId
            let paintingId = self.paintings[indexPath.row].identifier
            
            DBManager.shared.deletePainting(for: id, paintingId: paintingId) { err in
                DispatchQueue.main.async {
                    if let _ = err {
                        self.showAlert(title: "Error", message: "Error in deleting painting")
                    }
                    else {
                        self.fetchList(id: id) { arr in
                            self.paintings = arr
                            self.tableView.reloadData()
                        }
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
//                    var imageBase64: String? = painting.image
//                    if let imageData = selectedImage?.jpegData(compressionQuality: 0.8) {
//                        imageBase64 = imageData.base64EncodedString()
//                    }
                    
                    if let imageData = selectedImage?.jpegData(compressionQuality: 0.8){
                        let id = DBManager.shared.userId
                        let paintingId = painting.identifier
                        
                        let newPainting = PaintingModel(identifier: paintingId, image: imageData, title: title, subtitle: subtitle)
                        
                        DBManager.shared.updatePainting(for: id, identifier: paintingId, updatedPainting: newPainting) { err in
                            DispatchQueue.main.async {
                                if let _ = err {
                                    self.showAlert(title: "Error", message: "Error in updating painting")
                                }
                                else {
                                    self.fetchList(id: id) { arr in
                                        self.paintings = arr
                                        self.tableView.reloadData()
                                    }
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
