//
//  ShippingAddressVC.swift
//  PayPorte
//
//  Created by SimpuMind on 5/22/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SnapKit


class ShippingAddressVC: UIViewController {
    
    var didSetupConstraints = false
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    let dismissButton: UIButton = {
       let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "multiply"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping"
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    
    var addAddressButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 241, green: 100, blue: 57), for: .normal)
        button.setTitle("ADD NEW ADDRESS", for: .normal)
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 14)
        button.layer.borderColor = UIColor(red: 241, green: 100, blue: 57).cgColor
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let chooseExsitingLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose an existing shipping address."
        label.font = UIFont(name: "AvenirNext-Regular", size: 17)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.45)
        return label
    }()
    
    let view1: UIView = {
       let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.12)
        return v
    }()
    
    
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("DONE", for: .normal)
        //button.setImage(#imageLiteral(resourceName: "white_right_arrow"), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(addAddressButton)
        view.addSubview(chooseExsitingLabel)
        view.addSubview(view1)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        view.setNeedsUpdateConstraints()
        
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        tableView.register(AddressCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //MARK :- Add Targets
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        addAddressButton.addTarget(self, action: #selector(handleNewAddress), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        

        let colors = [UIColor(red: 247, green: 60, blue: 100), UIColor(red: 250, green: 152, blue: 36)]
        
        doneButton.applyGradientToButton(colours: colors)
        
    }
    
    func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleNewAddress(){
        let vc = NewAddressVC()
        slideInTransitioningDelegate.direction = .left
        vc.transitioningDelegate = slideInTransitioningDelegate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
    
    func handleDone(){
        
    }

}
