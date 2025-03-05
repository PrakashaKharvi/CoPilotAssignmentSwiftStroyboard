//
//  AppCoordinator.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 05/03/25.
//

import UIKit

class AppCoordinator {
    
    var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let viewModel = HomeViewModel()
        homeViewController.viewModel = viewModel
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
    }
    
}




