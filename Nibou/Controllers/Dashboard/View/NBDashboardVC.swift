//
//  NBDashboardVC.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBDashboardVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var lbl_header           : UILabel!
    @IBOutlet weak var lbl_joinDate         : UILabel!
    @IBOutlet weak var lbl_noOfAEDtotal     : UILabel!
    @IBOutlet weak var lbl_totalAed         : UILabel!
    @IBOutlet weak var lbl_noOfAEDmonth     : UILabel!
    @IBOutlet weak var lbl_monthAED         : UILabel!
    @IBOutlet weak var lbl_noOftotalMins    : UILabel!
    @IBOutlet weak var lbl_totalmins        : UILabel!
    @IBOutlet weak var lbl_noOfmonthMins    : UILabel!
    @IBOutlet weak var lbl_thismonth        : UILabel!
    @IBOutlet weak var btn_viewEarnings     : UIButton!
    @IBOutlet weak var btn_viewReviews      : UIButton!
    
    var totalAmount                         : String        = ""
    var totalMins                           : String        = ""
    var totalAmountMonthly                  : String        = ""
    var totalMinsMonthly                    : String        = ""
    
    //MARK:- UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.setupView()
        self.callGetOverallPaymentAPI()
    }
    
    func setupView(){
        self.lbl_totalAed.text = "TOTAL".localized()
        self.lbl_noOfAEDtotal.text = "₺ 0"
        self.lbl_totalmins.text = "TOTAL".localized()
        self.lbl_noOftotalMins.text = "0 " + "MINS".localized()
        
        self.lbl_monthAED.text = "THIS_MONTH".localized()
        self.lbl_noOfAEDmonth.text = "₺ 0"
        self.lbl_thismonth.text = "THIS_MONTH".localized()
        self.lbl_noOfmonthMins.text = "0 " + "MINS".localized()
        
        self.btn_viewReviews.setTitle("VIEW_REVIEWS_RATING".localized(), for: .normal)
        self.btn_viewEarnings.setTitle("VIEW_EARNIGNS_HISTORY".localized(), for: .normal)
        
        self.lbl_joinDate.text = ""
        
        self.lbl_header.text = "DASHBOARD_HEADER".localized()
    }

    @IBAction func btn_viewEarningAction(_ sender: Any) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NBEarningsVC") as! NBEarningsVC
        viewController.viewType = .month
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btn_viewReviewAction(_ sender: Any) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NBRatingsVC") as! NBRatingsVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NBDashboardVC: AlertDelegate{
    
}
