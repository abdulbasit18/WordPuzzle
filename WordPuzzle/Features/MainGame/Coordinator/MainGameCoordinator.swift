//
//  MainGameCoordinator.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit

final class MainGameCoordinator: BaseCoordinator {
    
    // MARK: - Initializer
    override init() {
        super.init()
        
    }
    
    // MARK: - Start
    override func start() {
        if let viewController = AppDelegate.container.resolve(MainGameViewControllerType.self) as? UIViewController {
            self.navigationController.setViewControllers([viewController], animated: true)
            
        }
    }
}
