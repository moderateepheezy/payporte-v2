//
//  SplashVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/21/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    var iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "standalone")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var label: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    var retryButton: UIButton = {
       let button = UIButton()
        button.setTitle("Try Again!", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 16)
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.label.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.label.text = "Setting up your shoping space..."
            self.label.fadeIn()
        })
    }

    func fetchStoreConfig(){
        
        self.label.alpha = 1
        self.retryButton.alpha = 0
        self.errorLabel.alpha = 0
        
        self.label.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.label.text = "Setting up your shoping space..."
            self.label.fadeIn()
        })
        
        Payporte.sharedInstance.handleFetch { (error) in
            
            if error == "0"{
                //return
                
                let vc = MainTabViewController()
                self.present(vc, animated: true, completion: nil)
            }
            else{
                self.reconstrainViews()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(label)
        view.addSubview(iconImageView)
        
        
        fetchStoreConfig()
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-40)
            make.width.height.equalTo(150)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalTo(view)
            make.height.equalTo(15)
        }
    }
    
    func reconstrainViews(){
        self.label.alpha = 0
        self.retryButton.alpha = 1
        self.errorLabel.alpha = 1
        self.view.addSubview(self.retryButton)
        self.view.addSubview(self.errorLabel)
        
        self.errorLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.label.text = "Error Connecting!"
            self.label.fadeIn()
        })
        
        
        self.errorLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(self.iconImageView.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.height.equalTo(15)
        }
        
        self.iconImageView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-40)
            make.width.height.equalTo(150)
        }
        
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
        
        self.retryButton.snp.makeConstraints({ (make) in
            make.top.equalTo(self.label.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(34)
            make.left.equalTo(self.view.snp.left).offset((self.view.frame.width / 2) - 50)
        })
        
        retryButton.addTarget(self, action: #selector(handleRetry(button:)), for: .touchUpInside)
    }
    
    func handleRetry(button: UIButton){
        
        self.fetchStoreConfig()
    }

}
