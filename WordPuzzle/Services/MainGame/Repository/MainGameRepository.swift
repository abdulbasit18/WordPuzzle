//
//  MainGameRepository.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 21/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Input Protocols
protocol MainGameRepositoryInputs: class {
    var getWordsSubject: PublishSubject<Void?> { get }
}

// MARK: - Outputs Protocols
protocol MainGameRepositoryOutputs: class {
    var wordsDataSubject: PublishSubject<[WordModel]> { get }
}

// MARK: - MainGameRepository Protocols
protocol MainGameRepositoryType: MainGameRepositoryInputs, MainGameRepositoryOutputs {
    var input: MainGameRepositoryInputs { get }
    var output: MainGameRepositoryOutputs { get }
}

// MARK: - MainGameLocalDataStore Implementation
final class MainGameRepository: MainGameRepositoryType {
    
    var input: MainGameRepositoryInputs { self }
    var output: MainGameRepositoryOutputs { self }
    
    // MARK: - Inputs
    var getWordsSubject = PublishSubject<Void?>()
    
    // MARK: - Outputs
    var wordsDataSubject = PublishSubject<[WordModel]>()
    
    // MARK: - Properties
    private var remoteStore: MainGameRemoteDataStoreType
    private var localStore: MainGameLocalDataStoreType
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(remoteStore: MainGameRemoteDataStoreType, localStore: MainGameLocalDataStoreType) {
        self.remoteStore = remoteStore
        self.localStore = localStore
        
        //Set Rx Bindings
        setupBindings()
    }
    // Note: Currently Only local fetch is implemented
    private func setupBindings() {
        //Input
        
        //Get request from view model from data source and pass it to local repo
        input.getWordsSubject
            .bind(to: localStore.input.getWordsSubject)
            .disposed(by: disposeBag)
        
        //output
        
        //Pass local fetched data source to viewModel
        localStore.output.wordsDataSubject
            .bind(to: output.wordsDataSubject)
            .disposed(by: disposeBag)
    }
}
