//
//  NBFooterWithButtonTableCell.swift
//  Nibou
//
//  Created by Ongraph on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBFooterWithButtonTableCell: UITableViewCell {

    @IBOutlet weak var btnUploadAndViewPdf: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
