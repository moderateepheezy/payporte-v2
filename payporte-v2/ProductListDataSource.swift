//
//  ProductListDataSource.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/26/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class ProductListDataSource: NSObject, UICollectionViewDataSource {
    
    var productLists = [ProductList]()
    
    var page = 0
    var limit = 8
    var coursorCount: Int!
    var itemCounts: Int!
    
    var collectionView: UICollectionView!
    var category_id: String?
    
    
    init(category_id: String, productLists: [ProductList], collectionView: UICollectionView, coursorCount: Int, itemCounts: Int) {
        super.init()
        self.category_id = category_id
        self.productLists = productLists
        self.collectionView = collectionView
        self.coursorCount = coursorCount
        self.itemCounts = itemCounts
        
        self.collectionView.addInfiniteScroll(handler: { (collectionView) in
            self.collectionView.performBatchUpdates({ 
                self.fetchData()
            }, completion: { (completed) in
                self.collectionView.finishInfiniteScroll()
            })
        })
        
        self.collectionView.setShouldShowInfiniteScrollHandler { (collectionView) -> Bool in
            return self.page < itemCounts
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndetifier, for: indexPath) as! ProductListCell
        
        let product = productLists[indexPath.item]
        cell.product = product
        
        return cell
        
    }
    
    func fetchData(){
        
        let tempIndex = (coursorCount / limit)
        print(coursorCount)
        let index = (tempIndex < 1) ? 1 : tempIndex
        let  offset = (coursorCount != 0) ? index * limit: 0
        if coursorCount >= offset {
            page = offset
            Payporte.sharedInstance.fetchProductListing(offset: page, category_id: category_id!, completion: { (productList) in
                
                self.productLists = productList
                self.collectionView.reloadData()
                
            }, itemCountCompletion: { (count) in
                
            }) { (count) in
                self.coursorCount = count
            }

        }
    }
    
    func sortAlphabeticallyAccending(){
        self.productLists.sort(by: {$0.0.product_name! > $0.1.product_name! })
        self.collectionView.reloadData()
    }
    
}

