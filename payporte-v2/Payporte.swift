//
//  Payporte.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/21/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol JSONDecodable {
    init?(_ json: [String: Any])
}

enum ResultType{
    case Success
    case Error
}

public class Payporte: OAKLIBServiceBinder {
    
    private var api: OAKLIBApi?
    private var cursor: OAKLIBSimpleCursor?
    
    var type: String?
    
    var coursorCount: Int?
    var itemCounts: Int?
    var error: String?
    var message: String?
    
    init() {
        api = OAKLIBApi.getInstance(system, handler: handler, service: service)
        OAKLIBSandwich.getInstance()?.getRecipe(api?.getChef())
        
    }
    
    private let handler = OKEventLoop()
    private let service = OKThreadLauncher()
    private let system = OKSystem()
    
    static let sharedInstance = Payporte()
    
    public func configChef(module: OAKLIBMenu, package: OAKLIBPackage,
                           params: [String: String], completed: @escaping(_ success: Bool) -> ()){
        api?.getChef()?.grab(module)?.serve(package, params: params,
                                            binder: RequestHandler(payporte: self, binder: self, completed: completed))
    }
    
    func fetchBanners(completion: @escaping ([Banner], _ error: String) -> ()){
        configChef(module: OAKLIBMenu.CONFIGMODULE, package: OAKLIBPackage.BANNERS, params: ["ou": "ik"], completed: {_ in
            
            self.baseQueryTemplate(completion: completion)
        })
    }
    
