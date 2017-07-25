//
//  ProductList.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/25/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ProductList: NSObject, JSONDecodable {

    public var _ID: String?
    public var category_id: String?
    public var product_id: String?
    public var product_image: String?
    public var product_name: String?
    public var product_price: String?
    public var product_regular_price: String?
    
    public var stock_status: Bool? = false
    
    public var seller: Seller?
    public var layerednavigation: Layerednavigation?
    
    required public init(_ json: [String: Any]) {
        self.product_regular_price = json["product_regular_price"] as? String ?? ""
        self.product_price = json["product_price"] as? String ?? ""
        self.stock_status = json["stock_status"] as? Bool ?? false
        self.product_name = json["product_name"] as? String ?? ""
        self.category_id = json["category_id"] as? String ?? ""
        self.product_id = json["product_id"] as? String? ?? ""
        self.product_image = json["product_image"] as? String ?? ""
        self._ID = json["_ID"] as? String ?? ""
        
        let sellerJson = json["seller"] as? [String: Any] ?? [:]
        self.seller = Seller(sellerJson)
        
        let string = json["layerednavigation"] as? String
        if string != nil {
            let json = Payporte.sharedInstance.createJsonString(string: string!)
            self.layerednavigation = Layerednavigation(json: json)
        }
    }
}

public class Seller: NSObject, JSONDecodable {
    
    public var id: Int?
    public var name: String?
    
    required public init?(_ json: [String : Any]) {
        self.id = json["id"] as? Int ?? 0
        self.name = json["name"] as? String ?? ""
    }
    
}

public class ShowPriceV2: NSObject, JSONDecodable {
    
    public var product_regular_price: Int?
    
    required public init?(_ json: [String : Any]) {
        self.product_regular_price = json["product_regular_price"] as? Int ?? 0
    }
    
}
