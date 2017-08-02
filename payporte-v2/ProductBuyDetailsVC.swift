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

class ProductBuyDetailsVC: UIViewController, SwiftImageCarouselVCDelegate {

    var productList: ProductList?
    
    var product: Product?

    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    
    var activityIndicator: NVActivityIndicatorView!
    
    var options = [[Options]]()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        return tv
    }()
    
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
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 385))
        self.setupCarousel(array: productImages, containerView: containerView)
        
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.alwaysBounceVertical = true
        tableView.parallaxHeader.view = containerView
        tableView.parallaxHeader.height = 385
        tableView.parallaxHeader.minimumHeight = 10
        tableView.parallaxHeader.mode = .centerFill
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(OptionsCell.self, forCellReuseIdentifier: cellIndetifier)
        tableView.register(ProductDescriptionCell.self, forCellReuseIdentifier: "cellFor")
        tableView.register(PriceNameViewCell.self, forCellReuseIdentifier: "cellForPrice")
        tableView.register(AddToCartButtonCell.self, forCellReuseIdentifier: "cellForAddToCart")
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(45)
            make.right.left.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        someData.removeAll()
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

extension ProductBuyDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForPrice", for: indexPath) as! PriceNameViewCell
            
            cell.product = product
            
            return cell
        }else if indexPath.item == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForAddToCart", for: indexPath) as! AddToCartButtonCell
            
            if options.count > 0{
                let opt = options[0]
                cell.option = opt[0]
                cell.hasOption = true
            }else{
                cell.hasOption = false
            }
            cell.product = product
            return cell
        }else if indexPath.item == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFor", for: indexPath) as! ProductDescriptionCell
            
            return cell
        }
        let cell = tableView
            .dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath) as! OptionsCell
        if options.count > 0{
            let opt = options[0]
            cell.options = opt
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.item == 3{
            let vc = ProductReadMoreVC()
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0{
            return 75
        }
        return 55
    }
}

public class OptionsCell: UITableViewCell, RGBottomSheetDelegate{
    
    var options: [Options]?{
        didSet{
            
            if let title = options?[0].optionTitle {
                selectSizeButton.alpha = 1
                selectSizeButton.isEnabled = true
                selectSizeButton.setTitle(title, for: .normal)
            }else{
                selectSizeButton.alpha = 0
                selectSizeButton.isEnabled = false
            }
        }
    }
    
    var sheet: RGBottomSheet?
    
    var selectSizeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Orkney-Medium", size: 16)
        button.setImage(#imageLiteral(resourceName: "ic_caret_down"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let selectQtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Quantity", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Medium", size: 16)
        button.setImage(#imageLiteral(resourceName: "ic_caret_down"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(selectQtyButton)
        self.contentView.addSubview(selectSizeButton)
        self.contentView.addSubview(middleView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        
    }
    
    func setupViews(){
        
        selectSizeButton.addTarget(self, action: #selector(handleBottomSheet), for: .touchUpInside)
        selectQtyButton.addTarget(self, action: #selector(handleQtyBottomSheet), for: .touchUpInside)
        
        selectQtyButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectQtyButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectQtyButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectQtyButton.imageView?.snp.makeConstraints({ (make) in
            
            make.leading.equalTo(selectQtyButton.snp.leading).offset(5)
            make.centerY.equalTo(selectQtyButton.snp.centerY)
            
        })
        
        selectQtyButton.titleLabel?.snp.makeConstraints({ (make) in
            
            make.trailing.equalTo(selectQtyButton.snp.trailing)
            make.centerY.equalTo(selectQtyButton.snp.centerY)
            
        })
        
        selectSizeButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectSizeButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectSizeButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        selectSizeButton.imageView?.snp.makeConstraints({ (make) in
            
            make.leading.equalTo(selectSizeButton.snp.leading).offset(10)
            make.centerY.equalTo(selectSizeButton.snp.centerY)
            
        })
        
        selectSizeButton.titleLabel?.snp.makeConstraints({ (make) in
            
            make.trailing.equalTo(selectSizeButton.snp.trailing)
            make.centerY.equalTo(selectSizeButton.snp.centerY)
            
        })
        
        middleView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(1)
            make.height.equalTo(25)
        })
        
        selectQtyButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.height.equalTo(self.snp.height)
            make.right.equalTo(middleView.snp.left).offset(-2)
        }
        selectSizeButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(self.snp.height)
            make.left.equalTo(middleView.snp.right).offset(10)
        }
        
    }
    
    func handleBottomSheet(button: UIButton){
        guard let options = options else {return}
        var array = [String]()
        for i in 0 ..< options.count - 1{
            array.append(options[i].optionValue!)
        }
        configureButtomSheet(options: array, title: options[0].optionTitle!, button: button)
    }
    
    func handleQtyBottomSheet(button: UIButton){
    var array = [String]()
        for i in  1 ..< 21{
            array.append("\(i)")
        }
        configureButtomSheet(options: array, title: "Quantity", button: button)
    }
    
