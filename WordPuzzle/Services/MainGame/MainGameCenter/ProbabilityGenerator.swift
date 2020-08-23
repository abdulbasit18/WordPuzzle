//
//  ProbabilityGenerator.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

// MARK: - Protocols
protocol ProbabilityGeneratorType: class {
    func isTheNextPairCorrect() -> Bool
}

// MARK: - ProbabilityGenerator Implementation
final class ProbabilityGenerator: ProbabilityGeneratorType {
    func isTheNextPairCorrect() -> Bool {
        let randomInt = Int.random(in: 0...2)
        return randomInt == 2
    }
}
