//
//  DefeatVC.swift
//  nucleAR
//
//  Created by Shifath Salam on 12/14/20.
//

import UIKit

class DefeatVC: UIViewController {
    
    
    @IBOutlet weak var websiteButtonTwo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    @IBAction func onWebsiteButtonClick(_ sender: UIButton) {
        if let url = URL(string: "https://navigatingnuclear.com/nuclear-reimagined-vft/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
