//
//  DrawerController.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/3/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

//import UIKit
//import KJExpandableTableTree
//
//class DrawerController: UIViewController {
//    
//    fileprivate var searchBar: UISearchBar!
//    
//    var searchActive : Bool = false
//    
//    let tableView: UITableView = {
//       let tv = UITableView()
//        tv.backgroundColor = .white
//        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        return tv
//    }()
//    
//    // KJ Tree instances -------------------------
//    var arrayTree:[Parent] = []
//    var kjtreeInstance: KJTree = KJTree()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        view.addSubview(tableView)
//        
//        tableView.snp.makeConstraints({ (make) in
//            make.top.equalTo(view)
//            make.width.equalTo(view)
//            make.bottom.equalTo(view)
//        })
//        
//        searchBar = UISearchBar()
//        searchBar.delegate = self
//        
//        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
//        searchBarButton.tintColor = UIColor.black
//        self.navigationItem.rightBarButtonItems = [ searchBarButton]
//        
//        self.navigationItem.title = "C A T E G O R Y"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
//        
//        let filepath: String? = Bundle.main.path(forResource: "Tree", ofType: "json")
//        let url = URL(fileURLWithPath: filepath ?? "")
//        
//        var jsonData: Data?
//        do {
//            jsonData = try Data(contentsOf: url)
//        }catch{
//            print("error")
//        }
//        
//        var jsonDictionary: NSDictionary?
//        do {
//            jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: .init(rawValue: 0)) as? NSDictionary
//        }catch{
//            print("error")
//        }
//        
//        var arrayParents: NSArray?
//        if let treeDictionary = jsonDictionary?.object(forKey: "Tree") as? NSDictionary {
//            if let arrayOfParents = treeDictionary.object(forKey: "Parents") as? NSArray {
//                arrayParents = arrayOfParents
//            }
//        }
//        
//        if let arrayOfParents = arrayParents {
//            kjtreeInstance = KJTree(parents: arrayOfParents, childrenKey: "Children", idKey: "Id")
//        }
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 44
//    }
//    
//    func search(){
//        self.navigationItem.titleView = self.searchBar;
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(configureNavigationBar))
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
//        self.searchActive = true
//    }
//    
//    func configureNavigationBar(){
//        searchActive = false
//        self.navigationItem.titleView = nil
//        self.navigationItem.title = "C A T E G O R Y"
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
//        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
//        searchBarButton.tintColor = UIColor.black
//        
//        
//        self.navigationItem.rightBarButtonItems = [ searchBarButton]
//    }
//
//}
//
//extension DrawerController: UISearchBarDelegate {
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        
//    }
//}
//
//extension DrawerController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let total = kjtreeInstance.tableView(tableView, numberOfRowsInSection: section)
//        return total
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let node = kjtreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
//        let indexTuples = node.index.components(separatedBy: ".")
//        
//        if indexTuples.count == 1  || indexTuples.count == 4 {
//            
//            // Parents
//            let cellIdentifierParents = "ParentsTableViewCellIdentity"
//            var cellParents: ParentsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? ParentsTableViewCell
//            if cellParents == nil {
//                tableView.register(UINib(nibName: "ParentsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierParents)
//                cellParents = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? ParentsTableViewCell
//            }
//            cellParents?.cellFillUp(indexParam: node.index, tupleCount: indexTuples.count)
//            cellParents?.selectionStyle = .none
//            
//            if node.state == .open {
//                cellParents?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
//            }else if node.state == .close {
//                cellParents?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
//            }else{
//                cellParents?.buttonState.setImage(nil, for: .normal)
//            }
//            
//            return cellParents!
//            
//        }else if indexTuples.count == 2{
//            
//            // Parents
//            let cellIdentifierChilds = "Childs2ndStageTableViewCellIdentity"
//            var cellChild: Childs2ndStageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs2ndStageTableViewCell
//            if cellChild == nil {
//                tableView.register(UINib(nibName: "Childs2ndStageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
//                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs2ndStageTableViewCell
//            }
//            cellChild?.cellFillUp(indexParam: node.index)
//            cellChild?.selectionStyle = .none
//            
//            if node.state == .open {
//                cellChild?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
//            }else if node.state == .close {
//                cellChild?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
//            }else{
//                cellChild?.buttonState.setImage(nil, for: .normal)
//            }
//            
//            return cellChild!
//            
//        }else if indexTuples.count == 3{
//            
//            // Parents
//            let cellIdentifierChilds = "Childs3rdStageTableViewCellIdentity"
//            var cellChild: Childs3rdStageTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs3rdStageTableViewCell
//            if cellChild == nil {
//                tableView.register(UINib(nibName: "Childs3rdStageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
//                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? Childs3rdStageTableViewCell
//            }
//            cellChild?.cellFillUp(indexParam: node.index)
//            cellChild?.selectionStyle = .none
//            
//            if node.state == .open {
//                cellChild?.buttonState.setImage(UIImage(named: "minus"), for: .normal)
//            }else if node.state == .close {
//                cellChild?.buttonState.setImage(UIImage(named: "plus"), for: .normal)
//            }else{
//                cellChild?.buttonState.setImage(nil, for: .normal)
//            }
//            
//            return cellChild!
//            
//        }else{
//            // Childs
//            // grab cell
//            var tableviewcell = tableView.dequeueReusableCell(withIdentifier: "cellidentity")
//            if tableviewcell == nil {
//                tableviewcell = UITableViewCell(style: .default, reuseIdentifier: "cellidentity")
//            }
//            tableviewcell?.textLabel?.text = node.index
//            tableviewcell?.backgroundColor = UIColor.white
//            tableviewcell?.selectionStyle = .none
//            return tableviewcell!
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let node = kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
//        print(node.index)
//        print(node.keyIdentity)
//        // if you've added any identifier or used indexing format
//        print(node.givenIndex)
//    }
//}
//
