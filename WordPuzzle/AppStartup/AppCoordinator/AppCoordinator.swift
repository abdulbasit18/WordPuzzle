//
//  AppCoordinator.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

final class AppCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        //Inject Main Coordinator
        let coordinator = AppDelegate.container.resolve(MainGameCoordinator.self)!
        self.start(coordinator: coordinator)
        // Set MainGame View as Root View Controller
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
    }
}
