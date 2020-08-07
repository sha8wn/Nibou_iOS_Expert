//
//  NBChatListTableCell.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBChatListTableCell: UITableViewCell {

    @IBOutlet weak var lbl_count    : UILabel!
    @IBOutlet weak var lbl_time     : UILabel!
    @IBOutlet weak var lbl_message  : UILabel!
    @IBOutlet weak var lbl_name     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
