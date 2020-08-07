//
//  NBChatWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//MARK: - Webservice extenstion of NBChatViewController
extension NBChatVC{
    
    /// This function is used to Send Message to server
    ///
    /// - Parameters:
    ///   - roomId: RoomId
    ///   - fileData: Array of Selected Image in Data format
    ///   - fileName: Array of Selected Image File Name
    ///   - paramsArray: Array of Selected Image Server Key Name
    ///   - mineType: Array of Selected Image Mine Type
    ///   - requestDict: Request Dictinory
    func callSendMessageAPi(roomId: String, fileData: [Data]?, fileName: [String]?, paramsArray: [String]?, mineType: [String]?, requestDict: [String: Any]? = nil){
        
        let urlPath = kBaseURL + kChatSendMessage + roomId
        
        Network.shared.multipartRequest(urlPath: urlPath, methods: .post, paramName: paramsArray, fileData: fileData, fileName: fileName, mineType: mineType, uploadDict: requestDict) { (response, message, statusCode, status) in
            if status == .Success{
                self.textView_message.text = ""
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    //end -------------------------------------------------
    
    
    /// This function is used to Call Chat History API for a Room Id
    ///
    /// - Parameter roomId: Room Id
    func callGetChatHistory(roomId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetChatHistory + roomId
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let chatModel = try self.JSONdecoder.decode(ChatHistoryModel.self, from: response?.data ?? Data())
                    
                    //Set Chat Data in Realm Database
                    self.setDataInDatabase(model: chatModel, roomId: self.roomId)
                    
//                    self.callGetRoomDetailApi(roomId: self.roomId)
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    //end -------------------------------------------------
    
    /// This function is used to Call Chat Bookmarks API for a Room Id
    ///
    /// - Parameter roomId: Room Id
    func callGetBookmarksAPI(roomId: String){
        self.showLoader(message: "LOADING".localized())
//        let urlPath = kBaseURL + String(format: kGetBookmark, roomId)
        let urlPath = kBaseURL + String(format: kGetBookmark, self.expertId)
        
        
        //Delete Previous Data from Realm Database
        self.deleteDataFromDatabase(roomId: roomId)
        self.deleteDataFromDatabase_Bookmark(roomId: roomId)
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let bookModel = try self.JSONdecoder.decode(ChatBookmarksModel.self, from: response?.data ?? Data())
                    
                    //Set Bookmarks if Bookmarks Data isn't empty
                    if bookModel.data!.count > 0{
                        self.setUpBookmarked(model: bookModel)
                    }
                    
                    //Call Chat History API
                    self.callGetChatHistory(roomId: self.roomId)
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    //end -------------------------------------------------
    
    
    func callGetRoomDetailApi(roomId: String, isPrivate: Bool){
           self.showLoader(message: "LOADING".localized())
           let urlPath = kBaseURL + kGetRoomDetails + roomId
           Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
               self.hideLoader()
               if status == .Success{
                   print("ROOM:\(roomId)")
                   self.isRoomFound = true
                   self.callService(isPrivate: isPrivate)
               }else{
                   self.isRoomFound = false
                   self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "CHAT_SESSION_ALREADY_ENDED".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
               }
           }
       }
}
