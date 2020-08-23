//
//  ObjectLoader.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

// MARK: - Protocols
protocol ObjectLoaderType: class {
    func getObject<T: Codable>(from fileName: String,
                               ext: String,
                               type: T.Type,
                               completion: @escaping (Result<T, Swift.Error>) -> Void )
}

// MARK: - ObjectLoader Implementation
final class ObjectLoader: ObjectLoaderType {
    
    func getObject<T: Codable>(from fileName: String,
                               ext: String,
                               type: T.Type,
                               completion: @escaping (Result<T, Swift.Error>) -> Void ) {
        DispatchQueue.global().async {
            do {
                guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
                    DispatchQueue.main.async {
                        completion(.failure(Error.invalidURL))
                    }
                    return
                }
                
                let data = try Data(contentsOf: url)
                let object: T = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    enum Error: Swift.Error {
        case invalidURL
    }
}
