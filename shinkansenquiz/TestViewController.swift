//
//  TestViewController.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/05/19.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var shinkansenLine:ShinkansenLine = ShinkansenLine()
    var numberOfStations:Int = 0
    var stations:[StationInfo] = [StationInfo()]
    var currentStationIndex = -1

    var pointIndex = 0
    var drawView = DrawView()
    var scale:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shinkansenLine.create(name:"tokaido")
        numberOfStations = shinkansenLine.getStationCount()
        stations = shinkansenLine.getStations()

        scale = view.bounds.width / 480.0
        
        let rect:CGRect = CGRect(x : imageView.frame.origin.x,
                                 y : imageView.frame.origin.y,
                                 width : view.bounds.width,
                                 height: view.bounds.width*3/4)
                                 
        
        drawView = DrawView(frame: rect)
        drawView.setParams(_stations: stations,_scale:scale,_mapView: imageView)
        self.view.addSubview(drawView)
    }
    
    @IBAction func onButton(_ sender: Any) {

        currentStationIndex += 1
        drawView.index = currentStationIndex
        drawView.setNeedsDisplay()

        if (currentStationIndex >= stations.count) {
            currentStationIndex = -1
        }        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

class DrawView: UIView {
    
    var index:Int = -1
    {
        didSet {
            if oldValue != index {
                self.setNeedsDisplay()
            }
        }
    }

    var stations:[StationInfo] = [StationInfo()]
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    func setParams(_stations:[StationInfo],_scale:CGFloat,_mapView:UIImageView) {
        stations = _stations
        scale = _scale
        mapView = _mapView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var scale:CGFloat = 1.0
    
    var oldMapIndex = 0
    var mapView: UIImageView!

    override func draw(_ rect: CGRect) {
        
        if (index == -1) {
            return
        }
        let mapIndex:Int    = Int(stations[index + 1].map.id)!
        if mapIndex != oldMapIndex {
            // Update map
            let mapString = ("tokaido" + "_map_" +
                String(format: "%02d",mapIndex) + "_base")
            mapView.image  = UIImage(named: mapString + ".jpg")
            oldMapIndex = mapIndex
        }
        
        let location_x  = stations[index + 1].map.location.x * scale
        let location_y  = stations[index + 1].map.location.y * scale
        let text_x      = stations[index].map.text.x * scale
        let text_y      = stations[index].map.text.y * scale
        
        let circle = UIBezierPath(arcCenter: CGPoint(x: location_x, y: location_y), radius: 9, startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: true)
        // 内側の色
        UIColor(red: 1, green: 0, blue: 0, alpha: 1.0).setFill()
        // 内側を塗りつぶす
        circle.fill()
        // 線の色
        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).setStroke()
        // 線の太さ
        circle.lineWidth = 2.0
        // 線を塗りつぶす
        circle.stroke()
        
        let title = UILabel()
        title.text = stations[index].name_kanji
        title.frame = CGRect(x:text_x,y:text_y,width: 50,height:30)
        //        title.textAlignment = .center
        addSubview(title)
    }

}
