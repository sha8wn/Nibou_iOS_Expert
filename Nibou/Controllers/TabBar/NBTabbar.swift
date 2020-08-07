//
//  NBTabbar.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Change unselected Tabbar Item color
        UITabBar.appearance().unselectedItemTintColor = FunctionConstants.getInstance().hexStringToUIColor("b5e0e0")

        // selected icon or text color
        UITabBar.appearance().tintColor = FunctionConstants.getInstance().hexStringToUIColor("6bc2c2")
        
        //remove topbar line
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        self.tabBar.barTintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
