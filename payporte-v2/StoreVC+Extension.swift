//
//  StoreVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension StoresVC {
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            collectionView.snp.makeConstraints({ (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.top.equalTo(view).offset(10)
                make.bottom.equalTo(view)
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
