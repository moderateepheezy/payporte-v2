//
//  PaymentSheetView.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/23/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import AZDialogView

enum DropType {
    case SHIPPING
    case PAYMENT
}

class PaymentSheetView: UIView {

    var options: [String]?
    
    var bottomSheetDelegate: RGBottomSheetDelegate?
    
    var checkOutVC: CheckoutVC?
    
    var checkoutDelegate: CheckoutDelegate?
    
    var dropType: DropType?
    
    let dialog = AZDialogViewController(title: "Bank Transfer", message: nil)
    
    var bottomView: ButtomSheetSubView = {
        var screenBound = UIScreen.main.bounds
        screenBound.size.height = 200.0
        let bottomView = ButtomSheetSubView(frame: screenBound)
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        return button
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        addSubview(tableView)
        addSubview(titleLabel)
        addSubview(doneButton)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.height.equalTo(55)
            make.top.equalTo(self)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(55)
            make.top.equalTo(self)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
        }
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self)
        }
        
        doneButton.addTarget(self, action: #selector(dismissView(button:)), for: .touchUpInside)
    }
    
    func dismissView(button: UIButton){
        bottomSheetDelegate?.closeButtomSheet()
        
    }
    
    func showTransferType(){
        dialog.showSeparator = false
        
        let container = dialog.container
        
        dialog.customViewSizeRatio = 1.0
        
        dialog.cancelEnabled = true
        
        dialog.cancelButtonStyle = { (button,height) in
            button.tintColor = primaryColor
            button.setTitle("CANCEL", for: [])
            return true //must return true, otherwise cancel button won't show.
        }
        
        let webView = UIWebView()
        container.addSubview(webView)
        
        let string = "Kindly make payment to the following account:\n\nAcc Name: <strong>Payporte Technology Limited</strong>\nBank: <strong>UBA</strong>\nAcc No: <strong>1020098172</strong>\n\nAfter making payment, kindly send an e-mail to bt@payporte.com with your name, amount paid and order number so your payment can be confirmed before we begin processing your order. Please, note that proof of payment (screenshot of transaction or picture of bank teller) may be required to confirm your payment.\n"
        
        webView.loadHTMLString(string, baseURL: nil)
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: container.topAnchor, constant: -25).isActive = true
        webView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        
        checkOutVC?.present(dialog, animated: true, completion: nil)
        bottomSheetDelegate?.closeButtomSheet()
    }
    
}


extension PaymentSheetView: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = options?[indexPath.item].uppercased()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Orkney-Regular", size: 13)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = options?[indexPath.item] else {return}
        if dropType == .PAYMENT{
            checkoutDelegate?.getSelectedPaymentMethod(method: option)
        }else if dropType == .SHIPPING {
            checkoutDelegate?.getSelectedShippingMethod(method: option)
        }
        bottomSheetDelegate?.closeButtomSheet()
    }
}
