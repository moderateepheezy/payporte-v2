//
//  OKThreadLauncher.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/19/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

public class OKThreadLauncher: OAKLIBService {
    
    public func poolHandler() -> OAKLIBHandler? {
        return PoolHandler()
    }
    
    public func onCreate() {
        
    }
    
    public func onStart(_ name: String, runnable: OAKLIBRunnable?) {
        let thread = Thread(target: runnable as Any, selector: #selector(runnable?.run), object: nil)
        if name != "" {
            thread.name = name
        }
        thread.start()
    }
    
}

public class PoolHandler: OAKLIBHandler{
    
    public func post(_ runnable: OAKLIBRunnable?) {
        
        DispatchQueue.global(qos: .background).async {
            runnable?.run()
        }
    }
    
}

