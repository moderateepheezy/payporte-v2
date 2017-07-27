//
//  ProductListDataSource.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/26/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ProductListDataSource: NSObject {
    
    var productLists = [ProductList]()
    
    var page = 0
    var limit = 8
    var coursorCount: Int!
    var itemCounts: Int!
    
    var collectionView: UICollectionView!
    var category_id: String?
    var navigationController: UINavigationController!
    var navigationItem: UINavigationItem!
    
    
    init(category_id: String, productLists: [ProductList],
         collectionView: UICollectionView,
         navigationController: UINavigationController, navigationItem: UINavigationItem, coursorCount: Int, itemCounts: Int) {
        super.init()
        self.category_id = category_id
        self.productLists = productLists
        self.collectionView = collectionView
        self.coursorCount = coursorCount
        self.itemCounts = itemCounts
        self.navigationController = navigationController
        
        
    }
    
    

    
}

