//
//  WelcomeVC.swift
//  GameProject
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Quiz Game"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center

        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)

    }

    @objc private func startGame() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

