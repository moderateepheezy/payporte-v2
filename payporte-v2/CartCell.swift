//
//  CartCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/2/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Stepperier

class CartCell: UITableViewCell {
    
    var productImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "01B")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Retroman Jacks Baggy"
        label.font = UIFont(name: "Orkney-Light", size: 14)
        label.textColor = UIColor(white: 0, alpha: 0.85)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Retro man Jacket"
        label.font = UIFont(name: "Orkney-Light", size: 14)
        label.textAlignment = .left
        return label
    }()
    
    let stepper: GMStepper = {
       let st = GMStepper()
        st.backgroundColor = UIColor(white: 0, alpha: 0.05)
        st.buttonsTextColor = UIColor(white: 0, alpha: 0.35)
        st.labelTextColor = primaryColor
        st.labelBackgroundColor = .white
        st.buttonsFont = UIFont(name: "Orkney-Medium", size: 10)!
        st.labelFont = UIFont(name: "Orkney-Medium", size: 12)!
        return st
    }()
    
//    let stepper: Stepperier = {
//        let st = Stepperier()
//        st.tintColor = primaryColor
//        st.backgroundColor = UIColor(white: 0, alpha: 1)
//        st.valueBackgroundColor = .white
//        st.font = UIFont(name: "Orkney-Regular", size: 12)!
//        return st
//    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(stepper)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        stepper.backgroundColor = UIColor(white: 0, alpha: 1)
        stepper.buttonsBackgroundColor = .clear
    }
    
    fileprivate func setupViews(){
        
        productImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(self.frame.height - 40)
        }
        
        productNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(-30)
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(18)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom).offset(5)
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(18)
        }
        
        stepper.snp.makeConstraints { (make) in
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(30)
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
