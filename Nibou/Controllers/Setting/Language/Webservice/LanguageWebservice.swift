//
//  LanguageWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 06/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension NBLanguageVC{
    
    func callGetLanguageListAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetLanguageList
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(LanguageModel.self, from: response?.data ?? Data())
                    if responseModel.data != nil{
                        self.arrayOfAvaiableLanguages = responseModel.data!
                        self.arrLanguage = []
                        if responseModel.data!.count > 0{
                            for model in responseModel.data!{
                                self.arrLanguage.append(model.attributes!.title!)
                            }
                        }
                    }else{
                        self.arrLanguage = []
                    }
                    self.callGetLanguagesApi()
                } catch let error {
                    self.arrLanguage = []
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.arrLanguage = []
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    //MARK: - GET PROFILE DATA
    func callGetLanguagesApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile + "?include=languages"
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    if responseModel.language != nil{
                        self.arrayOfData = responseModel.language!
                        if responseModel.language!.count > 0{
                            self.array_Language = []
                            for i in 0...responseModel.language!.count - 1{
                                let model = responseModel.language![i]
                                var subModel = LocalLanguageModel()
                                subModel.id = model.id!
                                subModel.language = model.attributes!.title!
                                subModel.isEmpty = false
                                subModel.isDelete = false
                                self.array_Language.append(subModel)
                                
                                for j in 0...self.arrLanguage.count - 1{
                                    if self.arrLanguage[j] == model.attributes!.title!{
                                        self.arrLanguage.remove(at: j)
                                        break
                                    }
                                }
                            }
                            self.btnSaveDelete.isHidden = true
                        }else{
                            self.btnSaveDelete.setTitle("SAVE_BTN".localized(), for: .normal)
                            self.btnSaveDelete.isHidden = false
                        }
                    }else{
                        self.btnSaveDelete.setTitle("SAVE_BTN".localized(), for: .normal)
                        self.btnSaveDelete.isHidden = false
                    }
                    self.calculateHeightForTable()
                    self.table_View.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    

    //MARK: - UPDATE LANGUAGE DATA
    func callUpdateProfileApi(languageArray: [Int], isDelete: Bool){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kUpdateProfile

        let requestDict = ["language_ids" : languageArray,
            ] as [String : Any]


        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                if isDelete{
                    self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "LANGUAGE_DELETED_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "LANGUAGE_UPDATED_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
                self.callGetLanguageListAPI()
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
