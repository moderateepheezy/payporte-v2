//
//  BottomSheetView.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/17/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import RGBottomSheet

public class BottomSheetView: UIView {
    
    var options: [Options]?{
        didSet{
            guard let opts = options else {return}
            for i in opts{
                guard let type = i.optionValue else {return}
                content.append(type)
            }
        }
    }
    
    
    var content = [String]()
    
    var sheet: RGBottomSheet?
    
    var bottomSheetDelegate: RGBottomSheetDelegate?
    
    var bottomView: ButtomSheetSubView = {
        var screenBound = UIScreen.main.bounds
        screenBound.size.height = 200.0
        let bottomView = ButtomSheetSubView(frame: screenBound)
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.9478505711, green: 0.9478505711, blue: 0.9478505711, alpha: 1)
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        return label
    }()
    
    let picker: UIPickerView = {
       let p = UIPickerView()
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(picker)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(55)
            make.top.equalTo(self)
        }

        picker.delegate = self
        picker.dataSource = self
            picker.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.left.right.bottom.equalTo(self)
            }
    }
    
    
    
}


extension BottomSheetView: UIPickerViewDelegate, UIPickerViewDataSource{
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return content.count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        return content[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Do something with the row
       // bottomSheetDelegate?.closeButtomSheet()
    }
}
