//
//  ChatWebSocket.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift


//MARK: - Websocket extension of NBChat ViewController
extension NBChatVC {
    
    /// This function is the Set up Action Cabel Websocket and also Receive Message message.
    func setUpWebSocket(roomId: String){
        
        let accessTokenModel = getAccessTokenModel()
        
        let webURL = kWebSocketURL + "?access_token=" + "\(accessTokenModel.accessToken)"

        self.webClient = ActionCableClient(url: URL(string: webURL)!)
        
        self.webClient.willConnect = {
            print("Will Connect")
        }
        
        self.webClient.onConnected = {
            print("Connected to \(self.webClient.url)")
        }
        
        self.webClient.onDisconnected = {(error: ConnectionError?) in
            print("Disconected with error: \(String(describing: error))")
        }
        
        self.webClient.willReconnect = {
            print("Reconnecting to \(self.webClient.url)")
            return true
        }
  
        let roomChannel = webClient.create("ChatChannel", identifier: ["rid" : "\(self.roomId)"], autoSubscribe: true, bufferActions: true)

        roomChannel.subscribe()

        roomChannel.onSubscribed = {
            print("Subscribed to \(String(describing: roomChannel.identifier))")
        }
        
        // A channel was unsubscribed, either manually or from a client disconnect.
        roomChannel.onUnsubscribed = {
            print("Unsubscribed")
        }
        
        // The attempt at subscribing to a channel was rejected by the server.
        roomChannel.onRejected = {
            print("Rejected")
        }

        //Receive Data from Action Cabel Websocket
        roomChannel.onReceive = { (JSON : Any?, error : Error?) in
            print("Received Chat WS Notification: ", JSON, error)
            DispatchQueue.main.async {
                guard let dict = JSON as? NSDictionary else { return }
                var data: Data!
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    data = jsonData
                }catch let error{
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
                do {
                    let responseChatModel = try self.JSONdecoder.decode(ChatSendModel.self, from: data)
                    if responseChatModel.data != nil{
                        var needUpdate: Bool = true
                        if self.chatModel != nil && self.chatModel.count > 0{
                            let listModel: List<ChatData> = self.chatModel[0].data
                            for i in 0..<listModel.count{
                                let model: ChatData! = listModel[i]
                                if model.chatId == responseChatModel.data!.id!{
                                    needUpdate = false
                                    break
                                }else{
                                }
                            }
                        }
                        
                        if needUpdate{
                            if responseChatModel.data!.attributes!.from_user_id! == Int(getLoggedInUserId()){
                                self.textView_message.text = ""
                            }
                            self.view.layoutIfNeeded()
                            self.view.layoutSubviews()
                            self.view.setNeedsUpdateConstraints()
                            self.updateDataInDatabase(model: responseChatModel, roomId: self.roomId)
                        }else{
                            
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
        self.webClient.connect()
    }
}
