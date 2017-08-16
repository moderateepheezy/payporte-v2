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

public class ShippingAddressVC: FormViewController {
    
    static var defaultValue: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        guard let x = fetchCounrtyStateArray() else {return}
        print(x)
        self.navigationItem.title = "A D D R E S S"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Orkney-Bold", size: 16)!]
        
        
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
            
            
            <<< TextRow() {
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
            
            <<< EmailRow() {
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
            
            <<< PhoneRow(){
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
            
            <<< DateRow(){
                $0.title = "Date of Birth"
                $0.cell.height = { 55 }
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }.cellUpdate({ (cell, row) in
                if row.value == Date(timeIntervalSinceReferenceDate: 0){
                    
                }
            })
            
            
            +++ Section("Delivery Address Info")
            
            <<< TextRow() {
                $0.title = "Address"
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
            <<< TextRow() {
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
                <<< PickerInlineRow<String>(){ row in
                    row.title = "Country"
                    row.cell.height = { 55 }
                    row.add(rule: RuleRequired())
                    row.options = countries() ?? []
                    row.value = "Nigeria"
                    }.onChange({ (row) in
                        guard let country = row.value else { return }
                        if let stateRow = self.form.rowBy(tag: "citytag") as? PickerInlineRow<String> {
                            stateRow.value = nil
                            stateRow.options = self.states(for: country) 
                            stateRow.value = ShippingAddressVC.defaultValue ?? nil
                            stateRow.reload() // not sure if needed
                        }
                    })
        
            <<< PickerInlineRow<String>("citytag"){ row in
                row.title = "State"
                row.cell.height = { 55 }
                row.options = self.states(for: "Nigeria")
                row.value = ShippingAddressVC.defaultValue ?? nil
            }
            
            <<< TextRow() {
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
        form.validate()
        let alert = UIAlertController(title: "form data", message: form.values().description, preferredStyle: .alert)
        
        present(alert, animated: true, completion: nil)
    }
    
    func fetchCounrtyStateArray() -> [NSDictionary]?{
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    
                    do {
                        let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                        do {
                            let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            if let countries : [NSDictionary] = jsonResult["data"] as? [NSDictionary] {
                                //print(countries)
                                return countries
                            }
                        } catch {}
                    } catch {}
                    
                    
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
    
    func states(for country: String) -> [String] {
        var statesData = [String]()
        if let countries = self.fetchCounrtyStateArray(){
            for acountry: NSDictionary in countries {
                if let count = acountry["country_name"] as? String{
                    if count == country{
                        print(acountry)
                        if let stats = acountry["states"] as? [NSDictionary]{
                            print(stats)
                            for state in stats {
                                
                                if let stat = state["state_name"] as? String {
                                    statesData.append(stat)
                                }
                            }
                            
                        }
                    }
                }
            }
            if statesData.count > 0{
                ShippingAddressVC.defaultValue = statesData[0]
                self.tableView.reloadData()
            }else{
                ShippingAddressVC.defaultValue = ""
                self.tableView.reloadData()
            }
            
            return statesData
        }
        return []
    }
    
    func countries() ->[String]?{
        var countriesData = [String]()
        if let countries = self.fetchCounrtyStateArray(){
            for country: NSDictionary in countries {
                if let count = country["country_name"] as? String{
                    countriesData.append(count)
                }
            }
            return countriesData
        }
        return nil
    }
    
}
