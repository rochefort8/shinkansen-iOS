//
//  Memu.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/04/28.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Menu {
    var name: String
    var name_kanji: String
    var name_kana: String
    var section:[Menu]
}

extension Menu {
    static func createMenus() -> [Menu] {
        
        var info: JSON = JSON.null

        do {
            if let file = Bundle.main.url(forResource: "shinkansen", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let json = JSON(jsonObject)
                info = JSON(json["shinkansen"].arrayValue)
            } else {
                print("no file")
                return []
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
        
        var menus:[Menu]
        menus = []
        let count:Int = info.count
        for i in 0...count-1 {
            let json = JSON(info[i])
            var section:[Menu]
            
            section = []
            let s = JSON(json["section"])
            section.append(Menu(name: s[0]["name"].stringValue,
                                name_kanji: s[0]["name_kanji"].stringValue,
                                name_kana: s[0]["name_kana"].stringValue,
                                section:[]))
            section.append(Menu(name: s[1]["name"].stringValue,
                                name_kanji: s[1]["name_kanji"].stringValue,
                                name_kana: s[1]["name_kana"].stringValue,
                                section:[]))

            menus.append(Menu(name: json["name"].stringValue,
                            name_kanji: json["name_kanji"].stringValue,
                            name_kana: json["name_kana"].stringValue,
                            section: section))
        }
        return menus
    }
}
