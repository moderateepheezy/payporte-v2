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
    
    let content = ["COLOR", "EXTENDED WARRANTY", "SIZE"]
    
    var sheet: RGBottomSheet?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(tableView)
        
        let config = RGBottomSheetConfiguration(
            showBlur: true
        )
        sheet = RGBottomSheet(
            withContentView: bottomView,
            configuration: config
        )
        
        tableView.delegate = self
        tableView.dataSource = self
            tableView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalTo(self)
            }
            tableView.register(BottomSheetCell.self, forCellReuseIdentifier: "cell")
            tableView.rowHeight = 55
    }
    
    
    
}

class BottomSheetCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "COLOR"
        label.font = UIFont(name: "Orkney-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "COLOR"
        label.font = UIFont(name: "Orkney-Bold", size: 13)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subTitleLabel)
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
            make.top.equalTo(self).offset(10)
            make.left.right.equalTo(self)
            make.width.equalTo(400)
            make.height.equalTo(15)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.width.equalTo(400)
            make.left.right.equalTo(self)
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

extension BottomSheetView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BottomSheetCell
        cell.titleLabel.text = content[indexPath.item]
        cell.subTitleLabel.text = "No Option Selected"
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sheet?.configuration.showBlur = false
        sheet?.configuration.showOverlay = true
        sheet?.show()
        bottomSheetDelegate?.closeButtomSheet()
    }
}
