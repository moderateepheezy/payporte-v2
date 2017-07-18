//
//  AddressCell.swift
//  PayPorte
//
//  Created by SimpuMind on 5/22/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import UICheckbox_Swift

class AddressCell: UITableViewCell {
    
    
    let checkbox: UICheckbox = {
       let cb = UICheckbox()
        cb.tintColor = UIColor(red: 241, green: 100, blue: 57)
        cb.layer.borderColor = UIColor(red: 241, green: 100, blue: 57).cgColor
        cb.layer.borderWidth = 0.85
        cb.clipsToBounds = true
        return cb
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "JOHN, 0816456780969"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Medium", size: 14)
        return label
    }()
    
    let usernameAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "John Street, Ebute-Metta Lagos"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Medium", size: 14)
        return label
    }()
    
    let view1: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.12)
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(checkbox)
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(usernameAddressLabel)
        self.contentView.addSubview(view1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        
    }
    
    
    fileprivate func setupViews(){

        
        checkbox.snp.makeConstraints({ (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.width.equalTo(20)
            make.height.equalTo(20
            )
        })
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.left.equalTo(checkbox.snp.right).offset(40)
            make.right.equalTo(self.contentView).offset(10)
            make.height.equalTo(15)
        }
        
        usernameAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.left.equalTo(checkbox.snp.right).offset(40)
            make.right.equalTo(self.contentView).offset(10)
            make.height.equalTo(15)
        }
        
        view1.snp.makeConstraints { (make) in
            make.top.equalTo(usernameAddressLabel.snp.bottom).offset(20)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1)
        }
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
