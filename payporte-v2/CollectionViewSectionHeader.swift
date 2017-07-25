//
//  CollectionViewSectionHeader.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let anotherLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Categories"
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        return label
    }()
    
    let appCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white//#colorLiteral(red: 0.9661722716, green: 0.9661722716, blue: 0.9661722716, alpha: 1)
        return cv
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
        addSubview(appCollectionView)
        addSubview(anotherLabel)
        
        appCollectionView.dataSource = self
        appCollectionView.delegate = self
        appCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        appCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(80)
        }
        
        anotherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appCollectionView.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(10)
            make.height.equalTo(15)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.width.equalTo(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)
    }
    
}

class AppCell: UICollectionViewCell{
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "women")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.textAlignment = .center
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    
    func setupViews(){
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.width.equalTo(self)
            make.height.equalTo(14)
        }
        
        imageView.layer.cornerRadius = 30
        
    }
}

