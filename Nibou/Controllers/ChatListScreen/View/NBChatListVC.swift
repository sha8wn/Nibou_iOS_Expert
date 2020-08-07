//
//  NBChatListVC.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBChatListVC: BaseViewController {

     //MARK: - Properties
    @IBOutlet weak var search_bar   : UISearchBar!
    @IBOutlet weak var table_view   : UITableView!
    @IBOutlet weak var lblNoRecord  : UILabel!
    var chatListModel               : NBChatListModel!
    var filteredModel               : [ChatHomeListModel]       = []
    var searchActive                : Bool                      = false
    var chatHomeListModel           : [ChatHomeListModel]       = []
    
     //MARK:- UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataOnBackgroundNotificationHandler(notification:)), name: Notification.Name("DEVICE_FOREGROUND"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotificationHandler(notification:)), name: Notification.Name("RELOAD_HOME_DATA"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newChatRoomCreatedNotificationHandler(notification:)), name: Notification.Name("NEW_CHAT_ROOM_CREATED"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageNotificationHandler(notification:)), name: Notification.Name("NEW_MESSAGE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.delayNotificationHandler(notification:)), name: Notification.Name("DELAY_RESPONSE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotificationHandler(notification:)), name: Notification.Name("CHATROOM_END"), object: nil)
        
        self.tabBarController?.tabBar.isHidden = false
        self.search_bar.placeholder = "SEARCH".localized()
        self.setup()
        self.callGetProfileApi()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DEVICE_FOREGROUND"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NEW_MESSAGE"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NEW_CHAT_ROOM_CREATED"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DELAY_RESPONSE"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("RELOAD_HOME_DATA"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CHATROOM_END"), object: nil)
    }
    
    //MARK: - Set Up View
    func setup(){
        self.table_view.register(UINib(nibName: "NBChatListTableCell", bundle: nil), forCellReuseIdentifier: "NBChatListTableCell")
        self.table_view.separatorStyle = .none
        self.search_bar.delegate = self
        self.search_bar.sizeToFit()
        self.lblNoRecord.text = "NO_DATA_FOUND".localized()
    }

    @objc func newChatRoomCreatedNotificationHandler(notification: Notification) {
//        self.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.search_bar.placeholder = "Search"
        self.setup()
        self.callGetProfileApi()
    }
    
    @objc func reloadDataNotificationHandler(notification: Notification) {
//        self.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.search_bar.placeholder = "Search"
        self.setup()
        self.callGetProfileApi()
    }
    
    @objc func reloadDataOnBackgroundNotificationHandler(notification: Notification) {
        self.tabBarController?.tabBar.isHidden = false
        self.search_bar.placeholder = "Search"
        self.setup()
        self.callGetProfileApi()
    }
    
    @objc func newMessageNotificationHandler(notification: Notification) {
        self.updateListOnNewMessage()
    }
    
    @objc func delayNotificationHandler(notification: Notification){
        DispatchQueue.main.async {
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
        }
 
        if self.chatHomeListModel != nil{
            if self.chatHomeListModel.count > 0{
                self.chatHomeListModel.sort { (($0 as ChatHomeListModel).data!.lastMessageTimestamp ?? "\(Date())") > (($1 as ChatHomeListModel).data!.lastMessageTimestamp ?? "\(Date())")}
            }
        }
        self.table_view.reloadData()
    }
    
    func updateListOnNewMessage(){
        DispatchQueue.main.async {
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
            
            if self.chatHomeListModel != nil{
                if self.chatHomeListModel.count > 0{
                    self.chatHomeListModel.sort { (($0 as ChatHomeListModel).data!.lastMessageTimestamp ?? "\(Date())") > (($1 as ChatHomeListModel).data!.lastMessageTimestamp ?? "\(Date())")}
                }
            }

            self.table_view.reloadData()
        }
    }
    
    
    func getModelForSearch(mainModel: NBChatListModel) -> [ChatHomeListModel]{
        var arrayOfUserModel: [ChatHomeListModel] = []
        if self.chatListModel != nil && self.chatListModel.data != nil && self.chatListModel.data!.count > 0{
            self.lblNoRecord.isHidden = true
            if let dataModel = self.chatListModel.data{
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
                        chatHomeListModel.data!.lastMessageTimestamp = messageModel.data!.attributes!.created_at ?? ""
                    }
                    arrayOfUserModel.append(chatHomeListModel)
                }
            }else{
                
            }
        }else{
            self.lblNoRecord.isHidden = false
        }
        return arrayOfUserModel
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- SEARCH BAR DELEGATES
extension NBChatListVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search_bar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchActive = false
        self.table_view.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search_bar.resignFirstResponder()
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint("searchbar >>",searchText)
        self.filteredModel = []
        DispatchQueue.main.async {
            if searchText == ""{
                searchBar.resignFirstResponder()
                searchBar.text = ""
                searchBar.setShowsCancelButton(false, animated: true)
                self.searchActive = false
                self.table_view.reloadData()
            }else{
                if self.chatHomeListModel.count > 0{
                    
                    self.callSearchAPI(searchString: searchText.lowercased())
                    self.searchActive = true
//                    self.table_view.reloadData()

                    
//                    for model in self.chatHomeListModel{
//                        guard let userName = model.userData!.data!.attributes!.username else { return }
//                        if userName.lowercased().contains(searchText.lowercased()){
//                            self.filteredModel.append(model)
//                        }
//                        self.searchActive = true
//                        self.table_view.reloadData()
//                    }
                }
            }
        }
    }
}

