//
//  PanelView.swift
//  WeiBoTest
//
//  Created by apple on 28/12/16.
//  Copyright © 2016年 mark. All rights reserved.
//  封装的版本
/*
  使用方法:
  外部创建
   lazy var panel:PanelView = PanelView()

   //设置视图位置，添加到view
   panel.center = view.center
 
   view.addSubview(panel)
 

*/
import UIKit

class PanelView: UIView {

    
    public lazy var progressLayer = CAShapeLayer()
    public lazy var alertprogressLayer = CAShapeLayer()

    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var radius = CGFloat(0)
    var threshold = CGFloat(0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        radius = width < height ? width/6 : height/6

        /// 创建圆
        createCircle()
        
        /// 创建刻度
        createscale()
        
        /// 创建刻度值
        createCircleValue()
        
        /// 进度曲线
        createProgressLine()
    }
  /*
    public  init(frame: CGRect, s: CGFloat) {
        super.init(frame: frame)
        threshold = s
        radius = width < height ? width/6 : height/6

        createCircle()
        
        /// 创建刻度
        createscale()
        
        /// 创建刻度值
        createCircleValue()
        
        /// 进度曲线
        createProgressLine()
        
    }
*/    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        radius = width < height ? width/6 : height/6

        /// 创建圆
        createCircle()
        
        /// 创建刻度
        createscale()
        
        /// 创建刻度值
        createCircleValue()
        
        /// 进度曲线
        createProgressLine()
    }
    
    
    /// 创建圆
    fileprivate func createCircle(){
        
        /// 创建圆
        let cicrle = UIBezierPath(arcCenter: center,
                                  radius: radius*5/8,
                                  startAngle: -(CGFloat(M_PI*9)/8),
                                  endAngle: (CGFloat(M_PI)/8),
                                  clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = radius/16
        shapeLayer.lineCap = "round"
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(colorLiteralRed: 185/255.0, green: 243/255.0, blue: 110/255.0, alpha: 1.0).cgColor
        shapeLayer.path = cicrle.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
        
    }
    
    /// 创建刻度
    fileprivate func createscale(){
        
        /// 创建刻度
        
        let perAngle: CGFloat = CGFloat(M_PI*5)/4/50
        
        for i in 0...50 {
            
            let startAngle = -(CGFloat(M_PI*9)/8) + perAngle*CGFloat(i)
            let endAngle = startAngle + perAngle/5
            
            let tickPath = UIBezierPath(arcCenter: center,
                                        radius: radius*7/8,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
            
            let perLayer = CAShapeLayer()
            if i%5 == 0{
        
                perLayer.strokeColor = UIColor.orange.cgColor
                perLayer.lineWidth = radius/16
                
            }else{
                
                perLayer.strokeColor = UIColor.orange.cgColor
                perLayer.lineWidth = radius/32
            }
            
            perLayer.path = tickPath.cgPath
            
            self.layer.addSublayer(perLayer)
        }
        
    }
    
    /// 创建刻度值
    fileprivate func createCircleValue(){
        
        /// 创建刻度值
        
        let textAngle = Float(M_PI*5)/4/10
        
        for i in 0...10 {
            
            let point = calculateTextPositon(center,-Float(M_PI)/8+textAngle*Float(i))
            
            let tickString = "\(labs(10-i)*10)"
            
            let label = UILabel(frame: CGRect(x: point.x - 10, y: point.y - 7, width: 23, height: 14))
            label.text = tickString
            label.font = UIFont.systemFont(ofSize: 8)
            label.textColor = UIColor.black
            label.textAlignment = .center
            addSubview(label)
        }
    }
    
    /// 进度曲线
    fileprivate func createProgressLine(){
        
        /// 进度曲线
        let progressPath = UIBezierPath(arcCenter: center,
                                        radius: 120/3,
                                        startAngle: -(CGFloat(M_PI*9)/8),
                                        endAngle: (CGFloat(M_PI)/8),
                                        clockwise: true)
        progressLayer.lineWidth = radius*3/16
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.cyan.cgColor
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0.70
        layer.addSublayer(progressLayer)

        
        // 警报曲线
        alertprogressLayer.lineWidth = radius*3/16
        alertprogressLayer.fillColor = UIColor.clear.cgColor
        alertprogressLayer.strokeColor = UIColor.red.cgColor
        alertprogressLayer.path = progressPath.cgPath
        alertprogressLayer.strokeStart = threshold
        alertprogressLayer.strokeEnd = progressLayer.strokeEnd
    
        layer.addSublayer(alertprogressLayer)


    }
    
    /// 计算文本的位置
    private func calculateTextPositon(_ ArcCenter: CGPoint,_ angle: Float) -> CGPoint{
        
        let x = Float(radius)*cosf(angle)
        let y = Float(radius)*sinf(angle)
        
        return CGPoint(x: ArcCenter.x + CGFloat(x), y: ArcCenter.y - CGFloat(y))
    }


}
