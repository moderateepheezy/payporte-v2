//
//  NewAddressVC.swift
//  PayPorte
//
//  Created by SimpuMind on 5/22/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0
import SwiftyJSON

class NewAddressVC: UIViewController, UITextFieldDelegate{
    
    var didSetupConstraints = false
    
    
    var countriesData: [String] = [String]()
    var statesData: [String] = [String]()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back_black"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Address"
        label.font = UIFont(name: "AvenirNext-Medium", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor(white: 0, alpha: 0.65)
        return label
    }()
    
    let usernameTextField: SkyFloatingLabelTextField = {
       let tf = SkyFloatingLabelTextField()
        tf.placeholder = "USERNAME"
        tf.title = "Username"
        tf.errorColor = UIColor.red
        tf.delegate = self as? UITextFieldDelegate
        tf.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.selectedTitleColor = UIColor(red: 241, green: 100, blue: 57)
        tf.selectedLineColor = UIColor(red: 241, green: 100, blue: 57)
        return tf
    }()
    
    let emailTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField()
        tf.placeholder = "EMAIL"
        tf.title = "Email"
        tf.keyboardType = .emailAddress
        tf.errorColor = UIColor.red
        tf.delegate = self as? UITextFieldDelegate
        tf.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.selectedTitleColor = UIColor(red: 241, green: 100, blue: 57)
        tf.selectedLineColor = UIColor(red: 241, green: 100, blue: 57)
        return tf
    }()
    
    let addressTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField()
        tf.placeholder = "DELIEVERY ADDRESS"
        tf.title = "Delivery Address"
        tf.errorColor = UIColor.red
        tf.delegate = self as? UITextFieldDelegate
        tf.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.selectedTitleColor = UIColor(red: 241, green: 100, blue: 57)
        tf.selectedLineColor = UIColor(red: 241, green: 100, blue: 57)
        return tf
    }()
    
    let phoneTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField()
        tf.placeholder = "PHONE NUMBER"
        tf.title = "Phone Numer"
        tf.keyboardType = .phonePad
        tf.errorColor = UIColor.red
        tf.delegate = self as? UITextFieldDelegate
        tf.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.selectedTitleColor = UIColor(red: 241, green: 100, blue: 57)
        tf.selectedLineColor = UIColor(red: 241, green: 100, blue: 57)
        return tf
    }()
    
    let cityTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField()
        tf.placeholder = "CITY"
        tf.title = "City"
        tf.errorColor = UIColor.red
        tf.delegate = self as? UITextFieldDelegate
        tf.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.selectedTitleColor = UIColor(red: 241, green: 100, blue: 57)
        tf.selectedLineColor = UIColor(red: 241, green: 100, blue: 57)
        return tf
    }()
    
    let zipTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField()
        tf.placeholder = "ZIP CODE"
        tf.title = "Zip Code"
        tf.errorColor = UIColor.red
        tf.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.selectedTitleColor = UIColor(red: 241, green: 100, blue: 57)
        tf.selectedLineColor = UIColor(red: 241, green: 100, blue: 57)
        tf.delegate = self as? UITextFieldDelegate
        return tf
    }()
    
    let stateButton: UIButton = {
        let tf = UIButton()
        tf.setTitle("STATE", for: .normal)
        tf.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.setTitleColor(UIColor.lightGray, for: .normal)
        tf.contentHorizontalAlignment = .left
        return tf
    }()
    
    let countryButton: UIButton = {
        let tf = UIButton()
        tf.setTitle("COUNTRY", for: .normal)
        tf.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        tf.setTitleColor(UIColor.lightGray, for: .normal)
        tf.contentHorizontalAlignment = .left
        return tf
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.setImage(#imageLiteral(resourceName: "white_right_arrow"), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    let countryView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let stateView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                                for country: NSDictionary in countries {
                                    guard let count = country["country_name"] as? String else{ return }
                                    countriesData.append(count)
                                    
                                    guard let states = country["states"] as? [NSDictionary] else {return}
                                    
                                    print(states)
                                    
                                    for state in states {
        
                                        guard let stat = state["state_name"] as? String else{ return }
                                        statesData.append(stat)
                                    }
                                }
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
        
        view.backgroundColor = .white
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(addressTextField)
        view.addSubview(phoneTextField)
        view.addSubview(cityTextField)
        view.addSubview(zipTextField)
        view.addSubview(stateButton)
        view.addSubview(countryButton)
        view.addSubview(saveButton)
        view.addSubview(countryView)
        view.addSubview(stateView)
        
        
        //MARK :- Add Targets
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        countryButton.addTarget(self, action: #selector(handleCountryPicker), for: .touchUpInside)
        stateButton.addTarget(self, action: #selector(handleStatePicker), for: .touchUpInside)
        
        
        saveButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        saveButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        saveButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        saveButton.imageView?.snp.makeConstraints({ (make) in
            
            make.leading.equalTo(saveButton.snp.leading).offset(16)
            make.centerY.equalTo(saveButton.snp.centerY)
            
        })
        
        let colors = [UIColor(red: 250, green: 152, blue: 36), UIColor(red: 247, green: 60, blue: 100)]
        saveButton.applyGradientToButton(colours: colors)

    }
    
    func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleCountryPicker(){
        
        let acp = ActionSheetStringPicker(title: "Choose Country", rows: countriesData, initialSelection: 0, doneBlock: { (picker, index, value) in
            self.countryButton.setTitle("\(self.countriesData[index])", for: .normal)
        }, cancel: nil, origin: countryButton.self)
        
        
        acp?.toolbarButtonsColor = UIColor(red: 241, green: 100, blue: 57)
        acp?.show()
    }
    
    func handleStatePicker(){
       let acp = ActionSheetStringPicker(title: "Choose State", rows: statesData, initialSelection: 14, doneBlock: { (picker, index, value) in
            self.stateButton.setTitle("\(self.statesData[index])", for: .normal)
        }, cancel: nil, origin: countryButton.self)
        
        
        acp?.toolbarButtonsColor = UIColor(red: 241, green: 100, blue: 57)
        acp?.show()
        
    }
    
    func getBarButton(_ title : String) -> UIBarButtonItem{
        let customButton =  UIButton.init(type: UIButtonType.custom)
        customButton.setTitle(title, for: .normal)
        customButton.frame = CGRect.init(x: 0, y: 5, width: 80, height: 32)
        customButton.setTitleColor(UIColor(red: 241, green: 100, blue: 57), for: .normal)
        
        return UIBarButtonItem.init(customView: customButton)
    }
    

}
