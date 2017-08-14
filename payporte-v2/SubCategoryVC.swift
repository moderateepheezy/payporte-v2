//
//  SubCategoryVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/24/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import JNDropDownMenu
import NVActivityIndicatorView


class SubCategoryVC: MainVC {

    var didSetupConstraints = false
    
    let cellId = "cellId"
    
    var categoryName: String?
    
    var category_id: String?
    
    var firstLevelcatgories: [Category]?
    var secondLevelcatgories: [Category]?
    
    var menu: JNDropDownMenu!
    
    var activityIndicator: NVActivityIndicatorView!
    
    let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorColor = .white
        return tv
    }()
    
    let spinnerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
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
    
    
    func fetchSubACategory(cat_id: String){
        
        Payporte.sharedInstance.fetchSubCategories(category_id: cat_id) { (categories, error) in
            
            if error != ""{
                Utilities.getBaseNotification(text: error, type: .error)
                return
            }
            self.firstLevelcatgories = categories
            let firstCat = categories[0]
            self.fetchSubBCategory(cat_id: firstCat.category_id!)
            self.menu = JNDropDownMenu(origin: CGPoint(x: 0, y: 64), height: 40, width: self.view.frame.size.width)
            self.menu.datasource = self
            self.menu.delegate = self
        
            self.view.addSubview(self.menu)
        }
    }
    
    func fetchSubBCategory(cat_id: String){
        Payporte.sharedInstance.fetchSubCategories(category_id: cat_id) { (categories, error) in
            if error != ""{
                Utilities.getBaseNotification(text: error, type: .error)
                return
            }
            self.spinnerView.alpha = 0
            self.activityIndicator.stopAnimating()
            self.secondLevelcatgories = categories
            self.tableView.reloadData()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        view.backgroundColor = .white
        addSubViewsToView()
        
        //let size = CGSize(width: 30, height: 30)
        
        guard let catName = categoryName else {return}
        navigationItem.title = catName
        
        fetchSubACategory(cat_id: category_id!)
    
    }
    
    
    private func addSubViewsToView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        view.addSubview(spinnerView)
        spinnerView.addSubview(loadLabel)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(40)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.bottom.equalTo(view.snp.bottom).offset(-10)
        }
        
        spinnerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
        
        loadLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(spinnerView.snp.bottom).offset(-5)
            make.left.equalTo(spinnerView.snp.left)
            make.right.equalTo(spinnerView.snp.right)
            make.height.equalTo(13)
        }
        
        
        let frame = CGRect(x: 15, y: 0, width: 35, height: 35)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballPulseSync, color: primaryColor, padding: 10)
        
        spinnerView.alpha = 1
        activityIndicator.startAnimating()
        spinnerView.addSubview(activityIndicator)
        
    }
    
    func goToProductDetails(category: Category){
        let vc = ProductListingVC()
        vc.categoryName = category.category_name
        vc.category_id = category.category_id
        vc.hidesBottomBarWhenPushed = false
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SubCategoryVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondLevelcatgories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.font = UIFont(name: "Orkney-Medium", size: 16)!
        let category = secondLevelcatgories?[indexPath.item]
        cell.textLabel?.text = category?.category_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.secondLevelcatgories?[indexPath.item]
        goToProductDetails(category: category!)
    }
    
}

extension SubCategoryVC: JNDropDownMenuDelegate, JNDropDownMenuDataSource{
    
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 1
    }
    
    func numberOfRows(in column: NSInteger, for menu: JNDropDownMenu) -> Int {
        return self.firstLevelcatgories?.count ?? 0
    }
    
    func titleForRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu) -> String {
        let categories = firstLevelcatgories?[indexPath.row]
        return (categories?.category_name)!
    }
    
    
    func didSelectRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu) {
        
        let category = self.firstLevelcatgories?[indexPath.row]
        
        let size = CGSize(width: 30, height: 30)
        spinnerView.alpha = 1
        activityIndicator.startAnimating()
        
        self.secondLevelcatgories?.removeAll()
        self.tableView.reloadData()
        
        fetchSubBCategory(cat_id: (category?.category_id)!)
    }
}
