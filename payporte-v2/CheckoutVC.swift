//
//  CheckoutVC.swift
//  PayPorte
//
//  Created by SimpuMind on 5/17/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SnapKit

class CheckoutVC: UIViewController {
    
    let colors = [UIColor(red: 250, green: 152, blue: 36), UIColor(red: 247, green: 60, blue: 100)]
    
    var didSetupConstraints = false
    
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back_black"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Checkout"
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    let totalPriceView: FancyView = {
       let view = FancyView()
        view.backgroundColor = .white
        return view
    }()
    
    let addressView: FancyView = {
        let view = FancyView()
        view.backgroundColor = .white
        return view
    }()
    
    let paymentView: FancyView = {
        let view = FancyView()
        view.backgroundColor = .white
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
    
    let cartLabel: UILabel = {
        let label = UILabel()
        label.text = "CART"
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    
    let shipToLabel: UILabel = {
        let label = UILabel()
        label.text = "SHIP TO"
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.textAlignment = .center
        return label
    }()
    
    let shippingMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "SHIPPING METHOD"
        label.textColor = UIColor(white: 0, alpha: 0.65)
        label.font = UIFont(name: "AvenirNext-Bold", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    
    let shippingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "NO SHIPPING METHOD SELECTED"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "JOHN ADDRESS, OFF GORILLA STREET LAGOS"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "JOHN (0705456789045)"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
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
        label.text = "YOU HAVE 1 ITEM(S) IN YOUR CART"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "TOTAL N2,000.00"
        label.textColor = UIColor(white: 0, alpha: 0.45)
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
        return label
    }()
    
    let couponTextField: UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "ENTER COUPON CODE"
        textfield.textColor = UIColor(white: 0, alpha: 0.45)
        textfield.font = UIFont(name: "AvenirNext-Regular", size: 10)
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    let verifyCouponButton: UIButton = {
        let button = UIButton()
        button.setTitle("VERIFY", for: .normal)
        button.setTitleColor(UIColor(white: 0, alpha: 0.4), for: .normal)
        button.backgroundColor = UIColor(white: 0, alpha: 0.30)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12)
        return button
    }()
    
    var placeOrderButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(white: 0, alpha: 0.65), for: .normal)
        button.setTitle("PLACE ORDER", for: .normal)
        button.setImage(#imageLiteral(resourceName: "white_right_arrow"), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 249, green: 249, blue: 249)
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(totalPriceView)
        view.addSubview(cartLabel)
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
        
        placeOrderButton.applyGradientToButton(colours: colors)
    
    }
    
    //MARK:- Handle Targets
    
    func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleShowItems(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    func handleChangeAddress() {
        
        let vc = ShippingAddressVC()
        present(vc, animated: true, completion: nil)
    }

}
