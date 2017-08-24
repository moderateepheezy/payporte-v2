//
//  PlaceOrderCardCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/23/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class PlaceOrderCardCell: UITableViewCell {
    
    let placeorderView: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        return view
    }()
    
    var placeOrderButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("PLACE ORDER", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.backgroundColor = primaryColor
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(placeorderView)
        placeorderView.addSubview(placeOrderButton)
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
        
        placeOrderButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        placeOrderButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        placeOrderButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        placeOrderButton.imageView?.snp.makeConstraints({ (make) in
            
            make.leading.equalTo(placeOrderButton.snp.leading).offset(16)
            make.centerY.equalTo(placeOrderButton.snp.centerY)
            
        })
        
        placeorderView.snp.makeConstraints { (make) in
            
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(60)
        }
        
        
        placeOrderButton.snp.makeConstraints { (make) in
            
            make.left.equalTo(placeorderView).offset(10)
            make.bottom.equalTo(placeorderView).offset(-10)
            make.right.equalTo(placeorderView).offset(-10)
            make.top.equalTo(placeorderView.snp.top).offset(10)
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
