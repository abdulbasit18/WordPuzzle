//
//  Container+Services.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 21/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Swinject

extension Container {
    func registerServices() {
        self.autoregister(MainGameRepositoryType.self, initializer: MainGameRepository.init)
        self.autoregister(MainGameRemoteDataStoreType.self, initializer: MainGameRemoteDataStore.init)
        self.autoregister(MainGameLocalDataStoreType.self, initializer: MainGameLocalDataStore.init)
        self.autoregister(ObjectLoaderType.self, initializer: ObjectLoader.init)
        self.autoregister(MainGameCenterType.self, initializer: MainGameCenter.init)
        self.autoregister(ProbabilityGeneratorType.self, initializer: ProbabilityGenerator.init)
        self.autoregister(GameTimerType.self, initializer: GameTimer.init)
        self.autoregister(WordPairGeneratorType.self) { (_) -> WordPairGenerator in
            WordPairGenerator(allWords: [])
        }
        self.autoregister(GameSettings.self) { (_) -> GameSettings in
            GameSettings(numberOfRounds: 0, maximumLimitForRounds: 0, minimumLimitForRounds: 0)
        }
        
    }
}
