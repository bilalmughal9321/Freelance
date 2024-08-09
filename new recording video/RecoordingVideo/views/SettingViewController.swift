//
//  SettingViewController.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 19/07/2024.
//

import UIKit

class SettingsViewController: UIViewController {

    var onSave: ((Int) -> Void)?
    
    static var sliderValue: Float = 10

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 5
        slider.maximumValue = 60
        slider.value = SettingsViewController.sliderValue
        slider.minimumTrackTintColor = .red
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Čas nahrávania: \(SettingsViewController.sliderValue)s" // Default value
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.setFont()
        return label
    }()

    private lazy var saveButton: UILabel = {
        let button = UILabel()
        button.text = "Uložiť"
        button.textColor = .white
        button.textAlignment = .center
//        button.setTitle("Uložiť", for: .normal)
//        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
      
//        button.titleLabel?.setFont()
        button.setFont()
        
    
//        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
 
       

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButton.isUserInteractionEnabled = true 
        saveButton.addGestureRecognizer(tap)
    }


    private func setupUI() {
        view.addSubview(slider)
        view.addSubview(valueLabel)
        view.addSubview(saveButton)
        

        slider.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            slider.widthAnchor.constraint(equalToConstant: 300),

            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -20),
            valueLabel.heightAnchor.constraint(equalToConstant: 50),

            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            saveButton.widthAnchor.constraint(equalToConstant: 300),
            saveButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Initial value display
        updateValueLabel()
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        updateValueLabel()
    }

    private func updateValueLabel() {
        let recordingTime = Int(slider.value)
        SettingsViewController.sliderValue = slider.value
        valueLabel.text = "Čas nahrávania: \(recordingTime)s"
    }

    @objc private func saveButtonTapped() {
        let recordingTime = Int(slider.value)
        onSave?(recordingTime)
        dismiss(animated: true, completion: nil)
    }
}



