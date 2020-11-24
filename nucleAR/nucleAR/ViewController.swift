//
//  Puzzle 2 View Controller
//  nucleAR
//
// Created by Shifa Salam
//

import UIKit
import RealityKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var arMagicView: ARView!
    @IBOutlet var timerLabel: UILabel!
    
    //setup variables for timer
    var timer: Timer?
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuring timer label
        timerLabel.frame = CGRect(x:10, y:0, width: 500, height: 200)
        timerLabel.font = timerLabel.font.withSize(30)
        timerLabel.center = CGPoint(x: 300, y: 50)
        beginTimer()
        
        // configuring tap gesture recognizer
        let itemTap = UITapGestureRecognizer(target: self, action: #selector(Tappy))
        view.addGestureRecognizer(itemTap)
        
        //setting up anchor with an AnchorEntity
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
           arMagicView.scene.addAnchor(anchor)
        
        //setting up elements
        var elements: [Entity] = []
        for _ in 1...4 {
               let box = MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
               let blackMaterial = SimpleMaterial(color: .black, isMetallic: true)
               let model = ModelEntity(mesh: box, materials: [blackMaterial])
               model.generateCollisionShapes(recursive: true)
               elements.append(model)
        }
        
        //setting up positioning for each element
        for (idx, element) in elements.enumerated() {
               let x = Float(idx % 4) - 1.5
               let z = Float(idx / 4) - 1.5
               element.position = [x*0.1, 0, z*0.1]
               anchor.addChild(element)
        }
           
        //configuring square platform for each element
        let squareSize: Float = 0.7
        let squareMesh = MeshResource.generateBox(size: squareSize)
        let occlusionSquare = ModelEntity(mesh: squareMesh, materials: [OcclusionMaterial()])
           occlusionSquare.position.y = -squareSize/2
        anchor.addChild(occlusionSquare)
           
           
        // creating cancellable to stop side effects
        var cancellable: AnyCancellable? = nil
           //loading usdz models
           cancellable = ModelEntity.loadModelAsync(named: "01")
            .append(ModelEntity.loadModelAsync(named: "02"))
            .append(ModelEntity.loadModelAsync(named: "03"))
            .append(ModelEntity.loadModelAsync(named: "04"))
           .collect()
               .sink(receiveCompletion: {error in
                   print("Error: \(error)")
                   cancellable?.cancel()
               }, receiveValue: { items in
                   var objects: [ModelEntity] = []
                   for item in items {
                       item.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: anchor)
                       item.generateCollisionShapes(recursive: true)
                       objects.append(item.clone(recursive: true))
                   }
                   //setting a name for each object
                   for (idx,obj) in objects.enumerated() {
                       obj.name = "entity_\(idx)"
                   }
                   //randomizing objects
                   objects.shuffle()
                   for (idx, obj) in objects.enumerated() {
                       elements[idx].addChild(obj)
                    if(obj.name=="entity_1"){
                        elements[idx].name = "entity_1" 
                   }
                       print(elements[idx])
                   }
                   cancellable?.cancel()
               })
       }
    
    //function to execute timer
    func beginTimer() {
             self.totalTime = 60
             self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
             self.view.addSubview(timerLabel)
         }
    
     //function to process timer value
     @objc func processTimer() {
             self.timerLabel.text = "Time Remaining: \(self.timeDisplay(self.totalTime))"
             if totalTime > 0 {
                 totalTime -= 1
             } else {
                 totalTime = 0
                 if let timer = self.timer {
                     //.invalidate() to stop timer
                     timer.invalidate()
                     self.timer = nil
                 }
             }
         }
    
    //function to help format the time
     func timeDisplay(_ totalSeconds: Int) -> String {
         let sec: Int = totalSeconds % 60
         let min: Int = (totalSeconds / 60) % 60
         return String(format: "%02d:%02d", min, sec)
     }
    
    // Tap function for puzzle 2 items
    @IBAction func Tappy(_ sender: UITapGestureRecognizer) {
        // locate where the user is tapping
        let tapLocation = sender.location(in: arMagicView)
                // configuring success label for the right answer
                let success = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 22))
                success.textColor = UIColor.white
                success.backgroundColor = UIColor.systemGreen
                success.center = CGPoint(x: 200, y: 10)
                success.textAlignment = .center
                // configuring error label for the wrong answer
                let error = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 22))
                error.textColor = UIColor.white
                error.backgroundColor = UIColor.red
                error.center = CGPoint(x: 200, y: 10)
                error.textAlignment = .center
                if let element = arMagicView.entity(at: tapLocation) {
                    // add time on correct choice or remove time on wrong choice
                    if element.name == "entity_1" {
                        totalTime += 10
                        success.text = "Correct! +10s"
                        self.view.addSubview(success)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            success.removeFromSuperview()
                        }
                    }else{
                        totalTime -= 10
                        error.text = "Incorrect! -10s"
                        self.view.addSubview(error)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            error.removeFromSuperview()
                        }
                    }
            }
    }
}
