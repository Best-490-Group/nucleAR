//
//  SplashViewController.swift
//  RootControllerNavigation
//
//  Created by Stanislav Ostrovskiy on 12/5/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    private let hintsIndicator = UIActivityIndicatorView(style: .UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(hintsIndicator)
        
        hintsIndicator.frame = view.bounds
        hintsIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        makeServiceCall()
    }
    
    private func makeServiceCall() {
        hintsIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.hintsIndicator.stopAnimating()
            if UserDefaults.standard.bool(forKey: "SESSION_STARTED") {
                AppDelegate.shared.rootViewController.switchToHomeScreen()
            } else {
                AppDelegate.shared.rootViewController.switchToEscapeRoom()
            }
        }
    }
}
