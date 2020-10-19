//
//  ViewController.swift
//  nucleAR
//
//  Created by Johanna Guevara on 10/18/20.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arMagicView: ARView!
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        arMagicView.session.delegate = self
        setupARView()
        arMagicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchScreenInteraction(recognizer:))))
    }
    
    // SET UP
    // Disabling the default configurations to remove any predefined limitations
    
    func setupARView(){
        arMagicView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic // supports IOS 12 and up
        arMagicView.session.run(configuration) // replacing default with ARWorld
    }
    
    // RECOGNIZE TOUCH
    // Translates user's touch screen interactions to coordinates in space
    @objc
    func touchScreenInteraction(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arMagicView) // AR object location
        let results = arMagicView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        // checks if AR location intersects with the real world enviornment
        
        // if there was a response we will anchor
        if let firstResult = results.first {
            let anchor = ARAnchor(name: "Nsymbol", transform:firstResult.worldTransform) // anchor usdz model 'Nsymbol'
            arMagicView.session.add(anchor: anchor)
        } else{
            print("ERROR: Object placement failed")
        }
    }
    
    // ATTACH OBJECT
    // Anchors the model entity to the scene
    func addAnchor(named entityName: String, for anchor: ARAnchor){
        let entity = try! ModelEntity.loadModel(named: entityName)      // Step 1: Create model entity
        entity.generateCollisionShapes(recursive: true)
        arMagicView.installGestures((.rotation), for: entity)
        
        let anchorEntity = AnchorEntity(anchor: anchor)                 // Step 2: Create anchor entity
        anchorEntity.addChild(entity)                                   // Step 3: Add model to anchor
        arMagicView.scene.addAnchor(anchorEntity)                       // Step 4: Add it to your scene
    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]){
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "Nsymbol" {
                addAnchor(named: anchorName, for: anchor)
            }
        }
    }
}
