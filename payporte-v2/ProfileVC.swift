//
//  ProfileVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    var didSetupConstraints = false
    
    let viewHolder : UIView = {
       let v = UIView()
        return v
    }()
    
    let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "standalone")
        return iv
    }()
    
    let descLabel: UILabel = {
       let label = UILabel()
        label.text = "Login to Payporte app, your prefered mobile store and gain full feature."
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0, alpha: 0.45)
        return label
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.layer.borderColor = primaryColor.cgColor
        button.layer.borderWidth = 1
        button.layer.shadowRadius = 2
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor(white: 0, alpha: 0.65)  , for: .normal)
        return button
    }()
    
    
    var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN IN", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.layer.shadowRadius = 2
        button.layer.masksToBounds = true
        button.backgroundColor = primaryColor
        button.setTitleColor(UIColor(white: 1, alpha: 1)  , for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.setNeedsUpdateConstraints()
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysOriginal)
        
        let menuBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: #selector(menuClick))
        menuBarButton.tintColor = UIColor.black
        
        self.navigationItem.title = "P R O F I L E"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        self.navigationItem.leftBarButtonItems = [menuBarButton]
        
        setupSubViews()
    }
    
    func setupSubViews(){
        view.addSubview(viewHolder)
        viewHolder.addSubview(iconImageView)
        viewHolder.addSubview(descLabel)
        viewHolder.addSubview(loginButton)
        viewHolder.addSubview(signupButton)
    }
    
    func menuClick(){
        let vc = DrawerController()
        vc.hidesBottomBarWhenPushed = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }

}
