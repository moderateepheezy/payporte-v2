//
//  StoresVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class StoresVC: UIViewController {
    
    var didSetupConstraints = false
    
    let cellIndetifier = "cellId"
    
    fileprivate var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    
    var data = [StringData]()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.setNeedsUpdateConstraints()
        
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "store_selected").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = #imageLiteral(resourceName: "store").withRenderingMode(.alwaysOriginal)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        let menuBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: #selector(menuClick))
        menuBarButton.tintColor = UIColor.black
        
        
        self.navigationItem.leftBarButtonItems = [ menuBarButton]
        
        
        self.navigationItem.rightBarButtonItems = [ searchBarButton]
        
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
    
    func search(){
        self.navigationItem.titleView = self.searchBar;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(configureNavigationBar))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.searchActive = true
    }
    
    func configureNavigationBar(){
        searchActive = false
        self.navigationItem.titleView = nil
        self.navigationItem.title = "S T O R E S"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItems = [ searchBarButton]
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

extension StoresVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
}

