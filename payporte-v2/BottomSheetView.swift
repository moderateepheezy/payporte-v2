//
//  BottomSheetView.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/17/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import RGBottomSheet

var someData = [String: String]()

public class BottomSheetView: UIView {
    
    var options: [String]?
    
    
    var sheet: RGBottomSheet?
    
    var bottomSheetDelegate: RGBottomSheetDelegate?
    
    var button: UIButton?
    
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
        label.textColor = .black
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        return label
    }()
    
    let picker: UIPickerView = {
       let p = UIPickerView()
        return p
    }()
    
    let doneButton: UIButton = {
       let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
        return button
    }()
    
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)
        
        addSubview(picker)
        addSubview(titleLabel)
        addSubview(doneButton)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.height.equalTo(55)
            make.top.equalTo(self)
        }

        doneButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(55)
            make.top.equalTo(self)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
        }
        
        
        picker.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self)
        }
        
        doneButton.addTarget(self, action: #selector(dismissView(button:)), for: .touchUpInside)
    }
    
    func dismissView(button: UIButton){
        bottomSheetDelegate?.closeButtomSheet()
        
    }
    
}


extension BottomSheetView: UIPickerViewDelegate, UIPickerViewDataSource{
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return options?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        return options?[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            guard let opt = options else {return}
        if opt.count > 0{
            button?.setTitle(opt[row], for: .normal)
            someData[titleLabel.text!] = "\(String(describing: opt[row]))"
        }
    }
}
