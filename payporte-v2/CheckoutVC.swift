//
//  CheckoutVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SnapKit
import RGBottomSheet


protocol CheckoutDelegate {
    
    func getShippingMethods(options: [String])
    func getPaymentMethods(options: [String])
    func getTotalAmount(total: String)
    func getUserAddress(street: String, phone: String)
    func getSelectedPaymentMethod(method: String)
    func getSelectedShippingMethod(method: String)
}

class CheckoutVC: UIViewController, RGBottomSheetDelegate, CheckoutDelegate {
    
    let colors = [UIColor(red: 250, green: 152, blue: 36), UIColor(red: 247, green: 60, blue: 100)]
    
    var didSetupConstraints = false
    
    var sheet: RGBottomSheet?
    
    var numberOfItem = 0
    var total = ""
    var street: String?
    var phoneNumber: String?
    var paymentType: String?
    var shippingType: String?
    
    var pymentData: [String]?
    
    var shippingData: [String]?
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Checkout"
        label.font = UIFont(name: "Orkney-Regular", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        tv.separatorStyle = .none
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        
        view.addSubview(titleLabel)
        
        view.addSubview(tableView)
        
        view.setNeedsUpdateConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(CartCardCell.self, forCellReuseIdentifier: "cartCell")
        tableView.register(ShipToCardCell.self, forCellReuseIdentifier: "shipToCell")
        tableView.register(ShippingMethodCardCell.self, forCellReuseIdentifier: "shippingMethodCell")
        tableView.register(PaymentMethodCardCell.self, forCellReuseIdentifier: "paymentMethodCell")
        tableView.register(PlaceOrderCardCell.self, forCellReuseIdentifier: "placeOrderCell")
        
        
        self.navigationItem.title = "C H E C K  O U T"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        
    }
    
    func closeButtomSheet() {
        sheet?.hide()
    }
    
    func getPaymentMethods(options: [String]) {
        self.pymentData = options
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getShippingMethods(options: [String]) {
        self.shippingData = options
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getTotalAmount(total: String) {
        self.total = "TOTAL \(String(describing: total))"
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getUserAddress(street: String, phone: String) {
        self.street = street
        self.phoneNumber = phone
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getSelectedPaymentMethod(method: String) {
        self.paymentType = method
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getSelectedShippingMethod(method: String) {
        self.shippingType = method
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleShowItems(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleChangeAddress() {
        
        let vc = ShippingAddressVC()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        vc.cartVcDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleShippingType(options: [String]){
        let title = "Select a Shipping Method"
        var bottomView: PaymentSheetView {
            var screenBound = UIScreen.main.bounds
            screenBound.size.height = 200.0
            let bottomView = PaymentSheetView(frame: screenBound)
            bottomView.backgroundColor = UIColor.white
            bottomView.options = options
            bottomView.titleLabel.text = title
            bottomView.bottomSheetDelegate = self
            bottomView.dropType = .SHIPPING
            bottomView.checkoutDelegate = self
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
        self.sheet?.show()
    }
    
    
    func handlePaymentType(options: [String]) {

        let title =  "Select a Payment Method"
        var bottomView: PaymentSheetView {
            var screenBound = UIScreen.main.bounds
            screenBound.size.height = 200.0
            let bottomView = PaymentSheetView(frame: screenBound)
            bottomView.backgroundColor = UIColor.white
            bottomView.options = options
            bottomView.titleLabel.text = title
            bottomView.bottomSheetDelegate = self
            bottomView.checkOutVC = self
            bottomView.dropType = .PAYMENT
            bottomView.checkoutDelegate = self
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
        self.sheet?.show()
    }

}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCardCell
            
            cell.priceLabel.text = "TOTAL \(String(describing: total))"
            cell.numOfItemLabel.text = "YOU HAVE \(numberOfItem) ITEM(S) IN YOUR CART"
            
            cell.selectionStyle = .none
            
            return cell
        }else if indexPath.item == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shipToCell", for: indexPath) as! ShipToCardCell
            
            if let street = self.street, let phone = self.phoneNumber {
                cell.addressLabel.text = street.uppercased()
                cell.phoneNumberLabel.text = phone
            }
            cell.selectionStyle = .none
            
            return cell
        }else if indexPath.item == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shippingMethodCell", for: indexPath) as! ShippingMethodCardCell
            
            if let shippingName = shippingType {
                cell.shippingTextLabel.text = shippingName
            }
            
            cell.selectionStyle = .none
            
            return cell
        }else if indexPath.item == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentMethodCell", for: indexPath) as! PaymentMethodCardCell
            
            
            if let paymentName = paymentType{
                cell.paymentTextLabel.text = paymentName
            }
            
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeOrderCell", for: indexPath) as! PlaceOrderCardCell
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            if indexPath.item == 0 {
                handleShowItems()
            }else if indexPath.item == 1{
                handleChangeAddress()
            }else if indexPath.item == 2 {
                guard let shippingData = shippingData else {
                    Utilities.getBaseNotification(text: "Please add Shipping Address", type: .info)
                    return
                }
                
                handleShippingType(options: shippingData)
            }
            else if indexPath.item == 3{
                
                guard let paymentData = pymentData else {
                    Utilities.getBaseNotification(text: "Please add Shipping Method", type: .info)
                    return
                }
                
                handlePaymentType(options: paymentData)
            }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.item == 0{
            return 210
        }else if indexPath.item == 1 {
            return 165
        }else if indexPath.item == 2{
            return 145
        }else if indexPath.item == 3{
            return 145
        }else{
            return 80
        }
    }
}


