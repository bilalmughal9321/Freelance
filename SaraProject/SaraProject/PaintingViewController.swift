//  PaintingViewController.swift
//  ARproject
//  Created by Sara Alkatheeri on 17/04/2024.

import UIKit

class PaintingViewController: UIViewController {
    
    var name = ""
    
    
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = name
        

        // Do any additional setup after loading the view.
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