    func configureButtomSheet(options: [String], title: String, button: UIButton){
        var bottomView: BottomSheetView {
            var screenBound = UIScreen.main.bounds
            screenBound.size.height = 200.0
            let bottomView = BottomSheetView(frame: screenBound)
            bottomView.backgroundColor = UIColor.white
            bottomView.bottomSheetDelegate = self
            bottomView.options = options
            bottomView.button = button
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
    
    func closeButtomSheet() {
        sheet?.hide()
    }

}

class PriceNameViewCell: UITableViewCell{
    
    var product: Product?{
        didSet{
            //guard let slashPrice = product?.productRegularPrice else {return}
            guard let price = product?.productPrice else {return}
            guard let productName = product?.productName else {return}
            //guard let sellerName = product?.seller?.name else {return}
            guard let shortDesc = product?.productShortDescription else {return}
            guard let stock = product?.stockStatus else {return}
            if stock == "false"{
                
                let yourAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 24)!] as [String : Any]
                let yourOtherAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 14)!] as [String : Any]
                
                let partOne = NSMutableAttributedString(string: "• ", attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: "Out of stock", attributes: yourOtherAttributes)
                
                let combination = NSMutableAttributedString()
                combination.append(partOne)
                combination.append(partTwo)
                inStockLabel.attributedText = combination
            }else{
                let yourAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.574704592, green: 1, blue: 0.2995168362, alpha: 1), NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 24)!] as [String : Any]
                let yourOtherAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 14)!] as [String : Any]
                
                let partOne = NSMutableAttributedString(string: "• ", attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: "In stock", attributes: yourOtherAttributes)
                
                let combination = NSMutableAttributedString()
                combination.append(partOne)
                combination.append(partTwo)
                inStockLabel.attributedText = combination
            }
            //slashPriceLabel.strikeThrough(text: slashPrice, fontSize: 14)
            priceLabel.text = "₦ \(price)"
            //vendorNameLabel.text = sellerName
            productNameLabel.text = productName
            setUpView(shortDesc: shortDesc, priceRect: price)
            
        }
    }
    var productDetailsVc: ProductBuyDetailsVC?
    
    var slashPriceLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 18)
        label.textColor = #colorLiteral(red: 0.1089585977, green: 0.1089585977, blue: 0.1089585977, alpha: 1)
        return label
    }()
    
    let inStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 22)
        label.textAlignment = .right
        label.text = ""
        return label
    }()
    
//    let vendorNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Orkney-Regular", size: 12)
//        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//        return label
//    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(productNameLabel)
        //self.contentView.addSubview(vendorNameLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(slashPriceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setUpView(shortDesc: String, priceRect: String){
        addSubview(productNameLabel)
        //addSubview(vendorNameLabel)
        addSubview(priceLabel)
        addSubview(slashPriceLabel)
        addSubview(inStockLabel)
        
        let priceRect = getLabelHeight(text: priceRect, font: UIFont(name: "Orkney-Bold", size: 18)!)
        
        let productNameRect = getLabelHeight(text: productNameLabel.text!, font: UIFont(name: "Orkney-Bold", size: 14)!)
        
        //let height = self.frame.height - (productNameLabel.frame.height - vendorNameLabel.frame.height - priceLabel.frame.height - slashPriceLabel.frame.height)
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.left.equalTo(self.snp.left).offset(20)
            make.width.equalTo(priceRect.width + 30)
            make.height.equalTo(18)
        }
        
        inStockLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.width.equalTo(150)
            make.height.equalTo(22)
        }
        
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(productNameRect.height)
        }
        
//        vendorNameLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
//            make.left.equalTo(self.snp.left).offset(20)
//            make.right.equalTo(self.snp.right).offset(-20)
//            make.height.equalTo(13)
//        }
        
        slashPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(20)
            make.left.equalTo(priceLabel.snp.right)
            make.width.equalTo(priceRect.width + 50)
            make.height.equalTo(15)
        }
        
    }
    
    func getLabelHeight(text: String, font: UIFont) -> CGRect{
        
        return  NSString(string: text).boundingRect(with: CGSize(width: self.frame.width, height: 1000) , options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin) , attributes: [NSFontAttributeName: font], context: nil)
    }
    
}

public class ProductDescriptionCell: UITableViewCell{
    
    let label: UILabel = {
       let b = UILabel()
        b.text = "Full Description"
        b.font = UIFont(name: "Orkney-Regular", size: 16)
        b.textColor = .black
        return b
    }()
    
    let rightIcon: UILabel = {
        let label = UILabel()
        label.text = ">"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.contentView.addSubview(rightIcon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        
    }
    
    func setupViews(){
        
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.right.equalTo(self.snp.right).offset(-10)
            make.left.equalTo(self.snp.left).offset(20)
            make.height.equalTo(self.snp.height)
        }
        
        rightIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(13)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.width.equalTo(25)
        }
        
    }
}

public class AddToCartButtonCell: UITableViewCell, NVActivityIndicatorViewable{
    
    var option: Options?
    var product: Product?
    var hasOption: Bool?
    
    var addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD TO CART", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.clipsToBounds = true
        button.backgroundColor = primaryColor
        button.setTitleColor(UIColor.white  , for: .normal)
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(addToCartButton)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
        
        addToCartButton.addTarget(self, action: #selector(handleAddToCart(button:)), for: .touchUpInside)
        
    }
    
    func setupViews(){
        addToCartButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-5)
        }
    }
    
    func handleAddToCart(button: UIButton){
        
        print(someData)
        //print(qtyText)
        if hasOption! &&  someData[(option?.optionTitle)!] != nil{
                Payporte.sharedInstance.addProductToCart(product: product!, option: option) { (value) in
                    button.loadingIndicator(show: false)
                    button.isEnabled = true
                    someData.removeAll()
                }
        }else if !hasOption!{
            Payporte.sharedInstance.addProductToCart(product: product!, option: option) { (value) in
                button.loadingIndicator(show: false)
                button.isEnabled = true
                someData.removeAll()
            }
        }else if hasOption! &&  someData[(option?.optionTitle)!] == nil{
            print("Please use option values for \((option?.optionTitle)!)")
        }else if hasOption! &&  someData["Quantity"] == nil{
            print("Please use option values for Quantity")
        }
        
    }
}

