//
//  FirstViewController.swift
//  Monitor
//
//  Created by Julian Zhu on 4/3/17.
//  Copyright © 2017 Lin Zhu. All rights reserved.
//


import UIKit
import AudioToolbox

protocol DataViewControllerDelegate: class {
    func gotrecord(_ controller: DataViewController, record: [String:Any])
}

class DataViewController: UIViewController, AlertSettingViewControllerDelegate{
    
    weak var delegate: DataViewControllerDelegate?
    var urlString = "http://www.reebh.com:8080/lastone.php"
    var interval = 2
    var isupdating = false
    var url: URL!
    var timer: Timer?
    var st: CGFloat!
    var sh: CGFloat!
    var isPlaying = false
    var soundId: SystemSoundID = 0
    
   lazy var panelSFH : PanelView = PanelView()
   lazy var panelSFT : PanelView = PanelView()
   lazy var panelHFH : PanelView = PanelView()
   lazy var panelHFT : PanelView = PanelView()
    
    
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var SFTLabel: UILabel!
    @IBOutlet weak var SFHLabel: UILabel!
    @IBOutlet weak var HFTLabel: UILabel!
    @IBOutlet weak var HFHLabel: UILabel!

    @IBOutlet weak var STLabel: UILabel!
    @IBOutlet weak var SHLabel: UILabel!
    
    
    
    @IBAction func getData() {
        if !isupdating {
            url = URL(string: urlString)!
            getButton.setTitle("停止", for: .normal)
            update()
            startTimer()
            isupdating = true
          
            
        } else {
            getButton.setTitle("获取数据", for: .normal)
            stopTimer()
            isupdating = false
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Dashboard
        Positionconf()
        view.addSubview(panelSFT)
        view.addSubview(panelSFH)
        view.addSubview(panelHFT)
        view.addSubview(panelHFH)
        
        threholdconf()
        
       
 
        //TabBar 监听
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "FirstRefresh"), object: nil)
        
        // SoundID
        let filename = "alert"
        let ext = "wav"
        
        if let soundUrl = Bundle.main.url(forResource: filename, withExtension: ext) {
           AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
        }
      
        
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
        //threhold
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
            }
            DispatchQueue.main.async {
                self.delegate?.gotrecord(self, record: jsonArr[0])
                let SFT = jsonArr[0]["sfT"] as! String
                let SFH = jsonArr[0]["sfH"] as! String
                let HFT = jsonArr[0]["hfT"] as! String
                let HFH = jsonArr[0]["hfH"] as! String

                self.SFTLabel.text = "送风温度：\(SFT)"
                if self.StringToFloat(str: SFT) >= self.st {
                    self.SFTLabel.textColor = UIColor.red
                    self.alert()
                } else {
                    self.SFTLabel.textColor = UIColor.black
                }
            
                self.SFHLabel.text = "送风湿度：\(SFH)"
                if self.StringToFloat(str: SFH) >= self.sh {
                    self.SFHLabel.textColor = UIColor.red
                    self.alert()
                } else {
                    self.SFHLabel.textColor = UIColor.black
                }
                
                self.HFTLabel.text = "回风温度：\(HFT)"
                if self.StringToFloat(str: HFT) >= self.st {
                    self.HFTLabel.textColor = UIColor.red
                    self.alert()
                } else {
                    self.HFTLabel.textColor = UIColor.black
                }
                
                self.HFHLabel.text = "回风湿度：\(HFH)"
                if self.StringToFloat(str: HFH) >= self.sh {
                    self.HFHLabel.textColor = UIColor.red
                    self.alert()
                } else {
                    self.HFHLabel.textColor = UIColor.black
                }
                
                UIView.animate(withDuration: 0.3)
                {
                    self.panelSFT.progressLayer.strokeEnd = self.StringToFloat(str: SFT) * 0.01
                    self.panelSFT.alertprogressLayer.strokeEnd = self.panelSFT.progressLayer.strokeEnd

                    self.panelSFH.progressLayer.strokeEnd = self.StringToFloat(str: SFH) * 0.01
                    self.panelSFH.alertprogressLayer.strokeEnd = self.panelSFH.progressLayer.strokeEnd
                    
                    self.panelHFT.progressLayer.strokeEnd = self.StringToFloat(str: HFT) * 0.01
                    self.panelHFT.alertprogressLayer.strokeEnd = self.panelHFT.progressLayer.strokeEnd
                    
                    self.panelHFH.progressLayer.strokeEnd = self.StringToFloat(str: HFH) * 0.01
                    self.panelHFH.alertprogressLayer.strokeEnd = self.panelHFH.progressLayer.strokeEnd
                    
                }
            }
        }
        
    }
    
    func threholdconf() {
        st = StringToFloat(str: (STLabel.text!))
        self.panelSFT.alertprogressLayer.strokeStart = st*0.01
        self.panelHFT.alertprogressLayer.strokeStart = st*0.01
        
        sh = StringToFloat(str: (SHLabel.text!))
        self.panelSFH.alertprogressLayer.strokeStart = sh*0.01
        self.panelHFH.alertprogressLayer.strokeStart = sh*0.01
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
    
    func alert() {

        AudioServicesPlayAlertSound(soundId)
 
    }
    
    func AlertSettingViewControllerDidCancel(_ controller: AlertSettingViewController) {
        dismiss(animated: true, completion: nil)
    }
    func AlertSettingViewController(_ controller: AlertSettingViewController, st: String, sh: String) {
        dismiss(animated: true, completion: nil)
        STLabel.text = st
        SHLabel.text = sh
        threholdconf()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        if segue.identifier == "AlertSetting" {
            // 2
            let navigationController = segue.destination  as! UINavigationController
            
            // 3
            let controller = navigationController.topViewController as! AlertSettingViewController
            // 4
            controller.delegate = self
            controller.temString = self.STLabel.text
            controller.humString = self.SHLabel.text

        }
    }
}

