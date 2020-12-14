/*
  Johanna Guevara, Shifa Salam, David Eisenbaum, Naz Parsamyan, Sevak Baghumyan
*/

import UIKit
import RealityKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet var arMagicView: ARView!
    @IBOutlet var timerLabel: UILabel!
    
    var timerTwo: Timer?
    var totalTimeCont = Int()
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
        continueTimer()

        guard let anchor = try? MyScene.loadBox() else { return }
        arMagicView.scene.anchors.append(anchor)
        
    }
    
    func continueTimer() {
             self.timerTwo = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
             self.view.addSubview(timerLabel)
         }
    
     //function to process timer value
     @objc func processTimer() {
             self.timerLabel.text = "Time Remaining: \(self.timeDisplay(self.totalTimeCont))"
             if totalTimeCont > 0 {
                 totalTimeCont -= 1
             } else {
                 totalTimeCont = 0
                 if let timerTwo = self.timerTwo {
                     //.invalidate() to stop timer
                     timerTwo.invalidate()
                     self.timerTwo = nil
                    
                                self.arMagicView.scene.anchors.removeAll()
                       
        
             }
                
             }
         }
    
    //function to help format the time
     func timeDisplay(_ totalSeconds: Int) -> String {
         let sec: Int = totalSeconds % 60
         let min: Int = (totalSeconds / 60) % 60
         return String(format: "%02d:%02d", min, sec)
     }
}
