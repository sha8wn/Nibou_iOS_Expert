//
//  LoginWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 27/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension LogInViewController{
    
    func callAccessTokenApi(emailAddress: String, password: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kAccessToken + "?grant_type=password&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&username=" + emailAddress + "&password=" + password + "&account_type=0"
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
            self.hideLoader()
            
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(LoginModel.self, from: response?.data ?? Data())
                    print("Success")
                    print(data.accessToken)
                    setAccessTokenModel(model: data)
                    
                    kAppDelegate.setUpWebSocket()
                    
                    self.callSaveDeviceAPI()
                    let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "NBTabbar") as! NBTabbar
                    let window = kAppDelegate.window
                    window?.rootViewController = tabBarController
                    window?.makeKeyAndVisible()
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    func callSaveDeviceAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kSaveDeviceToken
        let accessToken = getAccessTokenModel()
        let requestDict = ["devise_id" : kAppDelegate.kdeviceIdValueKey,
                           "firebase_token" : kAppDelegate.kdeviceFCMToken ?? "simulator",
                           "devise_description" : "iOS"
        ]
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            
            if status == .Success{
                print(response)
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
}
