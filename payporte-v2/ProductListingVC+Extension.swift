//
//  ProductListingVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension ProductListingVC {
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            headerView.snp.makeConstraints({ (make) in
                make.top.equalTo(view).offset(64)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(64)
            })
            
            sortButton.snp.makeConstraints({ (make) in
                
                make.top.equalTo(headerView.snp.top)
                make.bottom.equalTo(headerView.snp.bottom)
                make.width.equalTo(view.frame.width / 2)
                make.left.equalTo(headerView.snp.left)
            })
            
            filterButton.snp.makeConstraints({ (make) in
                make.top.equalTo(headerView.snp.top)
                make.bottom.equalTo(headerView.snp.bottom)
                make.width.equalTo(view.frame.width / 2)
                make.right.equalTo(headerView.snp.right)
            })
            
            collectionView.snp.makeConstraints({ (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.top.equalTo(headerView.snp.bottom).offset(10)
                make.bottom.equalTo(view)
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
