//
//  HomeScreenViewController.swift
//  nucleAR
//
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var firstTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        firstTitle.text = "nucleAR"
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
