//
//  CheckoutVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SnapKit

class CheckoutVC: UIViewController {
    
    let colors = [UIColor(red: 250, green: 152, blue: 36), UIColor(red: 247, green: 60, blue: 100)]
    
    var didSetupConstraints = false
    
    var numberOfItem = 0
    var total = ""
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "error"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Checkout"
        label.font = UIFont(name: "Orkney-Regular", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    let totalPriceView: CardView = {
        let view = CardView()
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        view.backgroundColor = .white
        return view
    }()
    
    let addressView: CardView = {
        let view = CardView()
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        view.backgroundColor = .white
        return view
    }()
    
    let paymentView: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        return view
    }()
    
    let priceDetailsSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(white: 0, alpha: 0.07).cgColor
        view.layer.borderWidth = 0.85
        view.clipsToBounds = true
        return view
    }()
    
    let shipToLabel: UILabel = {
        let label = UILabel()
        label.text = "SHIP TO"
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.textAlignment = .center
        return label
    }()
    
    let shippingMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "SHIPPING METHOD"
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    
    let shippingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "NO SHIPPING METHOD SELECTED"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "JOHN ADDRESS, OFF GORILLA STREET LAGOS"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "JOHN (0705456789045)"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        return label
    }()
    
    let editShippingImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        return button
    }()
    
    let editAddressImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        return button
    }()
    
    let showItemButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        return button
    }()
    
    
    let numOfItemLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Regular", size: 12)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        return label
    }()
    
    let couponTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "ENTER COUPON CODE"
        textfield.textColor = UIColor(white: 0, alpha: 0.45)
        textfield.font = UIFont(name: "Orkney-Regular", size: 10)
        textfield.setBottomBorder()
        return textfield
    }()
    
    let verifyCouponButton: UIButton = {
        let button = UIButton()
        button.setTitle("VERIFY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = primaryColor
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 12)
        return button
    }()
    
    var placeOrderButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("PLACE ORDER", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.backgroundColor = primaryColor
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(totalPriceView)
        view.addSubview(addressView)
        view.addSubview(paymentView)
        view.addSubview(placeOrderButton)
        view.addSubview(shipToLabel)
        view.addSubview(shippingMethodLabel)
        paymentView.addSubview(shippingTextLabel)
        paymentView.addSubview(editShippingImageView)
        addressView.addSubview(addressLabel)
        addressView.addSubview(phoneNumberLabel)
        addressView.addSubview(editAddressImageView)
        totalPriceView.addSubview(priceDetailsSubView)
        priceDetailsSubView.addSubview(showItemButton)
        priceDetailsSubView.addSubview(priceLabel)
        priceDetailsSubView.addSubview(numOfItemLabel)
        totalPriceView.addSubview(couponTextField)
        totalPriceView.addSubview(verifyCouponButton)
        
        view.setNeedsUpdateConstraints()
        
        priceLabel.text = "TOTAL \(String(describing: total))"
        numOfItemLabel.text = "YOU HAVE \(numberOfItem) ITEM(S) IN YOUR CART"
        
        self.navigationItem.title = "C H E C K  O U T"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        // MARK:- Add Targets
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        editAddressImageView.addTarget(self, action: #selector(handleChangeAddress), for: .touchUpInside)
        showItemButton.addTarget(self, action: #selector(handleShowItems), for: .touchUpInside)
        
        
        
        placeOrderButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        placeOrderButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        placeOrderButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        placeOrderButton.imageView?.snp.makeConstraints({ (make) in
            
            make.leading.equalTo(placeOrderButton.snp.leading).offset(16)
            make.centerY.equalTo(placeOrderButton.snp.centerY)
            
        })
        
    }
    
    //MARK:- Handle Targets
    
    func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleShowItems(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleChangeAddress() {
        
        //let vc = ShippingAddressVC()
        //present(vc, animated: true, completion: nil)
    }
    
}
