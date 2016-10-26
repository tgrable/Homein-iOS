//
//  VideoInsetLabel.swift
//  FirstMortgage
//
//  Created by Justin Davis on 8/28/201
//  
//

import Foundation
import UIKit

class VideoInsetLabel: UILabel {
    
    let topInset = CGFloat(0.0), bottomInset = CGFloat(0.0), leftInset = CGFloat(10.0), rightInset = CGFloat(10.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}