//
//  UICollectionGridViewController.swift
//  hangge_1081
//
//  Created by hangge on 2016/11/19.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import Foundation
import UIKit

//多列表格组件（通过CollectionView实现）
class UICollectionGridViewController: UICollectionViewController {
    //表头数据
    var cols: [String]! = []
    //行数据
    var rows: [[Any]]! = []
    //单元格内容居左时的左侧内边距
    private var cellPaddingLeft:CGFloat = 5
    
    init() {
        //初始化表格布局
        let layout = UICollectionGridViewLayout()
        super.init(collectionViewLayout: layout)
        layout.viewController = self
        collectionView!.backgroundColor = UIColor.white
        collectionView!.register(UICollectionViewCell.self,
                                      forCellWithReuseIdentifier: "cell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.isDirectionalLockEnabled = true
        collectionView!.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView!.bounces = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("UICollectionGridViewController.init(coder:) has not been implemented")
    }
    
    //设置列头数据
    func setColumns(columns: [String]) {
        cols = columns
    }
    
    //添加行数据
    func addRow(row: [Any]) {
        rows.append(row)
        collectionView!.collectionViewLayout.invalidateLayout()
        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView!.frame = CGRect(x:0, y:0,
                                       width:view.frame.width, height:view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //返回表格总行数
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
            if cols.isEmpty {
                return 0
            }
            //总行数是：记录数＋1个表头
            return rows.count + 1
    }
    
    //返回表格的列数
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return cols.count
    }
    
    //单元格内容创建
    override func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                for: indexPath) as UICollectionViewCell
        //单元格边框
        cell.layer.borderWidth = 1
        cell.backgroundColor = UIColor.white
        cell.clipsToBounds = true
        
        //先清空内部原有的元素
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        //添加内容标签
        let label = UILabel(frame: CGRect(x:0, y:0, width:cell.frame.width,
                                          height:cell.frame.height))
        
        //第一列的内容左对齐，其它列内容居中
        if indexPath.row != 0 {
            label.textAlignment = .center
        }else {
            label.textAlignment = .left
            label.frame.origin.x = cellPaddingLeft
        }
        
        //设置列头单元格，内容单元格的数据
        if indexPath.section == 0 {
            let text = NSAttributedString(string: cols[indexPath.row], attributes: [
                NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15)
                ])
            label.attributedText = text
        } else {
            label.font = UIFont.systemFont(ofSize: 15)
            label.text = "\(rows[indexPath.section-1][indexPath.row])"
        }
        cell.addSubview(label)
        
        return cell
    }
    
    //单元格选中事件
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        //打印出点击单元格的［行,列］坐标
        print("点击单元格的[行,列]坐标: [\(indexPath.section),\(indexPath.row)]")
    }
}
