//
//  LoginViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/14/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//


import UIKit
import SnapKit
import Alamofire

class account {
    static var name = ""
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func viewClick(_ sender: AnyObject) {
        restore()
    }
    
    let urlString = "http://www.reebh.com:8080/checklogin.php"
    var txtUser: UITextField! //用户名输入框
    var txtPwd: UITextField! //密码输入款
    var formView: UIView! //登陆框视图
    var horizontalLine: UIView! //分隔线
    var confirmButton:UIButton! //登录按钮
    var titleLabel: UILabel! //标题标签
    
    var topConstraint: Constraint? //登录框距顶部距离约束
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //视图背景色
        self.view.backgroundColor = UIColor(red: 1/255, green: 170/255, blue: 235/255, alpha: 1)
        //登录框高度
        let formViewHeight = 90
        //登录框背景
        self.formView = UIView()
        self.formView.layer.borderWidth = 0.5
        self.formView.layer.borderColor = UIColor.lightGray.cgColor
        self.formView.backgroundColor = UIColor.white
        self.formView.layer.cornerRadius = 5
        self.view.addSubview(self.formView)
        //最常规的设置模式
        self.formView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            //存储top属性
            self.topConstraint = make.centerY.equalTo(self.view).constraint
            make.height.equalTo(formViewHeight)
        }
        
        //分隔线
        self.horizontalLine =  UIView()
        self.horizontalLine.backgroundColor = UIColor.lightGray
        self.formView.addSubview(self.horizontalLine)
        self.horizontalLine.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView)
        }
        
        //用户名图标
        let imgLock1 =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgLock1.image = UIImage(named:"iconfont-user")
        
        //密码图标
        let imgLock2 =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgLock2.image = UIImage(named:"iconfont-password")
        
        //用户名输入框
        self.txtUser = UITextField()
        self.txtUser.delegate = self
        self.txtUser.placeholder = "用户名"
        self.txtUser.tag = 100
        self.txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        self.txtUser.leftViewMode = UITextFieldViewMode.always
        self.txtUser.returnKeyType = UIReturnKeyType.next
        self.txtUser.enablesReturnKeyAutomatically = true
        
        //用户名输入框左侧图标
        self.txtUser.leftView!.addSubview(imgLock1)
        self.formView.addSubview(self.txtUser)
        
        //布局
        self.txtUser.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(self.formView).offset(-formViewHeight/4)
        }
        
        //密码输入框
        self.txtPwd = UITextField()
        self.txtPwd.delegate = self
        self.txtPwd.placeholder = "密码"
        self.txtPwd.tag = 101
        self.txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        self.txtPwd.leftViewMode = UITextFieldViewMode.always
        self.txtPwd.returnKeyType = UIReturnKeyType.done
        self.txtPwd.isSecureTextEntry = true
        self.txtUser.enablesReturnKeyAutomatically = true

        
        //密码输入框左侧图标
        self.txtPwd.leftView!.addSubview(imgLock2)
        self.formView.addSubview(self.txtPwd)
        
        //布局
        self.txtPwd.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(self.formView).offset(formViewHeight/4)
        }
        
        //登录按钮
        self.confirmButton = UIButton(type: .system)
  
        self.confirmButton.setTitle("登录", for: UIControlState())
        self.confirmButton.setTitleColor(UIColor.black,
                                         for: UIControlState())
        self.confirmButton.layer.cornerRadius = 5
        self.confirmButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1,
                                                     alpha: 0.5)
        self.confirmButton.addTarget(self, action: #selector(loginConfrim),
                                     for: .touchUpInside)
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(self.formView.snp.bottom).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        //标题label
        self.titleLabel = UILabel()
        self.titleLabel.text = "智能监测系统"
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont.systemFont(ofSize: 36)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.formView.snp.top).offset(-20)
            make.centerX.equalTo(self.view)
            make.height.equalTo(44)
        }
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -125)
            self.view.layoutIfNeeded()
        })
    }
    
    //输入框返回时操作
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        let tag = textField.tag
        switch tag {
        case 100:
            
            self.txtPwd.becomeFirstResponder()
        case 101:
            loginConfrim()
        default:
            break
        }
        return true
    }
    
    //登录按钮点击
    func loginConfrim(){
        self.confirmButton.isEnabled = false
        self.txtPwd.isEnabled = false
        self.txtUser.isEnabled = false
    
        self.confirmButton.setTitle("正在登陆...", for: UIControlState())
        //验证成功
        if (txtUser.text != "") && (txtPwd.text != "") {
            //self.performSegue(withIdentifier: "login", sender: self)
            
            //creating parameters for the post request
            let parameters: Parameters=[
                "name":txtUser.text!,
                "password":txtPwd.text!
            ]
        
            //Sending http post request
            Alamofire.request(urlString, method: .post, parameters: parameters).responseString { response in
                if let result = response.result.value {
                    if result == "1" {
                        self.txtPwd.resignFirstResponder()
                        self.txtUser.resignFirstResponder()
                        account.name = self.txtUser.text!
                        
                        let alertController = UIAlertController(title: "登陆成功！", message: nil, preferredStyle: .alert)
                        //显示提示框
                        self.present(alertController, animated: true, completion: nil)
                        //两秒钟后自动消失
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.presentedViewController?.dismiss(animated: false, completion: nil)
                            
                            self.performSegue(withIdentifier: "login", sender: self)
                            
                            
                        }
                    } else if result == "0" {
                        self.errorpop()
                    } else {
                        self.neterror()
                    }
                } else {
                    self.neterror()
                }
            }
        } else {
            self.confirmButton.isEnabled = true
            self.txtPwd.isEnabled = true
            self.txtUser.isEnabled = true
            self.confirmButton.setTitle("登陆", for: UIControlState())
            
            let alertController = UIAlertController(title: "请填写完整用户名与密码!", message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func neterror() {
        self.confirmButton.setTitle("登陆", for: UIControlState())
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        
        let alertController = UIAlertController(title: "网络错误!", message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.confirmButton.isEnabled = true
            self.txtPwd.isEnabled = true
            self.txtUser.isEnabled = true
            self.confirmButton.setTitle("登陆", for: UIControlState())
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func errorpop() {
        let alertVC = UIAlertController(title: "用户名或密码错误", message: "请重新输入", preferredStyle: UIAlertControllerStyle.alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive)
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            self.restore()
        }
        alertVC.addAction(acSure)
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
        self.confirmButton.isEnabled = true
        self.txtPwd.isEnabled = true
        self.txtUser.isEnabled = true
        self.confirmButton.setTitle("登陆", for: UIControlState())
    }
    
    func restore() {
        //收起键盘
        self.view.endEditing(true)
        //视图约束恢复初始设置
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        })
    }
    


}

