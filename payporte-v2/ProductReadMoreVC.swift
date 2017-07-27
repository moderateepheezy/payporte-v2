//
//  ProductReadMoreVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/27/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ProductReadMoreVC: UIViewController {

    var product: Product?
    
    let dismisButton: UIButton = {
       let button = UIButton()
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 18)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9661722716, green: 0.9661722716, blue: 0.9661722716, alpha: 1)
        return button
    }()
    
    let lineView: UIView = {
       let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.9478505711, green: 0.9478505711, blue: 0.9478505711, alpha: 1)
        return v
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    let webView: UIWebView = {
       let wv = UIWebView()
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(dismisButton)
        view.addSubview(titleLabel)
        view.addSubview(lineView)
        view.addSubview(webView)
        self.navigationItem.title = product?.productName!
        
        
        dismisButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(30)
            make.width.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(dismisButton.snp.bottom).offset(10)
            make.width.equalTo(self.view)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.width.height.equalTo(35)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(self.view)
        }
        
        dismisButton.layer.cornerRadius = 20
        dismisButton.clipsToBounds = true
        dismisButton.addTarget(self, action: #selector(handleDismiss(button:)), for: .touchUpInside)
        
        guard let pDetails = product?.productDescription else {return}
        guard let productName = product?.productName else {return}
        
        titleLabel.text = productName
        webView.loadHTMLString(pDetails, baseURL: nil)
    }
    
    func handleDismiss(button: UIButton){
        dismiss(animated: true, completion: nil)
    }

}
