//
//  WordPairGenerator.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Input Protocols
protocol WordPairGeneratorInput {
    var generatePairSubject: PublishSubject<Bool> { get }
    var updateWordsSubject: PublishSubject<[WordModel]> { get }
}

// MARK: - Outputs Protocols
protocol WordPairGeneratorOutput {
    var getPairSubject: PublishSubject<RoundModel> { get }
}

// MARK: - WordPairGenerator Protocols
protocol WordPairGeneratorType: WordPairGeneratorInput, WordPairGeneratorOutput {
    var inputs: WordPairGeneratorInput { get}
    var outputs: WordPairGeneratorOutput { get }
}

// MARK: - WordPairGenerator Implementation
final class WordPairGenerator: WordPairGeneratorType {
    
    var inputs: WordPairGeneratorInput { self }
    var outputs: WordPairGeneratorOutput { self }
    
    // MARK: - Inputs
    var generatePairSubject = PublishSubject<Bool>()
    var updateWordsSubject = PublishSubject<[WordModel]>()
    
    // MARK: - OutPuts
    var getPairSubject = PublishSubject<RoundModel>()
    
    // MARK: - Properties
    private var allWords: [WordModel] = []
    private let disposeBag = DisposeBag()
    
    init(allWords: [WordModel] = []) {
        self.allWords = allWords
        
        //Setup RX Bindings
        setupBindings()
    }
    
    private func setupBindings() {
        //Inputs
        inputs.generatePairSubject
            .subscribe(onNext: { [weak self] (isCorrectPair) in
                if let pair = self?.generatePair(isCorrectPair: isCorrectPair) {
                    //Output
                    self?.outputs.getPairSubject.onNext(pair)
                }
            }).disposed(by: disposeBag)
        
        inputs.updateWordsSubject
            .subscribe(onNext: { [weak self] (words) in
                self?.updateWords(words)
            }).disposed(by: disposeBag)
    }
    
    private func updateWords(_ words: [WordModel]) {
        allWords = words
    }
    
    private func generatePair(isCorrectPair: Bool) -> RoundModel {
        let totalPairCount = allWords.count - 1
        let randomInt = Int.random(in: 0...totalPairCount)
        let randomElement = allWords[randomInt]
        allWords.remove(at: randomInt)
        if isCorrectPair {
            return RoundModel(currentWord: randomElement.english,
                              translation: randomElement.spanish,
                              isCorrectPair: true)
        } else {
            let randomWord = allWords.randomElement()!
            return RoundModel(currentWord: randomElement.english,
                              translation: randomWord.spanish,
                              isCorrectPair: false)
        }
    }
}
