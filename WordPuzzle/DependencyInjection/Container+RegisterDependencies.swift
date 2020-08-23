//
//  Container+RegisterDependencies.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 21/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    
    func registerDependencies() {
        self.registerServices()
        self.registerCoordinators()
        self.registerViewModels()
        self.registerViewControllers()
    }
}
