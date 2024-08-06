//
//  VideoPlayerViewController.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 20/07/2024.
//

import UIKit
import AVKit
import AVFoundation

protocol playerStatusDelegate {
    func save()
    func discard()
}

class VideoPlayerViewController: UIViewController {

    var fileURL: URL?
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.backgroundColor = .yellow
        return stackView
    }()
    
    var deleteBtn: UIButton = {
        let saveBtn = UIButton()
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0)
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 10
        saveBtn.setTitle("Vymazať video", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
//        saveBtn.textAlignment = .center
//        saveBtn.minimumScaleFactor = 0.5
//        saveBtn.numberOfLines = 0
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
        
        
        
        
        guard let fileURL = fileURL else {
            print("No file URL provided.")
            return
        }
        
//         Create an AVPlayer
        let player = AVPlayer(url: fileURL)
        
        playerViewController.player = player
        
        self.addChild(playerViewController)
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
        
        
//        self.view.addSubview(playerViewController.view)
        
        
        self.view.backgroundColor = .black
        
        setupActionButtons()
        
        // Start playing the video
        player.play()
    }

    func setupActionButtons() {
        let previewHeight = view.bounds.height / 4
        let previewWidth = view.bounds.width / 1.25
        
        let deleteBtn = UIButton()
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0)
        deleteBtn.layer.masksToBounds = true
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.setTitle("Vymazať video", for: .normal)
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.titleLabel?.setFont()
        deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        deleteBtn.isUserInteractionEnabled = true
        
        
        let saveBtn = UIButton()
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.backgroundColor = UIColor.blue
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 10
        saveBtn.setTitle("Uložiť video", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.setFont()
        saveBtn.addTarget(self, action: #selector(saveBtnTap), for: .touchUpInside)
        saveBtn.isUserInteractionEnabled = true
        
        
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add stackView for buttons
        self.view.addSubview(checkView)
        checkView.addSubview(playerViewController.view)
        
        checkView.addSubview(stackView)
        stackView.addArrangedSubview(saveBtn)
        stackView.addArrangedSubview(deleteBtn)
        
        
        
        // Setup constraints for playerViewController view
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
        
        // Setup constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: checkView.bottomAnchor, constant: 10),
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
