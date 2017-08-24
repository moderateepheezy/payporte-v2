//
//  CartCardCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/23/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

protocol CartCardDelegate {
    
    func updateCartCard(total: String)
}

class CartCardCell: UITableViewCell, CartCardDelegate {
    
    let totalPriceView: CardView = {
        let view = CardView()
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        view.backgroundColor = .white
        return view
    }()
    
    let priceDetailsSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(white: 0, alpha: 0.07).cgColor
        view.layer.borderWidth = 0.85
        view.clipsToBounds = true
        return view
    }()
    
    let cartLabel: UILabel = {
        let label = UILabel()
        label.text = "CART"
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.textAlignment = .center
        return label
    }()
    
    
    let showItemButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        return button
    }()
    
    
    let numOfItemLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        return label
    }()
    
    let couponTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "ENTER COUPON CODE"
        textfield.textColor = UIColor(white: 0, alpha: 0.45)
        textfield.font = UIFont(name: "Orkney-Regular", size: 10)
        textfield.setBottomBorder()
        return textfield
    }()
    
    let verifyCouponButton: UIButton = {
        let button = UIButton()
        button.setTitle("VERIFY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = primaryColor
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 12)
        return button
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(totalPriceView)
        self.contentView.addSubview(cartLabel)
        totalPriceView.addSubview(priceDetailsSubView)
        priceDetailsSubView.addSubview(showItemButton)
        priceDetailsSubView.addSubview(priceLabel)
        priceDetailsSubView.addSubview(numOfItemLabel)
        totalPriceView.addSubview(couponTextField)
        totalPriceView.addSubview(verifyCouponButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        setupConstraints()
    }
    
    func updateCartCard(total: String) {
        
    }
    
    func setupConstraints(){
        
        cartLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(15)
        }
        
        totalPriceView.snp.makeConstraints { (make) in
            make.top.equalTo(cartLabel.snp.bottom).offset(20)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(150)
        }
        
        priceDetailsSubView.snp.makeConstraints({ (make) in
            
            make.top.equalTo(totalPriceView.snp.top)
            make.left.equalTo(totalPriceView.snp.left)
            make.right.equalTo(totalPriceView.snp.right)
            make.height.equalTo(90)
        })
        
        showItemButton.snp.makeConstraints({ (make) in
            make.trailing.equalTo(priceDetailsSubView.snp.trailing).inset(20)
            make.centerY.equalTo(priceDetailsSubView.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(18)
        })
        
        numOfItemLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(priceDetailsSubView.snp.top).offset(30)
            make.right.equalTo(showItemButton.snp.left).offset(8)
            make.left.equalTo(priceDetailsSubView.snp.left).offset(20)
            make.height.equalTo(16)
        })
        
        priceLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(numOfItemLabel.snp.top).offset(20)
            make.right.equalTo(showItemButton.snp.left).offset(8)
            make.left.equalTo(priceDetailsSubView).offset(20)
            make.height.equalTo(16)
        })
        
        verifyCouponButton.snp.makeConstraints({ (make) in
            make.trailing.equalTo(totalPriceView.snp.trailing).inset(20)
            make.top.equalTo(priceDetailsSubView.snp.bottom).offset(17)
            make.width.equalTo(80)
            make.height.equalTo(25)
        })
        
        couponTextField.snp.makeConstraints({ (make) in
            make.left.equalTo(totalPriceView).inset(20)
            make.top.equalTo(priceDetailsSubView.snp.bottom).offset(17)
            make.width.equalTo(120)
            make.height.equalTo(25)
        })
        

    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
