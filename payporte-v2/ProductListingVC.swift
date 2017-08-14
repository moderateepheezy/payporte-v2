//
//  ProductListingVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/4/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import DropDown
import RGBottomSheet
import NVActivityIndicatorView

protocol ProductListingDelegate {
    
    func sortProductList(key: String)
    func filterProductList(key: String, value: String)
}

let cellIndetifier = "cellId"
var key = "0"

public enum DisplayType {
    case SEARCH
    case SUBCAT
}

class ProductListingVC: MainVC, RGBottomSheetDelegate, ProductListingDelegate {

    private var mySearchBar: UISearchBar!
    
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
        button.backgroundColor = .white
        button.alpha = 0
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
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
    
    lazy var pullUpRefreshControl: UIRefreshControl = {
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
    
    func getProductLists(category_id: String){
        
        
        Payporte.sharedInstance.fetchSortProductListing(key: "0", offset: 0, category_id: category_id, completion: { (productList, error) in
            if error != ""{
                Utilities.getBaseNotification(text: error, type: .error)
                return
            }
                if productList.count > 0{
                    self.spinnerView.alpha = 0
                    self.activityIndicator.stopAnimating()
                    self.productLists = productList
                    self.collectionView.reloadData()
                    self.showFilter()
                    self.showSort()
            }else{
                self.setupEmptyState()
            }
            
        }, itemCountCompletion: { (itemCounts) in
            self.itemCounts = itemCounts
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
    
    override func tryAgain() {
        getProductLists(category_id: category_id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProductLists(category_id: category_id!)
        
        view.backgroundColor = Utilities.getColorWithHexString("#f9f9f9")
        view.setNeedsUpdateConstraints()
        addSubViews()
        
        guard let catName = categoryName else {return}
        navigationItem.title = catName

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
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

    
    func fetchData(){
        
        let tempIndex = (coursorCount! / limit)
        let index = (tempIndex < 1) ? 1 : tempIndex
        let  offset = (coursorCount != 0) ? index * limit: 0
        if coursorCount! >= offset {
            page = offset
            print(key)
            Payporte.sharedInstance.fetchSortProductListing(key: key, offset: page, category_id: category_id!, completion: { (productList, error) in
                
                if error != ""{
                    Utilities.getBaseNotification(text: error, type: .error)
                    return
                }
                self.spinnerView.alpha = 0
                self.activityIndicator.stopAnimating()
                self.productLists = productList
                self.collectionView.reloadData()
                
            }, itemCountCompletion: { (itemCount) in
                self.itemCounts = itemCount
            }) { (count) in
                self.coursorCount = count
            }
            
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
            
            Payporte.sharedInstance.fetchSortProductListing(key: key, offset: page, category_id: (category_id!), completion: { (productList, error) in
                
                if error != ""{
                    Utilities.getBaseNotification(text: error, type: .error)
                    return
                }
                
                self.spinnerView.alpha = 0
                self.activityIndicator.stopAnimating()
                self.productLists = productList
                self.collectionView.reloadData()
                
            }, itemCountCompletion: { (itemCount) in
                
            }, cursorCompletion: { (coursorCount) in
                self.coursorCount = coursorCount
            })
            
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
            
            Payporte.sharedInstance.fetchFilterProductListing(key: key, value: value, offset: page, category_id: (category_id)!, completion: { (productList, error) in
                
                if error != ""{
                    Utilities.getBaseNotification(text: error, type: .error)
                    return
                }
                
                self.spinnerView.alpha = 0
                self.activityIndicator.stopAnimating()
                self.productLists = productList
                self.collectionView.reloadData()
                
            }, itemCountCompletion: { (itemCount) in
                
            }, cursorCompletion: { (coursorCount) in
                self.coursorCount = coursorCount
            })
            
//            Payporte.sharedInstance.fetchSortProductListing(key: key, offset: page, category_id: (category?.category_id!)!, completion: { (productList) in
//                
//                self.spinnerView.alpha = 0
//                self.activityIndicator.stopAnimating()
//                self.productLists = productList
//                self.collectionView.reloadData()
//                
//            }, itemCountCompletion: { (itemCount) in
//                
//            }, cursorCompletion: { (coursorCount) in
//                self.coursorCount = coursorCount
//            })
            
        }
    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        getProductLists(category_id: category_id!)
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
        
        spinnerView.alpha = 1
        activityIndicator.startAnimating()
        spinnerView.addSubview(activityIndicator)
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
        sortDown.anchorView = headerView
        
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
        filterDown.anchorView = headerView
        
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
    
    
}

extension ProductListingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        vc.productList_id = productList.product_id
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

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

