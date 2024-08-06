//
//  VideoRecordingVC.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 06/08/2024.
//

import Foundation
import AVFoundation
import UIKit

class VideoRecordingVC: UIViewController {
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var movieOutput: AVCaptureMovieFileOutput!
    
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print(self.view.bounds.width)
        print(self.view.bounds.height)
        
        
        // Size of the square view
        let size: CGFloat = min(view.bounds.width, view.bounds.height) * 0.8 // Adjust the multiplier as needed
        
        // Center the view
        let x = (view.bounds.width - size) / 2
        let y = (view.bounds.height - size) / 2
        
        // Update the frame of the view
        containerView.frame = CGRect(x: x, y: y, width: size, height: size)
        
    }
    
  
    
    
}
