//
//  TimingsViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

struct TimingModel {
    var day         : String?
    var startTime   : String?
    var start       : Date?
    var end         : Date?
    var endTime     : String?
    var isSelected  : Bool?
    var id          : String?
}

class TimingsViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var btnSave              : UIButton!
    var arrayData                           : [TimingModel]       = []
    var isError                             : Bool                = false
    var isDelete                            : Bool                = false
    var isUpdateSuccess                     : Bool                = false
    var isDeleteSuccess                     : Bool                = false
    var selectedTimeIndex                   : Int                 = 0
    var dispatchGroup                                             = DispatchGroup()
    let weekDays = ["MONDAY".localized(), "TUESDAY".localized(), "WEDNESDAY".localized(), "THRUSDAY".localized(), "FRIDAY".localized(), "SATURDAY".localized(), "SUNDAY".localized()]
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.callGetTimingsAPi()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.tableView.estimatedRowHeight = 80
        self.tableView.register(UINib(nibName: "TimingsTableViewCell", bundle: nil), forCellReuseIdentifier: "TimingsTableViewCell")
        self.setUpData()
        self.btnSave.setTitle("SAVE".localized(), for: .normal)
        self.lblHeader.text = "TIMINGS_HEADER".localized()
    }
    //end
    
    func setUpData(){
        for i in 0...6{
            var model = TimingModel()
            model.day = weekDays[i]
            model.startTime = "00:00"
            model.endTime = "00:00"
            model.isSelected = false
            self.arrayData.append(model)
        }
    }
    
    func updateTimingModelArray(arrayOfTimingsData: [TimingsData]){
        self.arrayData = []
        self.setUpData()
        if arrayOfTimingsData.count > 0{
            for i in 0...arrayOfTimingsData.count - 1{
                let model = arrayOfTimingsData[i]
                let day = model.attributes!.day_number!
                var localModel = arrayData[day - 1]
                localModel.startTime = model.attributes!.time_from ?? "00:00"
                localModel.endTime = model.attributes!.time_to ?? "00:00"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let startTime = dateFormatter.date(from: model.attributes!.time_to!)
                let endTime = dateFormatter.date(from: model.attributes!.time_from!)
                localModel.start = startTime!
                localModel.end = endTime!
                localModel.isSelected = true
                localModel.id = model.id!
                self.arrayData[day - 1] = localModel
            }
        }
        self.tableView.reloadData()
    }

    func getEditDataArray() -> [TimingModel]{
        var editedArray: [TimingModel] = []
        for model in self.arrayData{
            if model.startTime! == "00:00"{
                
            }else{
                editedArray.append(model)
            }
        }
        return editedArray
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveTapped(_ sender: Any) {
        let editedTimingsArray = self.getEditDataArray()
        if editedTimingsArray.count > 0{
            for i in 0...editedTimingsArray.count - 1{
                let model = editedTimingsArray[i]
                let day = self.weekDays.lastIndex(of: model.day!)
                if model.id == nil{
                    self.callAddTimingAPI(dayNumber: day! + 1, startTime: model.startTime!, endTime: model.endTime!)
                }else{
                    self.callUpdateTimingAPI(timingId: model.id!, dayNumber: day! + 1, startTime: model.startTime!, endTime: model.endTime!)
                }
            }
        }
        
//        var notifiy: Int = 0
        
        self.dispatchGroup.notify(queue: .main) {
//            notifiy = notifiy + 1
            if self.isError{
                self.isError = false
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
//                if  self.getEditDataArray().count == notifiy{
                    self.isUpdateSuccess = true
                    self.showAlert(viewController: self, alertTitle: "SUCCESS".localized(), alertMessage: "TIMINGS_UPDATED_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
//                }else{
//                    print("NOTIFY: \(notifiy)")
//                }
                
            }
            
        }
    }
}

//MARK: - UITableView Delegate and DataSource
extension TimingsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimingsTableViewCell", for: indexPath) as! TimingsTableViewCell
        let model: TimingModel = self.arrayData[indexPath.row]
        cell.btnTitle.isUserInteractionEnabled = false
        cell.btnTitle.setTitle(model.day!, for: .normal)
        if model.isSelected! == true{
            cell.btnTitle.setTitleColor(UIColor(named: "Blue_Color"), for: .normal)
            cell.timingView.isHidden = false
        }else{
            cell.btnTitle.setTitleColor(UIColor(named: "Placeholder_Light_Blue_Color"), for: .normal)
            cell.timingView.isHidden = true
        }
        cell.btnStartTime.tag = indexPath.row
        cell.btnEndTime.tag = indexPath.row
        cell.btnStartTime.setTitle("\(model.startTime!)", for: .normal)
        cell.btnEndTime.setTitle("\(model.endTime!)", for: .normal)
        cell.btnStartTime.addTarget(self, action: #selector(btnStartTimeTapped(sender:)), for: .touchUpInside)
        cell.btnEndTime.addTarget(self, action: #selector(btnEndTimeTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: TimingModel = self.arrayData[indexPath.row]
        if model.isSelected! == true{
            if model.startTime! == "00:00"{
                 model.isSelected = false
            }else{
                if model.id == nil{
                    model.isSelected = false
                }else{
                    self.isDelete = true
                    self.selectedTimeIndex = indexPath.row
                    self.showAlert(viewController: self, alertTitle: "WARNING".localized(), alertMessage: "TIMIMG_DELETE_POPUP_DESC".localized(), alertType: .twoButton, okTitleString: "OK".localized(), cancelTitleString: "CANCEL".localized())
                }
            }
        }else{
            model.isSelected = true
        }
        self.arrayData[indexPath.row] = model
        self.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
    }
    
    @objc
    func btnStartTimeTapped(sender: UIButton){
        var model: TimingModel = self.arrayData[sender.tag]
        PickerViewController.openDatePickerView(viewC: self, currentDate: nil, pickerMode: .time) { (value) in
            let timedateFormatter = DateFormatter()
            timedateFormatter.dateFormat = "HH:mm"
            let time = timedateFormatter.string(from: value)
            model.startTime = time
            model.start = value
            if model.end != nil{
                if value > model.end!{
                    model.end = nil
                    model.endTime = "00:00"
                }
            }
            self.arrayData[sender.tag] = model
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        }
    }
    
    @objc
    func btnEndTimeTapped(sender: UIButton){
        var model: TimingModel = self.arrayData[sender.tag]
        if model.startTime! == "00:00"{
            self.showAlert(viewController: self, alertTitle: "INVALID".localized(), alertMessage: "SELECT_START_TIME".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }else{
            PickerViewController.openDatePickerView(viewC: self, currentDate: nil, minimumDate: model.start ?? nil, pickerMode: .time) { (value) in
                let timedateFormatter = DateFormatter()
                
                timedateFormatter.dateFormat = "HH:mm"
                let time = timedateFormatter.string(from: value)
                model.endTime = time
                model.end = value
                self.arrayData[sender.tag] = model
                self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }
        }
    }
}

extension TimingsViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isDelete{
            self.isDelete = false
            let model: TimingModel = self.arrayData[self.selectedTimeIndex]
            self.callDeleteTimingAPI(timingId: model.id!)
        }else if self.isUpdateSuccess{
            self.isUpdateSuccess = false
            self.callGetTimingsAPi()
        }else if self.isDeleteSuccess{
            self.isDeleteSuccess = false
            self.callGetTimingsAPi()
        }
    }
}

