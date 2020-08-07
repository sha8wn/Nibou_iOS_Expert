//
//  BioViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class BioViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var txtMessage           : UITextView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var btnSave              : UIButton!
    @IBOutlet weak var btnBack              : UIButton!
    var isOpenFrom                          : String!       = ""
    var strMessage                          : String!       = ""
    var messageId                           : String!       = ""
    var roomId                              : String!       = ""
    var attributedString                    : NSMutableAttributedString!
    var isEditSuccesfully                   : Bool          = false
    //end
    
    //MARK: - UIViewController Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        if self.isOpenFrom == "Chat"{
            
        }else{
            self.callGetProfileApi()
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.txtMessage.delegate = self
        self.txtMessage.textContainer.lineFragmentPadding = 10
//        self.txtMessage.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.txtMessage.isScrollEnabled = true
        
        if self.isOpenFrom == "Chat"{
            self.lblHeader.text = "Highlight"
            self.txtMessage.textColor = UIColor(named: "Blue_Color")
            self.attributedString = NSMutableAttributedString(string: self.strMessage, attributes: [NSAttributedString.Key.font : UIFont(name: "Ubuntu-Medium", size: 16.0)!,
                                                                                                    NSAttributedString.Key.foregroundColor : UIColor(named: "Blue_Color")!])
            self.lblDesc.text = "Highlight important points from this chat"
            self.txtMessage.attributedText = self.attributedString
            self.txtMessage.isEditable = false
        }else{
            self.lblHeader.text = "SHORT_BIO".localized()
            self.txtMessage.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
            self.lblDesc.text = "SHORT_BIO_DESC".localized()
            self.txtMessage.text = "ENTER_BIO".localized()
            self.txtMessage.isEditable = true
        }
//        self.txtMessage.textColor = UIColor(named: "Blue_Color")
//        let highlightMenuItem = UIMenuItem(title: "Highlight", action: #selector(self.highlight))
//        UIMenuController.shared.menuItems = [highlightMenuItem]
//        let sysVer = Float(UIDevice.current.systemVersion) ?? 0.0
//        if sysVer >= 8.0 {
//            self.txtMessage.layoutManager.allowsNonContiguousLayout = false
//        }
        
        self.btnSave.setTitle("SAVE".localized(), for: .normal)
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
    @IBAction func btnSaveTapped(_ sender: Any) {
        if self.txtMessage.text.count > 0{
            if self.isOpenFrom == "Chat"{
                guard  let textRange = self.txtMessage.selectedTextRange else { return }
                let range = self.txtMessage.selectedRange
                let selectedText = self.txtMessage.text(in: textRange)
                self.attributedString.addAttribute(.backgroundColor, value: UIColor.gray, range: range)
                self.txtMessage.attributedText = attributedString
                if selectedText == ""{
                    self.callUpdateBookmarkAPI(text: self.txtMessage.text, messageId: self.messageId, roomId: self.roomId)
                }else{
                    self.callUpdateBookmarkAPI(text: selectedText ?? "", messageId: self.messageId, roomId: self.roomId)
                }
            }else{
                self.callUpdateProfileApi(shortBio: self.txtMessage.text)
            }
        }else{
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: "EMPTY_SHORT_BIO".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
        
        
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITextView Delegate
extension BioViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Placeholder_Light_Blue_Color") {
            textView.text = nil
            textView.textColor = UIColor(named: "Blue_Color")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your Bio"
            textView.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
        }
    }
    
//    @objc func highlight() {
//        let selectedTextRange: NSRange = self.txtMessage.selectedRange
//        self.attributedString.addAttribute(.backgroundColor, value: UIColor(named: "Blue_Color")!, range: selectedTextRange)
//        self.attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: selectedTextRange)
//        let sysVer = Float(UIDevice.current.systemVersion) ?? 0.0
//        if sysVer < 8.0 {
//            // iOS 7 fix
//            self.txtMessage.isScrollEnabled = false
//            self.txtMessage.attributedText = attributedString
//            self.txtMessage.isScrollEnabled = true
//        } else {
//            self.txtMessage.attributedText = attributedString
//        }
//    }
    
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        guard  let textRange = textView.selectedTextRange else { return }
//        let range = textView.selectedRange
//        let selectedText = textView.text(in: textRange)
//        self.attributedString.addAttribute(.backgroundColor, value: UIColor.gray, range: range)
//        textView.attributedText = attributedString
//    }
//
    
    
}


extension BioViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isEditSuccesfully{
            self.isEditSuccesfully = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}


