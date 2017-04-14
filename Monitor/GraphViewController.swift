//
//  SecondViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//

import UIKit
import QuartzCore
class GraphViewController: UIViewController, LineChartDelegate {
    
    var timer :Timer?
    
    var data = [CGFloat]()
    var data2 = [CGFloat]()
    var data3 = [CGFloat]()
    var data4 = [CGFloat]()
    var xLabels = [String]()
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [3, 4, -100, 11, 13, 15,1,  20, 4, -2,3, 5,1,  20, 4, -2,-100, 100]
        data2 = [1,  20, 4, -2,3, 5, 4, -2, 11, 13, 15,1, 4, -2, 11, 13, 15,1]
        data3 = [3, 4, -2, 11, 13, 15,1,  20, 4, -2,3, 5,1,  20, 4, -2,3, 5]
        data4 = [1,  20, 4, -2,3, 5, 4, -2, 11, 13, 15,1, 4, -2, 11, 13, 15,1]
        //xLabels = ["1", "2", "3", "4", "5", "6","1", "2", "3", "4", "5", "6","1", "2", "3", "4", "5", "6"]
        
        
        lineChart.animation.enabled = false
        lineChart.area = true
        lineChart.x.labels.visible = false
        lineChart.x.grid.count = CGFloat(data.count)
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
        
        lineChart.area = true
        
        
        lineChart.addLine(data)
        lineChart.addlinename("送风温度")
        lineChart.addLine(data2)
        lineChart.addlinename("送风湿度")
        lineChart.addLine(data3)
        lineChart.addlinename("回风温度")
        lineChart.addLine(data4)
        lineChart.addlinename("回风湿度")
        lineChart.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "SecondRefresh"), object: nil)
    }
    
    func update() {
        data.remove(at: 0)
        data2.remove(at: 0)
        data3.remove(at: 0)
        data4.remove(at: 0)
     //   xLabels.remove(at: 0)
      //  xLabels.append("\(arc4random_uniform(100))")
        data.append(CGFloat(arc4random_uniform(100)) )
        data2.append(CGFloat(arc4random_uniform(100)))
        data3.append(CGFloat(arc4random_uniform(100)) )
        data4.append(CGFloat(arc4random_uniform(100)))
        lineChart.clear()
        lineChart.addLine(data)
        lineChart.addLine(data2)
        lineChart.addLine(data3)
        lineChart.addLine(data4)
        //lineChart.x.labels.values = xLabels
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }    }
    
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
        //print("refresh")
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
}
