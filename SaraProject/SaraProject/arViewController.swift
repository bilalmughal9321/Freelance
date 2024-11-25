//  arViewController.swift
//  ARproject
//  Created by Sara Alkatheeri on 19/04/2024.

import UIKit
import RealityKit

class arViewController: UIViewController {

    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)

        // Do any additional setup after loading the view.
        
        
        // Load your image as a texture
        let imageTexture = try! TextureResource.load(named: "MonaLisa")

        // Create a plane mesh with the same aspect ratio as your image
        let imageSize: Float = 0.1 // Adjust the size as needed
        let planeMesh = MeshResource.generatePlane(width: imageSize, height: imageSize)

        // Create a material with your image texture
        var material = SimpleMaterial(color: .white, // Set color to white if you want the texture to be shown as it is
                                      isMetallic: false) // Set metallic property as needed

        // Apply the texture to the material
        material.baseColor = MaterialColorParameter.texture(imageTexture)

        // Create a model entity with the plane mesh and the image material
        let imageEntity = ModelEntity(mesh: planeMesh, materials: [material])

        // Create an anchor entity to position the image in the AR scene
        let imageAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 0))
        imageAnchor.addChild(imageEntity)

        // Add the anchor entity to the ARView's scene
        arView.scene.addAnchor(imageAnchor)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
