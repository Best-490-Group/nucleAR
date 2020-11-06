//
//  HomeScreenViewController.swift
//  nucleAR
//
//  Created by David Eisenbaum on 11/5/20.
//

import UIKit

class HomeScreenViewController: UIViewController {

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
