//
//  AccountViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/18/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import Foundation
import UIKit
class AccountViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: "注销将退出当前用户，并返回登陆界面",
                                                    preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "注销", style: .destructive, handler: {
                action in
          //  self.dismiss(animated: true, completion: nil)

                self.performSegue(withIdentifier: "logout", sender: self)
    
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        } else if indexPath.section == 0 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "pwd", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
