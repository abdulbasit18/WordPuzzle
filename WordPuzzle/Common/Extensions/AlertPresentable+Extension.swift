//
//  AlertPresentable+Extension.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//
import UIKit

protocol AlertsPresentable: class {}

extension AlertsPresentable where Self: UIViewController {
    
    func showAlert(with title: String? = nil,
                   and message: String? = nil,
                   actionTitle: String? = "Ok",
                   handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
