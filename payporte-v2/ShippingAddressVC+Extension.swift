//
//  ShippingAddressVC+Extension.swift
//  PayPorte
//
//  Created by SimpuMind on 5/22/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit


extension ShippingAddressVC{
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            
            dismissButton.snp.makeConstraints { (make) in
                make.right.equalTo(view).offset(-10)
                make.top.equalTo(view).offset(30)
                make.width.equalTo(35)
                make.height.equalTo(35)
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(40)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(17)
            }
            
            addAddressButton.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.top).offset(40)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(50)
            }
            
            chooseExsitingLabel.snp.makeConstraints { (make) in
                make.top.equalTo(addAddressButton.snp.bottom).offset(30)
                make.left.equalTo(view).offset(30)
                make.right.equalTo(view).offset(-30)
                make.height.equalTo(50)
            }
            
            view1.snp.makeConstraints { (make) in
                make.top.equalTo(chooseExsitingLabel.snp.bottom).offset(30)
                make.left.equalTo(view).offset(40)
                make.right.equalTo(view).offset(-40)
                make.height.equalTo(1)
            }
            
            
            doneButton.snp.makeConstraints { (make) in
                
                make.left.equalTo(view).offset(20)
                make.bottom.equalTo(view).offset(-20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(45)
            }
            
            
            tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(view1.snp.bottom).offset(5)
                make.bottom.equalTo(doneButton.snp.top).offset(-20)
                make.left.equalTo(view).offset(40)
                make.right.equalTo(view).offset(-40)
            })
            
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
}

extension ShippingAddressVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AddressCell
        
        if indexPath.item == 0 {
            cell.checkbox.isSelected = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
