//
//  MainGameViewModel.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import RxSwift

// MARK: - MainGame Protocol
protocol MainGameViewModelType {
}

// MARK: - MainGameViewModel Implementation

final class MainGameViewModel: MainGameViewModelType {
    // MARK: - Properties
    private let repository: MainGameRepositoryType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(repository: MainGameRepositoryType) {
        self.repository = repository
    }
}
