//
//  CartVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/2/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension CartVC {
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            cardview.snp.makeConstraints({ (make) in
                make.top.equalTo(view.snp.top).offset(64)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.height.equalTo(64)
            })
            
//            totalLabel.snp.makeConstraints({ (make) in
//                make.top.equalTo(cardview).offset(20)
//                make.left.equalTo(cardview).offset(20)
//                make.width.equalTo(100)
//                make.height.equalTo(17)
//            })
            
            priceLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(cardview)
                make.centerX.equalTo(cardview)
                make.width.equalTo(220)
                make.height.equalTo(23)
            })
            
            
            cardView2.snp.makeConstraints({ (make) in
                make.bottom.equalTo(view.snp.bottom)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.height.equalTo(64)
            })
            checkoutButton.snp.makeConstraints({ (make) in
                make.centerY.equalTo(cardView2)
                make.left.equalTo(cardView2.snp.left).offset(20)
                make.right.equalTo(cardView2.snp.right).offset(-20)
                make.height.equalTo(64)
            })
            
            tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(cardview.snp.bottom).offset(10)
                make.width.equalTo(view)
                make.bottom.equalTo(cardView2.snp.top).offset(-10)
            })

            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

