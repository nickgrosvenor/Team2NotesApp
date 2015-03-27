//
//  BackgroundCell.swift
//  DemoProj
//
//  Created by Pragnesh Dixit on 19/03/15.
//  Copyright (c) 2015 TriState Technology. All rights reserved.
//

import Foundation
import uikit
class BackgroundCell:UITableViewCell {
    
 @IBOutlet weak var imgView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
