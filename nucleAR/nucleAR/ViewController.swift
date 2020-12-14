/*
  Johanna Guevara, Shifa Salam, David Eisenbaum, Naz Parsamyan, Sevak Baghumyan
*/

import UIKit
import RealityKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet var arMagicView: ARView!
    @IBOutlet var timerLabel: UILabel!
    
    //setup variables for timer
    var timer: Timer?
    var totalTime = 60
    
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
        beginTimer()
        
        guard let anchor = try? MyScene.loadBox() else { return }
        arMagicView.scene.anchors.append(anchor)
    }

    
    //function to execute timer
    func beginTimer() {
             self.totalTime = 120
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
    
}
