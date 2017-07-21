//
//  Banner.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/21/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit


public class Banner: NSObject, JSONDecodable {
    
    var _ID: String?
    var categoryID: String?
    var categoryName: String?
    var has_child: String?
    var image_path: String?
    var productID: String?
    var type: String?
    var url: String?
    
    required public init(_ json: [String: Any]) {
        self._ID = json["_ID"] as? String ?? ""
        self.categoryID = json["categoryID"] as? String ?? ""
        self.categoryName = json["categoryName"] as? String ?? ""
        self.has_child = json["has_child"] as? String ?? ""
        self.image_path = json["image_path"] as? String ?? ""
        self.productID = json["productID"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.url = json["url"] as? String ?? ""
    }
}
