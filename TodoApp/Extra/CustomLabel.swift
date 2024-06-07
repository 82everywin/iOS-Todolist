//
//  CustomLabel.swift
//  TodoApp
//
//  Created by 한현승 on 6/5/24.
//
import UIKit

class CustomLabel: UILabel {
    var textInsets = UIEdgeInsets.zero
     
     override func drawText(in rect: CGRect) {
         let insetRect = rect.inset(by: textInsets)
         super.drawText(in: insetRect)
     }
     
     override var intrinsicContentSize: CGSize {
         let size = super.intrinsicContentSize
         return CGSize(width: size.width + textInsets.left + textInsets.right,
                       height: size.height + textInsets.top + textInsets.bottom)
     }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (textInsets.left + textInsets.right)
        }
    }
}
