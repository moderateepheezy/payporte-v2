//
//  ShippingMethodCardCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/23/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ShippingMethodCardCell: UITableViewCell {
    
    let shippingMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "SHIPPING METHOD"
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    let shippingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "NO SHIPPING METHOD SELECTED"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    let editShippingImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        return button
    }()
    
    let shippingMethodView: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        return view
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(shippingMethodView)
        self.contentView.addSubview(shippingMethodLabel)
        shippingMethodView.addSubview(shippingTextLabel)
        shippingMethodView.addSubview(editShippingImageView)
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
    
    func setupConstraints(){
        
        shippingMethodLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(15)
        }
        
        shippingMethodView.snp.makeConstraints { (make) in
            make.top.equalTo(shippingMethodLabel.snp.bottom).offset(20)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(80)
        }
        
        shippingTextLabel.snp.makeConstraints({ (make) in
            make.leading.equalTo(shippingMethodView.snp.leading).offset(16)
            make.centerY.equalTo(shippingMethodView.snp.centerY)
            make.width.equalTo(200)
            make.height.equalTo(15)
        })
        
        editShippingImageView.snp.makeConstraints({ (make) in
            make.trailing.equalTo(shippingMethodView.snp.trailing).inset(20)
            make.centerY.equalTo(shippingMethodView.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(20)
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
