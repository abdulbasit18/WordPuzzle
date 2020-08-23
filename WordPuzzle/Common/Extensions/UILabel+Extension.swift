//
//  UILabel+Extensio.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setMargins(margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle,
                                          value: paragraphStyle,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
