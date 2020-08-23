//
//  BaseViewController.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable, AlertsPresentable {
    
    let reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReachability()
    }
    
    //Check Internet Connection Availability
    private func setReachability() {
        reachability?.whenUnreachable = { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(with: "Network Error",
                           and: "Your Internet Appears to be Offline")
        }
        try? reachability?.startNotifier()
    }
}
