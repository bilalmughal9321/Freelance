//
//  newFile.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 21/08/2024.
//

import Foundation
//
//  NewScreen.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 20/08/2024.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureMovieFileOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
        setupPreviewLayer()
    }

    private func setupCamera() {
        captureSession.beginConfiguration()

        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        let cameraInput = try! AVCaptureDeviceInput(device: camera)
        captureSession.addInput(cameraInput)

        captureSession.addOutput(videoOutput)

        captureSession.commitConfiguration()
    }

    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }

    func startRecording() {
        let outputPath = FileManager.default.temporaryDirectory.appendingPathComponent("video.mp4")
        videoOutput.startRecording(to: outputPath, recordingDelegate: self)
    }

    func stopRecording() {
        videoOutput.stopRecording()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // Handle file saved or error
    }
}
