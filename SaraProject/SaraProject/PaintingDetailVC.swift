//
//  PaintingDetailVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit

/*
 
 /// 1. this file is appear after click on painting and you can move this painting to favourites in this screen by using favourites button
 
 */
class PaintingDetailVC: UIViewController {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var subtitleLbl: UITextView!
    
    var fromFavourites: Bool = false
    
    var paintingModel: PaintingModel? = nil
    
    
    @IBOutlet weak var favouriteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cellImage.layer.cornerRadius = 15
        cellImage.layer.masksToBounds = true 
        
        if let imageData = Data(base64Encoded: paintingModel?.image ?? "", options: .ignoreUnknownCharacters) {
            cellImage.image = UIImage(data: imageData)
        }
        
        titleLbl.text = paintingModel?.title ?? ""
        
        subtitleLbl.text = paintingModel?.subtitle ?? ""
        
        favouriteBtn.setTitle(fromFavourites ? "Remove from favourites" : "Add to favourites", for: .normal)
        
    }
    
    
    @IBAction func addToFavourites(_ sender: Any) {
        
        guard let model = paintingModel else { return }
            
            let id = DBManager.shared.userId
            let isFavourite = !fromFavourites // Toggle favourite status
            
            let updatedModel = PaintingModel(
                identifier: model.identifier,
                image: model.image,
                title: model.title,
                subtitle: model.subtitle,
                isFavourite: isFavourite
            )
            
        self.startLoading()
            DBManager.shared.updatePainting(for: id, identifier: model.identifier, updatedPainting: updatedModel) { err in
                
                self.stopLoading()
                
                if let err = err {
                    self.showAlert(title: "Error", message: "\(err.localizedDescription)")
                } else {
                    let message = isFavourite ? "Painting added to favourites" : "Painting removed from favourites"
                    self.showAlert(title: "Alert", message: message)
                }
            }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
