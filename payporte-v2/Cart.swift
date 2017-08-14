//
//  Cart.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/11/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit


public class Cart: NSObject, JSONDecodable  {
    
    var _ID: String?
    var cart_item_id: String?
    var product_id: String?
    var product_image: String?
    var product_max_qty: String?
    var product_name: String?
    var product_price: String?
    var product_qty: String?
    
    required public init?(_ json: [String : Any]) {
        self._ID = json["_ID"] as? String? ?? ""
        self.cart_item_id = json["cart_item_id"] as? String ?? ""
        self.product_id = json["product_id"] as? String ?? ""
        self.product_image = json["product_image"] as? String ?? ""
        self.product_price = json["product_price"] as? String ?? ""
        self.product_qty = json["product_qty"] as? String ?? ""
        self.product_name = json["product_name"] as? String ?? ""
    }
}
