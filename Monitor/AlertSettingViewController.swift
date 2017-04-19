//
//  AlertSettingViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/18/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import Foundation
import UIKit
protocol AlertSettingViewControllerDelegate: class {
    func AlertSettingViewControllerDidCancel(_ controller: AlertSettingViewController)
    func AlertSettingViewController(_ controller: AlertSettingViewController, st: String, sh: String)
}
class AlertSettingViewController: UITableViewController{
    weak var delegate: AlertSettingViewControllerDelegate?

    @IBOutlet weak var tem: UITextField!
    @IBOutlet weak var hum: UITextField!
     var temString :String?
     var humString :String?
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBAction func cancel() {
        delegate?.AlertSettingViewControllerDidCancel(self)
    }
    @IBAction func done() {
        delegate?.AlertSettingViewController(self, st: tem.text!, sh: hum.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tem.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
        hum.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
        tem.text = temString
        hum.text = humString

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textChange(_ textField:UITextField) {
        self.doneBarButton.isEnabled = (textField.text?.characters.count)!>0
    }

}

