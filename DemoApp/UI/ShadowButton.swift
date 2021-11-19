//
//  ShadowButton.swift
//  DevApp
//
//  Created by Gusakovsky, Sergey on 28.04.21.
//  Copyright © 2021 QulixSystems. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowButton: UIButton {
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }
    
    func enable() {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
    }
    
    func disable() {
        self.alpha = 0.7
        self.isUserInteractionEnabled = false
    }
}
