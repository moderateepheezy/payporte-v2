//
//  MainVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchBarButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItems = [ searchBarButton]
    }
    
    func search(){
        let vc = SearchVC()
        vc.searchField.becomeFirstResponder()
        navigationController?.pushViewController(vc, animated: true)
    }

}
