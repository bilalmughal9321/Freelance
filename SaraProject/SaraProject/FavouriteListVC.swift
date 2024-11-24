//
//  FavouriteListVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit

class FavouriteListVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var imagePickerCompletionHandler: ((UIImage?) -> Void)?
    
    var paintings: [PaintingModel] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startLoading()
        
        fetchList(id: DBManager.shared.userId) { arr in
            self.stopLoading()
            self.paintings = arr.filter { $0.isFavourite }
            self.tableView.reloadData()
        }
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
            destinationVC.fromFavourites = true
        }
    }
    
}


// MARK: # --------------------------- TABLEVIEW ------------------------------ # -

extension FavouriteListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paintings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PaintingCell
        let painting = paintings[indexPath.row]
        let base64String = painting.image
        if let imageData = Data(base64Encoded: painting.image, options: .ignoreUnknownCharacters) {
            cell?.cellImage?.image = UIImage(data: imageData)
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
            
            DBManager.shared.deleteFavouritePainting(for: id, paintingId: paintingId) { err in
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
    
    
}


// MARK: # --------------------------- IMAGE PICKER ------------------------------ # -


extension FavouriteListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
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
