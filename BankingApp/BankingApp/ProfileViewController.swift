//
//  ProfileViewController.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var emaillbl: UILabel!
    
    
    override func viewDidLoad() {
        
        emaillbl.text = Constant.email
        
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"

        let label = UILabel()
        label.text = "Profile details go here."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
