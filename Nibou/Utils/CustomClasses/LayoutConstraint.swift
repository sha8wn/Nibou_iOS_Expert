//
//  LayoutConstraint.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
@IBDesignable

class LayoutConstraint: NSLayoutConstraint {
    @IBInspectable
    var 📱iPhoneX: CGFloat = 0 {
        didSet {
            
            if UIScreen.main.bounds.size.height >= 811.0 {
                constant = 📱iPhoneX
            }
        }
    }
    @IBInspectable
    var 📱3¨5_inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.size.height == 480 {
                constant = 📱3¨5_inch
            }
        }
    }
    
    @IBInspectable
    var 📱4¨0_inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.size.height ==  568 {
                constant = 📱4¨0_inch
            }
        }
    }
    
    @IBInspectable
    var 📱4¨7_inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.size.height == 667 {
                constant = 📱4¨7_inch
            }
        }
    }
    
    @IBInspectable
    var 📱5¨5_inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.size.height == 736 {
                constant = 📱5¨5_inch
            }
        }
    }
}
