//
//  ChooseLanguageViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class ChooseLanguageViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var lblChooseLanguageStatic      : UILabel!
    @IBOutlet weak var btnEnglish                   : UIButton!
    @IBOutlet weak var btnArabic                    : UIButton!
    @IBOutlet weak var btnTurkish                   : UIButton!
    //end
    
    /**
     MARK: - UIViewController Life Cycle
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblChooseLanguageStatic.text = "CHOOSE_LANGUAGE_STATIC".localized()
    }
    //end

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnEnglishTapped(_ sender: Any) {
        Localize.setCurrentLanguage("en")
        setCurrentLanguage(language: "en")
        self.viewWillAppear(true)
    }
    
    @IBAction func btnArabicTapped(_ sender: Any) {
        Localize.setCurrentLanguage("ar")
        setCurrentLanguage(language: "ar")
        self.viewWillAppear(true)
    }
    
    @IBAction func btnTurkishTapped(_ sender: Any) {
        Localize.setCurrentLanguage("tr")
        setCurrentLanguage(language: "tr")
        self.viewWillAppear(true)
    }
}
