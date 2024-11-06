//
//  ViewController.swift
//  Greg
//
//  Created by Bilal Mughal on 04/11/2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let burgerSwitch = UISwitch()
    private let burgerLabel = UILabel()
    
    private let regularButton = UIButton(type: .system)
    private let cheeseButton = UIButton(type: .system)
    private let baconCheeseButton = UIButton(type: .system)
    
    private let costLabel = UILabel()
    private var selectedCost: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        burgerSwitch.addTarget(self, action: #selector(burgerSwitchChanged(_:)), for: .valueChanged)
        [regularButton, cheeseButton, baconCheeseButton].forEach {
            $0.addTarget(self, action: #selector(burgerOptionSelected(_:)), for: .touchUpInside)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Burger Switch and Label
        burgerLabel.text = "Burgers"
        burgerLabel.font = UIFont.systemFont(ofSize: 18)
        
        // Set up burger options buttons
        configureButton(button: regularButton, title: "Regular ($4.19)")
        configureButton(button: cheeseButton, title: "w/Cheese ($4.79)")
        configureButton(button: baconCheeseButton, title: "w/Bacon & Cheese ($5.39)")
        
        // Cost Label
        costLabel.text = "Cost of Meal: $0.00"
        costLabel.font = UIFont.systemFont(ofSize: 18)
        costLabel.textAlignment = .center
        
        // Add all subviews
        [burgerSwitch, burgerLabel, regularButton, cheeseButton, baconCheeseButton, costLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // Burger switch and label
            burgerSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            burgerSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            burgerLabel.centerYAnchor.constraint(equalTo: burgerSwitch.centerYAnchor),
            burgerLabel.leadingAnchor.constraint(equalTo: burgerSwitch.trailingAnchor, constant: 10),
            
            // Burger options buttons
            regularButton.topAnchor.constraint(equalTo: burgerSwitch.bottomAnchor, constant: 20),
            regularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            cheeseButton.topAnchor.constraint(equalTo: regularButton.bottomAnchor, constant: 10),
            cheeseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            baconCheeseButton.topAnchor.constraint(equalTo: cheeseButton.bottomAnchor, constant: 10),
            baconCheeseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Cost label
            costLabel.topAnchor.constraint(equalTo: baconCheeseButton.bottomAnchor, constant: 20),
            costLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Initially hide burger options
        toggleBurgerOptions(isVisible: false)
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.isHidden = true // Initially hidden
    }
    
    private func toggleBurgerOptions(isVisible: Bool) {
        regularButton.isHidden = !isVisible
        cheeseButton.isHidden = !isVisible
        baconCheeseButton.isHidden = !isVisible
        costLabel.text = isVisible ? "" : "Cost of Meal: $0.00"
    }
    
    @objc private func burgerSwitchChanged(_ sender: UISwitch) {
        toggleBurgerOptions(isVisible: sender.isOn)
        showToast(message: sender.isOn ? "Checkbox checked" : "Checkbox unchecked")
    }
    
    @objc private func burgerOptionSelected(_ sender: UIButton) {
        switch sender {
        case regularButton:
            selectedCost = 4.19
        case cheeseButton:
            selectedCost = 4.79
        case baconCheeseButton:
            selectedCost = 5.39
        default:
            break
        }
        costLabel.text = "Cost of Meal: $\(String(format: "%.2f", selectedCost))"
    }
    
    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = .black.withAlphaComponent(0.6)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.widthAnchor.constraint(equalToConstant: 200),
            toastLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 1.0, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}
