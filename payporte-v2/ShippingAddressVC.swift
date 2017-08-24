//
//  ShippingAddressVC.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Eureka
import SwiftyJSON


struct StateData {
    
    var stateId: String?
    var stateCode: String?
    var state: String?
}

public class ShippingAddressVC: FormViewController {
    
    static var defaultValue: String?
    static var countryCode: String?
    static var country: String?
    static var stateId: String?
    static var stateCode: String?
    
    var stateData: StateData?
    var count: [Country]?
    
    var cartVcDelegate: CheckoutDelegate?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "A D D R E S S"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        fetchCountry()
    }
    
    
    func setupForm(){
        
        
        let submitBarButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit(barbutton:)))
        submitBarButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItems = [ submitBarButton]
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.textLabel?.textColor = .white
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            cell.textLabel?.font = UIFont(name: "Orkney-Bold", size: 14)
            cell.contentView.backgroundColor = primaryColor
            
        }
        
        form +++ Section(header: "Basic Info", footer: "")
            
            
            <<< TextRow("fullnametag") {
                $0.title = "Full Name"
                $0.placeholder = "e.g John Doe"
                $0.cell.height = { 55 }
                
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< EmailRow("emailtag") {
                $0.title = "Email"
                $0.placeholder = "e.g johndoe@gmail.com"
                $0.cell.height = { 55 }
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< PhoneRow("phonetag"){
                $0.title = "Phone Number"
                $0.placeholder = "e.g +2349999999"
                $0.cell.height = { 55 }
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 14))
                $0.add(rule: RuleMaxLength(maxLength: 14))
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
//            <<< DateRow("datetag"){
//                $0.title = "Date of Birth"
//                $0.cell.height = { 55 }
//                $0.add(rule: RuleRequired())
//                $0.validationOptions = .validatesOnChange
//                $0.value = Date(timeIntervalSinceReferenceDate: 0)
//                }.cellUpdate({ (cell, row) in
//                    if row.value == Date(timeIntervalSinceReferenceDate: 0){
//                        
//                    }
//                })
            
            
            +++ Section("Delivery Address Info")
            
            <<< TextRow("addresstag") {
                $0.title = "Street"
                $0.placeholder = "e.g Parkview Street"
                $0.cell.height = { 55 }
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TextRow("citytag") {
                $0.title = "City"
                $0.placeholder = "e.g Ikeja"
                $0.cell.height = { 55 }
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid{
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< PickerInlineRow<String>("countrytag"){ row in
                row.title = "Country"
                row.cell.height = { 55 }
                row.add(rule: RuleRequired())
                row.options = countries() ?? []
                row.value = "Nigeria"
                ShippingAddressVC.country = row.value
                }.onChange({ (row) in
                    guard let country = row.value else { return }
                    if let stateRow = self.form.rowBy(tag: "statetag") as? PickerInlineRow<String> {
                        ShippingAddressVC.country = row.value
                        stateRow.value = nil
                        var arry = [String]()
                        let states = self.states(for: country)
                        for state in 0 ..< states.count{
                            arry.append(states[state].state!)
                        }
                        stateRow.options = arry
                        stateRow.value = ShippingAddressVC.defaultValue ?? nil
                        stateRow.reload() // not sure if needed
                        ShippingAddressVC.country = row.value
                    }
                })
            
            <<< PickerInlineRow<String>("statetag"){ row in
                row.title = "State"
                row.cell.height = { 55 }
                var arry = [String]()
                let states = self.states(for: "Nigeria")
                for state in 0 ..< states.count{
                    arry.append(states[state].state!)
                }
                row.options = arry
                row.value = ShippingAddressVC.defaultValue ?? nil
            }.onChange({ (row) in
                
                guard let country = ShippingAddressVC.country else {return}
                guard let value = row.value else {return}
                let stateCodeId = self.getStateCodeId(state: value, country: country)
                ShippingAddressVC.stateCode = stateCodeId?.stateCode
                ShippingAddressVC.stateId = stateCodeId?.stateId

            })
            
            <<< TextRow("ziptag") {
                $0.title = "Zip Code"
                $0.placeholder = "e.g 11111"
                $0.cell.height = { 55 }
                $0.add(rule: RuleMinLength(minLength: 5))
                $0.add(rule: RuleMaxLength(maxLength: 5))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
        }
    }
    
    func handleSubmit(barbutton: UIBarButtonItem){
        
        let data = form.values()
        let city = data["citytag"] as? String
        let state = data["statetag"] as? String
        let zip = data["ziptag"] as? String
        let address = data["addresstag"] as? String
        let email = data["emailtag"] as? String
        let phone = data["phonetag"] as? String
        let fullname = data["fullnametag"] as? String
        let country = data["countrytag"] as? String
        
        if let cityName = city, let zipCode = zip, let addressName = address,
            let emailName = email, let phoneNumber = phone, let fullUserName = fullname,
             let stateName = state, let countryName = country {
            
            let arry = [
                
                cityName,
                stateName,
                countryName,
                phoneNumber,
                addressName,
                fullUserName,
                emailName,
                zipCode,
                ShippingAddressVC.countryCode ?? "",
                ShippingAddressVC.stateId ?? "",
                ShippingAddressVC.stateCode ?? ""
            ]
            
            saveUserAddress(arry: arry, street: addressName, phone: "\(fullUserName.uppercased()) (\(phoneNumber))")
            
            
        }else{
            form.validate()
        }
        
    }
    
    func saveUserAddress(arry: [String], street: String, phone: String){
        Payporte.sharedInstance.saveAddress(arry: arry) { (payment, error, mesage) in
            
            if error !=  nil {
                
                let alert = UIAlertController(title: "Error saving address", message: error!, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            guard let payments = payment.paymentMethodList else {return}
            guard let shippings = payment.shippingMethodList else {return}
            var paymentDatas = [String]()
            var shippingDatas = [String]()
            
            for i in 0 ..< payments.count{
                guard let title = payments[i].title else {return}
                paymentDatas.append(title)
            }
            
            for i in 0 ..< shippings.count{
                guard let title = shippings[i].sMethodName else {return}
                shippingDatas.append(title)
            }
            
            self.cartVcDelegate?.getPaymentMethods(options: paymentDatas)
            self.cartVcDelegate?.getShippingMethods(options: shippingDatas)
            
            
            guard let total = payment.fee?.grandTotal else {return}
            
            self.cartVcDelegate?.getTotalAmount(total: total.description)
            self.cartVcDelegate?.getUserAddress(street: street, phone: phone)
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func fetchCountry() {
        
        Payporte.sharedInstance.fetchCountriesandStates { (countries, error, message) in
            
            if error != nil{
                return
            }
            
            self.count = countries
            
            self.setupForm()
        }
    }
    
    func states(for country: String) -> [StateData] {
        var statesData = [StateData]()
        if let countries = self.count {
            for acountry in countries{
                if let count = acountry.countryName{
                    if count == country{
                        ShippingAddressVC.countryCode = acountry.countryCode
                        if let stats = acountry.states {
                            for state in stats {
                                
                                if let stat = state.stateName {
                                    if let stateId = state.stateId, let stateCode = state.stateCode  {
                                        
                                        let data = StateData(stateId: stateId, stateCode: stateCode, state: stat)
                                        statesData.append(data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if statesData.count > 0{
                ShippingAddressVC.defaultValue = statesData[0].state
                ShippingAddressVC.stateCode = statesData[0].stateCode
                ShippingAddressVC.stateId = statesData[0].stateId
                self.tableView.reloadData()
            }else{
                ShippingAddressVC.defaultValue = ""
                self.tableView.reloadData()
            }
            
            return statesData
        }
        return []
    }
    
    func getStateCodeId(state form: String, country: String) -> StateData?{
        
        var states = self.states(for: country)
        for i in 0 ..< states.count{
            if states[i].state == form{
                return states[i]
            }
        }
        return nil
    }
    
    func countries() ->[String]?{
        var countriesData = [String]()
        if let countries = self.count{
            for country in countries {
                if let count = country.countryName{
                    countriesData.append(count)
                }
            }
            return countriesData
        }
        return nil
    }
    
}
