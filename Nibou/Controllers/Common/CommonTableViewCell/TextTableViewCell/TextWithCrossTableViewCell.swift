//
//  TextWithCrossTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 19/10/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TextWithCrossTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView       : UIView!
    @IBOutlet weak var txtField     : CustomTextField!
    @IBOutlet weak var btnCross     : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
