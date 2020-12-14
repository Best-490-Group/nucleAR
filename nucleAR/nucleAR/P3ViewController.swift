//
//  P3ViewController.swift
//  nucleAR
//
//  Created by David Eisenbaum on 12/10/20.
//

import UIKit
import ARKit
import SceneKit



// For collision detection
enum BodyType : Int {
    case type1 = 1
    case type2 = 2
}

class P3ViewController: UIViewController, SCNPhysicsContactDelegate {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet var timerHoop: UILabel!
    
    var powerOfShot: Float = 1.0
    
    var userHasSelected = false
    
    //setup variables for timer
    var timer: Timer?
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuring timer label
        timerHoop.frame = CGRect(x:10, y:0, width: 500, height: 200)
        timerHoop.font = timerHoop.font.withSize(30)
        timerHoop.center = CGPoint(x: 300, y: 50)
        beginTimer()

        // Set the view's delegate
        //sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Lighting
        self.sceneView.autoenablesDefaultLighting = true
        
        // Show world origin
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        // Prompt user the problem
        self.showText(textShow: "You are entering the Hot Fuel Examination Facility. Tap the element that will stabilize the hot cell.")
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/reactor.scn")!
        
        
        // Add physics to tube
        let sceneNode = scene.rootNode.childNode(withName: "emptynode", recursively: true)
        sceneNode?.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: sceneNode!, options: [SCNPhysicsShape.Option.keepAsCompound: false, SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
        
        
        // Change text
//        var theTextNode: SCNText!
//        let textNode = scene.rootNode.childNode(withName: "text", recursively: true)
//        theTextNode = textNode?.geometry as! SCNText
//        theTextNode.string = "Test Tube"
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Present balls
        showBalls()
        
        
        // Create node to detect collision
        let contactNode = SCNNode()
        contactNode.geometry = SCNBox(width: 0.7, height: 0.01, length: 0.7, chamferRadius: 0.33)
        //contactNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        contactNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        contactNode.position = SCNVector3(0,-3,-8) //pos to the right
        contactNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        contactNode.physicsBody?.categoryBitMask = BodyType.type1.rawValue
        self.sceneView.scene.rootNode.addChildNode(contactNode)
        
        
        // Handle tap for selection of argon or helium
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Collision Detection
        self.sceneView.scene.physicsWorld.contactDelegate = self
    
    }
    
    func beginTimer() {
             self.totalTime = 120
             self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
             self.view.addSubview(timerHoop)
         }
    
     //function to process timer value
     @objc func processTimer() {
             self.timerHoop.text = "Time Remaining: \(self.timeDisplay(self.totalTime))"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        
        sceneView.session.run(config)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeEveryOtherBall()
        if(userHasSelected) {
            guard let pointOfView = self.sceneView.pointOfView else {return}
            self.powerOfShot = 3
            let transform = pointOfView.transform
            let location = SCNVector3(transform.m41, transform.m42, transform.m43)
            let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
            let position = location + orientation
            let ball = SCNNode(geometry: SCNSphere(radius: 0.3))
            ball.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
            ball.position = position
            ball.name = "ball"
            
            
            let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball))
            ball.physicsBody = body
            ball.physicsBody?.applyForce(SCNVector3(orientation.x * powerOfShot, orientation.y * powerOfShot, orientation.z * powerOfShot), asImpulse: true)
            //ball.physicsBody?.categoryBitMask = BodyType.type2.rawValue // This makes ball go thru
            ball.physicsBody?.contactTestBitMask = BodyType.type1.rawValue
        
    
            self.sceneView.scene.rootNode.addChildNode(ball)
        }
    }
    
    /// remove every other ball
    func removeEveryOtherBall() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if (node.name == "ball") {
                node.removeFromParentNode()
            }
        }
    }
    
    func removeAllNodes() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    /// Called when ball touches bottom plane
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        userHasSelected = false
        self.showText(textShow: "Correct")
        DispatchQueue.main.async {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        
            // Go To next screen
            self.removeAllNodes()
            
            self.performSegue(withIdentifier: "toPuzzleOne", sender: nil)

            
        }
    }
    @IBAction func resetButton(_ sender: Any) {
        userHasSelected = false
        showBalls()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        
        if(hitTest.isEmpty) {
            print("didnt touch anything")
        }
        else {
            let results = hitTest[0].node
            print(results.name)
            if(results.name == "argon") {
                showText(textShow: "Correct element tapped, now tap the screen to shoot it into the hot cell!")
                // Allows user to "shoot" ball
                userHasSelected = true
                self.deleteArgonAndHelium()
            }
            else if (results.name == "oxygen") {
                showText(textShow: "Oxygen is incorrect. You just blew up the whole facility!!!😡")
            }
        }
    }
    
    func deleteArgonAndHelium() {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            if (node.name == "argon" || node.name == "oxygen") {
                node.removeFromParentNode()
            }
        }
    }
    
    /// Function places argon and helium and allows the user to select
    func showBalls() {
        
        // Add text to argon node
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        layer.backgroundColor = UIColor.white.cgColor
        let textLayer = CATextLayer()
        textLayer.frame = layer.bounds
        textLayer.fontSize = layer.bounds.size.height
        textLayer.string = "Argon"
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.display()
        layer.addSublayer(textLayer)
        
        // Create argon node
        let argonNode = SCNNode()
        argonNode.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.33)
        argonNode.name = "argon"
        argonNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        argonNode.geometry?.firstMaterial?.diffuse.contents = layer
        argonNode.position = SCNVector3(0.1,0,-0.01) //pos to the right
        self.sceneView.scene.rootNode.addChildNode(argonNode)
        
        // Add text to helium node
        let layer2 = CALayer()
        layer2.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        layer2.backgroundColor = UIColor.white.cgColor
        let textLayer2 = CATextLayer()
        textLayer2.frame = layer.bounds
        textLayer2.fontSize = layer.bounds.size.height
        textLayer2.string = "Oxygen"
        textLayer2.alignmentMode = CATextLayerAlignmentMode.left
        textLayer2.foregroundColor = UIColor.black.cgColor
        textLayer2.display()
        layer2.addSublayer(textLayer2)
        // Create Helium node
        let heliumNode = SCNNode()
        heliumNode.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.33)
        heliumNode.name = "oxygen"
        heliumNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        heliumNode.geometry?.firstMaterial?.diffuse.contents = layer2
        heliumNode.position = SCNVector3(-0.1,0,-0.01) //pos to the left
        self.sceneView.scene.rootNode.addChildNode(heliumNode)
    }
    
    ///Function prompts the user to tap on the correct element (argon) then is able to throw in argon
    func showText(textShow: String) {
        DispatchQueue.main.async {
            self.label.text = textShow
            self.label.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.label.isHidden = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPuzzleOne" {
            let destinationController = segue.destination as! ViewController
            destinationController.timerString = timerHoop.text!
            destinationController.totalTimeCont = self.totalTime
        }
    }

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + left.y, left.z + right.z)
}
