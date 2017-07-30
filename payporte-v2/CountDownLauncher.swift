//
//  CountDownView.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/27/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit

class CountDownLauncher: NSObject {

    
    let mainBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let boxView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let bgImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "countdown-background")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "oops")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let oppsLabel: UILabel = {
       let label = UILabel()
        label.text = "Oops!"
        label.font = UIFont(name: "Orkney-Medium", size: 24)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "The Store is close check back in..."
        label.font = UIFont(name: "Orkney-Regular", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let remindMeButton: UIButton = {
       let button = UIButton()
        button.setTitle("Remind Me Later", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Medium", size: 13)
        button.backgroundColor = primaryColor
        button.layer.cornerRadius = 45 / 2
        button.clipsToBounds = true
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Medium", size: 13)
        button.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let countdownLabel: CountdownLabel = {
       let label = CountdownLabel()
        label.font =  UIFont(name: "Orkney-Bold", size: 26)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let blackView = UIView()
    
    
    func setupViews(type: String){
        
        if let window = UIApplication.shared.keyWindow{
            
            blackView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            mainBoxView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            
            window.addSubview(blackView)
            window.addSubview(mainBoxView)
            mainBoxView.addSubview(boxView)
            boxView.addSubview(bgImageView)
            boxView.addSubview(iconImage)
            boxView.addSubview(label)
            boxView.addSubview(oppsLabel)
            boxView.addSubview(countdownLabel)
            mainBoxView.addSubview(remindMeButton)
            mainBoxView.addSubview(dismissButton)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            boxView.snp.makeConstraints { (make) in
                make.top.equalTo(window).offset(70)
                make.left.equalTo(window).offset(40)
                make.right.equalTo(window).offset(-40)
                make.height.equalTo((window.frame.height / 2) + 50)
            }
            
            bgImageView.snp.makeConstraints { (make) in
                make.top.equalTo(boxView)
                make.left.equalTo(boxView)
                make.right.equalTo(boxView)
                make.bottom.equalTo(boxView)
            }
            
            iconImage.snp.makeConstraints { (make) in
                make.top.equalTo(boxView).offset(40)
                make.left.equalTo(boxView).offset(100)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            
            oppsLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(iconImage.snp.bottom).offset(40)
                make.left.equalTo(boxView.snp.left).offset(60)
                make.right.equalTo(boxView.snp.right).offset(-60)
                make.height.equalTo(22)
            })
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(oppsLabel.snp.bottom).offset(30)
                make.left.equalTo(boxView.snp.left).offset(60)
                make.right.equalTo(boxView.snp.right).offset(-60)
                make.height.equalTo(36)
            })
            
            countdownLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(boxView.snp.bottom).offset(-20)
                make.right.equalTo(boxView.snp.right).offset(-20)
                make.left.equalTo(boxView.snp.left).offset(20)
                make.height.equalTo(28)
            })
            
            let offset = (mainBoxView.frame.width - 160) / 2
            
            remindMeButton.snp.makeConstraints { (make) in
                make.top.equalTo(boxView.snp.bottom).offset(30)
                make.left.equalTo(mainBoxView.snp.left).offset(offset)
                make.right.equalTo(mainBoxView.snp.right).offset(-offset)
                make.height.equalTo(45)
            }
            
            dismissButton.snp.makeConstraints({ (make) in
                make.left.equalTo(boxView.snp.right).offset(-13)
                make.top.equalTo(window).offset(62.5)
                make.width.height.equalTo(30)
            })
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
            }, completion: nil)
            
            let today = NSDate()
            let calendar = NSCalendar.current
            
            let todayWeekday = calendar.component(.weekday , from: today as Date)
            print(todayWeekday)
            if todayWeekday != 2 {
                
            }
            let addWeekdays = 2 - todayWeekday  // 7: Saturday number
            let components = NSDateComponents()
            components.weekday = addWeekdays
            
            let nextSaturday = calendar.date(byAdding: components as DateComponents, to: today as Date)
            countdownLabel.setCountDownTime(minutes: (nextSaturday?.timeIntervalSinceNow)!)
            countdownLabel.animationType = .Sparkle
            countdownLabel.start()
            
            dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        }
        
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.blackView.removeFromSuperview()
            self.mainBoxView.removeFromSuperview()
            
        }) { (completed: Bool) in
            
        }
    }
}
