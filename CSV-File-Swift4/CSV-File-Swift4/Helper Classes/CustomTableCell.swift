//
//  CustomTableCell.swift
//  MitoCalc
//
//  Created by IosDeveloper on 13/11/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
