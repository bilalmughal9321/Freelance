//
//  DetailVC.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var selectImage: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var detail: UITextView!
    
    
    var selectMovie: Movies!
    
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectImage.image = selectMovie.image
        self.titleLbl.text = selectMovie.name
        self.detail.text = selectMovie.detail
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PaymentVC
        destinationVC.selectMovie = selectMovie
        
    }

    
    @IBAction func oaymentTap(_ sender: Any) {
        performSegue(withIdentifier: "payment", sender: sender)
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
