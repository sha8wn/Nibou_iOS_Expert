//
//  NBRightMessageTableCell.swift
//  Nibou
//
//  Created by Ongraph on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBRightMessageTableCell: UITableViewCell {

    @IBOutlet weak var view_border      : UIView!
    @IBOutlet weak var btn_bookmark     : UIButton! {
        didSet {
            self.btn_bookmark.addTarget(self, action: #selector(self.btnBookmarTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var lbl_text         : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblTime          : UILabel!
    
    var completion:((_ sender: UIButton)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func btnBookmarTapped( _ sender: UIButton) {
        self.completion?(sender)
    }
    
}
