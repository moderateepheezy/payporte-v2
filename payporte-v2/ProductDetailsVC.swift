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

protocol RGBottomSheetDelegate {
    
    func closeButtomSheet()
}

class ProductDetailsVC: UIViewController, SwiftImageCarouselVCDelegate, RGBottomSheetDelegate {
    
    var didSetupConstraints = false
    
    fileprivate var searchBar: UISearchBar!
    
    var sheet: RGBottomSheet?
    
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
        return button
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        return view
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$ 46,000"
        label.font = UIFont(name: "Orkney-Bold", size: 17)
        label.textAlignment = .center
        label.textColor = primaryColor
        return label
    }()
    
    let vendorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Payporte"
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "T-Buckle"
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.setNeedsUpdateConstraints()
        addSubViews()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        addToCartButton.addTarget(self, action: #selector(handleAddToCart), for: .touchUpInside)
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItems = [searchBarButton]
        
        self.navigationItem.title = "T-Buckle"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = [
            "https://www.payporte.com/media/catalog/product/H/H/HHEADBLACKLEATHERBELT.jpg",
            "https://www.payporte.com/media/catalog/product/i/m/image1_7407.jpg",
            "https://www.payporte.com/media/catalog/product/1/7/1711_1.jpg",
            "https://www.payporte.com/media/catalog/product/J/U/JUNE27TH6.jpg"
        ]
        
        vc.noImage = #imageLiteral(resourceName: "placeholder")
        vc.contentMode = .scaleAspectFill
        vc.swiftImageCarouselVCDelegate = self
        vc.escapeFirstPageControlDefaultFrame = true
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        
        let config = RGBottomSheetConfiguration(
            showBlur: true
        )
        sheet = RGBottomSheet(
            withContentView: bottomView,
            configuration: config
        )
        
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
        view.addSubview(priceLabel)
        view.addSubview(productNameLabel)
        view.addSubview(vendorNameLabel)
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
