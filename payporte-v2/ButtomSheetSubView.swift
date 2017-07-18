//
//  ButtomSheetSubView.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/17/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

public class ButtomSheetSubView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
    fileprivate func setupViews(){
        
    }
}
