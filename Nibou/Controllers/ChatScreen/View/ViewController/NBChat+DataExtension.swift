//
//  NBChat+DataExtension.swift
//  Nibou
//
//  Created by Himanshu Goyal on 12/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension NBChatVC{
    
    // MARK: SetUp HeaderView
    /// Set Up Navigation Bar view
    ///
    /// - Parameter model: Home API Data of User
    func setUpHeaderView(model: HomeData){
        //Room Id
        self.roomId = model.id!
        
        //Room Type
        self.roomType = model.type!
        
        //Get Header Data
        for i in 0...model.attributes!.users!.count - 1{
            let subModel = model.attributes!.users![i]
            if getLoggedInUserId() == subModel.data!.id!{
                //NOT REQUIRED
            }else{
                //Expert Id
                self.expertId = subModel.data!.id!
                //Profile Name
                guard let userName = subModel.data!.attributes!.username else{ return }
                self.lblUserName.text = userName
            }
        }
        
        
        self.callGetRoomDetailApi(roomId: self.roomId, isPrivate: model.attributes!.is_private!)
//        self.callService(isPrivate: model.attributes!.is_private!)
        
        
    }
    //end -------------------------------------------------
    
    // MARK: - Set Up Date in TableView Header Section
    /// Update TableView Header With Date
    ///
    /// - Parameter timeStamp: Date from Server
    /// - Returns: showDate, ShowCurrentDate
    func setUpDateHeader(timeStamp: String) -> (Bool, Bool){
        let strDate = timeStamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: strDate)
        let (_, day) = Date().calculateMessageTimestampfrom(date: date!)
        print("DAYS: ", day)
        if day > 0{
            if self.previousDayCount != day{
                self.previousDayCount = day
                return (true, false)
            }else{
                return (false, false)
            }
        }else{
            if self.showDateCurrentDay != 1{
                self.showDateCurrentDay = 1
                return (true, true)
            }else{
                return (false, false)
            }
        }
    }
    //end -------------------------------------------------
    
    
    // MARK: - Set up TableView With Data
    ///
    /// - Parameter roomId: Unique Id
    func setUpTableViewWithData(roomId: String){
        self.chatModel = self.getDataFromDatabase(roomId: roomId)
        self.bookmarkModel = self.getDataFromDatabase_Bookmark(roomId: roomId)
        DispatchQueue.main.async {
            self.table_view.reloadData()
            self.scrollToTheBottom(animated: false, position: .bottom)
        }
    }
    //end -------------------------------------------------
    
    //MARK: - Get Images from Document Directoru
    /// This function is used to local image from Document Directory with Image Name
    ///
    /// - Parameter imageName: Local Saved Image Name
    /// - Returns: UIImage
    func getImageFromDirectory (_ imageName: String) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(String(describing: imageName)).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            print("YES")
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    //end -------------------------------------------------
    
    
    //MARK: - Call Initial Webservice
    /// This function is used to call initial webservice for Chat
    ///
    /// - Parameter isPrivate: This BOOL specify whether user selected to share bookmark message or not. If 'True' then we'll call Get Bookmarks API else not
    func callService(isPrivate: Bool? = false){
        if isPrivate!{
            self.callGetBookmarksAPI(roomId: self.roomId)
        }else{
            self.callGetChatHistory(roomId: self.roomId)
        }
    }
    //end -------------------------------------------------
    
    
    
    // MARK: - Get Data from Realm Database
    
    /// Get Chat Data From Database i.e Realm
    ///
    /// - Returns: Result of Chat Model Type
    func getDataFromDatabase(roomId: String) -> Results<ChatModel>{
        let results: Results<ChatModel> = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
        return results
    }
    //end -------------------------------------------------
    
    
    /// MARK: - Get Bookmarks Data From Database i.e Realm
    ///
    /// - Returns: Result of Chat Bookmarks Model Type
    func getDataFromDatabase_Bookmark(roomId: String) -> Results<Chat_BookMarkModel>{
        let results: Results<Chat_BookMarkModel> = self.relamDB.objects(Chat_BookMarkModel.self).filter("roomId = %@", roomId)
        return results
    }
    //end -------------------------------------------------
    

    //MARK: - Set Data in Realm Datebase
    
    /// This function is used to set chat data in Realm DB. This function also check whether we need to update Realm DB or not for a specify Room Id
    ///
    /// - Parameters:
    ///   - model: Chat History Response Model
    ///   - roomId: Unique Id i.e Room Id
    func setDataInDatabase(model: ChatHistoryModel, roomId: String){

        if model.data!.count > 0{
            let dataBaseResult = getDataFromDatabase(roomId: roomId)
            if dataBaseResult.count > 0{
                if dataBaseResult[0].data.count < model.data!.count{
                    //Delete Old Data
//                    self.deleteDataFromDatabase(roomId: self.roomId)
                    for i in 0...model.data!.count - 1{
                        let chatData = model.data![i]
                        let subModel = ChatData()
                        print(chatData)
                        subModel.localId = ""
                        subModel.chatId = chatData.id!
                        subModel.toUserId = chatData.attributes!.to_user_id!
                        subModel.fromUserId = chatData.attributes!.from_user_id!
                        subModel.timeStamp = chatData.attributes!.created_at!
                        subModel.message = chatData.attributes!.text ?? ""
                        if let arrayImage = chatData.attributes!.images{
                            if arrayImage.count > 0{
                                for object in arrayImage{
                                    if object.data!.attributes!.images!.count > 0{
                                        subModel.imageUrl = object.data!.attributes!.images![0].url!
                                    }
                                }
                            }
                        }
                        
                        if let bookmark = chatData.relationships!.bookmarks!.data {
                            if bookmark.count > 0{
                                subModel.isBookmarked = true
                            }else{
                                subModel.isBookmarked = false
                            }
                        }else{
                            subModel.isBookmarked = false
                        }
                        
                        if chatData.attributes!.text ?? "" == "END_SESSION"{
                            //NO NEED TO UPDATE
                            print("END_SESSION")
                        }else{
                            //Get Filter Model for Realm DB
                            let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
                            
                            //Update Model in Realm DB
                            if i > dataBaseResult[0].data.count - 1{
                                if let mainModel = mainModel.first {
                                    try! self.relamDB.write {
                                        mainModel.data.append(subModel)
                                    }
                                }
                            }
                        }
                    }
                }else{
                    for i in 0...model.data!.count - 1{
                        let savedModel = dataBaseResult[0].data[i]
                        let chatData = model.data![i]
                        let subModel = ChatData()
                        subModel.localId = ""
                        subModel.chatId = savedModel.chatId
                        subModel.toUserId = savedModel.toUserId
                        subModel.fromUserId = savedModel.fromUserId
                        subModel.timeStamp = savedModel.timeStamp
                        subModel.message = savedModel.message
                        subModel.imageUrl = savedModel.imageUrl
                        subModel.localImageUrl = savedModel.localImageUrl
                        if let bookmark = chatData.relationships!.bookmarks!.data {
                            if bookmark.count > 0{
                                subModel.isBookmarked = true
                            }else{
                                subModel.isBookmarked = false
                            }
                        }else{
                            subModel.isBookmarked = false
                        }
                        
                        if chatData.attributes!.text ?? "" == "END_SESSION"{
                            //NO NEED TO UPDATE
                            print("END_SESSION")
                        }else{
                            //Get Filter Model for Realm DB
                            let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
                            let previousDataModel = mainModel[0].data.filter("chatId = %@", "\(savedModel.chatId)")
                            if let model = previousDataModel.first{
                                try! self.relamDB.write {
                                    model.localId = ""
                                    model.chatId = subModel.chatId
                                    model.toUserId = subModel.toUserId
                                    model.fromUserId = subModel.fromUserId
                                    model.timeStamp = subModel.timeStamp
                                    model.message = subModel.message
                                    model.imageUrl = subModel.imageUrl
                                    model.localImageUrl = subModel.localImageUrl
                                    model.isBookmarked = subModel.isBookmarked
                                }
                            }
                        }
                    }
                    print("NOT NEED TO UPDATE")
                }
            }else{
                //Delete Old Data
                self.deleteDataFromDatabase(roomId: self.roomId)
     
                //Add New Data
                let mainModel = ChatModel()
                mainModel.roomId = roomId
                for i in 0...model.data!.count - 1{
                    let subModel = ChatData()
                    let chatData = model.data![i]
                    print(chatData)
                    subModel.localId = ""
                    subModel.chatId = chatData.id!
                    subModel.toUserId = chatData.attributes!.to_user_id!
                    subModel.fromUserId = chatData.attributes!.from_user_id!
                    subModel.timeStamp = chatData.attributes!.created_at!
                    subModel.message = chatData.attributes!.text ?? ""
                    let (showDate, showCurrentDate) = self.setUpDateHeader(timeStamp: chatData.attributes!.created_at!)
                    subModel.showHeader = showDate
                    subModel.showHeaderForToday = showCurrentDate
                    if let arrayImage = chatData.attributes!.images{
                        if arrayImage.count > 0{
                            for object in arrayImage{
                                if object.data!.attributes!.images!.count > 0{
                                    subModel.imageUrl = object.data!.attributes!.images![0].url!
                                }
                            }
                        }
                    }
                    
                    if let bookmark = chatData.relationships!.bookmarks!.data {
                        if bookmark.count > 0{
                            subModel.isBookmarked = true
                        }else{
                            subModel.isBookmarked = false
                        }
                    }else{
                        subModel.isBookmarked = false
                    }
                    
                    if chatData.attributes!.text ?? "" == "END_SESSION"{
                        //NO NEED TO UPDATE
                        print("END_SESSION")
                    }else{
                        mainModel.data.append(subModel)
                    }
 
                }
                //Update Chat Model in Realm DB
                try! relamDB.write {
                    relamDB.add(mainModel)
                }
            }
        }
        
        //Update Local Chat Model from Chat Model from Realm DB
        self.chatModel = self.getDataFromDatabase(roomId: roomId)

        DispatchQueue.main.async {
            self.table_view.reloadData()
            self.scrollToTheBottom(animated: false, position: .bottom)
        }

    }
    //end -------------------------------------------------
    
    /// This function is used to set bookmarks data in Realm DB. This function also check whether we need to update Realm DB or not for a specify Room Id
    ///
    /// - Parameters:
    ///   - model: Get Bookmarks API Response Model
    ///   - roomId: Unique Id i.e Room Id
    func setUpBookmarked(model: ChatBookmarksModel){
        
        if model.data!.count > 0{
            let dataBaseResult = getDataFromDatabase_Bookmark(roomId: roomId)
            if dataBaseResult.count > 0{
                if dataBaseResult[0].data.count < model.data!.count{
                    for i in 0...model.data!.count - 1{
                        let chatData = model.data![i]
                        let subModel = ChatData()
                        subModel.chatId = chatData.id!
                        subModel.fromUserId = chatData.attributes!.user_id!
                        subModel.timeStamp = chatData.attributes!.created_at!
                        subModel.message = chatData.attributes!.text ?? ""
                        subModel.isBookmarked = true
                         //Get Filter Model for Realm DB
                        let mainModel = self.relamDB.objects(Chat_BookMarkModel.self).filter("roomId = %@", roomId)
                        
                        //Update Model in Realm DB
                        if let mainModel = mainModel.first {
                            try! self.relamDB.write {
                                mainModel.data.append(subModel)
                            }
                        }
                    }
                }else{
                    // No Need to update because Server Data is same as Realm DB for this Room
                    print("NOT NEED TO UPDATE")
                }
            }else{
                //Delete Old Data
                self.deleteDataFromDatabase_Bookmark(roomId: self.roomId)
                self.deleteDataFromDatabase(roomId: self.roomId)
                //Add New Data
                let mainModel = Chat_BookMarkModel()
                mainModel.roomId = roomId
                for i in 0...model.data!.count - 1{
                    let subModel = ChatData()
                    let chatData = model.data![i]
                    print(chatData)
                    subModel.chatId = chatData.id!
                    subModel.fromUserId = chatData.attributes!.customer_id!
                    subModel.timeStamp = chatData.attributes!.created_at!
                    subModel.message = chatData.attributes!.text ?? ""
                    subModel.isBookmarked = true
                    let (showDate, showCurrentDate) = self.setUpDateHeader(timeStamp: chatData.attributes!.created_at!)
                    subModel.showHeader = showDate
                    subModel.showHeaderForToday = showCurrentDate
                    mainModel.data.append(subModel)
                }
                
                //Update Model in Realm DB
                try! relamDB.write {
                    relamDB.add(mainModel)
                }
            }
        }
        
        //Update Local Bookmarks Model from Bookmarks Model from Realm DB
        self.bookmarkModel = self.getDataFromDatabase_Bookmark(roomId: roomId)

        DispatchQueue.main.async {
            self.table_view.reloadData()
            self.scrollToTheBottom(animated: false, position: .bottom)
        }
    }
    //end -------------------------------------------------
    
    
    //MARK: - Update Data into Realm Datebase
    
    /// Update Chat Data in Realm Datebase
    ///
    /// - Parameters:
    ///   - model: Send Message Api Response Model
    ///   - roomId: Unique Id (Room Id)
    func updateDataInDatabase(model: ChatSendModel, roomId: String){
        let subModel = ChatData()
        let chatData = model.data!
        subModel.chatId = chatData.id!
        subModel.toUserId = chatData.attributes!.to_user_id!
        subModel.fromUserId = chatData.attributes!.from_user_id!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormatter.locale = .current
//        dateFormatter.timeZone = .current
//        let date = dateFormatter.date(from: chatData.attributes!.created_at!)
//        let strDate = "\(convertDateFormater(date: date ?? Date(), format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))"
//        subModel.timeStamp = strDate
        subModel.timeStamp = chatData.attributes!.created_at!
        subModel.message = chatData.attributes!.text ?? ""
        if let arrayImage = chatData.attributes!.images{
            if arrayImage.count > 0{
                for object in arrayImage{
                    if object.data!.attributes!.images!.count > 0{
                        subModel.imageUrl = object.data!.attributes!.images![0].url!
                    }
                }
            }
        }
        
        if let bookmark = chatData.relationships!.bookmarks!.data {
            if bookmark.count > 0{
                subModel.isBookmarked = true
            }else{
                subModel.isBookmarked = false
            }
        }else{
            subModel.isBookmarked = false
        }

        if chatData.attributes!.text ?? "" == "END_SESSION"{
            //NO NEED TO UPDATE
            print("END_SESSION")
        }else{
            let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
            
            if subModel.fromUserId != Int(getLoggedInUserId()) ?? 0{
                
                if let mainModel = mainModel.first {
                    try! self.relamDB.write {
                        mainModel.data.append(subModel)
                    }
                }
                self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
                
            }else{
                if self.chatModel != nil && self.chatModel.count > 0{
                    
                    let previousDataModel = mainModel[0].data.filter("localId = %@", "\(self.chatModel[0].data.count)")
                    
                    //            print(previousDataModel)
                    
                    if let previousDataModel = previousDataModel.first{
                        try! self.relamDB.write {
                            previousDataModel.chatId = subModel.chatId
                            previousDataModel.localId = ""
                            previousDataModel.toUserId = subModel.toUserId
                            previousDataModel.fromUserId = subModel.fromUserId
                            previousDataModel.timeStamp = subModel.timeStamp
                            previousDataModel.message = subModel.message
                            previousDataModel.imageUrl = subModel.imageUrl
                            previousDataModel.isBookmarked = subModel.isBookmarked
                        }
                    }else {
                        let previousDataModel = mainModel[0].data.filter("chatId = %@", "\(self.roomId)")
                        if let previousDataModel = previousDataModel.first{
                            try! self.relamDB.write {
                                previousDataModel.chatId = subModel.chatId
                                previousDataModel.localId = ""
                                previousDataModel.toUserId = subModel.toUserId
                                previousDataModel.fromUserId = subModel.fromUserId
                                previousDataModel.timeStamp = subModel.timeStamp
                                previousDataModel.message = subModel.message
                                previousDataModel.imageUrl = subModel.imageUrl
                                previousDataModel.isBookmarked = subModel.isBookmarked
                            }
                        }
                    }
                }else{
                    let previousDataModel = mainModel[0].data.filter("localId = %@", "\(self.roomId)")
                    if let previousDataModel = previousDataModel.first{
                        try! self.relamDB.write {
                            previousDataModel.chatId = subModel.chatId
                            previousDataModel.localId = ""
                            previousDataModel.toUserId = subModel.toUserId
                            previousDataModel.fromUserId = subModel.fromUserId
                            previousDataModel.timeStamp = subModel.timeStamp
                            previousDataModel.message = subModel.message
                            previousDataModel.imageUrl = subModel.imageUrl
                            previousDataModel.isBookmarked = subModel.isBookmarked
                        }
                    }
                }
            }
            
        }
        self.chatModel = self.getDataFromDatabase(roomId: roomId)
        DispatchQueue.main.async {
            self.table_view.reloadData()
            let visibleLastCellIndexPath = self.table_view.indexPathsForVisibleRows!.last
            if self.chatModel[0].data.count == visibleLastCellIndexPath!.section{
                self.scrollToTheBottom(animated: false, position: .bottom)
            }
        }
    }
    //end -------------------------------------------------

    
    /// This function is used to Update Realm Database with Temp. Chat Model
    ///
    /// - Parameters:
    ///   - chatId: Chat Id(Unique Id for a Message)
    ///   - localId: Local Id(This is used to specify that Chat Model is a Local model or not)
    ///   - message: Message
    ///   - localPathURL: Local Image Path
    func updateDataBaseWithTempData(chatId: String, localId: String, message: String? = "", localPathURL: String? = ""){
        let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
        if mainModel.count > 0{
            let subModel = ChatData()
            subModel.chatId = chatId
            subModel.localId = localId
            subModel.toUserId = Int(self.expertId) ?? 0
            subModel.fromUserId = Int(getLoggedInUserId()) ?? 0
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            dateFormatter.locale = .current
//            dateFormatter.timeZone = .current
//            let date = dateFormatter.string(from: Date())
//            subModel.timeStamp = date
            
            subModel.timeStamp = ""
            
            subModel.message = message ?? ""
            subModel.isBookmarked = false
            subModel.localImageUrl = localPathURL ?? ""
            if let mainModel = mainModel.first {
                try! self.relamDB.write {
                    mainModel.data.append(subModel)
                }
            }
            self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
            DispatchQueue.main.async {
                self.table_view.reloadData()
                self.scrollToTheBottom(animated: false, position: .bottom)
            }
        }else{
            let model = ChatModel()
            model.roomId = self.roomId
            let subModel = ChatData()
            subModel.chatId = chatId
            subModel.localId = localId
            subModel.toUserId = Int(self.expertId) ?? 0
            subModel.fromUserId = Int(getLoggedInUserId()) ?? 0
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            dateFormatter.locale = .current
//            dateFormatter.timeZone = .current
//            let date = dateFormatter.string(from: Date())
//            subModel.timeStamp = date
            subModel.timeStamp = ""
            subModel.message = message ?? ""
            subModel.localImageUrl = localPathURL ?? ""
            subModel.isBookmarked = false
            model.data.append(subModel)
            try! relamDB.write {
                relamDB.add(model)
            }
            self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
            DispatchQueue.main.async {
                self.table_view.reloadData()
                self.scrollToTheBottom(animated: false, position: .bottom)
            }
        }
    }
    //end -------------------------------------------------

    //MARK: - Delete Data from Realm Datebase
    
    /// This function is Used to Delete Chat Model from Realm Database for Room Id
    ///
    /// - Parameter roomId: Unique ID(Room Id)
    func deleteDataFromDatabase(roomId: String){
        let object = relamDB.objects(ChatModel.self).filter("roomId = %@", roomId).first
        try! relamDB.write {
            if let obj = object {
                self.relamDB.delete(obj)
            }
        }
    }
    //end -------------------------------------------------

    /// This function is Used to Delete Bookmarks Model from Realm Database for Room Id
    ///
    /// - Parameter roomId: Unique ID(Room Id)
    func deleteDataFromDatabase_Bookmark(roomId: String){
        let object = relamDB.objects(Chat_BookMarkModel.self).filter("roomId = %@", roomId).first
        try! relamDB.write {
            if let obj = object {
                self.relamDB.delete(obj)
            }
        }
    }
    //end -------------------------------------------------
}

func getLoggedInUserId() -> String{
    let model = getProfileModel()
    return model?.data!.id! ?? ""
}

