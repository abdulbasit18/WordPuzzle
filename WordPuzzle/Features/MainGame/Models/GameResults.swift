//
//  GameResults.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 22/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct GameResults {
    var currentRound: Int = 0
    var numberOfCorrectAnswers: Int = 0
    var numberOfIncorrectAnswers: Int = 0
    var numberOfNoAnswers: Int = 0
}

extension GameResults {
    enum Answer {
        case correct
        case incorrect
        case noAnswerProvided
    }
}
