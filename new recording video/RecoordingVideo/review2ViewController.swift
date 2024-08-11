//
//  review2ViewController.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 12/08/2024.
//

import UIKit

class review2ViewController: UIViewController {
    
    
    @IBOutlet weak var checkView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkView.backgroundColor = .blue
        
        stackView.backgroundColor = .blue
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
