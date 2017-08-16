//
//  Utilities.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/4/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class Utilities{
    
    public static func getColorWithHexString(_ hex: String) -> UIColor{
        
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
    }
    
    public static func getBaseNotification(text: String, type: CRNotificationType){
        if type == .error{
            CRNotifications.showNotification(type: type, title: "Error", message: text, dismissDelay: 3)
        }else if type == .success{
            CRNotifications.showNotification(type: type, title: "Success", message: text, dismissDelay: 3)
        }else{
            CRNotifications.showNotification(type: type, title: "Notice!", message: text, dismissDelay: 3)
        }
    }
    
    public static func configSort() -> [Sort] {
        let sortstring = "[\n" +
            "   {\n" +
            "      \"attribute\":\"price_sort\",\n" +
            "      \"title\":\"Price Sort\",\n" +
            "      \"filter\":[\n" +
            "         {\n" +
            "            \"value\":\"1\",\n" +
            "            \"label\":\"Low - High\"\n" +
            "         },\n" +
            "         {\n" +
            "            \"value\":\"2\",\n" +
            "            \"label\":\"High - Low\"\n" +
            "         }\n" +
            "      ]\n" +
            "   },\n" +
            "   {\n" +
            "      \"attribute\":\"alphabetical\",\n" +
            "      \"title\":\"Alphabetical Sort\",\n" +
            "      \"filter\":[\n" +
            "         {\n" +
            "            \"value\":\"3\",\n" +
            "            \"label\":\"Ascending\"\n" +
            "         },\n" +
            "         {\n" +
            "            \"value\":\"4\",\n" +
            "            \"label\":\"Descending\"\n" +
            "         }\n" +
            "      ]\n" +
            "   }\n" +
        "]"
        
        let json = Payporte.sharedInstance.createJsonString(string: sortstring)
        if let jsonArray = json.array{
            return jsonArray.map{return Sort(json: $0)}
        }
        return []
    }
    
    
}

