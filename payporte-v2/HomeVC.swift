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

class StringData {
    var img: String?
    var name: String?
    
    init(img: String, name: String) {
        self.img = img
        self.name = name
    }
}

class HomeVC: UIViewController, UISearchBarDelegate {
    
    private var mySearchBar: UISearchBar!
    
    var didSetupConstraints = false
    
    let cellIndetifier = "cellId"
    
    fileprivate let itemsPerRow: CGFloat = 2
    
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
    
    var collectionView: UICollectionView!
    
    
    func fetchCategories(){
        Payporte.sharedInstance.fetchCategories { (categories) in
            self.categories = categories
        
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fetchCategories()
        }
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = #imageLiteral(resourceName: "home").withRenderingMode(.alwaysOriginal)
        
        let menuBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: #selector(menuClick))
        menuBarButton.tintColor = UIColor.black
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "home")
        self.navigationItem.leftBarButtonItems = [ menuBarButton]

        view.backgroundColor = .white
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        
        mySearchBar.searchBarStyle = UISearchBarStyle.minimal
        
        mySearchBar.placeholder = "Search for product"
        
        mySearchBar.tintColor = UIColor.black
        
        mySearchBar.showsSearchResultsButton = true
        mySearchBar.endEditing(true)
        
        mySearchBar.setTextColor(color: UIColor.black)
        
        mySearchBar.tintColor = UIColor.black
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 50)
        let titleView = UIView(frame: frame)
        mySearchBar.frame = frame
        titleView.addSubview(mySearchBar)
        navigationItem.titleView = titleView
        
        
        let layout = CSStickyHeaderFlowLayout()
        layout.sectionInset = sectionInsets
        layout.itemSize = returnCellSize()
        layout.disableStretching = true
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
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
        layout.parallaxHeaderReferenceSize = CGSize(width: self.view.frame.size.width, height: 200)
        
        collectionView.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 60)
        
        addingViewsAddSubViews()
        
    }
    
    
    func addingViewsAddSubViews(){
        view.addSubview(collectionView)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Do some search stuff
        mySearchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mySearchBar.setTextColor(color: UIColor.lightGray)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        mySearchBar.text = ""
        mySearchBar.showsCancelButton = false
        mySearchBar.endEditing(true)
        mySearchBar.setTextColor(color: UIColor.black)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mySearchBar.endEditing(true)
    }
    
    func returnCellSize() -> CGSize {
        let paddingSpace = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 130)
    }
    
    func goToProductDetails(title: String){
        let vc = ProductListingVC()
        vc.categoryName = title
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
        
        let title = categories?[indexPath.item]
        
        guard let name = title?.category_name else {return}
        goToProductDetails(title: name)
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


