//
//  AppDelegateExtension.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications


/**
 MARK: - AppDelegate extension
 */
extension AppDelegate
{
    /**
     MARK: - Project SetUp
     - This function is used to setup the project
    */
    func setUp(){
        IQKeyboardManager.shared.enable = true
        let model: LoginModel = getAccessTokenModel()
        print(model.accessToken)
        if self.checkCurrentLanguage(language: self.getLanguage()){
            if getLanguage() != getCurrentLanguage(){
                Localize.setCurrentLanguage(getLanguage())
                setCurrentLanguage(language: getLanguage())
                
                //Set Turkish As Default
//                Localize.setCurrentLanguage("tr")
//                setCurrentLanguage(language: "tr")
            }
            if model.accessToken != ""{
                self.callSplashScreenApi { (type) in
                    let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                    let rootViewController: NBTabbar = mainStoryboard.instantiateViewController(withIdentifier: "NBTabbar") as! NBTabbar
                    navigationController.viewControllers = [rootViewController]
                    navigationController.navigationBar.isHidden = true
                    self.window?.rootViewController = navigationController
                }
            }else{
                let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController: UIViewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as UIViewController
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
            }
        }else{
            if getCurrentLanguage() != ""{
                if getLanguage() != getCurrentLanguage(){
                    if self.checkCurrentLanguage(language: getLanguage()){
                        Localize.setCurrentLanguage(getLanguage())
                        setCurrentLanguage(language: getLanguage())
                        
                        //Set Turkish As Default
//                        Localize.setCurrentLanguage("tr")
//                        setCurrentLanguage(language: "tr")
                        
                        if model.accessToken != ""{
                            self.callSplashScreenApi { (type) in
                                let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                                let rootViewController: NBTabbar = mainStoryboard.instantiateViewController(withIdentifier: "NBTabbar") as! NBTabbar
                                navigationController.viewControllers = [rootViewController]
                                navigationController.navigationBar.isHidden = true
                                self.window?.rootViewController = navigationController
                            }
                        }else{
                            let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                            let rootViewController: UIViewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as UIViewController
                            navigationController.viewControllers = [rootViewController]
                            self.window?.rootViewController = navigationController
                        }
                    }else{
                        if model.accessToken != ""{
                            self.callSplashScreenApi { (type) in
                                let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                                let rootViewController: NBTabbar = mainStoryboard.instantiateViewController(withIdentifier: "NBTabbar") as! NBTabbar
                                navigationController.viewControllers = [rootViewController]
                                navigationController.navigationBar.isHidden = true
                                self.window?.rootViewController = navigationController
                            }
                        }else{
                            let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                            let rootViewController: UIViewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as UIViewController
                            navigationController.viewControllers = [rootViewController]
                            self.window?.rootViewController = navigationController
                        }
                    }
                }else{
                    let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                    let rootViewController: ChooseLanguageViewController = walkthroughStoryboard.instantiateViewController(withIdentifier: "ChooseLanguageViewController") as! ChooseLanguageViewController
                    navigationController.viewControllers = [rootViewController]
                    self.window?.rootViewController = navigationController
                }
            }else{
                let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController: UIViewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as UIViewController
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
            }
        }
    }
    
    /**
     MARK: - Get App Current Language
     - This function is used to get app language
     
     - Returns: Language Code String
     */
    func getLanguage() -> String{
        let prefferedLanguage = Locale.preferredLanguages[0]
        let code = prefferedLanguage.components(separatedBy: "-")
        return code.first ?? Locale.preferredLanguages[0]
    }
    
    /**
     MARK: - Check App Current Language
     - This function is used to check current language and compare that current language is English, Arabic and Turkish or not
     
     - Returns: Bool(Check current language is English, Arabic and Turkish or not)
     */
    func checkCurrentLanguage(language: String) -> Bool{
        if language == "en"{
            return true
        }else if language == "tr"{
            return true
        }else if language == "ar"{
            return true
        }else{
            return false
        }
    }
    
