//
//  NBProfileVC.swift
//  Nibou
//
//  Created by Ongraph on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import SDWebImage

class NBProfileVC: BaseViewController {

    //MARK:- Properties
    @IBOutlet weak var table_view   : UITableView!
    @IBOutlet weak var lblHeader    : UILabel!
    @IBOutlet weak var btnSave      : UIButton!
    var txtFullName                 : CustomTextField!
    var txtCity                     : CustomTextField!
    var dataDict                    : [String: Any]?   = [:]
    var strEmail                    : String           = ""
    var profileImageURL             : String           = ""
    var pdfURL                      : String           = ""
    var pdfData                     : Data!
    var profileImage                : UIImage!
    var imagePicker                 : UIImagePickerController   = UIImagePickerController()
    var isEditSuccessfully          : Bool                      = false
    var isDeletePDF                 : Bool                      = false
    var isDeletePDFSuccessfully     : Bool                      = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.callGetProfileApi()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        
        self.lblHeader.text = "PROFILE".localized()
        
        self.dataDict = ["name"     : "",
                         "country"  : "",
                         "city"     : ""
        ]
        
        self.table_view.estimatedRowHeight = 80
        
        self.table_view.register(UINib(nibName: "HeaderWithImageTableCell", bundle: nil), forCellReuseIdentifier: "HeaderWithImageTableCell")
        self.table_view.register(UINib(nibName: "TextWithBGTableViewCell", bundle: nil), forCellReuseIdentifier: "TextWithBGTableViewCell")
        self.table_view.register(UINib(nibName: "NBFooterWithButtonTableCell", bundle: nil), forCellReuseIdentifier: "NBFooterWithButtonTableCell")
        
