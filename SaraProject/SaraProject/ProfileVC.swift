//
//  ProfileVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLbl.text = DBManager.shared.email
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(openImageGallery))
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(longPressRecognizer)
        
        DBManager.shared.fetchProfileImage(userId: DBManager.shared.userId) { data in
            DispatchQueue.main.async {                
                if let datas = data, let imageData = UIImage(data: datas) {
                    self.profileImg.image = imageData
                }
                else {
                    self.profileImg.image = UIImage(systemName: "person.fill")
                }
            }
        }
    }
    

    @objc func openImageGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

}


extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage // Set the selected image to your imageView
            
            let id = DBManager.shared.userId
            
            if let data = selectedImage.jpegData(compressionQuality: 0.5)?.base64EncodedString() {
                DBManager.shared.storeProfileImage(data, userId: id)
            }
            
            
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
