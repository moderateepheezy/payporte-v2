//
//  FilterSortViews.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/6/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class FilterProductVIew: UIView,
UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.separatorColor = UIColor(white: 0.95, alpha: 0.95)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
        tableView.estimatedRowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        
    }
    
    
    func initViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Cell"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
    }
}

class SortProductVIew: UIView,
   UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.separatorColor = UIColor(white: 0.95, alpha: 0.95)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
        
        tableView.estimatedRowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
    }
    
    func initViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Cell"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
    }
}
