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


public class Payporte: OAKLIBServiceBinder {
    
    private var api: OAKLIBApi?
    
    var type: String?
    
    var storeId: String?
    
    init() {
        api = OAKLIBApi.getInstance(system, handler: handler, service: service)
        OAKLIBSandwich.getInstance()?.getRecipe(api?.getChef())
        
    }
    
    private let handler = OKEventLoop()
    private let service = OKThreadLauncher()
    private let system = OKSystem()
    
    static let sharedInstance = Payporte()
    
    public func configChef(module: OAKLIBMenu, package: OAKLIBPackage, loadType: OAKLIBLoadType,
                           params: [String: String],completed: @escaping(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?) -> ()){
        api?.getChef()?.grab(module)?.serve(package, params: params,
                                            binder: RequestHandler(payporte: self, binder: self, loadType: loadType, completed: completed))
    }
    
    
    func handleFetch(completion: @escaping (_ error: String?) -> ()){
        
        configChef(module: .CONFIGMODULE, package: .STORELIST, loadType: .STATIC, params: ["u": "s"]) { (error, message, cache, cursor) in
            
            if error != nil{
                completion("We have a problem!")
                return
            }
            
            if cursor == nil && !(cursor?.moveToLast())! {
                print("No Store Configuration Found!")
                completion("No Store Configuration Found!")
                return
            }
            
            self.setupStore(cursor: cursor, completion: completion)
            
        }
    }
    
    func setupStore(cursor: OAKLIBSimpleCursor?, completion: @escaping (_ error: String?) -> ()){
        
        cursor?.moveToLast()
        guard let storeId = cursor?.getString("store_id") else {return}
        self.storeId = storeId
        handleFetchStore(storeId: storeId, completion: completion)
    }
    
    func handleFetchStore(storeId: String, completion: @escaping (_ error: String?) -> ()){
        
        type = "staticTypes"
        
        let params = ["data": "{\"store_id\": \"\(storeId)\"}"]
        configChef(module: .CONFIGMODULE, package: .STOREVIEW, loadType: .STATIC, params: params) { (error, message, cache, cursor) in
            
            if error != nil{
                completion("We have a problem!")
                return
            }
            
            if cursor == nil{
                print("No Store Configuration Found!")
                completion("No Store Configuration Found!")
                return
            }
            
            cursor?.moveToLast()
            
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = self.convertToDictionary(text: a) else {return}
            _ = dictionary["store_config"] as? [String: Any] ?? [:]
            _ = dictionary["device"] as? String ?? ""
            
            guard let cache = cache else {
                completion("We have a problem!")
                return
            }
            
            if cache {
                guard let id = self.storeId else {return}
                self.startApplication(storeId: id, completion: completion)
            }else{
                self.handleSaveStoreView(completion: completion)
            }
            
        }
    }
    
    func handleSaveStoreView(completion: @escaping (_ error: String?) -> ()){
        
        type = "staticTypes"
        guard let id = self.storeId else {return}
        let params = ["data": "{\"store_id\": \"\(id)\"}"]
        
        configChef(module: .CONFIGMODULE, package: .SAVESTORE, loadType: .STATIC, params: params) { (error, message, cache, cursor) in
            
            if error != nil{
                completion("We have a problem!")
                return
            }
            
            guard let message = message else {
                completion("We have a problem!")
                return
            }
            if "SUCCESS" != message && "CACHED" != message{
                completion(message)
                return
            }
            guard let storeId = self.storeId else {return}
            self.startApplication(storeId: storeId, completion: completion)
        }
    }
    
    func startApplication(storeId: String, completion: @escaping (_ error: String?) -> ()){
        
        let param = ["store_id": storeId]
        
        configChef(module: .CONFIGMODULE, package: .STARTAPPLICATION, loadType: .STATIC, params: param) { (error, message, cache, cursor) in
            
            if error != nil{
                completion("0")
                return
            }
            completion(nil)
            
        }
    }
    
