//
//  CategoryCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCell: UICollectionViewCell {
    
    
    var category: Category? {
        didSet{
            guard let catImg = category?.category_image else {return}
            guard let catName = category?.category_name else {return}
            
            itemNameLabel.text = catName
            
            let url  = URL(string: catImg)
            
            self.itemImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .retryFailed) { (image, error, cache, url) in
                
            }
        }
    }
    
    let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let itemNameLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Medium", size: 16)
        label.text = "WOMEN"
        label.textColor = .white
        label.numberOfLines = 0 
        label.backgroundColor = UIColor(white: 0, alpha: 0.6)
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
        addSubview(itemNameLabel)
        
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        itemImageView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
        
        itemNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self)
        }
    }
}
