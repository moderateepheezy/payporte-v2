//
//  ProductBuyDetailsVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/31/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import CSStickyHeaderFlowLayout
import NVActivityIndicatorView
import ParallaxHeader
import SwiftImageCarousel
import RGBottomSheet

class ProductBuyDetailsVC: UIViewController, SwiftImageCarouselVCDelegate, RGBottomSheetDelegate {

    var productList: ProductList?
    
    var product: Product?
    
    var collectionView: UICollectionView!
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    var sheet: RGBottomSheet?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    
    var activityIndicator: NVActivityIndicatorView!
    
    var options = [[Options]]()
    
    
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
    
    var addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD TO CART", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.clipsToBounds = true
        button.backgroundColor = primaryColor
        button.setTitleColor(UIColor.white  , for: .normal)
        return button
    }()
    
    func fetchProductDetails(product_id: String){
        Payporte.sharedInstance.fetchProductDetails(product_id: product_id) { (product) in
            self.addSubViews()
            
            self.spinnerView.alpha = 0
            self.activityIndicator.startAnimating()
            self.product = product
            guard let productImages = product.productImages else {return}
            //self.setupViewData(product: product)
            self.setupViews(productImages: productImages)
            
            guard let options = product.options else {return}
            self.options = options.group { $0.optionTypeId ?? "" }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9580028553, green: 0.9580028553, blue: 0.9580028553, alpha: 1)
        addSubViews()
        guard let id = productList?.product_id else {return}
        fetchProductDetails(product_id: id)
        
        view.backgroundColor = .white
    }
    
    func setupViews(productImages: [String]){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 420))
        self.setupCarousel(array: productImages, containerView: containerView)
        let gframe = CGRect(x: 0, y: 25, width: view.frame.width, height: view.frame.height)
        collectionView = UICollectionView(frame: gframe, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.parallaxHeader.view = containerView
        collectionView.parallaxHeader.height = 420
        collectionView.parallaxHeader.minimumHeight = 0
        collectionView.parallaxHeader.mode = .centerFill
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: cellIndetifier)
        collectionView.register(ProductDescriptionCell.self, forCellWithReuseIdentifier: "cellFor")
        
        if #available(iOS 10.0, *) {
            self.collectionView?.isPrefetchingEnabled = false
        } else {
            //Fallback on earlier versions
        }
        
        collectionView.register(DetailsViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 150)
        
        view.addSubview(collectionView)
        
        view.addSubview(addToCartButton)
        
        addToCartButton.snp.makeConstraints({ (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.left.equalTo(view.snp.left).offset(10)
            make.height.equalTo(45)
        })
    }
    
    func configureButtomSheet(options: [Options], title: String){
        var bottomView: BottomSheetView {
            var screenBound = UIScreen.main.bounds
            screenBound.size.height = 200.0
            let bottomView = BottomSheetView(frame: screenBound)
            bottomView.backgroundColor = UIColor.white
            bottomView.bottomSheetDelegate = self
            bottomView.options = options
            bottomView.titleLabel.text = title
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
        
        sheet?.show()
    }
    
    func setupCarousel(array: [String], containerView: UIView){
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = array
        
        vc.noImage = #imageLiteral(resourceName: "placeholder")
        vc.contentMode = .scaleAspectFill
        vc.swiftImageCarouselVCDelegate = self
        vc.escapeFirstPageControlDefaultFrame = true
        vc.willMove(toParentViewController: self)
        containerView.addSubview(vc.view)
        
        vc.view.frame = CGRect(x: 0, y: -20, width: containerView.frame.width, height: containerView.frame.height + 20)
        
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
    
    func addSubViews(){
        
        view.addSubview(spinnerView)
        spinnerView.addSubview(loadLabel)
        
        let frame = CGRect(x: 15, y: 0, width: 35, height: 35)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: primaryColor, padding: 10)
        
        spinnerView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.center)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
        
        spinnerView.alpha = 1
        activityIndicator.startAnimating()
        spinnerView.addSubview(activityIndicator)
    }
    
    func closeButtomSheet() {
        sheet?.hide()
    }
    
    func returnCellSize() -> CGSize {
        let paddingSpace = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 45)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}

