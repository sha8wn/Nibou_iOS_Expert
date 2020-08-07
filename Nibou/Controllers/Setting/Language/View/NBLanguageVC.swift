//
//  NBLanguageVC.swift
//  Nibou
//
//  Created by Ongraph on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

struct LocalLanguageModel{
    var language    : String?
    var id          : String?
    var isEmpty     : Bool?
    var isDelete    : Bool?
}

class NBLanguageVC: BaseViewController {
    
    @IBOutlet weak var consHeightForTableView   : NSLayoutConstraint!
    @IBOutlet weak var table_View               : UITableView!
    @IBOutlet weak var lblHeader                : UILabel!
    @IBOutlet weak var btnSaveDelete            : UIButton!
    @IBOutlet weak var btnAddAnother            : UIButton!
    @IBOutlet weak var txtField                 : CustomTextField!
    var selectedIndex                           : Int!                  = 0
    var arrLanguage                             : [String]              = ["English"]
    var arrayOfData                             : [LanguageData]        = []
    var arrayOfAvaiableLanguages                : [LanguageData]        = []
    var array_Language : [LocalLanguageModel]                           = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.callGetLanguageListAPI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.lblHeader.text = "LANGUAGES_HEADER".localized()
        var model = LocalLanguageModel()
        model.isEmpty = true
        model.isDelete = false
        self.array_Language.append(model)
        self.calculateHeightForTable()
        self.table_View.register(UINib(nibName: "TextWithCrossTableViewCell", bundle: nil), forCellReuseIdentifier: "TextWithCrossTableViewCell")
        self.btnSaveDelete.setTitle("", for: .normal)
        self.btnAddAnother.setTitle("ADD_ANOTHER".localized(), for: .normal)
    }
    
    func calculateHeightForTable(){
        if self.array_Language.count > 0{
            btnSaveDelete.isHidden = true
        }else{
            btnSaveDelete.isHidden = false
        }
        if (60 * array_Language.count > (Int(self.view.frame.height) - 300)){
            self.consHeightForTableView.constant = CGFloat(Int(self.view.frame.height) - 300)
        }else{
            self.consHeightForTableView.constant = CGFloat(array_Language.count * 60)
        }
    }
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveDeleteAction(_ sender: Any) {
           var model = LocalLanguageModel()
           if self.selectedIndex > 0{
               model = self.array_Language[self.selectedIndex]
               if model.language ?? "" != ""{
                   var arrayId: [Int] = []
                   for selectedModel in self.array_Language{
                       arrayId.append(Int(selectedModel.id!)!)
                   }
                   self.callUpdateProfileApi(languageArray: arrayId, isDelete: false)
               }
           }else{
               model = self.array_Language[0]
               if model.language ?? "" != ""{
                   var arrayId: [Int] = []
                   for selectedModel in self.array_Language{
                       if let _ = selectedModel.id{
                           arrayId.append(Int(selectedModel.id!)!)
                       }else{
                       }
                   }
                   self.callUpdateProfileApi(languageArray: arrayId, isDelete: false)
               }
           }
       }
    
    @IBAction func btnAddAnotherAction(_ sender: Any) {
        var model = LocalLanguageModel()
        model.isEmpty = true
        model.isDelete = false
        self.array_Language.append(model)
        self.calculateHeightForTable()
        self.table_View.reloadData()
        self.btnSaveDelete.setTitle("SAVE_BTN".localized(), for: .normal)
        self.btnSaveDelete.isHidden = false
        self.selectedIndex = 0
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

//MARK:- Extension SignUpVC of UITableView
extension NBLanguageVC: UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_Language.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.table_View.separatorColor = UIColor.clear
        self.table_View.tableFooterView = UIView()
        
        let cell : TextWithCrossTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "TextWithCrossTableViewCell", for: indexPath) as! TextWithCrossTableViewCell
        cell.txtField.setPlaceholder(placeholder: "".localized())
        cell.txtField.setLeftPaddingPoints(10.0)
        cell.txtField.placeholder = "SELECT_LANGUAGE".localized()
        
        let model = self.array_Language[indexPath.row]
        
        cell.txtField.text = model.language ?? ""
        cell.txtField.tag = indexPath.row
        
        self.txtField = cell.txtField
        self.txtField.delegate = self

        //Hide Delete Button If we have one language only
        if self.array_Language.count == 1{
            cell.btnCross.isHidden = true
        }
        else if self.array_Language.count == 2{
            if self.array_Language[0].isEmpty! == false && self.array_Language[1].isEmpty! == false{
                cell.btnCross.isHidden = false
            }else{
                cell.btnCross.isHidden = true
            }
        }
        else{
            if model.isEmpty! == true{
                cell.btnCross.isHidden = true
            }else{
                cell.btnCross.isHidden = false
            }
        }
        
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(btnDeleteTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnDeleteTapped(sender: UIButton){
        let model = self.array_Language[sender.tag]
        var arrayId: [Int] = []
        if model.language ?? "" != ""{
            self.arrLanguage.append(model.language!)
            self.array_Language.remove(at: sender.tag)
            if self.array_Language.count > 0{
                for selectedModel in self.array_Language{
                    if selectedModel.id != nil{
                        arrayId.append(Int(selectedModel.id!)!)
                    }
                }
            }
            self.calculateHeightForTable()
            self.table_View.reloadData()
            self.callUpdateProfileApi(languageArray: arrayId, isDelete: true)
        }
    }
}


extension NBLanguageVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var tempModel = self.array_Language[self.txtField.tag]
        if tempModel.isEmpty! == false{
            self.view.endEditing(true)
        }else{
            PickerViewController.openPickerView(viewC: self, dataArray: self.arrLanguage) { (value, index) in
                print(self.txtField.tag)
                for model in self.arrayOfAvaiableLanguages{
                    if model.attributes!.title! == value{
                        tempModel.id = model.id!
                        tempModel.language = model.attributes!.title!
                        tempModel.isDelete = false
                        tempModel.isEmpty = false
                    }
                }
                self.selectedIndex = self.txtField.tag
                self.array_Language[self.txtField.tag] = tempModel
                self.table_View.reloadData()
                self.btnSaveDelete.setTitle("SAVE_BTN".localized(), for: .normal)
                self.btnSaveDelete.isHidden = false
            }
        }
    }
}

extension NBLanguageVC: AlertDelegate{
    
}
