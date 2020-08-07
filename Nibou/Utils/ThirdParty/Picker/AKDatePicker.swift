//
//  AKDatePicker.swift
//
//
//  Created by Sakshi Singh on 27/03/17.
//  Copyright © 2017 Sakshi Singh. All rights reserved.
//

import Foundation
import UIKit

class AKDatePicker : UIDatePicker {
    
    internal typealias PickerDone = (_ date : Date) -> Void
    private var doneBlock : PickerDone!
    
    class func openPicker(in textField: UITextField, currentDate: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, pickerMode: UIDatePicker.Mode, doneBlock: @escaping PickerDone) {
        
        let picker = AKDatePicker()
        picker.doneBlock = doneBlock
        picker.backgroundColor = UIColor.white
        picker.openPickerInTextField(textField: textField, currentDate: currentDate, minimumDate: minimumDate, maximumDate: maximumDate, pickerMode: pickerMode)
        
    }
    
//    class func openPicker(in button: UIButton, currentDate: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, pickerMode: UIDatePicker.Mode, doneBlock: @escaping PickerDone) {
//
//        let picker = AKDatePicker()
//        picker.doneBlock = doneBlock
//        picker.backgroundColor = UIColor.white
//
//        picker.openPickerInTextField(button: button, currentDate: currentDate, minimumDate: minimumDate, maximumDate: maximumDate, pickerMode: pickerMode)
//
//    }
    
    private func openPickerInTextField(textField: UITextField, currentDate: Date?, minimumDate: Date?, maximumDate: Date?, pickerMode: UIDatePicker.Mode) {
        
        self.datePickerMode = pickerMode
        
        
        self.maximumDate = maximumDate //?? NSDate() //NSDate(timeIntervalSinceNow: -1.577e+8)
        self.date = currentDate ?? Date()
        self.minimumDate = minimumDate //?? NSDate() //NSDate(timeIntervalSince1970: -1000000000)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(AKDatePicker.pickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(AKDatePicker.pickerCancelButtonTapped))
        doneButton.tintColor = UIColor(red: 129/255, green: 181/255, blue: 60/255, alpha: 1)
        cancelButton.tintColor = UIColor(red: 129/255, green: 181/255, blue: 60/255, alpha: 1)
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton,spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField.inputView = self
        textField.inputAccessoryView = toolbar
        
    }
    
//    private func openPickerInTextField(button: UIButton, currentDate: Date?, minimumDate: Date?, maximumDate: Date?, pickerMode: UIDatePicker.Mode) {
//
//        self.datePickerMode = pickerMode
//
//
//        self.maximumDate = maximumDate //?? NSDate() //NSDate(timeIntervalSinceNow: -1.577e+8)
//        self.date = currentDate ?? Date()
//        self.minimumDate = minimumDate //?? NSDate() //NSDate(timeIntervalSince1970: -1000000000)
//
//        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(AKDatePicker.pickerDoneButtonTapped))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(AKDatePicker.pickerCancelButtonTapped))
//        doneButton.tintColor = UIColor(red: 129/255, green: 181/255, blue: 60/255, alpha: 1)
//        cancelButton.tintColor = UIColor(red: 129/255, green: 181/255, blue: 60/255, alpha: 1)
//
//
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let array = [cancelButton,spaceButton, doneButton]
//        toolbar.setItems(array, animated: true)
//        toolbar.backgroundColor = UIColor.lightText
//
//        button.inputView = self
//        button.inputAccessoryView = toolbar
//
//
//    }
    
    @IBAction private func pickerDoneButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        self.doneBlock(self.date)
    }
    
    @IBAction private func pickerCancelButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        self.setDate(Calendar.current.date(byAdding: .year, value: 0, to: Date(), wrappingComponents: false)!, animated: false)
    }
}
