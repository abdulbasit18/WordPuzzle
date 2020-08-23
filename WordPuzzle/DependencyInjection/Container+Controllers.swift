//
//  Container+Controllers.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 21/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    
    func registerViewControllers() {
        self.autoregister(MainGameViewControllerType.self, initializer: MainGameViewController.init)
    }
}
