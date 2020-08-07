//
//  ChatListWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 18/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

struct ChatHomeListModel {
    var userData: HomeUsers?
    var messageData: LastMessage?
    var data: HomeData?
}

// MARK: - Webservice
extension NBChatListVC{
    func callGetChatSessionApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChatSession
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) {
            (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(NBChatListModel.self, from: response?.data ?? Data())
                    self.chatListModel = data
                    if self.chatListModel != nil{
                        if self.chatListModel.data != nil{
                            if self.chatListModel.data!.count > 0{
                                var emptyLastMessageModel: [HomeData] = []
                                var tempModel: [HomeData] = []
                                for model in self.chatListModel.data!{
                                    if let _ = model.attributes!.last_message{
                                        tempModel.append(model)
                                    }else{
                                        var tempModel = model
                                        tempModel.lastMessageTimestamp = "\(Date())"
                                        emptyLastMessageModel.append(tempModel)
                                    }
                                }
                                tempModel.sort { ($0 as HomeData).attributes!.last_message!.data!.attributes!.created_at! > ($1 as HomeData).attributes!.last_message!.data!.attributes!.created_at! }
                                let newArrayModel = emptyLastMessageModel + tempModel
                                self.chatListModel.data = newArrayModel
                            }
                        }
                    }
                    
                    self.chatHomeListModel = self.getModelForSearch(mainModel: self.chatListModel)
                    
                    if self.chatListModel.data!.count > 0{
                        let arrayDelayMessage = getDelayMessageData()
                        for delayDict in arrayDelayMessage{
                            if self.chatHomeListModel.count > 0{
                                for i in 0...self.chatHomeListModel.count - 1{
                                    var model = self.chatHomeListModel[i].data!
                                    if model.id == delayDict["roomId"] as? String{
                                        model.delayResponse = delayDict["isDelay"] as? Bool
                                        self.chatHomeListModel[i].data! = model
                                    }else{
                                        
                                    }
                                }
                            }
                        }
                        
                        var arrayNewMessage = getNewMessageData()
                        arrayNewMessage.sort{ ($0["newMessageCount"] as! Int) > ($1["newMessageCount"] as! Int) }
                        print(arrayNewMessage)
                        for newMessageDict in arrayNewMessage{
                            if self.chatHomeListModel.count > 0{
                                for i in 0...self.chatHomeListModel.count - 1{
                                    var model = self.chatHomeListModel[i].data!
                                    if model.id == newMessageDict["roomId"] as? String{
                                        model.newMessageCount = newMessageDict["newMessageCount"] as? Int
                                        model.lastMessage = newMessageDict["lastMessage"] as? String
                                        model.lastMessageTimestamp = newMessageDict["lastMessageTimestamp"] as? String
                                        self.chatHomeListModel[i].data! = model
                                    }else{
                                        
                                    }
                                }
                            }
                        }
                        
//                        if self.chatHomeListModel != nil{
                            if self.chatHomeListModel.count > 0{
                                self.chatHomeListModel.sort { (($0 as ChatHomeListModel).data!.lastMessageTimestamp ?? "\(Date())") > (($1 as ChatHomeListModel).data!.lastMessageTimestamp ?? "\(Date())")}
                            }
//                        }
                    }else{
                    }
                    self.table_view.reloadData()
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    //MARK: - GET PROFILE DATA
    func callGetProfileApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    setProfileModel(model: responseModel)
                    self.callGetChatSessionApi()
                } catch let error {
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callSearchAPI(searchString: String){
        
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChatListSearch + searchString
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let searchData = try self.JSONdecoder.decode(NBChatListModel.self, from: response?.data ?? Data())
                    self.searchActive = true
                    var arrayOfUserModel: [ChatHomeListModel] = []
                    if searchData.data != nil && searchData.data!.count > 0{
                        self.lblNoRecord.isHidden = true
                        if let dataModel = searchData.data{
                            for i in 0...dataModel.count - 1{
                                var chatHomeListModel = ChatHomeListModel()
                                let model = dataModel[i]
                                chatHomeListModel.data = model
                                for j in 0...model.attributes!.users!.count - 1{
                                    let userModel = model.attributes!.users![j]
                                    if getLoggedInUserId() == userModel.data!.id!{
                                    }else{
                                        chatHomeListModel.userData = userModel
                                    }
                                }
                                if let messageModel = model.attributes!.last_message{
                                    chatHomeListModel.messageData = messageModel
                                }
                                arrayOfUserModel.append(chatHomeListModel)
                            }
                        }else{
                            
                        }
                    }else{
                        self.lblNoRecord.isHidden = false
                    }
                    self.filteredModel = arrayOfUserModel
                    self.table_view.reloadData()
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
        
    }
    
}
