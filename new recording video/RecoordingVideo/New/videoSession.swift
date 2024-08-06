//
//  videoSession.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 06/08/2024.
//

import Foundation
import AVFoundation

class videSession {
    
    private let movieOutput = AVCaptureMovieFileOutput()
    
    private func setupSession(captureSession: AVCaptureSession) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        if (captureSession.canAddOutput(movieOutput)) {
            captureSession.addOutput(movieOutput)
        }
        
        captureSession.startRunning()
    }
    
}
