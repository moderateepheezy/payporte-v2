//
//  CartCell.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/2/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit


enum StepperChangeType {
    case increased
    case decreased
}

class CartCell: UITableViewCell {
    
    var oldValue = 0.0
    
    var cartVc: CartVC?
    var index: Int?
    
    var cartVcDelegate: CartVCDelegate?
    
    var cart: Cart?{
        didSet{
            if let img = cart?.product_image {
                let url = URL(string: img)
                productImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
            guard let prodName = cart?.product_name else {return}
            guard let prodPrice = cart?.product_price else {return}
            guard let productQty = cart?.product_qty else {return}
            
            self.oldValue = Double(productQty)!
            
            stepper.minimumValue = 1
            productNameLabel.text = prodName
            priceLabel.text = "₦ \(String(describing: prodPrice))"
            selectionStyle = .none
            setupViews(text: prodName)
        }
    }
    
    var productImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textColor = UIColor(white: 0, alpha: 0.85)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.1754441624, green: 0.1754441624, blue: 0.1754441624, alpha: 1)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Bold", size: 12)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.titleLabel?.font = UIFont(name: "Orkney-Light", size: 14)
        button.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3924978596)
        return button
    }()
    
    let lineView1: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    
    let lineView2: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return v
    }()
    
    let stepper: GMStepper = {
       let st = GMStepper()
        st.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        st.buttonsTextColor = .white
        st.labelTextColor = primaryColor
        st.labelBackgroundColor = .white
        st.buttonsBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        st.buttonsFont = UIFont(name: "Orkney-Medium", size: 10)!
        st.labelFont = UIFont(name: "Orkney-Medium", size: 12)!
        return st
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(stepper)
        self.contentView.addSubview(deleteButton)
        //self.contentView.addSubview(lineView1)
        self.contentView.addSubview(lineView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let productQty = cart?.product_qty else {return}
        stepper.value = Double(productQty)!
        
        let productMaxQty = cart?.product_max_qty!
        
        if stepper.value == Double(productMaxQty!)! || Double(productMaxQty!)! < 1{
            stepper.maximumValue = 1
        }else{
            stepper.maximumValue = Double(productMaxQty!)! + 1
        }
        
        stepper.addTarget(self, action: #selector(handleStepperChange(_:)), for: .valueChanged)
    }
    
    func handleStepperChange(_ sender: GMStepper){
        
        let quantity = "\(stepper.value)"
        if oldValue > sender.value{
            cartVc?.checkoutButton.setTitle("SAVE CHANGES", for: .normal)
            updateTotalValue(type: .decreased, quantity: quantity)
        }else if oldValue < sender.value{
            cartVc?.checkoutButton.setTitle("SAVE CHANGES", for: .normal)
            updateTotalValue(type: .increased, quantity: quantity)
        }
        self.oldValue = sender.value
    }
    
    func updateCell(cart_id: String, quantity: String){
        Payporte.sharedInstance.updateCart(cart_id: cart_id, quantity: quantity) { (complete, value) in
            if quantity == "0"{
                self.cartVc?.syncCart()
                
                let dispachTime = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: dispachTime, execute: {
                    self.cartVc?.tabBarController?.decreaseBadge()
                    self.badgeUpdate()
                })
            }
        }
    }
    
    func badgeUpdate(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: itemCountlNotificationKey), object: nil)
    }
    
    func updateTotalValue(type: StepperChangeType, quantity: String){
        
        
        
        guard let totalPrice = cartVc?.priceLabel.text?.dropFirst(2) else {return}
        guard let price = Double(totalPrice) else {return}
        guard let prodPrice = cart?.product_price else {return}
        guard let prPrice = Double(prodPrice) else {return}
        let updatePrice: CGFloat
        switch type {
        case .increased:
            updatePrice = CGFloat(price + prPrice)
        case .decreased:
            updatePrice = CGFloat(price - prPrice)
        }
        cartVcDelegate?.updatePrice(newPrice: "₦ \(updatePrice)")
        
        guard let cart_id = cart?.cart_item_id else {return}
        
        updateCell(cart_id: cart_id, quantity: quantity)
        
    }
    
    func removeAllItem(){
        
        let quantitiy = stepper.value
        
        guard let totalPrice = cartVc?.priceLabel.text?.dropFirst(2) else {return}
        guard let price = Double(totalPrice) else {return}
        guard let prodPrice = cart?.product_price else {return}
        guard let prPrice = Double(prodPrice) else {return}
        
        let updatePrice: CGFloat = CGFloat(price - (prPrice * quantitiy))
        cartVcDelegate?.updatePrice(newPrice: "₦ \(updatePrice)")
        
        if updatePrice == 0.0{
            cartVc?.checkoutButton.alpha = 0
        }else{
            cartVc?.checkoutButton.alpha = 1
        }
        
        guard let cart_id = cart?.cart_item_id else {return}
        updateCell(cart_id: cart_id, quantity: "0")
        
    }
    
    fileprivate func setupViews(text: String){
        
        let nameFrame = getLabelHeight(text: text, font: UIFont(name: "Orkney-Light", size: 14)!)
        
        deleteButton.layer.cornerRadius = 10
        deleteButton.clipsToBounds = true
        deleteButton.addTarget(self, action: #selector(removeCell(button:)), for: .touchUpInside)
        
        productImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
            make.width.equalTo(self.frame.height - 40)
        }
        
        productNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(-30)
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-40)
            make.height.equalTo(nameFrame.height + 18)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom)
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(13)
        }
        
        stepper.snp.makeConstraints { (make) in
            make.left.equalTo(productImageView.snp.right).offset(20)
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-10)
            make.width.height.equalTo(20)
            make.top.equalTo(20)
        }
        
//        lineView1.snp.makeConstraints { (make) in
//            make.top.equalTo(self)
//            make.right.left.equalTo(self)
//            make.height.equalTo(1)
//        }
        
        lineView2.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.right.left.equalTo(self)
            make.height.equalTo(1)
        }
        
    }
    
    
    func removeCell(button: UIButton){
        
        cartVc?.cartArray.remove(at: index!)
        let indexPath = IndexPath(item: 0, section: 0)
        cartVc?.tableView.deleteRows(at: [indexPath], with: .fade)
        cartVc?.tableView.reloadData()
        
        removeAllItem()
    }
    
    func getLabelHeight(text: String, font: UIFont) -> CGRect{
        
        return  NSString(string: text).boundingRect(with: CGSize(width: self.frame.width, height: 1000) , options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin) , attributes: [NSFontAttributeName: font], context: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}

extension String {
    func dropFirst(_ n: Int = 1) -> String {
        return String(characters.dropFirst(n))
    }
    var dropFirst: String {
        return dropFirst()
    }
}
