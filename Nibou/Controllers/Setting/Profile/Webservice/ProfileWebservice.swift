//
//  ProfileWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 03/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension NBProfileVC{
    
    //MARK: - GET PROFILE DATA
    func callGetProfileApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    
                    guard let userName = responseModel.data!.attributes!.name else{ return }

                    guard let email = responseModel.data!.attributes!.email else{ return }

                    if let country = responseModel.data!.attributes!.country{
                        self.dataDict!["country"] = country
                    }else{
                        self.dataDict!["country"] = ""
                    }
                    
                    if let city = responseModel.data!.attributes!.city{
                        self.dataDict!["city"] = city
                    }else{
                        self.dataDict!["city"] = ""
                    }
     
                    if let pdfDict = responseModel.data!.attributes!.pdf{
                        if let url = pdfDict.url{
                            self.pdfURL = kBaseURL + url
                        }else{
                            self.pdfURL = ""
                        }
                    }else{
                        self.pdfURL = ""
                    }
                    
                    if let profilePicURL = responseModel.data!.attributes!.avatar!.url{
                        self.profileImageURL = kBaseURL + profilePicURL
                    }else{
                        self.profileImageURL = ""
                    }
                    
                    
                    self.strEmail = email

                    self.dataDict!["name"] = userName
                    
                    self.table_view.reloadData()
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    
    //MARK: - UPDATE PROFILE DATA
    func callUpdateProfileApi(fileData: [Data]?, fileName: [String]?, paramsArray: [String]?, mineType: [String]?, requestDict: [String: Any]? = nil){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kUpdateProfile

        Network.shared.multipartRequest(urlPath: urlPath, methods: .put, paramName: paramsArray, fileData: fileData, fileName: fileName, mineType: mineType, uploadDict: requestDict) { (response, message, statusCode, status) in
            
            self.hideLoader()
            if status == .Success{
                self.isEditSuccessfully = true
                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "PROFILE_UPDATE_SUCCESSFULLY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    func callDeletePDFApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kUpdateProfile

        let requestDict = ["remove_pdf"      : true
            ] as [String : Any]
        
        Network.shared.multipartRequest(urlPath: urlPath, methods: .put, paramName: nil, fileData: nil, fileName: nil, mineType: nil, uploadDict: requestDict) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.isDeletePDFSuccessfully = true
                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "SUCCESS_DELETE_PDF".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}

