//
//  PaintingDetailVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit

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
//        cellImage.layer.masksToBounds = true 
        
        if let data = paintingModel?.image {
            cellImage.image = UIImage(data: data)
        }
        
        titleLbl.text = paintingModel?.title ?? ""
        
        subtitleLbl.text = paintingModel?.subtitle ?? ""
        
        favouriteBtn.setTitle(fromFavourites ? "Remove from favourites" : "Add to favourites", for: .normal)
        
    }
    
    
    @IBAction func addToFavourites(_ sender: Any) {
        
        let id = DBManager.shared.userId
        
        if let model = paintingModel {
            
            if fromFavourites {
                DBManager.shared.deleteFavouritePainting(for: id, paintingId: model.identifier) { err in
                    if let _ = err {
                        self.showAlert(title: "Error", message: "Error in deleting from favourites")
                    }
                    else {
                        self.showAlert(title: "Alert", message: "Painting deleted from favourite")
                    }
                }
            }
            
            else {
                DBManager.shared.AddFavourite(for: id, painting: model) { err in
                    if let _ = err {
                        self.showAlert(title: "Error", message: "Error in adding in favourites")
                    }
                    else {
                        self.showAlert(title: "Alert", message: "Painting added into favourite you can check on favourite section")
                    }
                }
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
