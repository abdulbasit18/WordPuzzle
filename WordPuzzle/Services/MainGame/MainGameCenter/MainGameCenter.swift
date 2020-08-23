//
//  MainGameCenter.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Inputs
protocol MainGameCenterInput {
    var startNewRoundSubject: PublishSubject<Void?> { get }
    var updateResultSubject: PublishSubject<GameResults.Answer> { get }
}

// MARK: - Outputs
protocol MainGameCenterOutput {
    var onEventSubject: PublishSubject<MainGameCenter.Event> { get }
    var getGameResultsSubject: PublishSubject<GameResults> { get }
}

// MARK: - MainGameCenter Protocol
protocol MainGameCenterType: MainGameCenterInput, MainGameCenterOutput {
    var inputs: MainGameCenterInput { get }
    var outputs: MainGameCenterOutput { get }
    var probabilityGenerator: ProbabilityGeneratorType { get}
    var wordPairGenerator: WordPairGeneratorType { get}
    var gameSettings: GameSettings { get set }
}

// MARK: - MainGameCenter Implementation
final class MainGameCenter: MainGameCenterType {
    
    var inputs: MainGameCenterInput { self }
    var outputs: MainGameCenterOutput { self }
    
    //Inputs
    var startNewRoundSubject = PublishSubject<Void?>()
    var updateResultSubject = PublishSubject<GameResults.Answer>()
    
    //Outputs
    var onEventSubject = PublishSubject<MainGameCenter.Event>()
    var getGameResultsSubject = PublishSubject<GameResults>()
    
    var gameSettings: GameSettings
    var gameResult: GameResults = GameResults()
    let probabilityGenerator: ProbabilityGeneratorType
    let wordPairGenerator: WordPairGeneratorType
    private let disposeBag = DisposeBag()
    
    init(gameSettings: GameSettings,
         probabilityGenerator: ProbabilityGeneratorType,
         wordPairGenerator: WordPairGeneratorType) {
        
        self.probabilityGenerator = probabilityGenerator
        self.wordPairGenerator = wordPairGenerator
        self.gameSettings = gameSettings
        
        //Set Rx Bindings
        setupBindings()
        
    }
    
    private func setupBindings() {
        
        //Inputs
        inputs.updateResultSubject.subscribe(onNext: { [weak self] (answer) in
            self?.updateResult(with: answer)
            self?.startNewRound()
        }).disposed(by: disposeBag)
        
        inputs.startNewRoundSubject.subscribe(onNext: { [weak self] (_) in
            self?.startNewRound()
        }).disposed(by: disposeBag)
        
        // Outputs
        wordPairGenerator.outputs.getPairSubject.subscribe(onNext: { [weak self] (pair) in
            guard let self = self else { return }
            self.gameResult.currentRound += 1
            if self.gameResult.currentRound > self.gameSettings.numberOfRounds {
                self.outputs.onEventSubject.onNext(.gameFinished(self.gameResult))
                self.cleanData()
            } else {
                self.outputs.onEventSubject.onNext(.newRound(self.gameResult.currentRound))
                self.outputs.onEventSubject.onNext(.newWordPair(pair))
            }
            self.outputs.onEventSubject.onNext(.currentGameResult(self.gameResult))
        }).disposed(by: disposeBag)
    }
    
    private func cleanData() {
        gameResult = GameResults()
    }
}

extension MainGameCenter {
    
    func getGameResults() -> GameResults {
        gameResult
    }
    
    func startNewRound() {
        newRound()
    }
    
    func updateResult(with answer: GameResults.Answer) {
        switch answer {
        case .correct:
            self.gameResult.numberOfCorrectAnswers += 1
        case .incorrect:
            self.gameResult.numberOfIncorrectAnswers += 1
        case .noAnswerProvided:
            self.gameResult.numberOfNoAnswers += 1
        }
        self.outputs.getGameResultsSubject.onNext(self.gameResult)
    }
}

extension MainGameCenter {
    
    private func newRound() {
        generatePair()
        
    }
    private func generatePair() {
        let isCorrectPair = probabilityGenerator.isTheNextPairCorrect()
        wordPairGenerator.inputs.generatePairSubject.onNext(isCorrectPair)
    }
    
}

extension MainGameCenter {
    enum Event {
        case newRound(Int)
        case newWordPair(RoundModel)
        case currentGameResult(GameResults)
        case gameFinished(GameResults)
    }
}
