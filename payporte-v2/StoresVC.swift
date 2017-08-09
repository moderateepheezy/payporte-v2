//
//  StoresVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

struct StringData{
    var img: String?
    var name: String?
}

class StoresVC: MainVC {
    
    var didSetupConstraints = false
    
    let cellIndetifier = "cellId"
    
    
    var data = [StringData]()
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
        return cv
    }()
    
    lazy var countDownLauncher: CountDownLauncher = {
        let launcher = CountDownLauncher()
        return launcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setNeedsUpdateConstraints()
        
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "store_selected").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = #imageLiteral(resourceName: "store").withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.title = "S T O R E S"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        view.addSubview(collectionView)
        
        data.append(StringData(img: "1k-store", name: "1 k S t o r e"))
        data.append(StringData(img: "happy-feet", name: "Happy Feet"))
        data.append(StringData(img: "tgif", name: "T G I F"))
        data.append(StringData(img: "foodstore", name: "Food Store"))
        data.append(StringData(img: "plus-size", name: "Plus Size Store"))
        data.append(StringData(img: "oga-don-pay", name: "Oga Don Pay"))
        data.append(StringData(img: "rainbow", name: "Rainbow Sales"))
        data.append(StringData(img: "cupid-room", name: "Cupid Sales"))
        data.append(StringData(img: "orange-sales", name: "Easter Orange Sales"))
        data.append(StringData(img: "black-friday", name: "Black Friday"))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StoreCell.self, forCellWithReuseIdentifier: cellIndetifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func menuClick(){
        let vc = DrawerController()
        vc.hidesBottomBarWhenPushed = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension StoresVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifier, for: indexPath) as! StoreCell
        
        let dat = data[indexPath.item]
        cell.itemImageView.image = UIImage(named: dat.img!)
        cell.itemNameLabel.text = dat.name?.uppercased()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      countDownLauncher.setupViews(type: "bekki")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.right
    }
    
}

