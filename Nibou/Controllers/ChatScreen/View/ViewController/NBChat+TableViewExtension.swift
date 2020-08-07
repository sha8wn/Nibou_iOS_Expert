//
//  NBChat+TableViewExtension.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire

//MARK: - TableView Extension
extension NBChatVC : UITableViewDelegate, UITableViewDataSource{
    
    //NOTE: Section 0 is for Bookmarked Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            return listModel.count + 1
        }else{
            if self.bookmarkModel != nil && self.bookmarkModel.count > 0{
                return 1
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            if self.bookmarkModel != nil && self.bookmarkModel.count > 0{
                let bookModel: List<ChatData> = self.bookmarkModel[0].data
                return bookModel.count
            }else{
                return 0
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if self.bookmarkModel != nil && self.bookmarkModel.count > 0{
                let bookModel: List<ChatData> = self.bookmarkModel[0].data
                if bookModel.count > 0{
                    return 60
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else{
            if self.chatModel != nil && self.chatModel.count > 0{
                let listModel: List<ChatData> = self.chatModel[0].data
                let model: ChatData! = listModel[section - 1]
                if model.showHeader == true{
                    return 60
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            if self.bookmarkModel != nil && self.bookmarkModel.count > 0{
                let bookModel: List<ChatData> = self.bookmarkModel[0].data
                let model: ChatData! = bookModel[0]
                if model.showHeader == true{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NBTimeTableCell") as! NBTimeTableCell
                    let strDate = model.timeStamp
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let date = dateFormatter.date(from: strDate)
                   
                    if model.showHeaderForToday{
                        cell.lbl_time.text = "\(convertDateFormater(date: date!, format: "EEEE, HH:mm"))"
                    }else{
                        cell.lbl_time.text = "\(convertDateFormater(date: date!, format: "EEEE, dd MMM"))"
                    }
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    return cell
                }
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        }else{
            if self.chatModel != nil && self.chatModel.count > 0{
                let listModel: List<ChatData> = self.chatModel[0].data
                let model: ChatData! = listModel[section - 1]
                if model.showHeader == true{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NBTimeTableCell") as! NBTimeTableCell
                    let strDate = model.timeStamp
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let date = dateFormatter.date(from: strDate)
                    if model.showHeaderForToday{
                        cell.lbl_time.text = "\(convertDateFormater(date: date!, format: "EEEE, HH:mm"))"
                    }else{
                        cell.lbl_time.text = "\(convertDateFormater(date: date!, format: "EEEE, dd MMM"))"
                    }
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    return cell
                }
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.table_view.separatorColor = UIColor.clear
        self.table_view.tableFooterView = UIView()
        
        if indexPath.section == 0{
            if self.bookmarkModel != nil && self.bookmarkModel.count > 0{
                let bookModel: List<ChatData> = self.bookmarkModel[0].data
                let model: ChatData! = bookModel[indexPath.row]
                
                if "\(model.fromUserId)" == getLoggedInUserId(){
                    if model.message != ""{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBRightMessageTableCell", for: indexPath) as! NBRightMessageTableCell
                        cell.lbl_text.text = model.message
                        if model.localId == ""{
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.isHidden = true
                        }else{
                            cell.activityIndicator.startAnimating()
                            cell.activityIndicator.isHidden = false
                        }
                        cell.btn_bookmark.tag = indexPath.section - 1
                        if model.isBookmarked{
                            cell.btn_bookmark.setImage(UIImage(named: "bookmark_green_iPhone"), for: .normal)
                        }else{
                            cell.btn_bookmark.setImage(UIImage(named: "bookmark_light_green_iPhone"), for: .normal)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        
                        cell.completion = {(btn) in
                            self.btnBookMarkTapped_Previous(model: model)
                        }
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBRightImageTableViewCell", for: indexPath) as! NBRightImageTableViewCell
                        if model.localImageUrl != ""{
                            cell.button.setImage(nil, for: .normal)
                            if let image = self.getImageFromDirectory("\(model.localImageUrl)"){
                                cell.imgView.image = image
                            }else{
                                
                            }
                        }else{
                            cell.setUpCell(imageURL: model.imageUrl, isDownloaded: false, indexPath: indexPath)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.button.tag = indexPath.section - 1
                        cell.button.addTarget(self, action: #selector(btnImageTapped(sender:)), for: .touchUpInside)
                        return cell
                    }
                }else{
                    if model.message != ""{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBLeftMessageTableCell", for: indexPath) as! NBLeftMessageTableCell
                        cell.lbl_text.text = model.message
                        cell.btn_bookMark.tag = indexPath.section - 1
                        if model.isBookmarked{
                            cell.btn_bookMark.setImage(UIImage(named: "bookmark_green_iPhone"), for: .normal)
                        }else{
                            cell.btn_bookMark.setImage(UIImage(named: "bookmark_light_green_iPhone"), for: .normal)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.completion = {(btn) in self.btnBookMarkTapped_Previous(model: model)}
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBLeftImageTableViewCell", for: indexPath) as! NBLeftImageTableViewCell
                        if model.localImageUrl != ""{
                            cell.button.setImage(nil, for: .normal)
                            if let image = self.getImageFromDirectory("\(model.localImageUrl)"){
                                cell.imgView.image = image
                            }else{
                                
                            }
                        }else{
                            cell.setUpCell(imageURL: model.imageUrl, isDownloaded: false, indexPath: indexPath)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        cell.button.tag = indexPath.section - 1
                        cell.button.addTarget(self, action: #selector(btnImageTapped(sender:)), for: .touchUpInside)
                        return cell
                    }
                }
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        }else{
            if self.chatModel != nil && self.chatModel.count > 0{
                let listModel: List<ChatData> = self.chatModel[0].data
                let model: ChatData! = listModel[indexPath.section - 1]
                if "\(model.fromUserId)" == getLoggedInUserId(){
                    if model.message != ""{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBRightMessageTableCell", for: indexPath) as! NBRightMessageTableCell
                        cell.lbl_text.text = model.message
                        if model.localId == ""{
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.isHidden = true
                        }else{
                            cell.activityIndicator.startAnimating()
                            cell.activityIndicator.isHidden = false
                        }
//                        cell.btn_bookmark.tag = indexPath.section - 1
                        if model.isBookmarked{
                            cell.btn_bookmark.setImage(UIImage(named: "bookmark_green_iPhone"), for: .normal)
                        }else{
                            cell.btn_bookmark.setImage(UIImage(named: "bookmark_light_green_iPhone"), for: .normal)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.completion = {(btn) in
                            self.btnBookMarkTapped_Previous(model: model)
                        }
//                        cell.btn_bookmark.addTarget(self, action: #selector(btnBookMarkTapped(sender:)), for: .touchUpInside)
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBRightImageTableViewCell", for: indexPath) as! NBRightImageTableViewCell
                        if model.localImageUrl != ""{
                            cell.button.setImage(nil, for: .normal)
                            if let image = self.getImageFromDirectory("\(model.localImageUrl)"){
                                cell.imgView.image = image
                            }else{
                                
                            }
                        }else{
                            cell.setUpCell(imageURL: model.imageUrl, isDownloaded: false, indexPath: indexPath)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.button.tag = indexPath.section - 1
                        cell.button.addTarget(self, action: #selector(btnImageTapped(sender:)), for: .touchUpInside)
                        return cell
                    }
                }else{
                    if model.message != ""{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBLeftMessageTableCell", for: indexPath) as! NBLeftMessageTableCell
                        cell.lbl_text.text = model.message
//                        cell.btn_bookMark.tag = indexPath.section - 1
                        if model.isBookmarked{
                            cell.btn_bookMark.setImage(UIImage(named: "bookmark_green_iPhone"), for: .normal)
                        }else{
                            cell.btn_bookMark.setImage(UIImage(named: "bookmark_light_green_iPhone"), for: .normal)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.completion = {(btn) in
                            self.btnBookMarkTapped_Previous(model: model)
                        }
//                        cell.btn_bookMark.tag = indexPath.section - 1
                        
//                        cell.btn_bookMark.addTarget(self, action: #selector(btnBookMarkTapped(sender:)), for: .touchUpInside)
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NBLeftImageTableViewCell", for: indexPath) as! NBLeftImageTableViewCell
                        if model.localImageUrl != ""{
                            cell.button.setImage(nil, for: .normal)
                            if let image = self.getImageFromDirectory("\(model.localImageUrl)"){
                                cell.imgView.image = image
                            }else{
                                
                            }
                        }else{
                            cell.setUpCell(imageURL: model.imageUrl, isDownloaded: false, indexPath: indexPath)
                        }
                        cell.lblTime.text = getTimeForMessage(time: model.timeStamp)
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        cell.button.tag = indexPath.section - 1
                        cell.button.addTarget(self, action: #selector(btnImageTapped(sender:)), for: .touchUpInside)
                        return cell
                    }
                }
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        }
    }

    //MARK: - UITableView Button Action
    
    /// This function is called when Image Tapped on UITableViewCell
    ///
    /// - Parameter sender: UIButton sender
    @objc func btnImageTapped(sender: UIButton){
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            let model: ChatData! = listModel[sender.tag]
            if model.localImageUrl == ""{
                let imageFileName = "\(self.roomId)" + "_" + String(Int.random(in: 0 ... 1000)) as NSString
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    documentsURL.appendPathComponent("\(imageFileName).png")
                    return (documentsURL, [.removePreviousFile])
                }
                let imageUrl = kBaseURL + model.imageUrl
                Alamofire.download(imageUrl, to: destination).response { response in
                    if response.destinationURL != nil {
                        print(response.destinationURL!)
                        print(model.chatId)
                        let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", self.roomId)
                        let dataModel = mainModel[0].data.filter("chatId = %@", "\(model.chatId)")
                        if let dataModel = dataModel.first{
                            try! self.relamDB.write {
                                dataModel.localId = ""
                                dataModel.localImageUrl = imageFileName as String
                            }
                        }
                        print(dataModel)
                        self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
                        
                        self.table_view.reloadSections([sender.tag + 1], with: .none)
                    }
                }
            }else{
                let imageViewer = commonStoryboard.instantiateViewController(withIdentifier: "ImageViewerViewController") as! ImageViewerViewController
                imageViewer.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                if model.localImageUrl != ""{
                    imageViewer.imageType = .local
                    imageViewer.localImageName = model.localImageUrl
                }else{
                    imageViewer.imageType = .url
                    imageViewer.imageUrl = model.imageUrl
                }
                self.present(imageViewer, animated: false, completion: nil)
            }
        }else{
            
        }
    }
    //end -------------------------------------------------

    /// This function is called when Bookmark Button Tapped on UITableViewCell
    ///
    /// - Parameter sender: UIButton Sender
    func btnBookMarkTapped_Previous(model: ChatData){
        let shortBioVC = settingStoryboard.instantiateViewController(withIdentifier: "BioViewController") as! BioViewController
        shortBioVC.isOpenFrom = "Chat"
        shortBioVC.strMessage = model.message
        shortBioVC.messageId = model.chatId
        shortBioVC.roomId = self.roomId
        self.tabBarController?.tabBar.isHidden  = true
        self.navigationController?.pushViewController(shortBioVC, animated: true)
    }
    //end -------------------------------------------------

    
    
    /// This function is called when Bookmark Button Tapped on UITableViewCell
    ///
    /// - Parameter sender: UIButton Sender
    
    
    
    @objc func btnBookMarkTapped(sender: UIButton){
        
        var messageId: String = ""
        var message: String = ""
        
//        if self.bookmarkModel != nil && self.bookmarkModel.count > 0{
//            let bookModel: List<ChatData> = self.bookmarkModel[0].data
//            if bookModel.count >= sender.tag{
//
//                let model: ChatData! = bookModel[sender.tag]
//                if model != nil{
//                    if model.message != ""{
//                        message = model.message
//                        messageId = model.chatId
//                    }
//                }
//            }
//        }
        
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            if listModel.count >= sender.tag{
                let model: ChatData! = listModel[sender.tag]
                if model != nil{
                    if model.message != ""{
                        message = model.message
                        messageId = model.chatId
                    }
                }
            }
        }
        
        let shortBioVC = settingStoryboard.instantiateViewController(withIdentifier: "BioViewController") as! BioViewController
        shortBioVC.isOpenFrom = "Chat"
        shortBioVC.strMessage = message
        shortBioVC.messageId = messageId
        shortBioVC.roomId = self.roomId
        self.tabBarController?.tabBar.isHidden  = true
        self.navigationController?.pushViewController(shortBioVC, animated: true)
    }
    //end -------------------------------------------------
    
    func getTimeForMessage(time: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: time)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        dateFormatter1.locale = .current
        dateFormatter1.timeZone = .current
        let date1 = dateFormatter1.string(from: date ?? Date())
        return date1
//        return "\(convertDateFormater(date: date ?? Date(), format: "HH:mm"))"
    }
    
}
//end -------------------------------------------------



