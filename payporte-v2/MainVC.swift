//
//  MainVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/9/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import AZEmptyState

class MainVC: UIViewController {

    var emptyStateView: AZEmptyStateView!
    
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

    func setupEmptyState(){
        emptyStateView = AZEmptyStateView()
        
        //customize
        emptyStateView.image = #imageLiteral(resourceName: "error_cloud")
        emptyStateView.message = "Something went wrong..."
        emptyStateView.buttonText = "Try Again"
        emptyStateView.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        
        //add subview
        view.addSubview(emptyStateView)
        
        //add autolayout
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyStateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        emptyStateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
    }
    
    func tryAgain(){
        
    }
}
