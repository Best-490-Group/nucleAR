//
//  HomeScreenViewController.swift
//  nucleAR
//
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Customize button
        startButton.frame = CGRect(x: 160, y: 160, width: 160, height: 160)
        startButton.layer.cornerRadius = 18.0
        startButton.layer.borderWidth = 1.0
        startButton.clipsToBounds = true
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
