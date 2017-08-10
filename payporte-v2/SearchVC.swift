//
//  SearchVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/7/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import DropDown
import RGBottomSheet
import NVActivityIndicatorView

class SearchVC: UIViewController, RGBottomSheetDelegate, ProductListingDelegate {
    
    let searchField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Search a product"
        tf.borderStyle = .none
        tf.font = UIFont(name: "Orkney-Medium", size: 18)
        tf.returnKeyType = .search
        return tf
    }()
    
    let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = .white
        return tv
    }()
    
    var didSetupConstraints = false
    var sheet: RGBottomSheet?
    
    let sortDown = DropDown()
    let filterDown = DropDown()
    
    var categoryName: String?
    
    var category_id: String?
    
    var displayType: DisplayType?
    
    var coursorCount: Int?
    var itemCounts: Int?
    var page = 0
    var limit = 8
    
    fileprivate var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    
    var dataSource: ProductListDataSource!
    
    var productLists = [ProductList]()
    var filteredProductLists = [ProductList]()
    
    let headerView: CardView = {
        let v = CardView()
        v.backgroundColor = .white
        v.shadowColor = UIColor(white: 0.4, alpha: 0.40)
        v.shadowOpacity = 0.1
        return v
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("SORT", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.setImage(#imageLiteral(resourceName: "ic_caret_up"), for: .normal)
        button.setTitleColor(UIColor(red: 90, green: 90, blue: 90), for: .normal)
        button.backgroundColor = .white
        button.alpha = 0
        return button
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("FILTER", for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_caret_up"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.setTitleColor(UIColor(red: 90, green: 90, blue: 90), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.alpha = 0
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
        cv.alpha = 0
        return cv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ProductListingVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = primaryColor
        
        return refreshControl
    }()
    
    var activityIndicator: NVActivityIndicatorView!
    
    let spinnerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()
    
    let loadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        label.text = "Loading..."
        label.textAlignment = .center
        return label
    }()
    
    var datas = [ProductList]()
    var searchedArray = [ProductList]()
    
    func getList(text: String){
        Payporte.sharedInstance.fetchSearch(suggestion: text) { (datas) in
            self.datas = datas
            self.tableView.reloadData()
        }
    }
    
    func getProductLists(text: String){
        
        Payporte.sharedInstance.fetchSearchProductLists(key: "0", value: 0, search: text, offset: 0, completion: { (productLists) in
            
            self.spinnerView.alpha = 0
            self.activityIndicator.stopAnimating()
            self.productLists = productLists
            self.collectionView.reloadData()
            self.showSort()
            self.showFilter()
            
        }, itemCountCompletion: { (itemCount) in
            self.itemCounts = itemCount
        }) { (coursorCount) in
            self.coursorCount = coursorCount
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: cellIndetifier)
            
            self.refreshControl.endRefreshing()
        }
        
        self.collectionView.addInfiniteScroll(handler: { (collectionView) in
            self.collectionView.performBatchUpdates({
                self.fetchData()
            }, completion: { (completed) in
                self.collectionView.finishInfiniteScroll()
            })
        })
        
        self.collectionView.setShouldShowInfiniteScrollHandler { (collectionView) -> Bool in
            return self.page < self.itemCounts!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
        view.setNeedsUpdateConstraints()
        addSubViews()
        
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        searchField.delegate = self
        //searchField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        searchField.addTarget(self, action: #selector(searchRecordsAsPerText(_ :)), for: .editingChanged)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 45))
        backButton.setImage(#imageLiteral(resourceName: "icon_back"), for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(dismissButton(button:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let frame = CGRect(x: 40, y: 20, width: view.frame.width - 40, height: 50)
        searchField.frame = frame
        view.addSubview(searchField)
        
        tableView.frame = CGRect(x: 0, y: searchField.frame.origin.y + 50, width: view.frame.width, height: view.frame.height - 80)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func dismissButton(button: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    func searchRecordsAsPerText(_ textfield: UITextField) {
        searchedArray.removeAll()
        if textfield.text?.characters.count != 0 {
            collectionView.alpha = 0
            tableView.alpha = 1
            getList(text: textfield.text!)
            for data in datas {
                let range = data.product_name?.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
                    searchedArray.append(data)
                }
            }
        } else {
            searchedArray = datas
        }
        
        tableView.reloadData()
    }
    
    func fetchData(){
        
//        let tempIndex = (coursorCount! / limit)
//        let index = (tempIndex < 1) ? 1 : tempIndex
//        let  offset = (coursorCount != 0) ? index * limit: 0
//        if coursorCount! >= offset {
//            page = offset
//            print(key)
//            
//            
//            
//            Payporte.sharedInstance.fetchSortProductListing(key: key, offset: page, category_id: category_id!, completion: { (productList) in
//                self.spinnerView.alpha = 0
//                self.activityIndicator.stopAnimating()
//                self.productLists = productList
//                self.collectionView.reloadData()
//                
//            }, itemCountCompletion: { (itemCount) in
//                self.itemCounts = itemCount
//            }) { (count) in
//                self.coursorCount = count
//            }
//            
//        }
    }
    
    func goToProductDetails(category: Category){
        let vc = ProductListingVC()
        vc.categoryName = category.category_name
        vc.category_id = category.category_id
        vc.hidesBottomBarWhenPushed = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configSortBtnSheet(content: [SomeData], title: String){
        
        var bottomView: SortButtonSheetView {
            var screenBound = UIScreen.main.bounds
            screenBound.size.height = 200.0
            let bottomView = SortButtonSheetView(frame: screenBound)
            bottomView.backgroundColor = UIColor.white
            bottomView.content = content
            bottomView.titleLabel.text = title
            bottomView.dataSource = dataSource
            bottomView.bottomSheetDelegate = self
            bottomView.productListingDelegate = self
            return bottomView
        }
        
        if #available(iOS 10.0, *) {
            let config = RGBottomSheetConfiguration(showOverlay: true, showBlur: false, overlayTintColor: UIColor(white: 0, alpha: 0.5), blurTintColor: UIColor.black, blurStyle: .regular, customOverlayView: nil, customBlurView: nil)
            
            sheet = RGBottomSheet(
                withContentView: bottomView,
                configuration: config
            )
        } else {
            // Fallback on earlier versions
            let config = RGBottomSheetConfiguration(showOverlay: true, showBlur: false, overlayTintColor: UIColor(white: 0, alpha: 0.5))
            
            sheet = RGBottomSheet(
                withContentView: bottomView,
                configuration: config
            )
        }
    }
    
    func configFilterBtnSheet(content: [Filter], title: String){
        
        var bottomView: FilterButtomSheetView {
            var screenBound = UIScreen.main.bounds
            screenBound.size.height = 200.0
            let bottomView = FilterButtomSheetView(frame: screenBound)
            bottomView.backgroundColor = UIColor.white
            bottomView.content = content
            bottomView.titleLabel.text = title
            bottomView.dataSource = dataSource
            bottomView.bottomSheetDelegate = self
            bottomView.productListingDelegate = self
            return bottomView
        }
        
        if #available(iOS 10.0, *) {
            let config = RGBottomSheetConfiguration(showOverlay: true, showBlur: false, overlayTintColor: UIColor(white: 0, alpha: 0.5), blurTintColor: UIColor.black, blurStyle: .regular, customOverlayView: nil, customBlurView: nil)
            
            sheet = RGBottomSheet(
                withContentView: bottomView,
                configuration: config
            )
        } else {
            // Fallback on earlier versions
            let config = RGBottomSheetConfiguration(showOverlay: true, showBlur: false, overlayTintColor: UIColor(white: 0, alpha: 0.5))
            
            sheet = RGBottomSheet(
                withContentView: bottomView,
                configuration: config
            )
        }
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        if searchField.text?.characters.count != 0{
            getProductLists(text: searchField.text!)
        }
    }
    
    func closeButtomSheet() {
        sheet?.hide()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    func addSubViews(){
        view.addSubview(headerView)
        headerView.addSubview(filterButton)
        headerView.addSubview(sortButton)
        view.addSubview(collectionView)
        view.addSubview(spinnerView)
        collectionView.addSubview(self.refreshControl)
        spinnerView.addSubview(loadLabel)
        
        let frame = CGRect(x: 15, y: 0, width: 35, height: 35)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: primaryColor, padding: 10)
    }
    
    func showSort(){
        
        sortButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        sortButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        sortButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        sortButton.addTarget(self, action: #selector(handleMoreSort), for: .touchUpInside)
        
        sortButton.alpha = 1
        if productLists[0].layerednavigation == nil{
            sortButton.snp.makeConstraints({ (make) in
                make.width.left.right.equalTo(headerView)
                make.top.equalTo(headerView.snp.top)
                make.bottom.equalTo(headerView.snp.bottom)
            })
        }else{
            filterButton.alpha = 1
            sortButton.snp.makeConstraints({ (make) in
                
                make.top.equalTo(headerView.snp.top)
                make.bottom.equalTo(headerView.snp.bottom)
                make.width.equalTo(view.frame.width / 2)
                make.left.equalTo(headerView.snp.left)
            })
            
            filterButton.snp.makeConstraints({ (make) in
                make.top.equalTo(headerView.snp.top)
                make.bottom.equalTo(headerView.snp.bottom)
                make.width.equalTo(view.frame.width / 2)
                make.right.equalTo(headerView.snp.right)
            })
        }
        
        var items = [String]()
        var alphaItem = [SomeData]()
        var priceItem = [SomeData]()
        let sortDictionary = Utilities.configSort()
        for sort in sortDictionary {
            items.append(sort.title!)
        }
        for i in sortDictionary[1].filter!{
            alphaItem.append(SomeData(value: i.value!, label: i.label!))
        }
        
        for i in sortDictionary[0].filter!{
            priceItem.append(SomeData(value: i.value!, label: i.label!))
        }
        sortDown.dataSource = items
        sortDown.anchorView = sortButton
        
        sortDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Alphabetical Sort"{
                
                self.configSortBtnSheet(content: alphaItem, title: item)
                self.sheet?.show()
            }else if item == "Price Sort"{
                self.configSortBtnSheet(content: priceItem, title: item)
                self.sheet?.show()
            }
        }
        
        
        sortDown.width = view.frame.width
        sortDown.backgroundColor = .white
        sortDown.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        sortDown.separatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        sortDown.bottomOffset = CGPoint(x: headerView.frame.origin.x, y: headerView.frame.size.height + 5)
        
        sortDown.cancelAction = { [unowned self] in
            self.sortButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }
        
        sortDown.willShowAction = { [unowned self] in
            self.sortButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
    func showFilter(){
        
        filterButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        filterButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        filterButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        filterButton.addTarget(self, action: #selector(handleMoreFilter), for: .touchUpInside)
        
        var items = [String]()
        var layerArrays = [[Filter]]()
        let layerNavigation = self.productLists[0].layerednavigation
        guard let layerFilters = layerNavigation?.layerFilter else{return}
        for i in layerFilters{
            items.append(i.title!)
            layerArrays.append(i.filter!)
        }
        
        filterDown.width = view.frame.width
        filterDown.backgroundColor = .white
        filterDown.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        filterDown.separatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        filterDown.dataSource = items
        filterDown.anchorView = filterButton
        
        filterDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.configFilterBtnSheet(content: layerArrays[index], title: item)
            self.sheet?.show()
        }
        
        filterDown.bottomOffset = CGPoint(x: headerView.frame.origin.x, y: headerView.frame.size.height + 5)
        
        
        filterDown.cancelAction = { [unowned self] in
            self.filterButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }
        
        filterDown.willShowAction = { [unowned self] in
            self.filterButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
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
    
    func filterProductList(key: String, value: String){
        print(key)
        page = 0
        self.productLists.removeAll()
        self.spinnerView.alpha = 1
        self.activityIndicator.startAnimating()
        self.collectionView.reloadData()
        let tempIndex = (coursorCount! / limit)
        let index = (tempIndex < 1) ? 1 : tempIndex
        let  offset = (coursorCount != 0) ? index * limit: 0
        if coursorCount! >= offset {
            page = offset
            
            Payporte.sharedInstance.fetchSearchProductLists(key: key, value: Int(value)!, search: searchField.text!, offset: page, completion: { (productList) in
                self.spinnerView.alpha = 0
                self.activityIndicator.stopAnimating()
                self.productLists = productList
                self.collectionView.reloadData()
            }, itemCountCompletion: { (itemCount) in
                self.itemCounts = itemCount
            }, cursorCompletion: { (coursorCount) in
                self.coursorCount = coursorCount
            })
            
            
        }
    }
    
    func sortProductList(key: String){
        print(key)
        page = 0
        self.productLists.removeAll()
        self.spinnerView.alpha = 1
        self.activityIndicator.startAnimating()
        self.collectionView.reloadData()
        let tempIndex = (coursorCount! / limit)
        let index = (tempIndex < 1) ? 1 : tempIndex
        let  offset = (coursorCount != 0) ? index * limit: 0
        if coursorCount! >= offset {
            page = offset
            
            Payporte.sharedInstance.fetchSearchProductLists(key: key, value: 0, search: searchField.text!, offset: page, completion: { (productList) in
                self.spinnerView.alpha = 0
                self.activityIndicator.stopAnimating()
                self.productLists = productList
                self.collectionView.reloadData()
            }, itemCountCompletion: { (itemCount) in
                self.itemCounts = itemCount
            }, cursorCompletion: { (coursorCount) in
                self.coursorCount = coursorCount
            })
            
        }
    }
}

extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifier, for: indexPath) as! ProductListCell
        
        let product = productLists[indexPath.item]
        cell.product = product
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let productList = productLists[indexPath.item]
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        let vc = ProductBuyDetailsVC()
        vc.productList = productList
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 50)
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

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: "Orkney-Regular", size: 12)
        let x = datas[indexPath.item]
        cell.textLabel?.text = x.product_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let productList = datas[indexPath.item]
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        let vc = ProductBuyDetailsVC()
        vc.productList = productList
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.characters.count != 0 {
            textField.resignFirstResponder()
            tableView.alpha = 0
            spinnerView.alpha = 1
            activityIndicator.startAnimating()
            spinnerView.addSubview(activityIndicator)
            collectionView.alpha = 1
            getProductLists(text: textField.text!)
        }
        return true
    }
}
