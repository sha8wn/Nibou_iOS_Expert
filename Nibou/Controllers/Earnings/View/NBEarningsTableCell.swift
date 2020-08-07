//
//  NBEarningsTableCell.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBEarningsTableCell: UITableViewCell {

    @IBOutlet weak var lbl_month: UILabel!
    @IBOutlet weak var lbl_minPaid: UILabel!
    @IBOutlet weak var lbl_AED: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
