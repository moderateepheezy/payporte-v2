//
//  CollectionParallaxHeader.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class CollectionParallaxHeader: UICollectionReusableView {
    
    var headerView: CustomHeaderView = {
       let head = CustomHeaderView()
        return head
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.clipsToBounds = true
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerView.frame = self.bounds
    }
}
