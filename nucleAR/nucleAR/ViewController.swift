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
    
    //setup variables for Puzzle 1
    var anchorPuzzle1: Puzzle1.P1!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuring timer label
        timerLabel.frame = CGRect(x:10, y:0, width: 500, height: 200)
        timerLabel.font = timerLabel.font.withSize(30)
        timerLabel.center = CGPoint(x: 300, y: 50)
        beginTimer()
        
        // configuring tap gesture recognizer
        //let itemTap = UITapGestureRecognizer(target: self, action: #selector(Tappy))
        //view.addGestureRecognizer(itemTap)
        
        //setting up anchor for Puzzle 1
        anchorPuzzle1 = try! Puzzle1.loadP1()
        anchorPuzzle1.generateCollisionShapes(recursive: true)
        arMagicView.scene.addAnchor(anchorPuzzle1)
        //arMagicView.scene.anchors.append(anchorPuzzle1)
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
