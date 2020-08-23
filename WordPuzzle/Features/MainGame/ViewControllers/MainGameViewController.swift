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
    
    // MARK: - Properties
    private let viewModel: MainGameViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    private let _headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Guess The Correct Word"
        label.font = MainGameViewController.Constants.headerFont
        return label
    }()
    private let _wordLabel = UILabel()
    private let _floatingWordLabel = UILabel()
    private let _rightButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    private let _wrongButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    // MARK: - Init
    init(_ viewModel: MainGameViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        //Setup UI
        setupUI()
        
        //Setup Layout
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        // Title View Setup
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "Word Puzzle"
        let imageV = UIImageView()
        imageV.image = UIImage(named: "NavIcon")
        
        stackView.addArrangedSubview(imageV)
        stackView.addArrangedSubview(label)
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        navigationItem.titleView = stackView
        
        _rightButton.setImage(
            UIImage(named: "Right")?.withRenderingMode(.alwaysOriginal),
            for: .normal)
        _wrongButton.setImage(
            UIImage(named: "Wrong")?.withRenderingMode(.alwaysOriginal),
            for: .normal)
        
        _wordLabel.font = .systemFont(ofSize: 30)
        _wordLabel.textColor = .orange
        
        _floatingWordLabel.textAlignment = .center
        _floatingWordLabel.backgroundColor = .orange
        _floatingWordLabel.textColor = .white
        _floatingWordLabel.layer.masksToBounds = true
        _floatingWordLabel.clipsToBounds = true
        _floatingWordLabel.font = .systemFont(ofSize: 40)
        _floatingWordLabel.layer.cornerRadius = 10
        
    }
    
    private func setupLayout() {
        
        //Labels Layout
        view.addSubview(_headerLabel)
        _headerLabel.translatesAutoresizingMaskIntoConstraints = false
        _headerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top
                .equalTo(view.safeAreaLayoutGuide.snp.topMargin)
                .offset(Constants.margin)
        }
        
        view.addSubview(_wordLabel)
        _wordLabel.translatesAutoresizingMaskIntoConstraints = false
        _wordLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top
                .equalTo(_headerLabel.snp.bottom)
                .offset(Constants.margin)
        }
        
        view.addSubview(_floatingWordLabel)
        _floatingWordLabel.translatesAutoresizingMaskIntoConstraints = false
        _floatingWordLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        //Buttons Layout
        view.addSubview(_rightButton)
        _rightButton.translatesAutoresizingMaskIntoConstraints = false
        _rightButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Constants.buttonsMargin)
            make.bottom.equalToSuperview().offset(-Constants.buttonsMargin)
        }
        
        view.addSubview(_wrongButton)
        _wrongButton.translatesAutoresizingMaskIntoConstraints = false
        _wrongButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-Constants.buttonsMargin)
            make.bottom.equalToSuperview().offset(-Constants.buttonsMargin)
        }
    }
}

// MARK: - Constants
extension MainGameViewController {
    enum Constants {
        static let margin: CGFloat = 24
        static let buttonsMargin: CGFloat = margin * 2
        static let headerFont = UIFont.boldSystemFont(ofSize: 26)
    }
}
