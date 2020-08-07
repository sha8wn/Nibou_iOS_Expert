//
//  SuccessViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/10/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

/**
 Alert Delegate.
 ````
 func alertCancelTapped
 func alertOkTapped
 ````
 */

protocol SuccessViewDelegate {
    func successContinueTapped()
}

extension SuccessViewDelegate{
    func successContinueTapped(){
        
    }
}

class SuccessViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var txtDesc          : UITextView!
    @IBOutlet weak var btnContinue      : UIButton!
    var successDelegate                 : SuccessViewDelegate!
    var descStr                         : String!
    var titleStr                        : String!
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - SetUp UI
    /**
     Set Up UI of Success View
     */
    func setUpUI(){
        self.txtDesc.textContainerInset = .zero
        self.txtDesc.textContainer.lineFragmentPadding = 0
        self.lblTitle.text = titleStr
        self.txtDesc.text = descStr
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnContinueTapped(_ sender: Any) {
        self.successDelegate.successContinueTapped()
    }
    
}
