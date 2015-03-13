//
//  TableViewCell.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 04/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
