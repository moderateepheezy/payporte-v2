//
//  CustomStepperView.swift
//  CustomStepper
//
//  Created by SimpuMind on 5/12/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SnapKit

protocol CustomStepperViewDelegate {
    
    func getStepperValue(value: Int)
}

class CustomStepperView: UIView {
        
        var labelOriginalCenter: CGPoint!
    
    var timer: Timer!
    var speedAmmo = 100
    
    var delegate: CustomStepperViewDelegate?
    
        let topButton = UIButton()
        let bottomButton = UIButton()
        let label = UILabel()
        
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        func setup() {
            topButton.setTitle("-", for: .normal)
            topButton.backgroundColor = .blue
            addSubview(topButton)
            
            bottomButton.setTitle("+", for: .normal)
            bottomButton.backgroundColor = .blue
            addSubview(bottomButton)
            
            label.text = "0"
            label.textAlignment = .center
            label.backgroundColor = .red
            addSubview(label)
        }
        
        @IBInspectable var value = 0 {
            didSet {
                label.text = String(value)
            }
        
        }
    
        
        /// Text on the left button. Be sure that it fits in the button. Defaults to "-".
        @IBInspectable public var topButtonText: String = "-" {
            didSet {
                topButton.setTitle(topButtonText, for: .normal)
            }
        }
    
        /// Text on the right button. Be sure that it fits in the button. Defaults to "+".
        @IBInspectable public var bottomButtonText: String = "+" {
            didSet {
                bottomButton.setTitle(bottomButtonText, for: .normal)
            }
        }
        
        /// Text color of the buttons. Defaults to white.
        @IBInspectable public var buttonsTextColor: UIColor = .white {
            didSet {
                for button in [topButton, bottomButton] {
                    button.setTitleColor(buttonsTextColor, for: .normal)
                }
            }
        }
        
        /// Background color of the buttons. Defaults to dark blue.
        @IBInspectable public var buttonsBackgroundColor: UIColor = UIColor(red:0.21, green:0.5, blue:0.74, alpha:1) {
            didSet {
                for button in [topButton, bottomButton] {
                    button.backgroundColor = buttonsBackgroundColor
                }
                backgroundColor = buttonsBackgroundColor
            }
        }
        
        /// Font of the buttons. Defaults to AvenirNext-Bold, 20.0 points in size.
        public var buttonsFont = UIFont(name: "Orkney-Bold", size: 20.0)! {
            didSet {
                for button in [topButton, bottomButton] {
                    button.titleLabel?.font = buttonsFont
                }
            }
        }
        
        /// Text color of the middle label. Defaults to white.
        @IBInspectable public var labelTextColor: UIColor = .white {
            didSet {
                label.textColor = labelTextColor
            }
        }
        
        /// Text color of the middle label. Defaults to lighter blue.
        @IBInspectable public var labelBackgroundColor: UIColor = UIColor(red:0.26, green:0.6, blue:0.87, alpha:1) {
            didSet {
                label.backgroundColor = labelBackgroundColor
            }
        }
        
        /// Font of the middle label. Defaults to AvenirNext-Bold, 25.0 points in size.
        public var labelFont = UIFont(name: "Orkney-Bold", size: 25.0)! {
            didSet {
                label.font = labelFont
            }
        }
        
        /// Percentage of the middle label's width. Must be between 0 and 1. Defaults to 0.5. Be sure that it is wide enough to show the value.
        @IBInspectable public var labelWidthWeight: CGFloat = 0.5 {
            didSet {
                labelWidthWeight = min(1, max(0, labelWidthWeight))
                setNeedsLayout()
            }
        }
    
        override func layoutSubviews() {
            
            
            label.layer.cornerRadius = frame.width / 2
            label.clipsToBounds = true
            let labelWidthWeight: CGFloat = 0.5
            
            let buttonWidth = bounds.size.width * ((1 - labelWidthWeight) / 2)
            
            //        topButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height)
            //
            //        label.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
            //
            //        bottomButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: bounds.size.height)
            
            topButton.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(buttonWidth + 10)
            }
            
            label.snp.makeConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.height.equalTo(self.snp.width)
            }
            
            bottomButton.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left)
                make.bottom.equalTo(self.snp.bottom)
                make.right.equalTo(self.snp.right)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(buttonWidth + 10)
            }
            
            
            topButton.addTarget(self, action: #selector(topButtonTouchDown), for: .touchDown)
            bottomButton.addTarget(self, action: #selector(bottomButtonTouchDown), for: .touchDown)
            
        }
        
        
        
        // MARK: Button Event Actions
        func topButtonTouchDown(button: UIButton) {
            if value != 0{
                value -= 1
                delegate?.getStepperValue(value: value)
            }
        }
        
        func bottomButtonTouchDown(button: UIButton) {
            value += 1
            delegate?.getStepperValue(value: value)
            //timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(rapidFire), userInfo: nil, repeats: true)
        }
        
}
