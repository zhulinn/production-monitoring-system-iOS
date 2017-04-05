//
//  FirstViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//


import UIKit

class DataViewController: UIViewController {
    
    
    let  urlString = "http://www.reebh.com:8080/readlast.php"
    var interval = 1
    var updating = false
    var url: URL!
    var timer: Timer?
    
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var SFTLabel: UILabel!
    @IBOutlet weak var SFHLabel: UILabel!
    @IBOutlet weak var HFTLabel: UILabel!
    @IBOutlet weak var HFHLabel: UILabel!

    @IBOutlet weak var STLabel: UILabel!
    @IBOutlet weak var SHLabel: UILabel!
    
    @IBAction func getData() {
        if !updating {
            url = URL(string: urlString)!
            getButton.setTitle("Stop", for: .normal)
            startTimer()
            updating = true
        } else {
            getButton.setTitle("Get My Data", for: .normal)
            stopTimer()
            updating = false
        }
    }
    lazy var panelSFT:PanelView = PanelView()
    lazy var panelSFH:PanelView = PanelView()
    lazy var panelHFT:PanelView = PanelView()
    lazy var panelHFH:PanelView = PanelView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //封装的版本
        Positionconf()

        view.addSubview(panelSFT)
        view.addSubview(panelSFH)
        view.addSubview(panelHFT)
        view.addSubview(panelHFH)
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timesTest), userInfo: nil, repeats: true)
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
 
        Positionconf()
        panelSFT.setNeedsDisplay()
        panelSFH.setNeedsDisplay()
        panelHFT.setNeedsDisplay()
        panelHFH.setNeedsDisplay()
    }
    /*
    func Constraintsconf() {
        LeftLeading.constant = UIScreen.main.bounds.size.width*5/40
        RightLeading.constant =  UIScreen.main.bounds.size.width*10/40
    }
*/
    
    func Positionconf() {
        //  centers of dashboards
        let h = CGFloat(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? 120 : 70)
        let left = UIScreen.main.bounds.size.width*5/18
        let right = UIScreen.main.bounds.size.width*13/18
        let h1 = panelSFT.radius + h
        let h2 = panelHFT.radius + (UIScreen.main.bounds.size.height - h - 50)/2 + h
        panelSFT.center = CGPoint(x: left, y: h1)
        panelSFH.center = CGPoint(x: right, y: h1)
        panelHFT.center = CGPoint(x: left, y: h2)
        panelHFH.center = CGPoint(x: right, y: h2)
        //  origin of Labels
        
    }
    
    func showDataLabel() {
   
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    func update() {
        let queue = DispatchQueue.global()
        
        
        var jsonArr: [[String: Any]]!
        queue.async {
            if let jsonString = self.performStoreRequest(with: self.url) {
                
                let data = jsonString.data(using: String.Encoding.utf8)
                jsonArr = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                print("tp：", jsonArr[0]["Tp"]!, "    hr：", jsonArr[0]["Hr"]!)
                
            }
            DispatchQueue.main.async {
                let SFT = jsonArr[0]["Tp"] as? String
                let SFH = jsonArr[0]["Hr"] as? String
                self.SFTLabel.text = SFT
                self.SFHLabel.text = SFH
                self.panelSFT.progressLayer.strokeEnd = self.StringToFloat(str: SFT!) * 0.01
                self.panelSFH.progressLayer.strokeEnd = self.StringToFloat(str: SFH!) * 0.01
            }
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
    func StringToFloat(str:String)->(CGFloat){
        
        let string = str
        var cgFloat: CGFloat = 0
        
        
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    @objc func timesTest(){
        

        let c = CGFloat(arc4random()%100)
        let d = CGFloat(arc4random()%100)
        UIView.animate(withDuration: 0.3) {

            self.panelHFT.progressLayer.strokeEnd = c*0.01
            self.panelHFH.progressLayer.strokeEnd = d*0.01
        }
    }
    
    
    
}

