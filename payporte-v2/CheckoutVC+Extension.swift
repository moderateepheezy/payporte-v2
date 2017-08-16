//
//  CheckoutVC+Extension.swift
//  payporte-v2
//
//  Created by SimpuMind on 8/14/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

extension CheckoutVC {
    
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(40)
                make.centerX.equalTo(view)
                make.width.equalTo(100)
                make.height.equalTo(17)
            }
            
            cartLabel.snp.makeConstraints { (make) in
                make.top.equalTo(view.snp.top).offset(84)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(15)
            }
            
            totalPriceView.snp.makeConstraints { (make) in
                make.top.equalTo(cartLabel.snp.bottom).offset(20)
                make.left.equalTo(view.snp.left).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                make.height.equalTo(150)
            }
            
            shipToLabel.snp.makeConstraints { (make) in
                make.top.equalTo(totalPriceView.snp.bottom).offset(25)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(15)
            }
            
            addressView.snp.makeConstraints { (make) in
                make.top.equalTo(shipToLabel.snp.bottom).offset(20)
                make.left.equalTo(view.snp.left).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                make.height.equalTo(100)
            }
            
            shippingMethodLabel.snp.makeConstraints { (make) in
                make.top.equalTo(addressView.snp.bottom).offset(25)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(15)
            }
            
            paymentView.snp.makeConstraints { (make) in
                make.top.equalTo(shippingMethodLabel.snp.bottom).offset(20)
                make.left.equalTo(view.snp.left).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
                make.height.equalTo(80)
            }
            
            
            shippingTextLabel.snp.makeConstraints({ (make) in
                make.leading.equalTo(paymentView.snp.leading).offset(16)
                make.centerY.equalTo(paymentView.snp.centerY)
                make.width.equalTo(200)
                make.height.equalTo(15)
            })
            
            editShippingImageView.snp.makeConstraints({ (make) in
                make.trailing.equalTo(paymentView.snp.trailing).inset(20)
                make.centerY.equalTo(paymentView.snp.centerY)
                make.width.equalTo(20)
                make.height.equalTo(20)
            })
            
            editAddressImageView.snp.makeConstraints({ (make) in
                make.trailing.equalTo(addressView.snp.trailing).inset(20)
                make.centerY.equalTo(addressView.snp.centerY)
                make.width.equalTo(20)
                make.height.equalTo(20)
            })
            
            addressLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(addressView.snp.top).offset(25)
                make.right.equalTo(editAddressImageView.snp.left).offset(8)
                make.left.equalTo(addressView).offset(20)
                make.height.equalTo(16)
            })
            
            phoneNumberLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(addressLabel.snp.top).offset(20)
                make.right.equalTo(editAddressImageView.snp.left).offset(8)
                make.left.equalTo(addressView).offset(20)
                make.height.equalTo(16)
            })
            
            
            priceDetailsSubView.snp.makeConstraints({ (make) in
                
                make.top.equalTo(totalPriceView.snp.top)
                make.left.equalTo(totalPriceView.snp.left)
                make.right.equalTo(totalPriceView.snp.right)
                make.height.equalTo(90)
            })
            
            showItemButton.snp.makeConstraints({ (make) in
                make.trailing.equalTo(priceDetailsSubView.snp.trailing).inset(20)
                make.centerY.equalTo(priceDetailsSubView.snp.centerY)
                make.width.equalTo(20)
                make.height.equalTo(18)
            })
            
            numOfItemLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(priceDetailsSubView.snp.top).offset(30)
                make.right.equalTo(showItemButton.snp.left).offset(8)
                make.left.equalTo(priceDetailsSubView).offset(20)
                make.height.equalTo(16)
            })
            
            priceLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(numOfItemLabel.snp.top).offset(20)
                make.right.equalTo(showItemButton.snp.left).offset(8)
                make.left.equalTo(priceDetailsSubView).offset(20)
                make.height.equalTo(16)
            })
            
            verifyCouponButton.snp.makeConstraints({ (make) in
                make.trailing.equalTo(totalPriceView.snp.trailing).inset(20)
                make.top.equalTo(priceDetailsSubView.snp.bottom).offset(17)
                make.width.equalTo(80)
                make.height.equalTo(25)
            })
            
            couponTextField.snp.makeConstraints({ (make) in
                make.left.equalTo(totalPriceView).inset(20)
                make.top.equalTo(priceDetailsSubView.snp.bottom).offset(17)
                make.width.equalTo(120)
                make.height.equalTo(25)
            })
            
            placeorderView.snp.makeConstraints { (make) in
                
                make.left.equalTo(view).offset(20)
                make.bottom.equalTo(view).offset(-20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(60)
            }

            
            placeOrderButton.snp.makeConstraints { (make) in
                
                make.left.equalTo(placeorderView).offset(10)
                make.bottom.equalTo(placeorderView).offset(-10)
                make.right.equalTo(placeorderView).offset(-10)
                make.top.equalTo(placeorderView.snp.top).offset(10)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}
