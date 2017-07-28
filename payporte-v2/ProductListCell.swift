//
//  ProductListCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    
    var product: ProductList? {
        didSet{
            guard let productName = product?.product_name else {return}
            guard let productImage = product?.product_image else {return}
            guard let productPrice = product?.product_price else {return}
            guard let productVendor = product?.seller?.name else {return}
            guard let productSlashPrice = product?.product_regular_price else {return}
            
            let attrStr = NSMutableAttributedString(string: "₦ \(productSlashPrice)", attributes: [NSBaselineOffsetAttributeName : 0])
            
            // Now if you add the strike-through attribute to a range, it will work
            attrStr.addAttributes([
                NSFontAttributeName: UIFont(name: "Orkney-Medium", size: 12)!,
                NSStrikethroughStyleAttributeName: 1
                ], range: NSMakeRange(0, attrStr.length))
            
            
            itemNameLabel.text = productName
            slashPriceLabel.attributedText = attrStr
            itemPriceLabel.text = "₦ \(productPrice)"
            itemVendorLabel.text = productVendor
            let url = URL(string: productImage)
            itemImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
    }
    
    let itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let itemNameLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        label.text = "T-Buckle"
        label.textAlignment = .center
        return label
    }()
    
    let itemPriceLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Medium", size: 13)
        label.text = "$ 200"
        label.textColor = primaryColor
        label.textAlignment = .center
        return label
    }()
    
    var slashPriceLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Medium", size: 12)
        label.text = "$ 200"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let itemVendorLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Regular", size: 10)
        label.text = "Payporte"
        label.textAlignment = .center
        label.textColor = .lightGray
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
        backgroundColor = .white
        addSubview(itemImageView)
        addSubview(itemNameLabel)
        addSubview(itemVendorLabel)
        addSubview(slashPriceLabel)
        addSubview(itemPriceLabel)
        
        
        itemImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(100)
        }
        
        itemVendorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemImageView.snp.bottom).offset(20)
            make.left.right.equalTo(self)
            make.height.equalTo(14)
        }
        
        itemNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemVendorLabel.snp.bottom).offset(5)
            make.left.right.equalTo(self)
            make.height.equalTo(16)
        }
        
        slashPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self)
            make.height.equalTo(16)
        }
        
        itemPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(slashPriceLabel.snp.bottom).offset(5)
            make.left.right.equalTo(self)
            make.height.equalTo(16)
        }
        
        
    }

    
}
