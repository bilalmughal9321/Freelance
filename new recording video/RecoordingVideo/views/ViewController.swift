//
//  ViewController.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 18/07/2024.
//

import UIKit
import AVFoundation
import Photos



class ViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var movieOutput: AVCaptureMovieFileOutput!
    var isRecording = false
    var timer: CGFloat = 10
    var progress: CGFloat = 0.0
    var countdownTimer: Timer?
    var remainingTime: CGFloat = 0
    var outputFileURLS: URL!
    var widthAnchor: NSLayoutConstraint? = nil
    var shouldLockOrientation = false
        
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Odkazovač"
        lbl.textColor = .black
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        lbl.setFont()
        return lbl
    }()

    var counterLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.alpha = 0
        lbl.setFont()
        return lbl
    }()

    var progressBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = .themeRed
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var dottedView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var recordButton: UILabel = {
        let recordButton = UILabel()
        recordButton.textColor = .white
        recordButton.backgroundColor = .themeRed
        recordButton.layer.masksToBounds = true
        recordButton.layer.cornerRadius = 20
        recordButton.textAlignment = .center
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setFont()
        return recordButton
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .system)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        deleteBtn.layer.cornerRadius = 10
        deleteBtn.setTitle("Discard Video", for: .normal)
        deleteBtn.setTitleColor(.white, for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        
        return deleteBtn
    }()
    
    var saveBtn: UIButton = {
        var saveBtn = UIButton(type: .system)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        saveBtn.layer.cornerRadius = 10
        saveBtn.setTitle("Save Video", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnTap), for: .touchUpInside)
        return saveBtn
    }()
    
    var countDownView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .themeRed
        return view
    }()
    
    var countdownLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.textAlignment = .center
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Cally-Bold", size: 30)
//        label.setFont()
        return label
    }()
    
    var dottesStatus: Bool = false {
        didSet{
            if isRecording {
                UIView.animate(withDuration: 0.5) {
                    self.dottedView.alpha =  self.dottesStatus ? 1 : 0
                }
            } else {
                self.dottedView.alpha = 0
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setupCamera()
        setupUI()
        setupSettingButton()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(recordButtonTapped))
        recordButton.isUserInteractionEnabled = true
        recordButton.addGestureRecognizer(tapGest)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.updateVideoPreviewLayerFrame()
    }

    func setupCamera() {
        if Constant.isRealDevice {
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .high
            
            // Video Input
            guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                print("Front camera not available")
                return
            }
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: frontCamera)
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Audio Input
            guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
                print("Audio device not available")
                return
            }
            
            do {
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
            self.movieOutput = AVCaptureMovieFileOutput()
            if self.captureSession.canAddOutput(self.movieOutput) {
                self.captureSession.addOutput(self.movieOutput)
            }
            
            if let connection = self.movieOutput.connection(with: .video) {
                connection.videoOrientation = self.currentVideoOrientation()
            }
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer.videoGravity = .resizeAspectFill
            
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
        
        
        self.setConatinerView()
        self.initDottedView()
        self.initCountDownView()
        
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            return .portrait
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    func setConatinerView() {
        let previewHeight = view.bounds.height / 2
        let previewWidth = view.bounds.width / 1.25
        let previewX = (view.bounds.width - previewWidth) / 2
        let previewY = (view.bounds.height - previewHeight) / 2
        
        self.view.addSubview(titleLbl)
        
        self.view.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalToSystemSpacingBelow: self.view.centerYAnchor, multiplier: 0.9).isActive = true
//        containerView.widthAnchor.constraint(equalToConstant: previewWidth).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: previewHeight).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        if Constant.isRealDevice {
            self.containerView.layer.addSublayer(self.videoPreviewLayer)
        }
        
        Thread.mainThread {
            if Constant.isRealDevice{
                self.videoPreviewLayer.frame = self.containerView.bounds
            }
            self.titleLbl.frame = CGRect(x: self.containerView.frame.origin.x,
                                         y: self.containerView.frame.origin.y - 60,
                                         width: self.containerView.frame.width,
                                         height: 50)
        }
        
        if Constant.isRealDevice{
            videoPreviewLayer.cornerRadius = 10
        }
    }
    
    func initDottedView() {
        self.view.addSubview(dottedView)
        
        NSLayoutConstraint.activate([
            dottedView.widthAnchor.constraint(equalToConstant: 10),
            dottedView.heightAnchor.constraint(equalToConstant: 10),
            dottedView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            dottedView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
        ])
        dottedView.layer.cornerRadius = 5
        dottedView.alpha = 0
    }
    
    func initCountDownView() {
        self.view.addSubview(countDownView)
        countDownView.addSubview(countdownLabel)
        
        NSLayoutConstraint.activate([
//            countDownView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
//            countDownView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            countDownView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            countDownView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            countDownView.widthAnchor.constraint(equalToConstant: 60),
            countDownView.heightAnchor.constraint(equalToConstant: 60),
            
            countdownLabel.centerXAnchor.constraint(equalTo: countDownView.centerXAnchor, constant: 0),
            countdownLabel.centerYAnchor.constraint(equalTo: countDownView.centerYAnchor, constant: 0),
            countdownLabel.widthAnchor.constraint(equalTo: countDownView.widthAnchor, multiplier: 1),
            countdownLabel.heightAnchor.constraint(equalTo: countDownView.heightAnchor, multiplier: 1)
        ])
        
        countDownView.layer.cornerRadius = 30
        countDownView.alpha = 0
        countdownLabel.alpha = 0
    }

    func setupUI() {
        view.addSubview(recordButton)
        view.addSubview(counterLabel)
                recordButton.text = "Začať nahrávanie na  \(Int(timer)) sekúnd"
//        recordButton.text = "Start \(Int(timer))-Second Recording"
//        recordButton.setTitle("Start \(Int(timer))-Second Recording", for: .normal)
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            recordButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            recordButton.heightAnchor.constraint(equalToConstant: 50),

            counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            counterLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            counterLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            counterLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setupSettingButton() {
        let settingsButton = UIButton(type: .system)
        let settingsImage = UIImage(systemName: "gear") // Using system image "gear"
        settingsButton.setImage(settingsImage, for: .normal)
        settingsButton.tintColor = .black // Optional: Set image color
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.widthAnchor.constraint(equalToConstant: 50), // Set appropriate size
            settingsButton.heightAnchor.constraint(equalToConstant: 50) // Set appropriate size
        ])
    }

    @objc func openSettings() {
        let vc = SettingsViewController()
        vc.onSave = { [weak self] time in
            self?.timer = CGFloat(time)
//            self?.recordButton.text = "Start \(Int(time))-Second Recording"
            self?.recordButton.text = "Začať nahrávanie na  \(Int(time)) sekúnd"
//            self?.recordButton.setTitle("Start \(Int(time))-Second Recording", for: .normal)
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true)
    }
    
    @objc func recordButtonTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func initProgressBar() {
        containerView.addSubview(progressBar)
        progressBar.alpha = 1
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: containerView.frame.width),
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            progressBar.heightAnchor.constraint(equalToConstant: 5),
        ])
