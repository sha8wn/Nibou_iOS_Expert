
import Foundation
import UIKit

func isValidEmail(email:String) -> Bool {
    let emailRegEx = "[a-zA-Z0-9][a-zA-Z0-9\\.\\_\\-\\!\\#\\$\\'\\*\\+\\=\\?\\^\\`\\{\\}\\~\\/]{0,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
    ")+"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func isValidMobile(Mobile:String) -> Bool{
    let RegEx = "^[0-9]{10,16}$"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: Mobile)
}


func isValidMobileForCountryCode(mobileNumber: String) -> Bool{
    if mobileNumber.prefix(2) == "62"{
        return false
    }else if mobileNumber.prefix(3) == "062"{
        return false
    }else{
        return true
    }
}



func checkMobileNumber(Mobile:String) -> Bool{
    let RegEx = "^0*$"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: Mobile)
}

func isValidName(name: String) -> Bool{
    let RegEx = "[a-zA-Z\\s]+"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: name)
}


func trimString(str: String) -> String{
    return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}

func isNumeric(string: String) -> Bool
{
    let RegEx = "^[0-9]*$"
    let test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return test.evaluate(with: string)
}

func isValidUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}
