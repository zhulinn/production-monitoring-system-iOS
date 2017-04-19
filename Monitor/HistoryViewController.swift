//
//  HistoryViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import UIKit
import Alamofire



class HistoryViewController: UIViewController, SettingViewControllerDelegate {
    
    var gridViewController: UICollectionGridViewController!
    let urlString = "http://www.reebh.com:8080/history.php"
    var startString : String!
    var endString: String!
    var row = ["","","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridViewController = UICollectionGridViewController()
        gridViewController.setColumns(columns: ["采集时间                    ", "送风温度", "送风湿度", "回风温度", "回风湿度"])
        


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
    func SettingViewController(_ controller: SettingViewController, startString: String, endString: String) {
        gridViewController = UICollectionGridViewController()
        gridViewController.setColumns(columns: ["采集时间                    ", "送风温度", "送风湿度", "回风温度", "回风湿度"])
        
        
        
        view.addSubview(gridViewController.view)
        self.startString = startString
        self.endString = endString
        query()
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
    
    func query() {
        let parameters: Parameters=[
            "start": startString,
            "end": endString
            ]
        //Sending http post request
        Alamofire.request(urlString, method: .post, parameters: parameters).responseString { response in
            if let result = response.result.value {
                let data = result.data(using: String.Encoding.utf8)
                let records = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                if records.count > 0 {
                    for record in records {
                        self.row[0] = record["Dt"] as! String
                        self.row[1] = record["sfT"] as! String
                        self.row[2] = record["sfH"] as! String
                        self.row[3] = record["hfT"] as! String
                        self.row[4] = record["hfH"] as! String
                        self.gridViewController.addRow(row: self.row)
                    }
                } else {
                    let alertController = UIAlertController(title: "暂无记录!", message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }                }
                
            } else {
                let alertController = UIAlertController(title: "网络错误!", message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }
        }

    }



}