//        progressBar.layer.masksToBounds = false
        self.view.layoutIfNeeded()
    }
    
    func animateDottedView() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.dottesStatus = !self.dottesStatus
            if self.isRecording {
                self.animateDottedView()
            }
            else {
                self.dottesStatus = false
            }
        })
    }
    
    func startRecording() {
        countDownView.alpha = 1
        countdownLabel.alpha = 1
        self.recordButton.isUserInteractionEnabled = false
        countdown(from: 3)
        
//        lockOrientation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            self.initProgressBar()
            self.animateDottedView()
            let outputPath = NSTemporaryDirectory() + UUID().uuidString + ".mov"
            let outputFileURL = URL(fileURLWithPath: outputPath)
            if Constant.isRealDevice{
                self.movieOutput.startRecording(to: outputFileURL, recordingDelegate: self)
            }
            self.isRecording = true
            self.updateRecordButtonTitle()
            self.remainingTime = self.timer
            self.updateCounterLabel()
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounterLabel), userInfo: nil, repeats: true)
            self.animateProgressBar()
        })
        
    }

    func animateProgressBar() {
        progressBar.layer.removeAllAnimations()
            progressBar.layer.speed = 1.0
            progressBar.layer.timeOffset = 0.0
            progressBar.layer.beginTime = 0.0
            
            // Reset the progress bar width
            progressBar.frame.size.width = 0
        UIView.animate(withDuration: TimeInterval(timer - 1), delay: 0, options: .curveLinear, animations: {
            self.progressBar.frame.size.width = self.view.frame.size.width * 0.75
        }, completion: nil)
        
    }
    
    func stopRecording() {
        if isRecording {
//            unlockOrientation()
            countDownView.alpha = 0
            countdownLabel.alpha = 0
            if Constant.isRealDevice{
                movieOutput.stopRecording()
            }
            isRecording = false
            updateRecordButtonTitle()
            countdownTimer?.invalidate()
            counterLabel.text = ""
            counterLabel.alpha = 0
            dottedView.alpha = 0
            // Pause the progress bar animation
            let pausedTime = progressBar.layer.convertTime(CACurrentMediaTime(), from: nil)
            progressBar.layer.speed = 0.0
            progressBar.layer.timeOffset = pausedTime
        }
    }

    @objc func updateCounterLabel() {
        remainingTime -= 1
//        Zostáva čas 10 sekúnd
        counterLabel.text = "Zostáva čas \(Int(remainingTime)) s"
//        counterLabel.text = "Time remaining: \(Int(remainingTime)) seconds"
        counterLabel.alpha = 1

        if remainingTime <= 0 {
            counterLabel.alpha = 0
            countdownTimer?.invalidate()
            counterLabel.text = ""
            stopRecording()
        }
    }

    func updateRecordButtonTitle() {
//        let title = isRecording ? "Stop Recording" : "Start \(Int(timer))-Second Recording"
        let title = isRecording ? "Zastaviť nahrávanie" : "Začať nahrávanie na  \(Int(timer)) sekúnd"
        DispatchQueue.main.async {
            self.recordButton.text = title
//            self.recordButton.setTitle(title, for: .normal)
        }
    }
    
    func countdown(from number: Int) {
        if number > 0 {
            countdownLabel.text = "\(number)"
            UIView.animate(withDuration: 1.0, animations: {
                self.countdownLabel.alpha = 0.0
            }) { _ in
                self.countdownLabel.alpha = 1.0
                self.countdown(from: number - 1)
            }
        } else {
            self.countdownLabel.alpha = 0.0
            self.countDownView.alpha = 0.0
            self.recordButton.isUserInteractionEnabled = true
        }
    }

    func saveVideoToGallery(outputFileURL: URL) {
        
        PHPhotoLibrary.requestAuthorization { status in
            self.progressBar.alpha = 0
            guard status == .authorized else {
                print("Photo library access not granted.")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
            }) { success, error in
                if let error = error {
                    print("Error saving video to gallery: \(error.localizedDescription)")
                } else {
                    print("Video uložené do galérie")
                    DispatchQueue.main.async {
                        self.showToaster(message: "Video uložené do galérie")
                    }
                }
            }
        }
        
