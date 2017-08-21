//
//  HomeVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SnapKit
import CLabsImageSlider
import CSStickyHeaderFlowLayout

class HomeVC: MainVC {
    
    
    var didSetupConstraints = false
    
    let cellIndetifier = "cellId"
    
    fileprivate let itemsPerRow: CGFloat = 2
    let itemCount = 5
    fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    
    var categories: [Category]?
    
    var cardView: CardView = {
       let card = CardView()
        card.cornerRadius = 0
        card.backgroundColor = primaryColor
        card.shadowColor = .white
        return card
    }()
    
    var categoryLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "POPULAR PRODUCTS"
        label.font = UIFont(name: "Orkney-Medium", size: 13)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Medium", size: 14)
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var collectionView: UICollectionView!
    
    
    func fetchCategories(){
        
        Payporte.sharedInstance.fetchCategories { (categories, error, message, cursorCount) in
            if error != nil{
                Utilities.getBaseNotification(text: error!, type: .error)
                return
            }
            self.categories = categories
            
            self.collectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Payporte.sharedInstance.fetchCartItems { (carts, total, error, message, itemCount, cursorCount) in
            
            self.fetchBadgeCount()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchBadgeCount), name: NSNotification.Name(rawValue: itemCountlNotificationKey), object: nil)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        self.fetchCategories()
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = #imageLiteral(resourceName: "home").withRenderingMode(.alwaysOriginal)
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "home")
        
        self.navigationItem.title = "P A Y P O R T E"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        let layout = CSStickyHeaderFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = returnCellSize()
        layout.disableStretching = true
        
        let gframe = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 40)
        collectionView = UICollectionView(frame: gframe, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellIndetifier)
        
        collectionView.register(CollectionParallaxHeader.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        layout.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.size.width, height: 150)
        
        collectionView.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 160)
        
        
        addingViewsAddSubViews()
    }
    
    func fetchBadgeCount() {
        Payporte.sharedInstance.fetchCartItems { (carts, total, error, message, itemCount, cursorCount) in
            
            if error != nil{
                return
            }
            
            self.tabBarController?.tabBar.items?[2].badgeValue = "\(cursorCount)"
        }
    }
    
    
    func addingViewsAddSubViews(){
        view.addSubview(collectionView)
        view.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(10)
            make.left.equalTo(view.snp.left).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(view)
        }
    }
    
    func returnCellSize() -> CGSize {
        let paddingSpace = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func goToSubCategories(title: String, category_id: String){
        let vc = SubCategoryVC()
        vc.categoryName = title
        vc.category_id = category_id
        vc.hidesBottomBarWhenPushed = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifier, for: indexPath) as! CategoryCell
        
        let category = categories?[indexPath.item]
        cell.category = category
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cat = categories?[indexPath.item]
        
        guard let name = cat?.category_name else {return}
        guard let cat_id = cat?.category_id else {return}
        goToSubCategories(title: name, category_id: cat_id)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == CSStickyHeaderParallaxHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "parallaxHeader", for: indexPath)
            return view
        } else if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
            view.backgroundColor = UIColor.white
            return view
        }
        
        return UICollectionReusableView()
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


