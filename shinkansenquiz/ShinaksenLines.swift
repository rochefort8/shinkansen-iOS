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
    var name: String
    var name_kanji: String
    var name_kana: String
}

struct StationInfo {
    var id : String
    var name: String
    var name_kanji: String
    var name_kana: String
}

class ShinkansenLine: NSObject {
    
    var lineInfo: JSON = JSON.null
    var stationInfo: JSON = JSON.null
    
    // Constructor
    init(name: String){
        super.init()
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
        return StationInfo(id:json["id"].stringValue,
                           name: json["name"].stringValue,
                           name_kanji: json["name_kanji"].stringValue,
                           name_kana: json["name_kana"].stringValue)
    }

    func getStations() -> [StationInfo] {
        var stations:[StationInfo]
        stations = []

        for i in 0...stationInfo.count-1 {
            let json = JSON(stationInfo[i])
            stations.append(StationInfo(id:json["id"].stringValue,
                        name: json["name"].stringValue,
                        name_kanji: json["name_kanji"].stringValue,
                        name_kana: json["name_kana"].stringValue))
        }
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

