//
//  MainGameViewController.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

// MARK: - Protocols

protocol MainGameViewControllerType {}

final class MainGameViewController: BaseViewController, MainGameViewControllerType {
    
    private let viewModel: MainGameViewModelType
    
    // MARK: - Init
    init(_ viewModel: MainGameViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
