//
//  MenuViewCell.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/05/12.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name_kanji: UILabel!
    @IBOutlet var name_kana: UILabel!
    @IBOutlet var section_kanji: UILabel!
    @IBOutlet var section_kana: UILabel!
    
    func configurateTheCell(_ menu: Menu) {
        
        let name = menu.name + "_" + String(Int.random(in: 0 ... 2)) + ".jpg"
        imageView.image = UIImage(named: name)
        name_kanji.text     = menu.name_kanji + "新幹線"
        name_kana.text      = menu.name_kana + "しんかんせん"
        section_kanji.text  = menu.section[0].name_kanji + " ~ " + menu.section[1].name_kanji
        section_kana.text   = menu.section[0].name_kana  + "   " + menu.section[1].name_kana
    }
}
