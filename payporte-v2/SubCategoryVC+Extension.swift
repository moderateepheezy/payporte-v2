//
//  SubCategoryVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/24/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

extension SubCategoryVC{
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            

            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