    func fetchCategories(completion: @escaping ([Category], _ error: String) -> ()){
        configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.CATEGORYLIST, params: ["ou": "ik"], completed: {_ in
            
            self.baseQueryTemplate(completion: completion)
        })
    }
    
    func fetchSubCategories(category_id: String, completion: @escaping ([Category], _ error: String) -> ()){
        
        var params = [String: String]()
        var data = [String: String]()
        params["category_id"] = category_id
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            
            data["data"] = theJSONText
            data["category_id"] = category_id
            
            configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.CATEGORYLIST, params: data, completed: {_ in
                
                self.baseQueryTemplate(completion: completion)
            })
        }
    }
    
    func fetchSortProductListing(key: String, offset: Int, category_id: String, completion: @escaping ([ProductList], _ error: String) -> (), itemCountCompletion: @escaping (Int) -> (), cursorCompletion: @escaping (Int) -> ()){
        type = "productList"
        var param = [String: String]()
        var data = [String: String]()
        param["limit"] = "8"
        param["width"] = "300"
        param["height"] = "300"
        param["sort_option"] = key
        param["offset"] = "\(offset)"
        param["category_id"] = category_id
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: param,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            
            data["data"] = theJSONText
            data["sort_option"] = key
            data["category_id"] = category_id
            
            configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.PRODUCTLIST, params: data, completed: {_ in
                
                self.baseQueryTemplate(itemCountCompletion: itemCountCompletion, cursorCompletion: cursorCompletion, completion: completion)
            })
        }
    }
    
    func fetchFilterProductListing(key: String, value: String, offset: Int, category_id: String, completion: @escaping ([ProductList], _ error: String) -> (), itemCountCompletion: @escaping (Int) -> (), cursorCompletion: @escaping (Int) -> ()){
        type = "productList"
        var param = [String: String]()
        var data = [String: String]()
        param["limit"] = "8"
        param["width"] = "300"
        param["height"] = "300"
        param["sort_option"] = key
        param["offset"] = "\(offset)"
        param["filter"] = "{\"\(key)\": \"\(value)\"}"
        param["category_id"] = category_id
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: param,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            
            data["data"] = theJSONText
            data["sort_option"] = key
            data["category_id"] = category_id
            
            configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.PRODUCTLIST, params: data, completed: {_ in
                
                self.baseQueryTemplate(itemCountCompletion: itemCountCompletion, cursorCompletion: cursorCompletion, completion: completion)
            })
        }
    }
    
    
    func fetchProductDetails(product_id: String, completion: @escaping (Product, _ error: String) -> ()){
        
        var param = [String: String]()
        param["product_id"] = product_id
        
        configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.PRODUCTDETAIL, params: param, completed: {_ in
            
            if (!(self.cursor?.moveToFirst())!) {
                return;
            }
            
            guard let a = self.cursor?.toJson() else {return}
            let json = self.createJsonString(string: a)
            let product = Product(json: json)
            DispatchQueue.main.async {
                print(self.error ?? "")
                completion(product, self.error ?? "")
            }
        })
    }
    
    public func addProductToCart(product: Product, option: Options?, completion: @escaping (_ message: String, _ error: String) -> ()){
        
        type = "addProduct"
        
        let product_id = product.productId!
        guard let product_qty = someData["Quantity"] else {return}
        
        var param = [String: String]()
        var data = [String: Any]()
        var prod = [String: Any]()
        var priceDic = [String: Any]()
        
        if let option = option{
            
            guard let option_selected = someData[option.optionTitle!] else {return}
            prod["option_id"] = option.optionId
            prod["option_value"] = option.optionValue
            prod["option_price"] = option.optionPrice
            prod["option_title"] = option.optionTitle
            prod["position"] = option.position
            prod["option_type_id"] = option.optionTypeId
            prod["option_type"] = option.optionType
            prod["is_required"] = option.isRequired
            prod["dependence_option_ids"] = option.dependenceOptionIds
            priceDic[option_selected] = prod
            data = ["options": priceDic, "product_id": product_id , "product_qty": product_qty ]
        }else{
            data = ["options": "[]", "product_id": product_id , "product_qty": product_qty ]
        }

        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: data,
            options: .prettyPrinted) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            param["data"] = theJSONText
            
            configChef(module: .CHECKOUTMODULE, package: .PRODUCTADDTOCART, params: param, completed: {_ in
                self.success(completion: completion)
            })
        }
    }
    
    
    func success(completion: @escaping (_ message: String, _ error: String) -> ()){
        if self.error != nil{
            DispatchQueue.main.async {
                completion(self.message ?? "", self.error ?? "")
            }
        }
        DispatchQueue.main.async {
            completion(self.message ?? "", self.error ?? "")
        }
    }
    
    func fetchSearch(suggestion: String, completion: @escaping ([ProductList], _ error: String) -> ()){
        
        let param = ["keyword": suggestion]
        
        configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.LOCALSEARCHLIST, params: param, completed: {_ in
            
            self.baseQueryTemplate(completion: completion)
            
        })
    }
    
    func fetchSearchProductLists(key: String, value: Int, search: String, offset: Int, completion: @escaping ([ProductList], _ error: String) -> (), itemCountCompletion: @escaping (Int) -> (), cursorCompletion: @escaping (Int) -> ()){
        type = "productList"
        var param = [String: String]()
        var data = [String: String]()
        param["limit"] = "8"
        param["width"] = "300"
        param["height"] = "300"
        param["key_word"] = search
        param["sort_option"] = key
        param["offset"] = "\(offset)"
        param["filter"] = "{\"\(key)\": \"\(value)\"}"
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: param,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            
            data["data"] = theJSONText
            data["key_word"] = key
            data["sort_option "] = search
            data["filter"] = "{\"\(key)\": \"\(value)\"}"
            
            configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.SEARCHLIST, params: data, completed: {_ in
                
                self.baseQueryTemplate(itemCountCompletion: itemCountCompletion, cursorCompletion: cursorCompletion, completion: completion)
                
            })
        }

    }
    func fetchCartItems(completion: @escaping ([Cart], _ message: String, _ error: String, _ itemCount: Int, _ cursorCount: Int) -> ()){
        type = "cartType"
        configChef(module: .CUSTOMERMODULE, package: .PRODUCTGETCART, params: ["uk":"us"], completed: {_ in
            
                self.baseQueryTemplate(completion: completion)
            
            })
    }

    
    private func baseQueryTemplate<T: JSONDecodable>(completion: @escaping ([T], _ message: String, _ error: String, _ itemCount: Int, _ cursorCount: Int) -> ()){
        if (!(cursor?.moveToFirst())!) {
            return;
        }
        
        var models  = [T]()
        
        guard let count = cursor?.getCount() else {return}
        for i in 0 ..< count{
            cursor?.move(toPosition: i)
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            completion(models, self.message ?? "", self.error ?? "", self.itemCounts ?? 0, self.coursorCount ?? 0)
        }
    }
    
    private func baseQueryTemplate<T: JSONDecodable>(completion: @escaping ([T], _ error: String) -> ()){
        if (!(cursor?.moveToFirst())!) {
            return;
        }
        
        var models  = [T]()
        
        guard let count = cursor?.getCount() else {return}
        for i in 0 ..< count{
            cursor?.move(toPosition: i)
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            completion(models, self.error ?? "")
        }
    }
    
    private func baseQueryTemplate<T: JSONDecodable>(itemCountCompletion: @escaping (Int) -> (), cursorCompletion: @escaping (Int) -> (), completion: @escaping ([T], _ error: String) -> ()){
        if (!(cursor?.moveToFirst())!) {
            return
        }
        
        
        var models  = [T]()
        
        guard let count = cursor?.getCount() else {return}
        for i in 0 ..< count{
            cursor?.move(toPosition: i)
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            print(self.error ?? "")
            completion(models, self.error ?? "")
            itemCountCompletion(self.itemCounts ?? 0)
            cursorCompletion(self.coursorCount ?? 0)
        }
    }
    
    private func baseQueryTemplate<T: JSONDecodable>(cursorCompletion: @escaping (Int) -> (), completion: @escaping ([T], _ error: String) -> ()){
       
        var models  = [T]()
        print(self.error)
        if self.error != nil{
            completion(models, self.error ?? "")
            return
        }
        if (!(cursor?.moveToFirst())!) {
            return
        }
        
        guard let count = cursor?.getCount() else {return}
        for i in 0 ..< count{
            cursor?.move(toPosition: i)
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            completion(models,self.error ?? "")
            cursorCompletion(self.coursorCount ?? 0)
        }
    }
    
    
    public func loadType() -> OAKLIBLoadType {
        
        if type == "addProduct"{
            return .STRICT
        }
        return .LAZY
    }
    
    public func onError(_ message: String) {
        self.error = message
        print(self.error)
        //Utilities.getBaseNotification(text: message, type: .error)
    }
    
    public func onLoad(_ message: String, cache: Bool, cursor: OAKLIBSimpleCursor?) {
        print(message)
        self.cursor = cursor
        print(cursor?.getCount() ?? 0)
        if (!(cursor?.moveToFirst())!) {
            return
        }
        let x = cursor?.toJson()
        print(x)
        if type == "addProduct"{
            if message != "SUCCESS"{
                self.message = message
            }else{
                self.message = ""
            }
        }
        
        if type == "cartType" && message != "CACHED" && message != "SUCCESS"{
            self.message = message
        }
        
        if message == "CACHED" && (type == "productList") {
            self.itemCounts = Int.max
        }else if message != "SUCCESS" && (type == "productList") {
            self.itemCounts = Int(message)!
        }
        
        self.coursorCount = Int((cursor?.getCount())!)
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func convertDicToString(dictionary: [String: Any]) -> String{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: []) {
            if let theJSONText = String(data: theJSONData,
                                        encoding: .ascii){
            print("JSON string = \(theJSONText)")
                return theJSONText
            }
            return ""
        }
        return ""
    }
    
    private func convertStringToJson(dic: String) -> String {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String: String] {
                // use dictFromJSON
                return dictFromJSON.debugDescription
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return ""
    }
    
    func createJsonString(string: String) -> JSON{
        if let dataFromString = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return json
        }
        
        return nil
    }
    
    private class RequestHandler: OAKLIBServiceBinder {
        
        var payporte: Payporte;
        var binder: OAKLIBServiceBinder;
        var completed: (_ success: Bool) -> ()
        
        init(payporte: Payporte, binder: OAKLIBServiceBinder, completed: @escaping(_ success: Bool) -> ()) {
            self.binder = binder;
            self.payporte = payporte
            self.completed = completed
        }
        
        public func loadType() -> OAKLIBLoadType {
            return binder.loadType();
        }
        
        public func onError(_ message: String) {
            binder.onError(message);
        }
        
        public func onLoad(_ message: String, cache: Bool, cursor: OAKLIBSimpleCursor?) {
            binder.onLoad(message, cache: cache, cursor: cursor)
            
            completed(true)
        }
        
    }
   
}
