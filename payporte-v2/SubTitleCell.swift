//
//  SubTitleCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/24/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class SubTitleCell: UICollectionViewCell {
    
    let subLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.text = "Some Text"
        label.layer.borderColor = UIColor(white: 0.68, alpha: 0.68).cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(2)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(45)
        }
    }
    
}
