//
//  SortButtonSheetView.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/25/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import RGBottomSheet

public class SortButtonSheetView:  UIView {
    
    var content: [String]?
    
    var dataSource: ProductListDataSource?
    
    var bottomSheetDelegate: RGBottomSheetDelegate?
    
    var bottomView: ButtomSheetSubView = {
        var screenBound = UIScreen.main.bounds
        screenBound.size.height = 200.0
        let bottomView = ButtomSheetSubView(frame: screenBound)
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorInset = UIEdgeInsets.zero
        return tv
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.9478505711, green: 0.9478505711, blue: 0.9478505711, alpha: 1)
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(titleLabel)
        addSubview(tableView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(55)
            make.top.equalTo(self)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.bottom.equalTo(self)
        }
        tableView.register(SortButtonCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 55
    }
    
    
    
}

class SortButtonCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Orkney-Medium", size: 14)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
    fileprivate func setupViews(){
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.right.equalTo(self)
            make.width.equalTo(self.frame.width)
            make.height.equalTo(15)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SortButtonSheetView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SortButtonCell
        cell.titleLabel.text = content?[indexPath.item]
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.item == 1{
            dataSource?.sortAlphabeticallyAccending()
        }
        bottomSheetDelegate?.closeButtomSheet()
    }
}

