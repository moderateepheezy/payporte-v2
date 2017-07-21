//
//  OKSystem.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/20/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

public class OKSystem: OAKLIBSystem {
    
    public func getPath() -> String {
        
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let file = documentsFolder.appending("/payporte")
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: file) {
            try? fileManager.createDirectory(atPath: file, withIntermediateDirectories: false, attributes: nil)
        }
        
        return file
    }
    
    public func query(_ database: String, query: String) -> OAKLIBSimpleCursor? {
        

        
        return nil
    }
    
    
}
