//
//  CollectionViewSectionHeader.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {

    var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "A L L  C A T E G O R I E S"
        label.font = UIFont(name: "Orkney-Medium", size: 13)
        return label
    }()
    
    var cardView: CardView = {
        let card = CardView()
        card.cornerRadius = 0
        card.backgroundColor = primaryColor
        card.shadowColor = .white
        return card
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(cardView)
        addSubview(categoryLabel)
        cardView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).offset(-10)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(60)
        })
        
        categoryLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(cardView)
            make.centerX.equalTo(cardView)
            make.height.equalTo(18)
        })
    }

}
