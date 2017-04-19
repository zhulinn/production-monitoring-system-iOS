//
//  SecondViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import UIKit
import QuartzCore



class GraphViewController: UIViewController, LineChartDelegate, DataViewControllerDelegate {
    
    var timer :Timer?
    
    var records = [[String: Any]]()
    var isfirst = true
    let url20 = URL(string: "http://www.reebh.com:8080/lasttwenty.php")!
    var data1 = [CGFloat(0.0), CGFloat(0)]
    var data2 = [CGFloat(0.0), CGFloat(0)]
    var data3 = [CGFloat(0.0), CGFloat(0)]
    var data4 = [CGFloat(0.0), CGFloat(0)]
 //   var xLabels = [String]()
    
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationController0 = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let controller0 = navigationController0.topViewController as! DataViewController
        controller0.delegate = self
        
        lineChart.animation.enabled = false
        lineChart.area = true
        lineChart.x.labels.visible = false
        lineChart.x.grid.count = CGFloat(data1.count)
        lineChart.y.grid.count = 10
       //lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        
        lineChart.x.axis.visible = true
        lineChart.y.axis.visible = true
        lineChart.y.axis.inset = 20
        lineChart.x.axis.inset = 20
        lineChart.dots.innerRadius = 5
        lineChart.dots.outerRadius = 7
        lineChart.dots.innerRadiusHighlighted = 6
        lineChart.dots.outerRadiusHighlighted = 8
        
        lineChart.area = false

        lineChart.addLine(data1)
        lineChart.addlinename("送风温度")
        lineChart.addLine(data2)
        lineChart.addlinename("送风湿度")
        lineChart.addLine(data3)
        lineChart.addlinename("回风温度")
        lineChart.addLine(data4)
        lineChart.addlinename("回风湿度")
     
        lineChart.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "SecondRefresh"), object: nil)
    }
    

    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label1.isHidden = false
        label2.isHidden = false
        label3.isHidden = false
        label4.isHidden = false

        label1.text = "送风温度: \(yValues[0])"
        label3.text = "送风湿度： \(yValues[1])"
        label2.text = "回风温度: \(yValues[2])"
        label4.text = "回风湿度： \(yValues[3])"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
      refresh()
    }
    func refresh() {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    func performStoreRequest(with url: URL) -> String? {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Download Error: \(error)")
            return nil
        }
    }
    
    func datainit() {
        if let jsonString = self.performStoreRequest(with: self.url20) {
            let data = jsonString.data(using: String.Encoding.utf8)
            records = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]

            self.data1.removeAll()
            self.data2.removeAll()
            self.data3.removeAll()
            self.data4.removeAll()
            
            for record in records.reversed() {
                data1.append(StringToFloat(str: record["sfT"] as! String))
                data2.append(StringToFloat(str: record["sfH"] as! String))
                data3.append(StringToFloat(str: record["hfT"] as! String))
                data4.append(StringToFloat(str: record["hfH"] as! String))
            }
            self.lineChart.addLine(self.data1)
            self.lineChart.addLine(self.data2)
            self.lineChart.addLine(self.data3)
            self.lineChart.addLine(self.data4)
            
            
        }
       
    }
    func StringToFloat(str:String)->(CGFloat){
        
        let string = str
        var cgFloat: CGFloat = 0
        
        
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    func gotrecord(_ controller: DataViewController, record: [String:Any]) {
        if isfirst {
            isfirst = false
            let queue = DispatchQueue.global()
            queue.async {
                self.datainit()
                self.lineChart.clear()
                self.refresh()
            }

            
        }
        if data1.count == 20 {
            data1.remove(at: 0)
            data2.remove(at: 0)
            data3.remove(at: 0)
            data4.remove(at: 0)
            
            data1.append(StringToFloat(str: record["sfT"] as! String))
            data2.append(StringToFloat(str: record["sfH"] as! String))
            data3.append(StringToFloat(str: record["hfT"] as! String))
            data4.append(StringToFloat(str: record["hfH"] as! String))
            
            lineChart.clear()
            lineChart.addLine(data1)
            lineChart.addLine(data2)
            lineChart.addLine(data3)
            lineChart.addLine(data4)
            //lineChart.x.labels.values = xLabels
            
            refresh()
        }
    }
    

}
