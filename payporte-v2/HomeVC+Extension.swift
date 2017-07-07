//
//  HomeVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension HomeVC {
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
//            banners.snp.makeConstraints({ (make) in
//                make.width.equalTo(view.frame.width)
//                make.height.equalTo(200)
//                make.top.equalTo(view.snp.top).offset(64)
//            })
//            
//            pageController.snp.makeConstraints({ (make) in
//                make.centerX.equalTo(view)
//                make.width.equalTo(100)
//                make.height.equalTo(20)
//                make.top.equalTo(view).offset(230)
//            })
//            
//            cardView.snp.makeConstraints({ (make) in
//                make.top.equalTo(banners.snp.bottom).offset(-10)
//                make.left.equalTo(view.snp.left).offset(10)
//                make.right.equalTo(view.snp.right).offset(-10)
//                make.height.equalTo(60)
//            })
//            
//            categoryLabel.snp.makeConstraints({ (make) in
//                make.centerY.equalTo(cardView)
//                make.centerX.equalTo(cardView)
//                make.height.equalTo(18)
//            })
//            
//            collectionView.snp.makeConstraints({ (make) in
//                make.top.equalTo(cardView.snp.bottom).offset(5)
//                make.left.equalTo(view)
//                make.right.equalTo(view)
//                make.bottom.equalTo(view)
//            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
