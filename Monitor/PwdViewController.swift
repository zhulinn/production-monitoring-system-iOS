//
//  PwdViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/18/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PwdViewController: UITableViewController, UITextFieldDelegate {
    let urlString = "http://www.reebh.com:8080/changepwd.php"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var oldpwd: UITextField!
    @IBOutlet weak var newpwd: UITextField!
    @IBOutlet weak var checkpwd: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameTextField.text = account.name
        oldpwd.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
        newpwd.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
        checkpwd.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        oldpwd.delegate = self
        newpwd.delegate = self
        checkpwd.delegate = self
        oldpwd.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        if (oldpwd.text != "") && (newpwd.text != "") && (checkpwd.text != "") {
            if newpwd.text == checkpwd.text {
                self.upload()
            } else {
                let alertController = UIAlertController(title: "两次填写的密码不一致！", message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "请填写完整密码！", message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    //输入框返回时操作
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        
        let tag = textField.tag
        
        switch tag {
        case 101:
            self.oldpwd.resignFirstResponder()
            self.newpwd.becomeFirstResponder()
        case 102:
            self.newpwd.resignFirstResponder()
            self.checkpwd.becomeFirstResponder()
        case 103:
            self.checkpwd.resignFirstResponder()
            done()
        default:
            break
        }
        return true
 
    }

    
    func upload() {
        let parameters: Parameters=[
            "name": account.name,
            "oldpwd": oldpwd.text!,
            "newpwd": newpwd.text!
            ]
        //Sending http post request
        Alamofire.request(urlString, method: .post, parameters: parameters).responseString { response in
            if let result = response.result.value {
                if result == "0" {
                    self.wrongpwdpop()
                } else if result == "1" {
                    self.successpop()
                } else {
                    self.neterror()
                }
            } else {
                self.neterror()
            }
        }
    }
    
    func textChange(_ textField:UITextField) {
        self.doneBarButton.isEnabled = (oldpwd.text?.characters.count)!>0 && (newpwd.text?.characters.count)!>0 && (checkpwd.text?.characters.count)!>0
    }
    
    func neterror() {
        let alertController = UIAlertController(title: "网络错误!", message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    func successpop() {
        let alertVC = UIAlertController(title: "密码修改成功", message: "请重新登陆", preferredStyle: UIAlertControllerStyle.alert)
        let acCancel = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            
            
            if let timer = timer {
                timer.invalidate()
            }
            self.performSegue(withIdentifier: "forceout", sender: self)
        }
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    func wrongpwdpop() {
        let alertController = UIAlertController(title: "密码错误!请重新输入！", message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
