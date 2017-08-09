//
//  SearchVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation

extension SearchVC{
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            headerView.snp.makeConstraints({ (make) in
                make.top.equalTo(view).offset(64)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(64)
            })
            
            collectionView.snp.makeConstraints({ (make) in
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.top.equalTo(headerView.snp.bottom).offset(10)
                make.bottom.equalTo(view)
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
