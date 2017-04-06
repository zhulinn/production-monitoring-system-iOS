//
//  TabBarController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/6/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //这边不用这个代码swift自动集成了代理 直接用就可以了
        //        self.tabBar.delegate = self
        
    }
    
    //代理点击事件
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print(item.tag)
        if item.tag == 0 {
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "FirstRefresh"), object: nil)
        }
        else if item.tag == 1
        {
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "SecondRefresh"), object: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
