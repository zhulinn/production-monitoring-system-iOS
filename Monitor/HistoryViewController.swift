//
//  HistoryViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, SettingViewControllerViewControllerDelegate {
    
    var gridViewController: UICollectionGridViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridViewController = UICollectionGridViewController()
        gridViewController.setColumns(columns: ["采集时间                 ", "送风温度", "送风湿度", "回风温度", "回风湿度"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])
        gridViewController.addRow(row: ["2017-4-17 16:45:32", "45", "100", "8", "60"])



        view.addSubview(gridViewController.view)
    }
    override func viewDidLayoutSubviews() {
        let barheight = CGFloat(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? 113 : 81)
        let yvalue = CGFloat(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? 64 : 32)
        gridViewController.view.frame = CGRect(x:0, y:yvalue, width:view.frame.width, height:view.frame.height-barheight)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SettingViewControllerDidCancel(_ controller: SettingViewController) {
        dismiss(animated: true, completion: nil)
    }
    func SettingViewController(_ controller: SettingViewController, startdate: Date, enddate: Date) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        if segue.identifier == "Setting" {
            // 2
            let navigationController = segue.destination  as! UINavigationController

                // 3
            let controller = navigationController.topViewController as! SettingViewController
            // 4
            controller.delegate = self
        }
    }
}
