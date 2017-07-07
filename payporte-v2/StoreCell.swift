//
//  StoreCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class StoreCell: UICollectionViewCell {
    
    let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.image = #imageLiteral(resourceName: "cupid-room")
        return iv
    }()
    
    let itemNameLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Medium", size: 16)
        label.text = "WOMEN"
        label.textColor = UIColor(red: 35, green: 35, blue: 35)
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0, alpha: 0.2)
        label.textAlignment = .center
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
        addSubview(itemImageView)
        //addSubview(itemNameLabel)
        
        backgroundColor = .white
        itemImageView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
        
//        itemNameLabel.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//            make.top.equalTo(itemImageView.snp.bottom).offset(10)
//            make.height.equalTo(18)
//            make.width.equalTo(self)
//        }
    }
    
}
