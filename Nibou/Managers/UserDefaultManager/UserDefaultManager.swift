//
//  UserDefaultManager.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation


/**
 MARK: - Key Contants
 */

let kLanguage               = "Language"
let kAccessTokenModel       = "AccessTokenModel"
let kProfileModel           = "ProfileModel"
let kNewMessage             = "NewMessage"
let kDelayMessage           = "DelayMessage"
let kSessionTimout          = "SessionTimeout"

//MARK: - Current Language
/**
 MARK: - Set Current Language
 */
func setCurrentLanguage(language: String){
    kUserDefault.set(language, forKey: kLanguage)
    kUserDefault.synchronize()
}

/**
 MARK: - Get Current Language
 - Returns: Language Code
 */
func getCurrentLanguage() -> String{
    if let code = kUserDefault.value(forKey: kLanguage) as? String{
        return code
    }else{
        return ""
    }
}


//MARK: - AccessToken Data
/**
 MARK: - Set AccessToken Data
 */
func setAccessTokenModel(model: LoginModel){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(model) {
        kUserDefault.set(encoded, forKey: kAccessTokenModel)
        kUserDefault.synchronize()
    }
}

/**
 MARK: - Get AccessToken Data
 - Returns: AccessToken Data
 */
func getAccessTokenModel() -> LoginModel{
    if let data = kUserDefault.object(forKey: kAccessTokenModel) as? Data {
        let decoder = JSONDecoder()
        if let model = try? decoder.decode(LoginModel.self, from: data) {
            return model
        }else{
            return LoginModel(accessToken: "", tokenType: "", expiresIn: 0, refreshToken: "", createdAt: 0)
        }
    }else{
        return LoginModel(accessToken: "", tokenType: "", expiresIn: 0, refreshToken: "", createdAt: 0)
    }
}

//MARK: - Profile Data
/**
 MARK: - Set Profile Data
 */
func setProfileModel(model: ProfileModel){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(model) {
        kUserDefault.set(encoded, forKey: kProfileModel)
        kUserDefault.synchronize()
    }
}

/**
 MARK: - Get Profile Data
 - Returns: Profile Data
 */
func getProfileModel() -> ProfileModel?{
    if let data = kUserDefault.object(forKey: kProfileModel) as? Data {
        let decoder = JSONDecoder()
        if let model = try? decoder.decode(ProfileModel.self, from: data) {
            return model
        }else{
            return nil
        }
    }else{
        return nil
    }
}

//MARK: - New Message
/**
 MARK: - Set New Message Data
 */
func setNewMessageData(array: [[String: Any]]){
    kUserDefault.set(array, forKey: kNewMessage)
    kUserDefault.synchronize()
}

/**
 MARK: - Get New Message Data
 - Returns: New Message Data
 */
func getNewMessageData() -> [[String: Any]]{
    if let arrayNewMessage = kUserDefault.object(forKey: kNewMessage) as? [[String: Any]] {
        return arrayNewMessage
    }else{
        return []
    }
}


//MARK: - Delay Message
/**
 MARK: - Set Delay Message Data
 */
func setDelayMessageData(array: [[String: Any]]){
    kUserDefault.set(array, forKey: kDelayMessage)
    kUserDefault.synchronize()
}

/**
 MARK: - Get Delay Message Data
 - Returns: Delay Message Data
 */
func getDelayMessageData() -> [[String: Any]]{
    if let arrayNewMessage = kUserDefault.object(forKey: kDelayMessage) as? [[String: Any]] {
        return arrayNewMessage
    }else{
        return []
    }
}


//MARK: - Session Timeout Data
/**
 MARK: - Set Session Timeout Data
 */
func setSessionTimoutData(array: [[String: Any]]){
    kUserDefault.set(array, forKey: kSessionTimout)
    kUserDefault.synchronize()
}

/**
 MARK: - Get Session Timeout Data
 - Returns: Session Timeout Data
 */
func getSessionTimoutData() -> [[String: Any]]{
    if let arraySessionData = kUserDefault.object(forKey: kSessionTimout) as? [[String: Any]] {
        return arraySessionData
    }else{
        return []
    }
}



//MARK: - Clear All Defaults
func clearUserDefault(){
    kAppDelegate.webClient.disconnect()
    kAppDelegate.notficationChannel.unsubscribe()
    let userDefault = UserDefaults.standard
    userDefault.removeObject(forKey: kNewMessage)
    userDefault.removeObject(forKey: kAccessTokenModel)
    userDefault.removeObject(forKey: kProfileModel)
    userDefault.removeObject(forKey: kSessionTimout)
    userDefault.removeObject(forKey: kDelayMessage)
    userDefault.synchronize()
}
