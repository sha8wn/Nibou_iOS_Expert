//
//  WebViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController, UIWebViewDelegate {

    /*
     MARK: - Properties
    */
    @IBOutlet var btnBack       : UIButton!
    @IBOutlet var lblHeader     : UILabel!
    @IBOutlet var webView       : UIWebView!
    var urlString               : String!
    
    //end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        if isValidUrl(urlString: urlString){
            self.showLoader(message: "LOADING".localized())
            let url = URL(string: self.urlString!)
            self.webView.loadRequest(URLRequest(url: url!))
        }else{
            self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton,singleButtonTitle: "OK".localized())
            
        }
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.hideLoader()
        self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton,singleButtonTitle: "OK".localized())
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.hideLoader()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Extension of CustomPopUpDelegate
/**
 This confirms the delegate function of CustomPopUpDelegate
 */
extension WebViewController: AlertDelegate{
    func alertCancelTapped() {
        self.hideLoader()
    }
    
    func alertOkTapped() {
        self.hideLoader()
    }
}
