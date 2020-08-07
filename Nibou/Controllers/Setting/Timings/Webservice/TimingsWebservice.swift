//
//  TimingsWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 23/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension TimingsViewController{
    
    func callGetTimingsAPi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetTimings
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(TimingsModel.self, from: response?.data ?? Data())
                    print(responseModel)
                    if responseModel.data!.count > 0 || responseModel.data != nil{
                        self.updateTimingModelArray(arrayOfTimingsData: responseModel.data!)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    
    func callAddTimingAPI(dayNumber: Int, startTime: String, endTime: String){
        
        self.dispatchGroup.enter()
        
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetTimings
        let requestDict = ["day_number"    : dayNumber,
                           "time_from"     : startTime,
                           "time_to"       : endTime
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.dispatchGroup.leave()
            }else{
                self.isError = true
                self.dispatchGroup.leave()
            }
        }
    }
    
    func callUpdateTimingAPI(timingId: String, dayNumber: Int, startTime: String, endTime: String){
        
        self.dispatchGroup.enter()
        
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetTimings + "/" + timingId
        let requestDict = ["day_number"    : dayNumber,
                           "time_from"     : startTime,
                           "time_to"       : endTime
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.dispatchGroup.leave()
            }else{
                self.isError = true
                self.dispatchGroup.leave()
            }
        }
    }
    
    func callDeleteTimingAPI(timingId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetTimings + "/" + timingId
        Network.shared.request(urlPath: urlPath, methods: .delete, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.isDeleteSuccess = true
                self.showAlert(viewController: self, alertTitle: "SUCCESS".localized(), alertMessage: "TIMINGS_DELETED_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
}
