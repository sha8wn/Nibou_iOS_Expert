//
//  NBSpecializationWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 24/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension NBSpecializationVC{
    
    func callGetSpecializationListAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetExpertiesList
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(LanguageModel.self, from: response?.data ?? Data())
                    if responseModel.data != nil{
                        self.arrayOfAvaiableSpecialization = responseModel.data!
                        self.arrSpecialization = []
                        if responseModel.data!.count > 0{
                            for model in responseModel.data!{
                                self.arrSpecialization.append(model.attributes!.title!)
                            }
                        }else{
                            self.arrSpecialization = []
                        }
                    }else{
                        self.arrSpecialization = []
                    }
                    self.callGetSpecializationApi()
                } catch let error {
                    self.arrSpecialization = []
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.arrSpecialization = []
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    //MARK: - GET PROFILE DATA
    func callGetSpecializationApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile + "?include=expertises"
        
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

                                for j in 0...self.arrSpecialization.count - 1{
                                    if self.arrSpecialization[j] == model.attributes!.title!{
                                        self.arrSpecialization.remove(at: j)
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
        
        let requestDict = ["expertise_ids" : languageArray,
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                if isDelete{
                    self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "SPECIALIZATION_ADDED_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "SPECIALIZATION_UPDATE_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
                self.callGetSpecializationListAPI()
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
