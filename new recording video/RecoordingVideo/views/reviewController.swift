//
//  reviewController.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 06/08/2024.
//

import UIKit
import AVKit
import AVFoundation

class reviewController: UIViewController {
    
    var fileURL: URL?
    
    var parentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    var deleteBtn: UIButton = {
        let saveBtn = UIButton()
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0)
        saveBtn.layer.masksToBounds = false
        saveBtn.layer.cornerRadius = 10
        saveBtn.setTitle("Vymazať video", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.setFont()
        saveBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        saveBtn.isUserInteractionEnabled = true
        return saveBtn
    }()
    
    var saveBtn: UIButton = {
        let saveBtn = UIButton()
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.backgroundColor = UIColor.red
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 10
        saveBtn.setTitle("Uložiť video", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.setFont()
        saveBtn.addTarget(self, action: #selector(saveBtnTap), for: .touchUpInside)
        saveBtn.isUserInteractionEnabled = true
        return saveBtn
    }()
    
    var checkView: UIView = {
        let views = UIView()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.backgroundColor = .green
        return views
    }()
    
    var delgate: playerStatusDelegate? = nil
    
    let playerViewController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Constant.isRealDevice{
            guard let fileURL = fileURL else {
                print("No file URL provided.")
                return
            }
            
            let player = AVPlayer(url: fileURL)
            
            playerViewController.player = player
            
            self.addChild(playerViewController)
            playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
            
//            self.view.backgroundColor = UIColor(red: 254/255, green: 181/255, blue: 177/255, alpha: 1)
            self.view.backgroundColor = .white
            
            player.play()
        }
     
        self.view.addSubview(parentStackView)
        
        parentStackView.addArrangedSubview(playerViewController.view)
        parentStackView.addArrangedSubview(stackView)
        
        
        stackView.addArrangedSubview(saveBtn)
        stackView.addArrangedSubview(deleteBtn)
        
        
        NSLayoutConstraint.activate([
            // parent stack view
            parentStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            parentStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            parentStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            parentStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9),
            
            // check view

            
            // player view
//            playerViewController.view.centerXAnchor.constraint(equalTo: parentStackView.centerXAnchor, constant: 0),
//            playerViewController.view.centerYAnchor.constraint(equalTo: parentStackView.centerYAnchor, constant: 0),
//            playerViewController.view.widthAnchor.constraint(equalTo: parentStackView.widthAnchor, multiplier: 1),
//            playerViewController.view.heightAnchor.constraint(equalTo: parentStackView.heightAnchor, multiplier: 1),
            
            // buttons view
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.view.layoutIfNeeded()
        
//        setupActionButtons()

        
    }

    func setupActionButtons() {
        let previewHeight = view.bounds.height / 4
        let previewWidth = view.bounds.width / 1.25
        
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(checkView)
        checkView.addSubview(playerViewController.view)
        
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(saveBtn)
        stackView.addArrangedSubview(deleteBtn)
        
        NSLayoutConstraint.activate([
            
            checkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            checkView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            checkView.widthAnchor.constraint(equalToConstant: previewWidth),
            checkView.heightAnchor.constraint(equalToConstant: previewHeight),
            
            playerViewController.view.centerXAnchor.constraint(equalTo: checkView.centerXAnchor, constant: 0),
            playerViewController.view.centerYAnchor.constraint(equalTo: checkView.centerYAnchor, constant: 0),
            playerViewController.view.widthAnchor.constraint(equalTo: checkView.widthAnchor, multiplier: 1),
            playerViewController.view.heightAnchor.constraint(equalTo: checkView.heightAnchor, multiplier: 1),
            
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: checkView.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: checkView.widthAnchor, multiplier: 1),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    

    @objc func deleteBtnTap() {
        delgate?.discard()
        dismiss(animated: true)
    }
    
    @objc func saveBtnTap() {
        delgate?.save()
        dismiss(animated: true)
    }

}
