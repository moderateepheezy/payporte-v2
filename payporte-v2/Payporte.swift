//
//  Payporte.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/21/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

protocol JSONDecodable {
    init?(_ json: [String: Any])
}

public class Payporte: OAKLIBServiceBinder {
    
    private var api: OAKLIBApi?
    private var cursor: OAKLIBSimpleCursor?
    
    init() {
        api = OAKLIBApi.getInstance(system, handler: handler, service: service)
    }
    
    private let handler = OKEventLoop()
    private let service = OKThreadLauncher()
    private let system = OKSystem()
    
    static let sharedInstance = Payporte()
    
    public func configChef(module: OAKLIBMenu, package: OAKLIBPackage,
                            params: [String: String], completed: @escaping(_ success: Bool) -> ()){

        api = OAKLIBApi.getInstance(system, handler: handler, service: service)
        OAKLIBSandwich.getInstance()?.getRecipe(api?.getChef())
        api?.getChef()?.grab(module)?.serve(package, params: params,
                                            binder: RequestHandler(payporte: self, binder: self, completed: completed))
    }
    
    func fetchBanners(completion: @escaping ([Banner]) -> ()){
        configChef(module: OAKLIBMenu.CONFIGMODULE, package: OAKLIBPackage.BANNERS, params: ["ou": "ik"], completed: {_ in
            
            self.baseQueryTemplate(completion: completion)
        })
    }
    
    func fetchCategories(completion: @escaping ([Category]) -> ()){
        configChef(module: OAKLIBMenu.CATALOGMODULE, package: OAKLIBPackage.CATEGORYLIST, params: ["ou": "ik"], completed: {_ in
            
            self.baseQueryTemplate(completion: completion)
        })
    }
    
    func baseQueryTemplate<T: JSONDecodable>(completion: @escaping ([T]) -> ()){
        
        cursor?.moveToFirst();
        
        var models  = [T]()
        
        guard let count = cursor?.getCount() else {return}
        for i in 0 ..< count{
            cursor?.move(toPosition: i)
            guard let a = cursor?.toJson() else {return}
            guard let dictionary = convertToDictionary(text: a) else {return}
            models.append(T(dictionary)!)
        }
        
        DispatchQueue.main.async {
            print("Something")
            completion(models)
        }
    }
    
    public func loadType() -> OAKLIBLoadType {
        return OAKLIBLoadType.STRICT
    }
    
    public func onError(_ message: String) {
        print(message)
    }
    
    public func onLoad(_ message: String, cache: Bool, cursor: OAKLIBSimpleCursor?) {
        self.cursor = cursor
        cursor?.moveToFirst()
        let x = cursor?.toJson()
        
        print(message)
        print(cache)
        print(cursor.debugDescription)
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
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
