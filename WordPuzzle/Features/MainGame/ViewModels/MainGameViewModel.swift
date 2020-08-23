//
//  MainGameViewModel.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Input Protocols
protocol MainGameViewModelInput: class {
    var viewDidLoadSubject: PublishSubject<Void?> { get }
    var tappedCorrectAnswerSubject: PublishSubject<Void?> { get }
    var tappedWrongAnswerSubject: PublishSubject<Void?> { get }
    var restartSubject: PublishSubject<Void?> { get }
}

// MARK: - Output Protocols
protocol MainGameViewModelOutput: class {
    var displayError: PublishSubject<Error> { get }
    var displayRoundNumber: PublishSubject<Int> { get }
    var displayRound: PublishSubject<RoundModel> { get }
    var display: PublishSubject<GameResults> { get }
    var gameFinished: PublishSubject<Void?> { get}
    var removeLoadingAnimation: PublishSubject<Void?> { get }
    var showLoadingAnimation: PublishSubject<Void?> { get }
    var speedOfGame: Double { get }
    var resultSubject: PublishSubject<String> { get }
}

// MARK: - MainGame Protocol
protocol MainGameViewModelType: MainGameViewModelInput, MainGameViewModelOutput {
    var input: MainGameViewModelInput { get }
    var output: MainGameViewModelOutput { get }
}

// MARK: - MainGameViewModel Implementation

final class MainGameViewModel: MainGameViewModelType {
    
    var input: MainGameViewModelInput { self }
    var output: MainGameViewModelOutput { self }
    
    // MARK: - Inputs
    var viewDidLoadSubject = PublishSubject<Void?>()
    var tappedCorrectAnswerSubject = PublishSubject<Void?>()
    var tappedWrongAnswerSubject = PublishSubject<Void?>()
    var restartSubject = PublishSubject<Void?>()
    
    // MARK: - Outputs
    var displayError = PublishSubject<Error>()
    var displayRoundNumber = PublishSubject<Int>()
    var displayRound = PublishSubject<RoundModel>()
    var display = PublishSubject<GameResults>()
    var gameFinished = PublishSubject<Void?>()
    var removeLoadingAnimation = PublishSubject<Void?>()
    var showLoadingAnimation = PublishSubject<Void?>()
    var resultSubject = PublishSubject<String>()
    var speedOfGame: Double = AppConstants.speedOfGame
    var isGameFinished: Bool = false
    
    // MARK: - Properties
    private let repository: MainGameRepositoryType
    private var gameCenter: MainGameCenterType
    let timer: GameTimerType? = AppDelegate.container.resolve(GameTimerType.self)
    private let disposeBag = DisposeBag()
    private var currentWord: RoundModel?
    
    // MARK: - Initializer
    init(repository: MainGameRepositoryType,
         gameCenter: MainGameCenterType) {
        self.repository = repository
        self.gameCenter = gameCenter
        //Setup RX Bindings
        setupBindings()
    }
    
    private func setupBindings() {
        
        //Inputs
        inputBindings()
        
        //Outputs
        outputBindings()
    }
    
    private func inputBindings() {
        
        //Get ViewModelLoad invocation for data loading
        input.viewDidLoadSubject
            .bind(to: repository.input.getWordsSubject)
            .disposed(by: disposeBag)
        
        //Restart game when tapped on restart button
        input.restartSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            //Fetch words data source and start game from them
            self.repository.input.getWordsSubject.onNext(nil)
            //Change game state
            self.isGameFinished = false
        }).disposed(by: disposeBag)
        
        //Evaluate answer when user tap correct button
        input.tappedCorrectAnswerSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.stopTimer()
            //Check if answer is correct
            let answer: GameResults.Answer = (self.currentWord?.isCorrectPair ?? false) ? .correct : .incorrect
            // Update the results
            self.gameCenter.inputs.updateResultSubject.onNext(answer)
            //Start new round if required
            self.gameCenter.startNewRoundSubject.onNext(nil)
            self.startTimer()
        }).disposed(by: disposeBag)
        
        //Evaluate answer when user tap wrong button
        input.tappedWrongAnswerSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.stopTimer()
            //Check if answer is correct
            let answer: GameResults.Answer = (self.currentWord?.isCorrectPair ?? false) ? .incorrect : .correct
            // Update the results
            self.gameCenter.inputs.updateResultSubject.onNext(answer)
            //Start new round if required
            self.gameCenter.startNewRoundSubject.onNext(nil)
            self.startTimer()
        }).disposed(by: disposeBag)
    }
    
    private func outputBindings() {
        
        //Show loading animation to user since on viewLoad trigger we have called service
        output.showLoadingAnimation.onNext(nil)
        
        //Subscribed for data source from repository
        repository.output.wordsDataSubject.subscribe(onNext: { [weak self] (words) in
            self?.output.removeLoadingAnimation.onNext(nil)
            //Start game with given words
            self?.present(words: words)
            }, onError: { [weak self] _ in
                self?.output.removeLoadingAnimation.onNext(nil)
        }).disposed(by: disposeBag)
        
        //Get game events and changed ui accordingly
        gameCenter.outputs.onEventSubject.subscribe(onNext: { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .newRound(let number):
                print("Round Number \(number)")
            case .newWordPair(let wordPair):
                //Get new pair and update the UI
                self.currentWord = wordPair
                self.output.displayRound.onNext(wordPair)
            case .currentGameResult(let results):
                print("Result \(results)")
            case .gameFinished(let results):
                //After finishing the game clean game settings
                self.isGameFinished = true
                self.stopTimer()
                //Update ui with the result
                self.prepare(result: results)
            }
        }).disposed(by: disposeBag)
    }
    
    private func present(words: [WordModel]) {
        stopTimer()
        output.removeLoadingAnimation.onNext(nil)
        let gameSetting =  GameSettings(numberOfRounds: 3, maximumLimitForRounds: 10, minimumLimitForRounds: 1)
        setupGameCenter(with: words, gameSettings: gameSetting)
        startNewRound()
        startTimer()
    }
    
    private func setupGameCenter(with words: [WordModel], gameSettings: GameSettings) {
        gameCenter.gameSettings = gameSettings
        gameCenter.wordPairGenerator.inputs.updateWordsSubject.onNext(words)
    }
    
    private func stopTimer() {
        timer?.stop()
    }
    
    private func startTimer() {
        setTimerAction { [weak self] in
            guard let self = self else { return}
            if !self.isGameFinished {
                self.gameCenter.inputs.updateResultSubject.onNext(.noAnswerProvided)
                self.gameCenter.inputs.startNewRoundSubject.onNext(nil) } else {
                self.stopTimer()
            }
        }
        timer?.start(timeInterval: speedOfGame)
    }
    
    private func setTimerAction(action: @escaping () -> Void) {
        timer?.timerAction(action: action)
    }
    
    private func startNewRound() {
        gameCenter.inputs.startNewRoundSubject.onNext(nil)
    }
    
    private func prepare(result: GameResults) {
        var resultString = "Correct Answers: \(result.numberOfCorrectAnswers) \n"
        resultString.append("Wrong Answers: \(result.numberOfIncorrectAnswers) \n")
        resultString.append("No Answers: \(result.numberOfNoAnswers)")
        output.resultSubject.onNext(resultString)
    }
}
