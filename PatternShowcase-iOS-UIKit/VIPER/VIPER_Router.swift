//
//  VIPER_Router.swift
//  PatternShowcase-iOS-UIKit
//
//  Created by Samet Koyuncu on 23.07.2023.
//

import UIKit

class VIPERRouter {
    static func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ThirdVC") as! ThirdVC
        return viewController
    }
}
