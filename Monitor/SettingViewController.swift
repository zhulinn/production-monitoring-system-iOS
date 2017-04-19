//
//  SettingViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import UIKit
protocol SettingViewControllerDelegate: class {
    func SettingViewControllerDidCancel(_ controller: SettingViewController)
    func SettingViewController(_ controller: SettingViewController, startString: String, endString: String)
}
class SettingViewController: UITableViewController {
    var startdate = Date()
    var enddate = Date()
    weak var delegate: SettingViewControllerDelegate?
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var startdatePicker: UIDatePicker!
    @IBOutlet weak var enddatePicker: UIDatePicker!
    @IBAction func satartdateChanged(_ datePicker: UIDatePicker) {
        startdate = startdatePicker.date
        btnconf()
        updateDueDateLabel()
    }
    @IBAction func enddateChanged(_ datePicker: UIDatePicker) {
        enddate = enddatePicker.date
         btnconf()
        updateDueDateLabel()
    }
    @IBAction func cancel() {
          delegate?.SettingViewControllerDidCancel(self)
    }
    @IBAction func done() {
            delegate?.SettingViewController(self, startString: startLabel.text!, endString: endLabel.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDueDateLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startLabel.text = formatter.string(from: startdate)
        endLabel.text = formatter.string(from: enddate)
    }
    
    func btnconf() {
        if startdate > enddate {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
    }
    
}
