//
//  HyakuninIsshu.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2017/10/21.
//  Copyright © 2017年 Yuji Ogihara. All rights reserved.
//

import Foundation
import AVFoundation

import SwiftyJSON

struct LineInfo {
    var name: String        = ""
    var name_kanji: String  = ""
    var name_kana: String   = ""
}

struct MapInfo {
    var id       : String   = ""
    var location : CGPoint  = CGPoint(x: 0.0,y:0.0)
    var text     : CGPoint  = CGPoint(x: 0.0,y:0.0)
}

struct StationInfo {
    var id : String         = ""
    var name: String        = ""
    var name_kanji: String  = ""
    var name_kana: String   = ""
    var map      : MapInfo  = MapInfo()
}


class ShinkansenLine: NSObject {
    
    var lineInfo: JSON = JSON.null
    var stationInfo: JSON = JSON.null
    
    // Constructor
    
    func create(name: String){
        parseJsonData(name:name)
    }
    
    func getLineInfo() -> LineInfo {
        return LineInfo(name: lineInfo["name"].stringValue,
                        name_kanji: lineInfo["name_kanji"].stringValue,
                        name_kana: lineInfo["name_kana"].stringValue)
    }
    func getStationCount() -> Int{
        return stationInfo.count
    }

    func getStation(number:Int) -> StationInfo {
        let json = JSON(stationInfo[number])
        let json_map  = JSON(json["map"])
        let json_location   = JSON(json_map["location"])
        let json_text   = JSON(json_map["text"])

        var mapInfo = MapInfo()
        mapInfo.id = json_map["id"].stringValue
        mapInfo.location = CGPoint(x :json_location["x"].doubleValue,
                                   y :json_location["y"].doubleValue)        
        mapInfo.text     = CGPoint(x :json_text["x"].doubleValue,
                                   y :json_text["y"].doubleValue)

        return StationInfo(id:json["id"].stringValue,
                           name: json["name"].stringValue,
                           name_kanji: json["name_kanji"].stringValue,
                           name_kana: json["name_kana"].stringValue,
                           map:     mapInfo)
        
    }

    func getStations() -> [StationInfo] {
        var stations:[StationInfo]
        stations = []

        for i in 0...stationInfo.count-1 {
            stations.append(getStation(number: i))
        }
        stations.reverse()
        return stations
    }

    private func parseJsonData(name:String) {
        do {
            if let file = Bundle.main.url(forResource: name, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                lineInfo = JSON(jsonObject)
                stationInfo = JSON(lineInfo["station"].arrayValue)
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
