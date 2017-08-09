//
//  Category.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/21/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

public class Category: NSObject, JSONDecodable  {
    
    var _ID: String?
    var category_name: String?
    var category_id: String?
    var has_child: String?
    var category_image: String?
    
    required public init?(_ json: [String : Any]) {
        self._ID = json["_ID"] as? String ?? ""
        self.category_name = json["category_name"] as? String ?? ""
        self.category_id = json["category_id"] as? String ?? ""
        self.has_child = json["has_child"] as? String ?? ""
        self.category_image = json["category_image"] as? String ?? ""
    }
    
    init(_ID:String, category_name: String, category_id: String) {
        self._ID = _ID
        self.category_name = category_name
        self.category_id = category_id
    }
}