extension ProductBuyDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return options.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == options.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFor", for: indexPath) as! ProductDescriptionCell
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifier, for: indexPath) as! OptionsCell
        
        let option = options[indexPath.item]
        cell.option = option[0]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item  < options.count {
            return returnCellSize()
        }else{
            let paddingSpace = sectionInsets.left * (2 + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: collectionView.frame.width, height: widthPerItem)
        }
    }
    
    func getLabelHeight(text: String, font: UIFont) -> CGRect{
        
        return  NSString(string: text).boundingRect(with: CGSize(width: view.frame.width, height: 1000) , options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin) , attributes: [NSFontAttributeName: font], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.item == options.count{
            let vc = ProductReadMoreVC()
            present(vc, animated: true, completion: nil)
        }
        
        let opts = options[indexPath.item]
        guard let title = opts[0].optionTitle else {return}
        configureButtomSheet(options: opts, title: title)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
         if kind ==  UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! DetailsViewSectionHeader
            view.product = product
            view.productDetailsVc = self
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

public class OptionsCell: UICollectionViewCell{
    
    var option: Options?{
        didSet{
            guard let title = option?.optionTitle else {return}
            titleLabel.text = title
        }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let selectedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 14)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = "12"
        label.textAlignment = .right
        return label
    }()
    
    let dropIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_cart_add")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(titleLabel)
        addSubview(selectedTitleLabel)
        addSubview(dropIcon)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        dropIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.left.equalTo(self.snp.left).offset(5)
            make.height.equalTo(self.snp.height)
        }
        selectedTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalTo(dropIcon.snp.left).offset(-5)
            make.height.equalTo(self)
        }
    }
}

class DetailsViewSectionHeader: UICollectionReusableView{
    
    var product: Product?{
        didSet{
            guard let slashPrice = product?.productRegularPrice else {return}
            guard let price = product?.productPrice else {return}
            guard let productName = product?.productName else {return}
            guard let sellerName = product?.seller?.name else {return}
            guard let shortDesc = product?.productShortDescription else {return}
            
            slashPriceLabel.strikeThrough(text: slashPrice, fontSize: 14)
            priceLabel.text = "₦ \(price)"
            vendorNameLabel.text = sellerName
            productNameLabel.text = productName
            setUpView(shortDesc: shortDesc)
            
        }
    }
    var productDetailsVc: ProductBuyDetailsVC?
    
    var slashPriceLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Regular", size: 15)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 18)
        label.textColor = primaryColor
        return label
    }()
    
    let vendorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    let view: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Regular", size: 16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(shortDesc: String){
        addSubview(productNameLabel)
        addSubview(vendorNameLabel)
        addSubview(view)
        addSubview(priceLabel)
        addSubview(slashPriceLabel)
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(slashPriceLabel.snp.bottom).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.left.equalTo(self.snp.left).offset(10)
            make.height.equalTo(1)
        }
        
        //let shortDescRect = getLabelHeight(text: shortDesc, font: UIFont(name: "Orkney-Regular", size: 9)!)
        
        let productNameRect = getLabelHeight(text: productNameLabel.text!, font: UIFont(name: "Orkney-Bold", size: 15)!)
        
        //let height = self.frame.height - (productNameLabel.frame.height - vendorNameLabel.frame.height - priceLabel.frame.height - slashPriceLabel.frame.height)
        
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(productNameRect.height)
        }
        
        vendorNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(13)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vendorNameLabel.snp.bottom).offset(20)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(18)
        }
        
        slashPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(15)
        }
        
    }
    
    func getLabelHeight(text: String, font: UIFont) -> CGRect{
        
        return  NSString(string: text).boundingRect(with: CGSize(width: self.frame.width, height: 1000) , options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin) , attributes: [NSFontAttributeName: font], context: nil)
    }
    
}

public class ProductDescriptionCell: UICollectionViewCell{
    
    let label: UILabel = {
       let b = UILabel()
        b.text = "Full Description"
        b.font = UIFont(name: "Orkney-Regular", size: 14)
        b.textColor = .black
        return b
    }()
    
    let view: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    
    let view2: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    
    let rightIcon: UILabel = {
        let label = UILabel()
        label.text = ">"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(view)
        addSubview(view2)
        addSubview(label)
        addSubview(rightIcon)
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right).offset(-20)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(1)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(1)
            make.right.equalTo(self.snp.right).offset(-10)
            make.left.equalTo(self.snp.left).offset(10)
            make.height.equalTo(45)
        }
        
        rightIcon.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.width.equalTo(25)
        }
        
        view2.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.right.equalTo(self.snp.right).offset(-20)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(1)
        }
    }
}

