//
//  CheckoutVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

extension CheckoutVC {
    
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(40)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(17)
            }
            
            tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(view).offset(84)
                make.right.equalTo(view.snp.right)
                make.left.equalTo(view.snp.left)
                make.bottom.equalTo(view.snp.bottom)
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