//        let alert = UIAlertController(title: "Save Video", message: "Do you want to save this video to your gallery?", preferredStyle: .alert)

//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
////            self.animateReset()
//            PHPhotoLibrary.requestAuthorization { status in
//                self.progressBar.alpha = 0
//                guard status == .authorized else {
//                    print("Photo library access not granted.")
//                    return
//                }
//
//                PHPhotoLibrary.shared().performChanges({
//                    let options = PHAssetResourceCreationOptions()
//                    let creationRequest = PHAssetCreationRequest.forAsset()
//                    creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
//                }) { success, error in
//                    if let error = error {
//                        print("Error saving video to gallery: \(error.localizedDescription)")
//                    } else {
//                        print("Video saved to gallery successfully.")
//                        DispatchQueue.main.async {
//                            self.showToaster(message: "Video saved to gallery successfully.")
//                        }
//                    }
//                }
//            }
//        }))

//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
           
//        }))
//
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
    }

}

extension ViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            print("Video recorded successfully at: \(outputFileURL.path)")
            outputFileURLS = outputFileURL
//            actionButton()
            
            let vc = reviewController()
            vc.fileURL = outputFileURL
            vc.delgate = self 
            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true)
            
        }
        isRecording = false
        updateRecordButtonTitle()
    }

    func showToaster(message: String) {
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.backgroundColor = .white
        parentView.layer.cornerRadius = 10

        let toasterTitle = UILabel()
        toasterTitle.text = message
        toasterTitle.minimumScaleFactor = 0.5
        toasterTitle.textColor = .black
        toasterTitle.translatesAutoresizingMaskIntoConstraints = false
        toasterTitle.textAlignment = .center
        toasterTitle.font = UIFont.boldSystemFont(ofSize: 13)

        self.view.addSubview(parentView)
        parentView.addSubview(toasterTitle)

        NSLayoutConstraint.activate([
            parentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
            parentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            parentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            parentView.heightAnchor.constraint(equalToConstant: 30),

            toasterTitle.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            toasterTitle.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            toasterTitle.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.9),
            toasterTitle.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.9)
        ])

        parentView.alpha = 0
        toasterTitle.alpha = 0
        UIView.animate(withDuration: 1) {
            parentView.alpha = 1
            toasterTitle.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                UIView.animate(withDuration: 1) {
                    parentView.alpha = 0
                    toasterTitle.alpha = 0
                } completion: { _ in
                    parentView.removeFromSuperview()
                    toasterTitle.removeFromSuperview()
                }
            })
        }
    }
    
    func actionButton(_ status: Bool = false) {
        
        guard !status else {
            stackView.removeFromSuperview()
            saveBtn.removeFromSuperview()
            deleteBtn.removeFromSuperview()
            return
        }
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(saveBtn)
        stackView.addArrangedSubview(deleteBtn)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: containerView.frame.height / 3)
        ])
        recordButton.isUserInteractionEnabled = false
        
    }
    
    @objc func deleteBtnTap() {
        actionButton(true)
        self.progressBar.alpha = 0
        print("Video has been deleted")
        self.recordButton.isUserInteractionEnabled = true
    }
    
    @objc func saveBtnTap() {
        actionButton(true)
        PHPhotoLibrary.requestAuthorization { status in
            
            guard status == .authorized else {
                print("Photo library access not granted.")
                self.recordButton.isUserInteractionEnabled = true
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .video, fileURL: self.outputFileURLS, options: options)
            }) { success, error in
                if let error = error {
                    print("Error saving video to gallery: \(error.localizedDescription)")
                } else {
                    print("Video saved to gallery successfully.")
                    DispatchQueue.main.async {
                        self.showToaster(message: "Video uložené do galérie")
                        self.recordButton.isUserInteractionEnabled = true
                        self.progressBar.alpha = 0
                    }
                }
            }
        }
    }
    
}