    func fetchBanners(completion: @escaping ([Banner], _ error: String?, _ message: String?, _ cursorCount: Int) -> ()){
        
        configChef(module: .CONFIGMODULE, package: .BANNERS, loadType: .LAZY, params: ["ok": "u"]) { (error, message, cache, cursor) in
            
            self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
            
        }
    }
    
    func fetchCategories(completion: @escaping ([Category], _ error: String?, _ message: String?, _ cursorCount: Int) -> ()){
        
        
        configChef(module: .CATALOGMODULE, package: .CATEGORYLIST, loadType: .LAZY, params: ["ok": "u"]) { (error, message, cache, cursor) in
            
            self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
            
        }
    
    }
    
    func fetchSubCategories(category_id: String, completion: @escaping ([Category], _ error: String?, _ message: String?, _ cursorCount: Int) -> ()){
        
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
            
            configChef(module: .CATALOGMODULE, package: .CATEGORYLIST, loadType: .LAZY, params: data) { (error, message, cache, cursor) in
                
                self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
                
            }
    
        }
    }
    
    func fetchSortProductListing(key: String, offset: Int, category_id: String, completion: @escaping ([ProductList], _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
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
            

            
            configChef(module: .CATALOGMODULE, package: .PRODUCTLIST, loadType: .LAZY, params: data, completed: { (error, message, cache, cursor) in
                
                self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
            })
        }
    }
    
    func fetchFilterProductListing(key: String, value: String, offset: Int, category_id: String, completion: @escaping ([ProductList], _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
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
            
            
            configChef(module: .CATALOGMODULE, package: .PRODUCTLIST, loadType: .LAZY, params: data, completed: { (error, message, cache, cursor) in
                
                self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
            })
        }
    }
    
    func fetchSearchProductLists(key: String, value: Int, search: String, offset: Int, completion: @escaping ([ProductList], _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
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
            
            
            configChef(module: .CATALOGMODULE, package: .SEARCHLIST, loadType: .LAZY, params: data, completed: { (error, message, cache, cursor) in
                
                self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
            })
        }
        
    }
    
    func fetchProductDetails(product_id: String, completion: @escaping (Product, _ error: String?, _ message: String?) -> ()){
        
        var param = [String: String]()
        param["product_id"] = product_id
        
        configChef(module: .CATALOGMODULE, package: .PRODUCTDETAIL, loadType: .LAZY, params: param) { (error, message, cache, cursor) in
            
            if error != nil{
                guard let msg = message else {return}
                guard let err = error else {return}
                completion(Product(json: JSON.null), err.message, msg)
                return
            }
            
            if (!(cursor?.moveToFirst())!) {
                return
            }
            
            guard let a = cursor?.toJson() else {return}
            let json = self.createJsonString(string: a)
            let product = Product(json: json)
            DispatchQueue.main.async {
                guard let msg = message else {return}
                completion(product, nil, msg)
            }
            
        }
        
    }
    
    
    func syncCarts( completion: @escaping (Bool, _ message: String) -> ()){
        
        type = "syncType"
        
        configChef(module: .CUSTOMERMODULE, package: .PRODUCTEDITCART, loadType: .STRICT, params: ["u": "s"]) { (error, message, cache, cursor) in
            
            if error != nil{
                completion(false, "\(String(describing: error))")
            }
            
            completion(true, "\(String(describing: message))")
        }
    }
    
    func updateCart(cart_id: String, quantity: String, completion: @escaping (Bool, _ message: String) -> ()){
        
        type = "updateCartType"
        
        var params = [String: String]()
        params["product_qty"] = quantity
        params["cart_item_id"] = cart_id
        
        configChef(module: .CUSTOMERMODULE, package: .PRODUCTUPDATECART, loadType: .STRICT, params: params) { (error, message, cache, cursor) in
            
            if error != nil{
                completion(false, "\(String(describing: error))")
            }
            
            completion(true, "\(String(describing: message))")
        }
    }
    
    public func addProductToCart(product: Product, option: Options?, completion: @escaping (_ error: String?, _ message: String?) -> ()){
        
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
            
            configChef(module: .CHECKOUTMODULE, package: .PRODUCTADDTOCART, loadType: .STRICT, params: param, completed: { (error, message, cache, cursor) in
                print(message)
                self.success(error: error?.message, message: message, completion: completion)
            })
            
        }
    }
    
    
    func success(error: String?, message: String?, completion: @escaping (_ error: String?, _ message: String?) -> ()){
        if error != nil{
            DispatchQueue.main.async {
                guard let msg = message else {return}
                guard let err = error else {return}
                completion(err, msg)
            }
        }
        DispatchQueue.main.async {
            guard let msg = message else {return}
            completion(nil, msg)
        }
    }
    
    func fetchSearch(suggestion: String, completion: @escaping ([ProductList], _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
        
        let param = ["keyword": suggestion]
        
        configChef(module: .CATALOGMODULE, package: .LOCALSEARCHLIST, loadType: .LAZY, params: param) { (error, messge, cache, cursor) in
            
            self.baseQueryTemplate(error, messge, cache, cursor, completion: completion)
        }
    }
    
    
    func fetchCartItems(completion: @escaping ([Cart],  _ totalPrice: CGFloat, _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
        
        type = "cartType"
        configChef(module: .CUSTOMERMODULE, package: .PRODUCTGETCART, loadType: .STATIC, params: ["us": "uk"]) { (error, message, cache, cursor) in
            
            self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
        }
    }
    
    func fetchCartItemsRefresh(completion: @escaping ([Cart],  _ totalPrice: CGFloat, _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
        
        type = "cartTypeRefresh"
        
        configChef(module: .CUSTOMERMODULE, package: .PRODUCTGETCART, loadType: .STRICT, params: ["us": "uk"]) { (error, message, cache, cursor) in
            
            self.baseQueryTemplate(error, message, cache, cursor, completion: completion)
        }
    }

    func fetchCountriesandStates(){
        
        configChef(module: .CONFIGMODULE, package: .ALLOWEDLOCATION, loadType: .STATIC, params: ["u": "us"]) { (error, message, cache, cursor) in
            
            
            guard let cursor = cursor else {return}
            
            if (!(cursor.moveToFirst())) {
                return
            }
            
            let count = cursor.getCount()
            for i in 0 ..< count{
                cursor.move(toPosition: i)
                let x = cursor.toJson()
                
            }
            
        }
    }
    
    private func baseQueryTemplate<T: JSONDecodable>(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?, completion: @escaping ([T], _ totalPrice: CGFloat, _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
        
        
        if error != nil{
            completion([], 0.0 ,"\(String(describing: error))", "\(String(describing: message))", 0, 0)
        }
        
        guard let cursor = cursor else {return}
        
        if (!(cursor.moveToFirst())) {
            return
        }
        
        var models  = [T]()
        var totalPrice: CGFloat = 0.0
        
        guard let message = message else {return}
        
        var msg: String = ""
        if self.type == "cartType" && message != "CACHED" && message != "SUCCESS"{
            msg = message
        }
        let count = cursor.getCount()
        for i in 0 ..< count{
            cursor.move(toPosition: i)
            let a = cursor.toJson()
            guard let dictionary = convertToDictionary(text: a) else {return}
            let strPrice = dictionary["product_price"] as? String ?? "0"
            let strQuantity = dictionary["product_qty"] as? String ?? "0"
            guard let quantity = NumberFormatter().number(from: strQuantity) else { return }
            guard let price = NumberFormatter().number(from: strPrice) else { return }
            totalPrice = totalPrice + (CGFloat(price) * CGFloat(quantity))
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            
            if message != "CACHED"{
                completion(models, totalPrice, nil, "\(message)",  0, 0)
            }
            let cursorCount = Int((cursor.getCount()))
            completion(models, totalPrice, nil, msg,  0, cursorCount)
        }
    }
    
    
    private func baseQueryTemplate<T: JSONDecodable>(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?, completion: @escaping ([T], _ error: String?, _ message: String?, _ itemCount: Int, _ cursorCount: Int) -> ()){
        
        if error != nil{
            completion([], error?.message, "", 0, 0)
        }
        
        if (!(cursor?.moveToFirst())!) {
            return;
        }
        
        var models  = [T]()
        var itemCounts: Int = 0
        var coursorCount: Int = 0

        guard let count = cursor?.getCount() else {return}
        for i in 0 ..< count{
            cursor?.move(toPosition: i)
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        
        
        DispatchQueue.main.async {
            
            if message == "CACHED"{
                itemCounts = Int.max
            }else if message != "SUCCESS" {
                itemCounts = Int(message ?? "0")!
            }
            
            completion(models, nil, message ?? "", itemCounts , Int((cursor?.getCount()) ?? 0) )
        }
    }
    
    
    private func baseQueryTemplate<T: JSONDecodable>(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?, completion: @escaping ([T], _ error: String?) -> ()){
        if (!(cursor?.moveToFirst())!) {
            return;
        }
        
        if error != nil{
            completion([], "\(String(describing: error))")
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
            completion(models, nil)
        }
    }
    
    
    
//    private func baseQueryTemplate<T: JSONDecodable>(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?, itemCountCompletion: @escaping (Int) -> (), cursorCompletion: @escaping (Int) -> (), completion: @escaping ([T], _ error: String) -> ()){
//        if (!(cursor?.moveToFirst())!) {
//            return
//        }
//        
//        
//        var models  = [T]()
//        
//        guard let count = cursor?.getCount() else {return}
//        for i in 0 ..< count{
//            cursor?.move(toPosition: i)
//            guard let a = cursor?.toJson() else {return}
//            guard let dictionary = convertToDictionary(text: a) else {return}
//            models.append(T(dictionary)!)
//        }
//        
//        DispatchQueue.main.async {
//            print(self.error ?? "")
//            completion(models, self.error ?? "")
//            itemCountCompletion(self.itemCounts ?? 0)
//            cursorCompletion(self.coursorCount ?? 0)
//        }
//    }
    
    private func baseQueryTemplate<T: JSONDecodable>(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?, completion: @escaping ([T], _ error: String?, _ mesage: String?, _ cursorCount: Int) -> ()){
       
        
        if error != nil{
            guard let msg = message else {return}
            guard let err = error else {return}
            completion([], err.message, msg, 0)
        }
        
        var models  = [T]()
        guard let cursor = cursor else {return}
        if (!(cursor.moveToFirst())) {
            return
        }
        
        let cursorCount: Int
        
        let count = cursor.getCount()
        for i in 0 ..< count{
            cursor.move(toPosition: i)
            let a = cursor.toJson()
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                completion(models, nil, "\(String(describing: message))", 0)
            }
        }
    }
    
    
    public func loadType() -> OAKLIBLoadType {
        
        return .LAZY
    }
    
    public func onError(_ message: String) {
        
    }
    
    public func onLoad(_ message: String, cache: Bool, cursor: OAKLIBSimpleCursor?) {
        
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
    
    public class PayporteError: Error {
        let message: String
        init(message: String) {
            self.message = message
        }
    }
    
    private class RequestHandler: OAKLIBServiceBinder {
        
        var payporte: Payporte
        var binder: OAKLIBServiceBinder
        var completed: (_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?) -> ()
        var cursor: OAKLIBSimpleCursor?
        var message: String?
        var cache: Bool?
        var loadype: OAKLIBLoadType?
        
        init(payporte: Payporte, binder: OAKLIBServiceBinder, loadType: OAKLIBLoadType, completed: @escaping(_ error: PayporteError?, _ message: String?, _ cache: Bool?, _ cursor: OAKLIBSimpleCursor?) -> ()) {
            self.binder = binder;
            self.payporte = payporte
            self.completed = completed
            self.loadype = loadType
        }
        
        public func loadType() -> OAKLIBLoadType {
            return loadype!
        }
        
        public func onError(_ message: String) {
            binder.onError(message)
            completed(PayporteError(message: message), nil, nil, nil)
        }
        
        public func onLoad(_ message: String, cache: Bool, cursor: OAKLIBSimpleCursor?) {
            binder.onLoad(message, cache: cache, cursor: cursor)
            
            completed(nil, message, cache, cursor)
        }
        
    }
   
}
