//
//  Profile+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/4/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension ProfileVC {
    
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            viewHolder.snp.makeConstraints({ (make) in
                make.top.equalTo(view).offset(164)
                make.bottom.equalTo(view).offset(-100)
                make.left.equalTo(view).offset(50)
                make.right.equalTo(view).offset(-50)
            })
            
            signupButton.snp.makeConstraints({ (make) in
                make.left.right.equalTo(viewHolder)
                make.height.equalTo(60)
                make.bottom.equalTo(viewHolder)
            })
            
            loginButton.snp.makeConstraints({ (make) in
                make.left.right.equalTo(viewHolder)
                make.height.equalTo(60)
                make.bottom.equalTo(signupButton.snp.top).offset(-18)
            })
            
            descLabel.snp.makeConstraints({ (make) in
                make.left.right.equalTo(viewHolder)
                make.height.equalTo(28)
                make.bottom.equalTo(loginButton.snp.top).offset(-18)
            })
            
            iconImageView.snp.makeConstraints({ (make) in
                make.width.equalTo(100)
                make.centerX.equalTo(viewHolder)
                make.bottom.equalTo(descLabel.snp.top).offset(-18)
            })

            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}
