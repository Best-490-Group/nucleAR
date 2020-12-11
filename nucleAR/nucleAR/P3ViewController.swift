//
//  P3ViewController.swift
//  nucleAR
//
//  Created by David Eisenbaum on 12/10/20.
//

import UIKit
import ARKit
import SceneKit

class P3ViewController: UIViewController {

    @IBOutlet weak var label: ARSCNView!
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func resetButton(_ sender: Any) {
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
