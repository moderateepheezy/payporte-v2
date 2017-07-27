//
//  ProductDetailsVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/17/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension ProductDetailsVC {
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            containerView.snp.makeConstraints({ (make) in
                make.top.equalTo(view.snp.top)
                make.left.right.equalTo(view)
                make.height.equalTo((view.frame.height / 2) + 100)
            })
            
            buttonView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(view)
                make.height.equalTo(65)
            })
            
            middleView.snp.makeConstraints({ (make) in
                make.centerX.equalTo(buttonView)
                make.centerY.equalTo(buttonView)
                make.width.equalTo(1)
                make.height.equalTo(30)
            })
            
            addToCartButton.snp.makeConstraints({ (make) in
                make.left.top.bottom.equalTo(buttonView)
                make.right.equalTo(middleView.snp.left).offset(10)
            })
            
            readMoreButton.snp.makeConstraints({ (make) in
                make.right.top.bottom.equalTo(buttonView)
                make.left.equalTo(middleView.snp.right).offset(10)
            })
            
            productNameLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(buttonView.snp.top).offset(-10)
                make.left.equalTo(view.snp.left).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                make.height.equalTo(20)
            })
            
            vendorNameLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(productNameLabel.snp.top).offset(-10)
                make.left.equalTo(view.snp.left).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                make.height.equalTo(20)
            })
            
            priceLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(vendorNameLabel.snp.top).offset(-30)
                make.left.equalTo(view.snp.left).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                make.height.equalTo(20)
            })
            
            spinnerView.snp.makeConstraints { (make) in
                make.center.equalTo(self.view.center)
                make.height.equalTo(50)
                make.width.equalTo(60)
            }
            
            loadLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(spinnerView.snp.bottom).offset(-5)
                make.left.equalTo(spinnerView.snp.left)
                make.right.equalTo(spinnerView.snp.right)
                make.height.equalTo(13)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