extension ViewController: playerStatusDelegate {
    
    func discard() {
        actionButton(true)
        self.progressBar.alpha = 0
        print("Video has been deleted")
        self.recordButton.isUserInteractionEnabled = true
    }
    
    func save() {
        PHPhotoLibrary.requestAuthorization { status in
            
            guard status == .authorized else {
                print("Photo library access not granted.")
                self.recordButton.isUserInteractionEnabled = true
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .video, fileURL: self.outputFileURLS, options: options)
            }) { success, error in
                if let error = error {
                    print("Error saving video to gallery: \(error.localizedDescription)")
                } else {
                    print("Video saved to gallery successfully.")
                    DispatchQueue.main.async {
                        self.showToaster(message: "Video uložené do galérie")
                        self.recordButton.isUserInteractionEnabled = true
                        self.progressBar.alpha = 0
                    }
                }
            }
        }
    }
}








//MARK: - ORIENTATION
extension ViewController {
    
//    override var shouldAutorotate: Bool {
//        return !shouldLockOrientation
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return shouldLockOrientation ? .portrait : .all
//    }
//    
//    func lockOrientation() {
//        shouldLockOrientation = true
//        let value = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
//        self.setNeedsUpdateOfSupportedInterfaceOrientations()
//    }
//    
//    func unlockOrientation() {
//        shouldLockOrientation = false
//        self.setNeedsUpdateOfSupportedInterfaceOrientations()
//    }
    
    func updateVideoPreviewLayerFrame() {
        
        print("width: \(self.view.bounds.width)")
        print("height: \(self.view.bounds.height)")
        
        let size: CGFloat = min(view.bounds.width, view.bounds.height) * 0.8 // Adjust the multiplier as needed
        
        // Center the view
        let x = (view.bounds.width - size) / 2
        let y = (view.bounds.height - size) / 2
        
        print("x: \(x)")
        print("y: \(y)")
        
            // Update the frame of the view
        Thread.mainThread {
//            self.containerView.frame = CGRect(x: x, y: y - 20, width: size, height: size)
            
            if Constant.isRealDevice {
                self.videoPreviewLayer.frame = self.containerView.bounds
            }
            
            self.titleLbl.frame = CGRect(x: y, y: self.containerView.frame.minY - 60, width: size, height: 50)
            
            
            print("frame: \(self.titleLbl.frame)")
            if Constant.isRealDevice{
                if let connection = self.videoPreviewLayer.connection {
                    switch UIDevice.current.orientation {
                    case .portrait:
                        connection.videoOrientation = .portrait
                    case .portraitUpsideDown:
                        connection.videoOrientation = .portraitUpsideDown
                    case .landscapeLeft:
                        connection.videoOrientation = .landscapeRight
                    case .landscapeRight:
                        connection.videoOrientation = .landscapeLeft
                    default:
                        connection.videoOrientation = .portrait
                    }
                }
            }
        }
        

       }
    
}





