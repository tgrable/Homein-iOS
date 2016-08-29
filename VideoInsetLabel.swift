//
//  VideoInsetLabel.swift
//  Rockford Public Library
//
//  Created by Justin Davis on 4/5/16.
//  Copyright © 2016 Justin Davis. All rights reserved.
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