// MARK: - TableView Delegate and DataSource
extension NBChatListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.chatHomeListModel.count > 0{
            if self.searchActive{
                return self.filteredModel.count
            }else{
                return self.chatHomeListModel.count
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "NBChatListTableCell", for: indexPath) as! NBChatListTableCell
        var name: String = ""
        var message: String = ""
        var dateTime: String = ""
        if self.chatHomeListModel.count > 0{
            var model: ChatHomeListModel!
            if self.searchActive{
                model = self.filteredModel[indexPath.row]
            }else{
                model = self.chatHomeListModel[indexPath.row]
            }
            if let userModel = model.userData{
                name = userModel.data!.attributes!.username ?? ""
            }
            if let messageModel = model.messageData{
                message = messageModel.data!.attributes!.text ?? "IMAGE".localized()
                dateTime = self.getDateOfMessage(date: messageModel.data!.attributes!.created_at ?? "")
            }
            
            cell.lbl_time.text = dateTime
            
            cell.lbl_count.layer.cornerRadius = cell.lbl_count.frame.height/2
            if model.data!.newMessageCount ?? 0 > 0{
                cell.lbl_count.isHidden = false
                cell.lbl_count.text = "\(model.data!.newMessageCount!)"
                cell.lbl_message.text = "\(model.data!.lastMessage!)"
                cell.lbl_time.text = self.getDateOfMessage(date: model.data!.lastMessageTimestamp ?? "")
                if model.data!.delayResponse ?? false == true{
                    cell.lbl_count.backgroundColor = UIColor(named: "Red_Chat_Count")
                }else{
                    cell.lbl_count.backgroundColor = UIColor(named: "Light_Blue_Chat_Count")
                }
            }else{
                cell.lbl_message.text = message
                cell.lbl_count.isHidden = true
            }
        }
        cell.lbl_name.text = name
        self.table_view.tableFooterView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("index Path >>", indexPath.row)
        self.tabBarController?.tabBar.isHidden  = true
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NBChatVC") as! NBChatVC
        if self.chatHomeListModel.count > 0{
            var model: ChatHomeListModel!
            if self.searchActive{
                model = self.filteredModel[indexPath.row]
            }else{
                model = self.chatHomeListModel[indexPath.row]
            }
            viewController.homeDataModel = model.data!
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getDateOfMessage(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: date)
        let (_, day) = Date().calculateMessageTimestampfrom(date: date!)
        if day == 0{
            return "\(convertDateFormater(date: date!, format: "HH:mm"))"
        }else if day == 1{
            return "YESTERDAY".localized()
        }else{
            dateFormatter.dateFormat = "EEEE, dd MMM"
            let newDate = dateFormatter.string(from: date!)
            return newDate
        }
    }
}

// MARK: - AlertDelegate
extension NBChatListVC: AlertDelegate{
    
}




