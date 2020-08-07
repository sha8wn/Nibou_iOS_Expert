//
//  AppDelegateWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 10/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension AppDelegate{

    func callSplashScreenApi(completion:@escaping (_ status: WebServiceResponseType) -> Void){
     
        let urlPath = kBaseURL + kUpdateProfile
        
        let requestDict = ["timezone"           : "\(TimeZone.current.identifier)",
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
      
            if status == .Success{
                do {
                    let JSONdecoder = JSONDecoder()
                    let responseModel = try JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    print(responseModel)
                    setProfileModel(model: responseModel)
                    completion(status)
                } catch let error {
                    completion(status)
                    print(error.localizedDescription)
                }
            }else{
                completion(.Failure)
                print("SOMETHING_WENT_WRONG")
            }
        }
    }
    
    func callSendMessageAPi(roomId: String, fileData: [Data]?, fileName: [String]?, paramsArray: [String]?, mineType: [String]?, requestDict: [String: Any]? = nil){
        
        let urlPath = kBaseURL + kChatSendMessage + roomId
        
        Network.shared.multipartRequest(urlPath: urlPath, methods: .post, paramName: paramsArray, fileData: fileData, fileName: fileName, mineType: mineType, uploadDict: requestDict) { (response, message, statusCode, status) in
            
            print(status)
            
        }
    }
    
}