    func triggerLocalNotification(title: String? = "", subtitle: String? = "", body: String? = "", userInfo: [AnyHashable : Any]){
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.subtitle = subtitle ?? ""
        content.body = body ?? ""
        content.sound = .default
        content.badge = 0
        content.userInfo = userInfo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Nibou Expert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func handleWebSocketNotification(webSocketData: NSDictionary? = nil){
        var model: WebSocketNotificationModel!
        var data: Data!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: webSocketData!, options: .prettyPrinted)
            data = jsonData
        }catch let error{
            print(error.localizedDescription)
        }
        
        if let action = webSocketData?.value(forKey: "action") as? String{
            if action == "session_end"{
                self.triggerLocalNotification(title: "Nibou", subtitle: "CHAT_SESSION_END".localized(), body: "", userInfo: webSocketData as! [AnyHashable : Any])
                if let roomDict = webSocketData?.value(forKey: "room") as? NSDictionary{
                    if let roomData = roomDict.value(forKey: "data") as? NSDictionary{
                        if let roomId = roomData.value(forKey: "id") as? String{
                            let dict: [String: String] = ["roomId" : "\(roomId)"]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHATROOM_END".localized()), object: dict)
                        }
                    }
                }
            }else{
                do {
                    let notificationModel = try JSONDecoder().decode(WebSocketNotificationModel.self, from: data)
                    model = notificationModel
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        
        let state = UIApplication.shared.applicationState
        if model != nil{
            if model.action! == "new_chat_room"{
                if state == .background{
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEW_CHAT_ROOM_CREATED"), object: nil)
                }
                self.triggerLocalNotification(title: "Nibou", subtitle: "NEW_ROOM_CREATED".localized(), body: "CHAT_WITH_EXPERT".localized(), userInfo: webSocketData as! [AnyHashable : Any])
            }else if model.action! == "session_end"{
                self.triggerLocalNotification(title: "Nibou", subtitle: "CHAT_SESSION_END".localized(), body: "", userInfo: webSocketData as! [AnyHashable : Any])
                if state == .background{
                }else{
                    let dict: [String: String] = ["roomId" : "\(model.room!.data!.id!)"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHATROOM_END".localized()), object: dict)
                }
            }else if model.action! == "session_timeout"{
                if state == .background || state == .inactive{
                }else{
                    self.showAlert(alertTitle: "DELAYED_RESPONSE".localized(), alertMessage: String(format: "DELAYED_RESPONSE_MESSAGE".localized(), "\(model.timeout ?? "0")"), okTitleString: "OK".localized(), type: .sessionTimeout, model: model!)
                }
                
                var arrayDelayMessage = getDelayMessageData()
                var isUpdate: Bool  = false
                var indexToUpdate: Int = 0
                if arrayDelayMessage.count > 0{
                    for i in 0...arrayDelayMessage.count - 1{
                        var dictDelayMessage = arrayDelayMessage[i]
                        if dictDelayMessage["roomId"] as! String == "\(model.room!.data!.id!)"{
                            isUpdate = true
                            indexToUpdate = i
                        }else{
                            
                        }
                    }
                    if isUpdate{
                        var dictDelayMessage = arrayDelayMessage[indexToUpdate]
                        dictDelayMessage["isDelay"] = true
                        arrayDelayMessage[indexToUpdate] = dictDelayMessage
                        kUserDefault.removeObject(forKey: kNewMessage)
                        kUserDefault.synchronize()
                        setDelayMessageData(array: arrayDelayMessage)
                    }else{
                        let dict: [String: Any] = ["roomId" : "\(model.room!.data!.id!)",
                            "isDelay": true
                        ]
                        arrayDelayMessage.append(dict)
                        setDelayMessageData(array: arrayDelayMessage)
                    }
                }else{
                    let dict: [String: Any] = ["roomId" : "\(model.room!.data!.id!)",
                        "isDelay": true
                    ]
                    arrayDelayMessage.append(dict)
                    setDelayMessageData(array: arrayDelayMessage)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DELAY_RESPONSE"), object: nil)
            }else if model.action! == "user_offline"{
                
            }else if model.action! == "new_message"{
                var arrayNewMessage = getNewMessageData()
                var isUpdate: Bool  = false
                var indexToUpdate: Int = 0
                if arrayNewMessage.count > 0{
                    for i in 0...arrayNewMessage.count - 1{
                        var dictNewMessage = arrayNewMessage[i]
                        if dictNewMessage["roomId"] as! String == "\(model.room!.data!.id!)"{
                            isUpdate = true
                            indexToUpdate = i
                        }else{
                            
                        }
                    }
                    print("UPDATE: \(isUpdate)")
                    if isUpdate{
                        var dictNewMessage = arrayNewMessage[indexToUpdate]
                        if let lastMessageModel = model!.message{
                            if lastMessageModel.data!.attributes!.to_user_id ?? 0 == Int(getLoggedInUserId()){
                                dictNewMessage["newMessageCount"] = dictNewMessage["newMessageCount"] as! Int + 1
                                dictNewMessage["lastMessage"] = "\(lastMessageModel.data!.attributes!.text ?? "")"
                                dictNewMessage["lastMessageTimestamp"] = "\(lastMessageModel.data!.attributes!.created_at ?? "\(Date())")"
                                arrayNewMessage[indexToUpdate] = dictNewMessage
                                kUserDefault.removeObject(forKey: kNewMessage)
                                kUserDefault.synchronize()
                                setNewMessageData(array: arrayNewMessage)
                            }else{
                            }
                        }
                    }else{
                        if let lastMessageModel = model!.message{
                            if lastMessageModel.data!.attributes!.to_user_id ?? 0 == Int(getLoggedInUserId()){
                                let dict: [String: Any] = ["roomId" : "\(model.room!.data!.id!)",
                                    "newMessageCount": 1,
                                    "lastMessage": "\(lastMessageModel.data!.attributes!.text ?? "")",
                                    "lastMessageTimestamp": "\(lastMessageModel.data!.attributes!.created_at ?? "\(Date())")"
                                ]
                                arrayNewMessage.append(dict)
                                kUserDefault.removeObject(forKey: kNewMessage)
                                kUserDefault.synchronize()
                                setNewMessageData(array: arrayNewMessage)
                            }else{
                            }
                        }
                    }
                }else{
                    if let lastMessageModel = model!.message{
                        if lastMessageModel.data!.attributes!.to_user_id ?? 0 == Int(getLoggedInUserId()){
                            let dict: [String: Any] = ["roomId" : "\(model.room!.data!.id!)",
                                "newMessageCount": 1,
                                "lastMessage": "\(lastMessageModel.data!.attributes!.text ?? "")",
                                "lastMessageTimestamp": "\(lastMessageModel.data!.attributes!.created_at ?? "\(Date())")"
                            ]
                            arrayNewMessage.append(dict)
                            setNewMessageData(array: arrayNewMessage)
                        }else{
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEW_MESSAGE"), object: nil)
            }else if model.action! == "room_timer"{
                
            }
        }
    }
    
    func handlePushNotification(data: [AnyHashable : Any]? = nil){
        let dict = data as! [AnyHashable: Any]
        print(dict as! [String: Any])
        
        var isLocalNotification: Bool = false
        if let isLocal = dict["localNotification"] as? Bool{
            isLocalNotification = isLocal
        }else{
            isLocalNotification = false
        }
        
        if isLocalNotification == true{
            //HANDLE LOCAL NOTIFICATION
        }else{
            //HANDLE PUSH NOTIFICATION
            
            if dict["action"] as? String != nil{
                //Notification type
                let type = dict["action"] as! String
                if type == "new_chat_room"{
                    
                }else if type == "session_timeout"{
                    
//                    let roomId = dict["room_id"] as? String
//                    self.callSendMessageAPi(roomId: roomId ?? "", fileData: nil, fileName: nil, paramsArray: nil, mineType: nil, requestDict: ["text" : "END_SESSION"])
                    
                }else if type == "session_end"{
                    
                }else if type == "new_message"{
                    let roomId = dict["room_id"] as? String
                    
                    let message = dict["message"] as? String
                    if let data = message!.data(using: String.Encoding.utf8) {
                        do {
                            let messageDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                            let toUserId = messageDict!["to_user_id"] as? Int
                            let lastMessageDate = messageDict!["created_at"] as? String
                            let lastMessageText = messageDict!["text"] as? String
                            var arrayNewMessage = getNewMessageData()
                            var isUpdate: Bool  = false
                            var indexToUpdate: Int = 0
                            
                            if arrayNewMessage.count > 0{
                                for i in 0...arrayNewMessage.count - 1{
                                    var dictNewMessage = arrayNewMessage[i]
                                    if dictNewMessage["roomId"] as! String == "\(String(describing: roomId))"{
                                        isUpdate = true
                                        indexToUpdate = i
                                    }else{
                                        
                                    }
                                }
                                print("UPDATE: \(isUpdate)")
                                if isUpdate{
                                    var dictNewMessage = arrayNewMessage[indexToUpdate]
                                    if toUserId == Int(getLoggedInUserId()){
                                        dictNewMessage["newMessageCount"] = dictNewMessage["newMessageCount"] as! Int + 1
                                        dictNewMessage["lastMessage"] = "\(lastMessageText ?? "")"
                                        dictNewMessage["lastMessageTimestamp"] = lastMessageDate ?? "\(Date())"
                                        arrayNewMessage[indexToUpdate] = dictNewMessage
                                        kUserDefault.removeObject(forKey: kNewMessage)
                                        kUserDefault.synchronize()
                                        setNewMessageData(array: arrayNewMessage)
                                    }else{
                                    }
                                }else{
                                    if toUserId == Int(getLoggedInUserId()){
                                        let dict: [String: Any] = ["roomId" : "\(String(describing: roomId))",
                                            "newMessageCount": 1,
                                            "lastMessage": "\(lastMessageText ?? "")",
                                            "lastMessageTimestamp": "\(lastMessageDate ?? "\(Date())")"
                                        ]
                                        arrayNewMessage.append(dict)
                                        kUserDefault.removeObject(forKey: kNewMessage)
                                        kUserDefault.synchronize()
                                        setNewMessageData(array: arrayNewMessage)
                                        //                                return
                                    }else{
                                    }
                                }
                            }else{
                                if toUserId == Int(getLoggedInUserId()){
                                    let dict: [String: Any] = ["roomId" : "\(String(describing: roomId))",
                                        "newMessageCount": 1,
                                        "lastMessage": "\(lastMessageText ?? "")",
                                        "lastMessageTimestamp": "\(lastMessageDate ?? "\(Date())")"
                                    ]
                                    arrayNewMessage.append(dict)
                                    setNewMessageData(array: arrayNewMessage)
                                }else{
                                }
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEW_MESSAGE"), object: nil)
                        } catch {
                            
                        }
                    }
                }else{
                    
                }
            }
        }
    }
    
    func showAlert(alertTitle: String? = "", alertMessage: String? = "", okTitleString: String? = "", type: NotificationType, data: [AnyHashable : Any]? = nil, model: WebSocketNotificationModel? = nil){
        let alertViewC = commonStoryboard.instantiateViewController(withIdentifier: "NotificationAlertViewController") as! NotificationAlertViewController
        alertViewC.titleStr = alertTitle
        alertViewC.messageStr = alertMessage
        alertViewC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertViewC.okTitleString = okTitleString
        alertViewC.notificationType = type
        alertViewC.notificationModel = model
        alertViewC.notificationData = data
        self.window?.rootViewController?.present(alertViewC, animated: false, completion: nil)
    }
}


