//
//  WordModel.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

struct WordModel {
    let english: String
    let spanish: String
}

extension WordModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case english = "text_eng"
        case spanish = "text_spa"
    }
    
}
