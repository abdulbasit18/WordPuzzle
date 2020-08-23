//
//  Container+Coordinators.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 21/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerCoordinators() {
        self.autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        self.autoregister(MainGameCoordinator.self, initializer: MainGameCoordinator.init)
    }
}
