/*
  Johanna Guevara, Shifa Salam, David Eisenbaum, Naz Parsamyan, Sevak Baghumyan
*/

import UIKit
import RealityKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet var arMagicView: ARView!
    @IBOutlet var timerLabel: UILabel!
    

 var timerString = String()
    
//    func triggerAction(){
//        if let anchorPuzzle1 = arMagicView.scene.anchors[0] as? MyScene.Box2{
//            anchorPuzzle1.notifications.triggerAction.post()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuring timer label
        timerLabel.frame = CGRect(x:10, y:0, width: 500, height: 200)
        timerLabel.font = timerLabel.font.withSize(30)
        timerLabel.center = CGPoint(x: 300, y: 50)
        timerLabel.text = timerString
        self.view.addSubview(timerLabel)
//        let anchorPuzzle1 = try! MyScene.loadBox2()
//        anchorPuzzle1.actions.reactorEnding.onAction
        
        var anchorPuzzle1: MyScene.Box!
        anchorPuzzle1 = try! MyScene.loadBox()
        anchorPuzzle1.generateCollisionShapes(recursive: true)
        arMagicView.scene.addAnchor(anchorPuzzle1)
        //arMagicView.scene.anchors.append(anchorPuzzle1)
        
        
        
        //anchorPuzzle1.actions.ReactorEnding.onAction = handleTapOnEntity(_:)
        
//        if(anchorPuzzle1.scene?.name == "ARView.scene-4"){
//            print("okay")
//        }
//        //4389697504 aka ARView.scene-4 aka Box2
    }
    
//    func handleTapOnEntity(_ entity: Entity?) {
//         guard let entity = entity else { return }
//         print("Made it")
//     }
}
