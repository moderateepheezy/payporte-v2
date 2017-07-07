//
//  Childs2ndStageTableViewCell.swift
//  Expandable3
//
//  Created by MAC241 on 11/05/17.
//  Copyright © 2017 KiranJasvanee. All rights reserved.
//

import UIKit

class Childs2ndStageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageviewBackground: UIImageView!
    @IBOutlet weak var labelChildAtIndex: UILabel!
    
    @IBOutlet weak var buttonState: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelChildAtIndex.font = UIFont(name: "Orkney-Bold", size: 14)
    }
    
    func cellFillUp(indexParam: String) {
        
        
        labelChildAtIndex.textColor = UIColor(white: 0, alpha: 0.65)
        labelChildAtIndex.text = "Child custom cell at index: \(indexParam)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
