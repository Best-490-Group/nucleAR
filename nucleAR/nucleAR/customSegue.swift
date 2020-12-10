//
//  customSegue.swift
//  nucleAR
//
//  Created by Shifath Salam on 12/9/20.
//

import Foundation
import UIKit

class SegueNavigationReplaceTop: UIStoryboardSegue {

    override func perform () {
        guard let navigationController = source.navigationController else { return }
        navigationController.popViewController(animated: false)
        navigationController.pushViewController(destination, animated: false)
    }
}
