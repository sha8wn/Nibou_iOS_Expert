//
//  BioWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 03/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension BioViewController{
    
    //MARK: - GET PROFILE DATA
    func callGetProfileApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    
                    guard let shortBio = responseModel.data!.attributes!.short_bio else{ return }
                    
                    self.txtMessage.text = shortBio
                    
                    if shortBio != ""{
                        self.txtMessage.textColor = UIColor(named: "Blue_Color")
                    }
                    
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
    func callUpdateProfileApi(shortBio: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kUpdateProfile
        
        let requestDict = ["short_bio"           : "\(shortBio)",
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    
                    print(responseModel)
                    
                    self.isEditSuccesfully = true
                    self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "PROFILE_UPDATE_SUCCESSFULLY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    func callUpdateBookmarkAPI(text: String, messageId: String, roomId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + String(format: kUpdateBookmark, roomId)
        let requestDict = ["message_id"    : "\(messageId)",
                           "text"          : "\(text)"
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.isEditSuccesfully = true
                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "BOOKMARK_UPDATE_SUCCESSFULLY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
}

