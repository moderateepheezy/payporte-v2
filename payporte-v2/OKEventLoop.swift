//
//  OKEventLoop.swift
//  
//
//  Created by SimpuMind on 7/19/17.
//

import UIKit
class OKEventLoop: OAKLIBHandler{
    
    func post(_ runnable: OAKLIBRunnable?) {
        DispatchQueue.main.async{
            runnable?.run()
        }
    }
    
}
