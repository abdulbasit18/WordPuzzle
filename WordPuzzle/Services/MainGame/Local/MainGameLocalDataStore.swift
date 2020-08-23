//
//  MainGameLocalDataStore.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Input Protocols
protocol MainGameLocalDataStoreInputs: class {
    var getWordsSubject: PublishSubject<Void?> { get }
}

// MARK: - Output Protocols
protocol MainGameLocalDataStoreOutputs: class {
    var wordsDataSubject: PublishSubject<[WordModel]> { get }
}

// MARK: - MainGameLocalDataStore Protocols
protocol MainGameLocalDataStoreType: MainGameLocalDataStoreInputs, MainGameLocalDataStoreOutputs {
    var input: MainGameLocalDataStoreInputs { get }
    var output: MainGameLocalDataStoreOutputs { get }
}

// MARK: - MainGameLocalDataStore Implementation
final class MainGameLocalDataStore: MainGameLocalDataStoreType {
    
    var input: MainGameLocalDataStoreInputs { self }
    var output: MainGameLocalDataStoreOutputs { self }
    
    // MARK: - Inputs
    var getWordsSubject = PublishSubject<Void?>()
    
    // MARK: - Outputs
    var wordsDataSubject = PublishSubject<[WordModel]>()
    
    // MARK: - Properties
    lazy var objectLoader: ObjectLoaderType? = AppDelegate.container.resolve(ObjectLoaderType.self)
    let disposeBag = DisposeBag()
    
    init() {
        //Setup Rx Bindings
        setupBindings()
    }
    
    private func setupBindings() {
        input.getWordsSubject.subscribe(onNext: { [weak self] (_) in
            self?.fetchLocalWords()
        }).disposed(by: disposeBag)
        
    }
    
    private func fetchLocalWords() {
        objectLoader?.getObject(from: "words",
                                ext: "json",
                                type: [WordModel].self,
                                completion: { [weak self] result in
                                    
                                    guard let self = self else { return }
                                    switch result {
                                    case .success(let words):
                                        self.output.wordsDataSubject.onNext(words)
                                    case .failure:
                                        break // Error is not handled due to time constraint
                                    }
        })
    }
}
