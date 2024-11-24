//
//  DetailsViewController.swift
//  ARproject
//
//  Created by Sara Alkatheeri on 19/04/2024.
//

import UIKit
import CoreLocation

class DetailsViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var monaLisaImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var favoritesBtn: UIButton!
    
    var paintingSelected: Bool = false
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        locationManager.requestWhenInUseAuthorization()
//        
//        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        startLoading()
        
      
        
        DBManager.shared.doesPaintingExist(paintingID: "0987654321") { status, isfavourite, err in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription)
            }
            else {
                
                self.stopLoading()
                
                if status && isfavourite ?? false {
                    self.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                    self.paintingSelected = true
                }
                else {
                    self.likeBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                    self.paintingSelected = false
                }
                
            }
        }
        
    }
    
    
    @IBAction func locationBtn(_ sender: Any) {
        
//        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation:CLLocation = locations[locations.count - 1]
        let lat = currentLocation.coordinate.latitude
        let lng = currentLocation.coordinate.longitude
        
        print (lat + lng)
    }
    
    
    @IBAction func likeBtnTap(_ sender: UIButton) {
        
        if let imageData = UIImage(named: "MonaLisa")?
            .jpegData(compressionQuality: 0.01) {
            
            let id = DBManager.shared.userId
            let imageString = imageData.base64EncodedString()
            
            let paintingModel = PaintingModel(
                identifier: "0987654321",
                image: imageString,
                title: "Mona Lisa",
                subtitle: "It has been described as 'the best known, the most visited, the most written about, the most sung about, and the most parodied' work of art in the world.",
                isFavourite: paintingSelected ? false : true)
            
            self.startLoading()
            DBManager.shared.addPaintingInFirestore(id, paintingModel) { response in
                
                self.stopLoading()
                
                self.showAlert(title: "Alert", message: self.paintingSelected ? "Painting removed from favourites" : "Painting added in favourites")
                self.likeBtn.setImage(UIImage(systemName: self.paintingSelected ? "hand.thumbsup" : "hand.thumbsup.fill"), for: .normal)
                self.paintingSelected.toggle()
            } _: { err in
                self.showAlert(title: "Error", message: err.localizedDescription)
            }

            
        }
        
//        if let imageData = UIImage(named: "MonaLisa")?.jpegData(compressionQuality: 1){
//            let model = favorites(paintingID: uuid,
//                                  image: imageData,
//                                  title: "Mona Lisa")
//            
//            MyHelper.shared.addPainting(painting: model) { success, message in
//                if success {
//                    self.showAlert(message: "painting is save as favorites", isError: false)
//                }
//                else {
//                    self.showAlert(message: message)
//                }
//            }
//            
//        }
           
        
        
        
        
        
        
    }
    
    @IBAction func cameraBtnTap(_ sender: UIButton) {
        
    }
    
    @IBAction func mapBtnTap(_ sender: UIButton) {
        
    }
    
    @IBAction func favoritesBtnTap(_ sender: UIButton) {
        
//        performSegue(withIdentifier: "museum", sender: sender)
        
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
