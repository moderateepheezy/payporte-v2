//
//  ProductDetailsVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/17/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SwiftImageCarousel
import RGBottomSheet
import NVActivityIndicatorView

protocol RGBottomSheetDelegate {
    
    func closeButtomSheet()
}

class ProductDetailsVC: UIViewController, SwiftImageCarouselVCDelegate, RGBottomSheetDelegate {
    
    var didSetupConstraints = false
    
    fileprivate var searchBar: UISearchBar!
    
    var sheet: RGBottomSheet?
    
    var productList: ProductList?
    
    var product: Product?
    
    var searchActive : Bool = false
    
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = primaryColor
        return view
    }()
    
    var bottomView: BottomSheetView {
        var screenBound = UIScreen.main.bounds
        screenBound.size.height = 200.0
        let bottomView = BottomSheetView(frame: screenBound)
        bottomView.backgroundColor = UIColor.white
        bottomView.bottomSheetDelegate = self
        return bottomView
    }
    
    var addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD TO CART", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.clipsToBounds = true
        button.backgroundColor = primaryColor
        button.setTitleColor(UIColor.white  , for: .normal)
        return button
    }()
    
    var readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("READ MORE >>", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white  , for: .normal)
        button.backgroundColor = primaryColor
        button.isEnabled = false
        return button
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        return view
    }()
    
    var slashPriceLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Medium", size: 14)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 17)
        label.textAlignment = .center
        label.textColor = primaryColor
        return label
    }()
    
    let vendorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
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
    
    func fetchProductDetails(product_id: String){
        Payporte.sharedInstance.fetchProductDetails(product_id: product_id) { (product, error) in
            if error != ""{
                Utilities.getBaseNotification(text: error, type: .error)
                return
            }
            self.readMoreButton.isEnabled = true
            self.spinnerView.alpha = 0
            self.activityIndicator.startAnimating()
            self.product = product
            guard let productImages = product.productImages else {return}
            self.setupCarousel(array: productImages)
            self.setupViewData(product: product)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = productList?.product_id else {return}
        fetchProductDetails(product_id: id)
        
        view.backgroundColor = .white
        view.setNeedsUpdateConstraints()
        addSubViews()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        addToCartButton.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItems = [searchBarButton]
        
        self.navigationItem.title = productList?.product_name!
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        
        let config = RGBottomSheetConfiguration(
            showBlur: true
        )
        sheet = RGBottomSheet(
            withContentView: bottomView,
            configuration: config
        )
        
        readMoreButton.addTarget(self, action: #selector(loadReadMoreVC(button:)), for: .touchUpInside)
    }
    
    func setupBotttomSheet(){
        guard let options = product?.options else {return}
        print(options.group { $0.optionTypeId ?? "" })
    }
    
    func loadReadMoreVC(button: UIButton){
        let vc = ProductReadMoreVC()
        vc.product = product
        present(vc, animated: true, completion: nil)
    }
    
    func setupCarousel(array: [String]){
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = array
        
        vc.noImage = #imageLiteral(resourceName: "placeholder")
        vc.contentMode = .scaleAspectFit
        vc.swiftImageCarouselVCDelegate = self
        vc.escapeFirstPageControlDefaultFrame = true
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 10, width: containerView.frame.width, height: containerView.frame.height - 10)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
    
    func setupViewData(product: Product?){
        guard let slashPrice = product?.productRegularPrice else {return}
        guard let price = product?.productPrice else {return}
        guard let productName = product?.productName else {return}
        guard let sellerName = productList?.seller?.name else {return}
        slashPriceLabel.strikeThrough(text: slashPrice, fontSize: 14)
        priceLabel.text = "₦ \(price)"
        vendorNameLabel.text = sellerName
        productNameLabel.text = productName
    }
    
    func closeButtomSheet() {
        sheet?.hide()
    }
    
    func addSubViews(){
        view.addSubview(containerView)
        view.addSubview(buttonView)
        buttonView.addSubview(addToCartButton)
        buttonView.addSubview(readMoreButton)
        buttonView.addSubview(middleView)
        view.addSubview(slashPriceLabel)
        view.addSubview(priceLabel)
        view.addSubview(productNameLabel)
        view.addSubview(vendorNameLabel)
        view.addSubview(spinnerView)
        spinnerView.addSubview(loadLabel)
        
        let frame = CGRect(x: 15, y: 0, width: 35, height: 35)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: primaryColor, padding: 10)
        
        spinnerView.alpha = 1
        activityIndicator.startAnimating()
        spinnerView.addSubview(activityIndicator)
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
        self.navigationItem.title = "T-Buckle"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItems = [ searchBarButton]
    }
    
    func handleAddToCart(){
        sheet?.configuration.showBlur = false
        sheet?.configuration.showOverlay = true
        sheet?.show()
    }

}

extension ProductDetailsVC: UISearchBarDelegate {
    
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
