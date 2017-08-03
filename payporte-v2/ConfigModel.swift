//
//  ConfigModel.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/3/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import Foundation

public class ConfigModel{
    
    private var api: OAKLIBApi?
    var mStoreId: String?
    var mDeviceId: String?
    
    private let handler = OKEventLoop()
    private let service = OKThreadLauncher()
    private let system = OKSystem()
    
    init() {
        api = OAKLIBApi.getInstance(system, handler: handler, service: service)
        OAKLIBSandwich.getInstance()?.getRecipe(api?.getChef())
    }
}
