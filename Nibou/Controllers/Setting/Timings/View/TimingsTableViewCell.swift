//
//  TimingsTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TimingsTableViewCell: UITableViewCell {

    @IBOutlet weak var timingView           : UIView!
    @IBOutlet weak var btnTitle             : UIButton!
    @IBOutlet weak var btnStartTime         : UIButton!
    @IBOutlet weak var btnEndTime           : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
