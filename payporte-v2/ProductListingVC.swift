//
//  ProductListingVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/4/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import DropDown

class ProductListingVC: UIViewController {

    private var mySearchBar: UISearchBar!
    
    var didSetupConstraints = false
    
    let sortDown = DropDown()
    let filterDown = DropDown()
    
    var categoryName: String?
    
    let cellIndetifier = "cellId"
    
    fileprivate var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    
    var data = [StringData]()
    
    let headerView: CardView = {
       let v = CardView()
        v.backgroundColor = .white
        v.shadowColor = UIColor(white: 0.90, alpha: 0.90)
        return v
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("SORT", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.setImage(#imageLiteral(resourceName: "ic_caret_up"), for: .normal)
        button.setTitleColor(UIColor(red: 90, green: 90, blue: 90), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("FILTER", for: .normal)
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "ic_caret_up"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.setTitleColor(UIColor(red: 90, green: 90, blue: 90), for: .normal)
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
        view.setNeedsUpdateConstraints()
        addSubViews()
        
        dropDownSetup()
        
        data.append(StringData(img: "i1", name: "Bettles"))
        data.append( StringData(img: "i2", name: "Frends and Gabana"))
        data.append( StringData(img: "i3", name: "Neither"))
        data.append( StringData(img: "i4", name: "Frontiers"))
        data.append( StringData(img: "i5", name: "Funny Look"))
        data.append( StringData(img: "i6", name: "Sweet Man"))
        data.append( StringData(img: "i7", name: "Gucci Knees"))
        data.append( StringData(img: "i8", name: "Hush Puppy Types"))
        data.append( StringData(img: "i9", name: "Breathing Egg"))
        data.append( StringData(img: "i10", name: "Source Tree"))
        
        guard let catName = categoryName else {return}
        navigationItem.title = catName.uppercased()
        
        sortButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        sortButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        sortButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        filterButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        filterButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        filterButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        sortButton.addTarget(self, action: #selector(handleMoreSort), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(handleMoreFilter), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: cellIndetifier)

    }
    
    
    func addSubViews(){
        view.addSubview(headerView)
        headerView.addSubview(filterButton)
        headerView.addSubview(sortButton)
        view.addSubview(collectionView)
    }
    
    func dropDownSetup(){
        
        sortDown.dataSource = ["Action 1", "Action 2", "Action 3"]
        sortDown.anchorView = sortButton
        
        filterDown.dataSource = ["Action 1", "Action 2", "Action 3"]
        filterDown.anchorView = filterButton
        
        sortDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
        
        filterDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
        
        sortDown.width = view.frame.width
        filterDown.width = view.frame.width
        
        sortDown.bottomOffset = CGPoint(x: 0, y:((sortDown.anchorView?.plainView.bounds.height)! + 64))
        filterDown.bottomOffset = CGPoint(x: 0, y:((filterDown.anchorView?.plainView.bounds.height)! + 64))
        
        sortDown.backgroundColor = .white
        filterDown.backgroundColor = .white
        
        
        filterDown.cancelAction = { [unowned self] in
            print("Drop down will show")
            self.filterButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }
        
        filterDown.willShowAction = { [unowned self] in
            print("Drop down will show")
            self.filterButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        sortDown.cancelAction = { [unowned self] in
            print("Drop down will show")
            self.sortButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }
        
        sortDown.willShowAction = { [unowned self] in
            print("Drop down will show")
            self.sortButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }

    func handleMoreSort(){
        UIView.animate(withDuration: 0.45) {
            self.sortDown.show()
        }
    }
    
    func handleMoreFilter(){
        UIView.animate(withDuration: 0.45) {
            self.filterDown.show()
        }
    }
    
    
}

extension ProductListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifier, for: indexPath) as! ProductListCell
        
        let dat = data[indexPath.item]
        cell.itemImageView.image = UIImage(named: dat.img!)
        cell.itemNameLabel.text = dat.name?.uppercased()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        let vc = ProductDetailsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 40)
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