        self.btnSave.setTitle("SAVE".localized(), for: .normal)
    }

    //MARK: - Validate Form
    private func getValidate() -> (Bool, String){
        self.getCellValue()
        var error : (Bool, String) = (false, "")
        if(self.dataDict!["name"] as! String == ""){
            error = (false, "USER_NAME_EMPTY".localized())
        }
        else if(self.dataDict!["country"] as! String == ""){
            error = (false, "COUNTRY_EMPTY".localized())
        }
        else if(self.dataDict!["city"] as! String == ""){
            error = (false, "CITY_EMPTY".localized())
        }
        else{
            error = (true, "")
        }
        return error
    }
    //end
    
    //MARK:- Button Action
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_saveAction(_ sender: Any) {
  
        let (isValidate, errorMessage) = self.getValidate()
        if isValidate{
         
            var dataArray: [Data] = []
            var fileNameArray: [String] = []
            var paramsArray: [String] = []
            var mineTypeArray: [String] = []
            
            if self.pdfData != nil{
                dataArray.append(self.pdfData)
                fileNameArray.append("Expert_Profile.pdf")
                paramsArray.append("pdf")
                mineTypeArray.append("application/pdf")
            }

            if self.profileImage != nil{
                let imageData = self.profileImage.jpegData(compressionQuality: 0.5)
                dataArray.append(imageData!)
                fileNameArray.append("Expert_Profile_Pic.jpeg")
                paramsArray.append("avatar")
                mineTypeArray.append("image/jpeg")
                
            }
            
            if self.pdfData == nil{
                if self.profileImage == nil{
                     self.callUpdateProfileApi(fileData: nil, fileName: nil, paramsArray: nil, mineType: nil, requestDict: self.dataDict)
                }else{
                     self.callUpdateProfileApi(fileData: dataArray, fileName: fileNameArray, paramsArray: paramsArray, mineType: mineTypeArray, requestDict: self.dataDict)
                }
            }else{
                 self.callUpdateProfileApi(fileData: dataArray, fileName: fileNameArray, paramsArray: paramsArray, mineType: mineTypeArray, requestDict: self.dataDict)
            }
        }else{
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: errorMessage, alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
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

//MARK:- Extension SignUpVC of UITableView
extension NBProfileVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 4
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 140
        }else if indexPath.section == 1{
            return 60
        }else{
            return 115
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.table_view.separatorColor = UIColor.clear
        self.table_view.tableFooterView = UIView()
        
        if indexPath.section == 0{
            let headerCell : HeaderWithImageTableCell = tableView.dequeueReusableCell(
                withIdentifier: "HeaderWithImageTableCell", for: indexPath) as! HeaderWithImageTableCell
            headerCell.imgUserImage.contentMode = .scaleAspectFill
            headerCell.imgUserImage.image = self.profileImage ?? UIImage(named: "profile_icon_iPhone")
            headerCell.imgUserImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            if self.profileImage != nil{
                headerCell.imgUserImage.image = self.profileImage
            }else{
                if self.profileImageURL != ""{
                    headerCell.imgUserImage.sd_setImage(with: URL(string: self.profileImageURL), completed: nil)
                }else{
                    headerCell.imgUserImage.image = UIImage(named: "profile_icon_iPhone")
                }
            }
            
            
            headerCell.btnImagePicker.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
            return headerCell
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                let cell : TextWithBGTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithBGTableViewCell", for: indexPath) as! TextWithBGTableViewCell
                cell.txtField.setPlaceholder(placeholder: "FULL_NAME".localized(), color: UIColor.textfield2SepratorColor())
                cell.txtField.setLeftPaddingPoints(10.0)
                cell.txtField.text = self.dataDict!["name"] as? String
                cell.txtField.delegate = self
                self.txtFullName = cell.txtField
                return cell
            }else if indexPath.row == 1{
                let cell : TextWithBGTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithBGTableViewCell", for: indexPath) as! TextWithBGTableViewCell
                cell.txtField.setLeftPaddingPoints(10.0)
                cell.txtField.setPlaceholder(placeholder: "EMAIL_ADDRESS".localized(), color: UIColor.textfield2SepratorColor())
                cell.txtField.alpha = 0.5
                cell.txtField.text = self.strEmail
                return cell
            }else if indexPath.row == 2{
                let cell : TextWithBGTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithBGTableViewCell", for: indexPath) as! TextWithBGTableViewCell
                cell.txtField.setLeftPaddingPoints(10.0)
                cell.txtField.isUserInteractionEnabled = false
                cell.txtField.setPlaceholder(placeholder: "COUNTRY".localized(), color: UIColor.textfield2SepratorColor())
                cell.txtField.text = self.dataDict!["country"] as? String
                return cell
            }else{
                let cell : TextWithBGTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithBGTableViewCell", for: indexPath) as! TextWithBGTableViewCell
                cell.txtField.setLeftPaddingPoints(10.0)
                cell.txtField.setPlaceholder(placeholder: "CITY".localized(), color: UIColor.textfield2SepratorColor())
                cell.txtField.text = self.dataDict!["city"] as? String
                cell.txtField.delegate = self
                self.txtCity = cell.txtField
                return cell
            }
        }else{
            let footerCell : NBFooterWithButtonTableCell = tableView.dequeueReusableCell(
                withIdentifier: "NBFooterWithButtonTableCell", for: indexPath) as! NBFooterWithButtonTableCell
            if self.pdfURL == ""{
                footerCell.btnUploadAndViewPdf.setTitle("UPLOAD_PDF".localized(), for: .normal)
                footerCell.btnDelete.isHidden = true
            }else{
                footerCell.btnUploadAndViewPdf.setTitle("VIEW_PDF".localized(), for: UIControl.State.normal)
                footerCell.btnDelete.setTitle("DELETE".localized(), for: .normal)
                footerCell.btnDelete.isHidden = false
                footerCell.btnDelete.addTarget(self, action: #selector(btnDeletePDFTapped(sender:)), for: .touchUpInside)
            }
            footerCell.btnUploadAndViewPdf.addTarget(self, action: #selector(btnUploadAndViewPDFTApped(sender:)), for: .touchUpInside)
            
            return footerCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 2{
                self.view.endEditing(true)
                let countryView = CountrySelectView.shared
                countryView.barTintColor = .black
                countryView.displayLanguage = .english
                countryView.searchBarPlaceholder = "SEARCH".localized()
                countryView.show()
                countryView.selectedCountryCallBack = { (countryDic) -> Void in
                    self.dataDict!["country"] = "\(countryDic["en"] as! String)"
                    self.table_view.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
                }
            }
        }
    }

    @objc func openImagePicker(sender: UIButton){
        self.presentPicker()
    }
    
    @objc func btnUploadAndViewPDFTApped(sender: UIButton){
        if sender.titleLabel?.text == "VIEW_PDF".localized(){
            self.openWebView(urlString: self.pdfURL)
        }else{
            let types: [String] = [kUTTypePDF as String]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
            documentPicker.allowsMultipleSelection = false
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }
        
    }
    
    @objc func btnDeletePDFTapped(sender: UIButton){
        self.isDeletePDF = true
        self.showAlert(viewController: self, alertTitle: "", alertMessage: "DELETE_PDF".localized(), alertType: AlertType.twoButton, okTitleString: "OK".localized(), cancelTitleString: "CANCEL".localized())
        
    }
    
    func getCellValue(){
        let indexPath1 = IndexPath(row: 0, section: 1)
        if let cell = self.table_view.cellForRow(at: indexPath1) as? TextTableViewCell {
            self.txtFullName.text = cell.txtField.text!
        }
     
        let indexPath2 = IndexPath(row: 2, section: 1)
        if let cell = self.table_view.cellForRow(at: indexPath2) as? TextTableViewCell{
            self.txtCity.text = cell.txtField.text!
        }
    }
    
}

/**
 MARK: - Extension Profile of UITextFieldDelegate
 */
extension NBProfileVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtFullName{
            self.dataDict!["name"] = textField.text!
        }else if textField == self.txtCity{
            self.dataDict!["city"] = textField.text!
        }else{
            
        }
    }
}
//end

extension NBProfileVC: AlertDelegate{
    func alertOkTapped() {
        if self.isEditSuccessfully{
            self.isEditSuccessfully = false
            self.navigationController?.popViewController(animated: true)
        }else if self.isDeletePDF{
            self.isDeletePDF = false
            self.pdfURL = ""
            self.callDeletePDFApi()
        }else if self.isDeletePDFSuccessfully{
            clearUserDefault()
            self.isDeletePDFSuccessfully = false
            self.pdfURL = ""
            self.table_view.reloadData()
        }
    }
}


extension NBProfileVC:  UIDocumentPickerDelegate, UINavigationControllerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let data = try! Data(contentsOf: urls.first!)
        self.pdfData = data
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension NBProfileVC: UIImagePickerControllerDelegate {
    
    func presentPicker(){
        self.checkPermission()
        let alert: UIAlertController = UIAlertController(title: "CHOOSE_IMAGE".localized(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "CAMERA".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "GALLERY".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        self.imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open Camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //end
    
    //MARK: - Open Gallary
    func openGallary()
    {
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    //end
    
    
    private func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        default:
            print("")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return picker.dismiss(animated: true, completion: nil)
        }
        picker.dismiss(animated: true) {
            self.profileImage = image
            self.table_view.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
}

