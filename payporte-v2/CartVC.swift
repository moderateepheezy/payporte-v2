//
//  CartVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/29/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class CartVC: MainVC {
    
    let cellIdentifier = "cellIdentifier"
    
    var cartArray = [Cart]()
    
    var cardview: CardView = {
       let cv = CardView()
        cv.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        cv.backgroundColor = .white
        return cv
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "T O T A L"
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        label.textAlignment = .left
        label.textColor = UIColor(white: 0, alpha: 0.85)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 16)
        label.textColor = UIColor(white: 0, alpha: 0.85)
        label.textAlignment = .center
        return label
    }()
    
    let cardView2: CardView = {
        let cv = CardView()
        cv.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        cv.backgroundColor = .white
        return cv
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        return tv
    }()
    
    var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("CHECK OUT", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        button.isUserInteractionEnabled = true
        button.setImage(#imageLiteral(resourceName: "right_arrow"), for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(UIColor(white: 0, alpha: 0.65)  , for: .normal)
        return button
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = primaryColor
        
        return refreshControl
    }()
    
    var didSetupConstraints = false
    
    func fetchCartItems(){
        Payporte.sharedInstance.fetchCartItems { (carts, message, error, itemCount, cursorCount) in
            if error != ""{
                Utilities.getBaseNotification(text: error, type: .error)
                return
            }
            
            self.view.setNeedsUpdateConstraints()
            self.addSubViewsToView()
            self.priceLabel.text = "₦ \(message)"
            self.cartArray = carts
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCartItems()
        
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "cart_select").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.image = #imageLiteral(resourceName: "cart").withRenderingMode(.alwaysOriginal)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: cellIdentifier)
 
        
        self.navigationItem.title = "C A R T"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        checkoutButton.addTarget(self, action: #selector(handlePushToCartVc(button:)), for: .touchUpInside)
        checkoutButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        checkoutButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        checkoutButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        checkoutButton.imageView?.snp.makeConstraints({ (make) in
            
            make.leading.equalTo(checkoutButton.snp.leading).offset(16)
            make.centerY.equalTo(checkoutButton.snp.centerY)
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func addSubViewsToView(){
        view.addSubview(cardview)
        cardview.addSubview(totalLabel)
        cardview.addSubview(priceLabel)
        view.addSubview(cardView2)
        view.addSubview(tableView)
        cardView2.addSubview(checkoutButton)
        tableView.addSubview(refreshControl)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        fetchCartItems()
    }
    
    func handlePushToCartVc(button: UIButton){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        let vc = CheckoutVC()
        vc.numberOfItem = 10
        vc.total = priceLabel.text!
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartCell
        cell.index = indexPath.item
        cell.cartVc = self
        let arr = cartArray[indexPath.item]
        cell.cart = arr
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let arr = cartArray[indexPath.item]
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        let vc = ProductBuyDetailsVC()
        vc.productList_id = arr.product_id
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

