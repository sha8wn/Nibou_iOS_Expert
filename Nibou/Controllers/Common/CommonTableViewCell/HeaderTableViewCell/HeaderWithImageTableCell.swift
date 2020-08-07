//
//  HeaderWithImageTableCell.swift
//  Nibou
//
//  Created by Ongraph on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class HeaderWithImageTableCell: UITableViewCell {

    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var btnImagePicker: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUserImage.layer.cornerRadius = imgUserImage.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
