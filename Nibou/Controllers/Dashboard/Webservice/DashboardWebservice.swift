//
//  DashboardWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 13/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension NBDashboardVC{
    
    func callGetOverallPaymentAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetOverallPayment
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(DashboardOverallModel.self, from: response?.data ?? Data())
                    
                    guard let totalAmt = responseModel.data?.attributes?.amount else {return}
                    
                    self.totalAmount = String(totalAmt.stringWithoutZeroFraction)

                    let totalSec = responseModel.data?.attributes?.total_seconds ?? 0

                    let sec = totalSec / 60
   
//                    let totalMin = Int(sec) % 60
                    
                let totalMin = Int(sec)
                    
                    self.lbl_noOfAEDtotal.text = "₺ " + self.totalAmount
                    self.lbl_noOftotalMins.text = String(totalMin) + " " + "MINS".localized()
                    
                    self.callGetMonthlyPaymentAPI()
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 404{
                    self.lbl_noOfAEDtotal.text = "₺ 0"
                    self.lbl_noOftotalMins.text = "0 " + "MINS".localized()
                }else{
                    self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    func callGetMonthlyPaymentAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetMonthlyPayment + "\(getFirstDayOfCurrentMonth())"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(DashboardOverallModel.self, from: response?.data ?? Data())
                    
                    guard let totalAmount = responseModel.data?.attributes?.amount else {return}
                    
                    self.totalAmountMonthly = String(totalAmount.stringWithoutZeroFraction)
          
                    let totalSec = responseModel.data?.attributes?.total_seconds ?? 0
                    
                    let sec = totalSec / 60
                    
                    let totalMin = Int(sec)
                    
                    self.lbl_noOfAEDmonth.text = "₺ " + self.totalAmount
                    self.lbl_noOfmonthMins.text = String(totalMin) + " " + "MINS".localized()
                    
                    
                    //DATE
                    guard let strDate = responseModel.data?.attributes?.date_at else {return}
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let date = dateFormatter.date(from: strDate)
                    let joinedOn = "\(convertDateFormater(date: date!, format:"dd MMMM yyyy"))"
                    self.lbl_joinDate.text = "JOINED_ON".localized() + " \(joinedOn)"
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 404{
                    self.lbl_noOfAEDmonth.text = "₺ 0"
                    self.lbl_noOfmonthMins.text = "0 " + "MINS".localized()
                }else{
                    self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    func getFirstDayOfCurrentMonth() -> String{
        let calendar = Calendar.current
        let firstDayComponents = calendar.dateComponents([.year, .month], from: Date())
        let firstDay = calendar.date(from: firstDayComponents)!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: firstDay)
        
        return date
    }
    
}
