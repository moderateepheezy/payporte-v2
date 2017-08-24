//
//  ShipToCardCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/23/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ShipToCardCell: UITableViewCell {
    
    let shipToLabel: UILabel = {
        let label = UILabel()
        label.text = "SHIP TO"
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.textAlignment = .center
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "ADD A DELIVERY ADDRESS"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        return label
    }()
    
    let editAddressImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        return button
    }()
    
    let addressView: CardView = {
        let view = CardView()
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(addressView)
        self.contentView.addSubview(shipToLabel)
        addressView.addSubview(addressLabel)
        addressView.addSubview(phoneNumberLabel)
        addressView.addSubview(editAddressImageView)
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
        
        shipToLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(15)
        }
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(shipToLabel.snp.bottom).offset(20)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(100)
        }
        
        addressLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(addressView.snp.top).offset(30)
            make.right.equalTo(editAddressImageView.snp.left).offset(8)
            make.left.equalTo(addressView).offset(20)
            make.height.equalTo(16)
        })
        
        phoneNumberLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(addressLabel.snp.top).offset(20)
            make.right.equalTo(editAddressImageView.snp.left).offset(8)
            make.left.equalTo(addressView).offset(20)
            make.height.equalTo(16)
        })
        
        editAddressImageView.snp.makeConstraints({ (make) in
            make.trailing.equalTo(addressView.snp.trailing).inset(20)
            make.centerY.equalTo(addressView.snp.centerY)
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
