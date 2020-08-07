//
//  SettingViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnLogout            : UIButton!
    var arrTitle                            : [String]            = []
    var arrImage                            : [String]            = []
    var isLogout                            : Bool                = false
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    //end
    
    //MARK: - Set Up View
    func setup(){
        self.tableView.estimatedRowHeight = 80
        self.tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        self.lblHeader.text = "SETTINGS".localized()
        self.arrTitle = ["UPDATE_PROFILE".localized(), "SHORT_BIO".localized(), "CHANGE_PASSWORD".localized(), "MANAGE_TIMINGS".localized(), "EXPERTISE".localized(), "LANGUAGE".localized(), "FEEDBACK".localized()]
        self.arrImage = ["ic_Edit_Profile", "ic_Transaction_History", "ic_Change_Password", "ic_Menu_Clock", "ic_Pricing", "ic_Choose_Language", "ic_Feedback"]
    }
    //end

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnLogoutTapped(_ sender: Any) {
        self.isLogout = true
        
        self.showAlert(viewController: self, alertTitle: "", alertMessage: "LOGOUT_ALERT".localized(), alertType: AlertType.twoButton, okTitleString: "LOGOUT".localized(), cancelTitleString: "CANCEL".localized())
        
    }

}

//MARK: - UITableView Delegate and DataSource
extension SettingViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.lblTitle.text = self.arrTitle[indexPath.row]
        cell.imgView.image = UIImage(named: self.arrImage[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let profileVC = settingStoryboard.instantiateViewController(withIdentifier: "NBProfileVC") as! NBProfileVC
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else if indexPath.row == 1{
            let shortBioVC = settingStoryboard.instantiateViewController(withIdentifier: "BioViewController") as! BioViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(shortBioVC, animated: true)
        }else if indexPath.row == 2{
            let changePasswordVC = settingStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
        }else if indexPath.row == 3{
            let timingsVC = settingStoryboard.instantiateViewController(withIdentifier: "TimingsViewController") as! TimingsViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(timingsVC, animated: true)
        }else if indexPath.row == 4{
            let expertiseVC = settingStoryboard.instantiateViewController(withIdentifier: "NBSpecializationVC") as! NBSpecializationVC
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(expertiseVC, animated: true)
        }else if indexPath.row == 5{
            let languageVC = settingStoryboard.instantiateViewController(withIdentifier: "NBLanguageVC") as! NBLanguageVC
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(languageVC, animated: true)
        }else{
            let feedbackVC = settingStoryboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
}


// MARK: - AlertDelegate
extension SettingViewController: AlertDelegate{
    func alertCancelTapped(){
        if self.isLogout{
            self.isLogout = false
        }else{
            
        }
    }
    func alertOkTapped(){
        if self.isLogout{
            self.isLogout = false
            self.callLogOutApi()
        }else{
            
        }
    }
}

extension SettingViewController{
    func callLogOutApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kLogOut
        let requestDict = ["available": false] as [String : Any]
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            
            //Unsubscribe to Socket
            kAppDelegate.notficationChannel.unsubscribe()
            kAppDelegate.webClient.disconnect()
            
            //Clear UserDefault
            clearUserDefault()
            
            //Open Login Screen
            let loginVC = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
