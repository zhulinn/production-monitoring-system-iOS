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
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let data: [CGFloat] = [3, 4, -2, 11, 13, 15]
        let data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        lineChart.delegate = self
        
    }
    
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label1.text = "x: \(x)     y: \(yValues[0])"
        label2.text = "x: \(x)     y: \(yValues[1])"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
}
