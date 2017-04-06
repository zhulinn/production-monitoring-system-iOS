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
    var interval = 2
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
            update()
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dashboard
        Positionconf()
        view.addSubview(panelSFT)
        view.addSubview(panelSFH)
        view.addSubview(panelHFT)
        view.addSubview(panelHFH)
        
        //TabBar 监听
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "FirstRefresh"), object: nil)
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        refresh()
    }

    func refresh() {
        //print("refresh")
        Positionconf()
        panelSFT.setNeedsDisplay()
        panelSFH.setNeedsDisplay()
        panelHFT.setNeedsDisplay()
        panelHFH.setNeedsDisplay()
    }
    
    func Positionconf() {
        //  centers of dashboards
        let h = CGFloat(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? 120 : 70)
        let left = UIScreen.main.bounds.size.width*5/18
        let right = UIScreen.main.bounds.size.width*13/18
        let h1 = panelSFT.radius + h
        let bottom = UIScreen.main.bounds.size.height - 50
        let half = (bottom - h)/2 + h
        let h2 = panelHFT.radius + half
        panelSFT.center = CGPoint(x: left, y: h1)
        panelSFH.center = CGPoint(x: right, y: h1)
        panelHFT.center = CGPoint(x: left, y: h2)
        panelHFH.center = CGPoint(x: right, y: h2)
        //  origin of Labels
        SFTLabel.frame.origin.x = left - SFTLabel.frame.width/2
        SFTLabel.frame.origin.y = (h1 + half)/2 - SFTLabel.frame.height/2 + 10
        
        SFHLabel.frame.origin.x = right - SFHLabel.frame.width/2
        SFHLabel.frame.origin.y = SFTLabel.frame.origin.y
        
        HFTLabel.frame.origin.x = SFTLabel.frame.origin.x
        HFTLabel.frame.origin.y = (h2 + bottom)/2 - HFTLabel.frame.height/2 + 10
        
        HFHLabel.frame.origin.x = SFHLabel.frame.origin.x
        HFHLabel.frame.origin.y = HFTLabel.frame.origin.y
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
                let SFT = jsonArr[0]["Tp"] as! String
                let SFH = jsonArr[0]["Hr"] as! String
                self.SFTLabel.text = "送风温度：\(SFT)"
                self.SFHLabel.text = "送风湿度：\(SFH)"
                UIView.animate(withDuration: 0.3)
                {
                    self.panelSFT.progressLayer.strokeEnd = self.StringToFloat(str: SFT) * 0.01
                    self.panelSFH.progressLayer.strokeEnd = self.StringToFloat(str: SFH) * 0.01
                }
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

    
    
    
}

