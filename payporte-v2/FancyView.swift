//
//  FancyView.swift
//  sample-projects
//
//  Created by Afees LAwal on 24/07/2016.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit

@IBDesignable
class FancyView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 4
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.borderColor = UIColor(white: 0, alpha: 0.07).cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        layer.shadowPath = shadowPath.cgPath
    }

}
