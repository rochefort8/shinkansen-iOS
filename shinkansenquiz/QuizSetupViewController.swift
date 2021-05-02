//
//  YomiageSetupViewController.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/04/28.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuizSetupViewController: UIViewController  {
    @IBOutlet var bannerView: GADBannerView!
    
    @IBOutlet var shinkansenView: UIImageView!
    @IBOutlet var name_kana: UILabel!
    @IBOutlet var name_kanji: UILabel!
    @IBOutlet var section_kanji: UILabel!
    @IBOutlet var section_kana: UILabel!
    @IBOutlet var signalView: UIImageView!
    @IBOutlet var isOutbound: UISwitch!
    
    /*
     @IBOutlet var shinkansenView: UIImageView!
     @IBOutlet weak var isAutomaticPlayNextSwitch: UISwitch!
    */
    let numberOfShimonokuRepeatList: [String] = ["1", "2", "3", "4"]
    var menu = Menu()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let banner = GoogleMobileAds()
        banner.createBannarView(view: bannerView, parent: self)
        
        let name = menu.name + "_" + String(Int.random(in: 0 ... 2)) + ".jpg"
        shinkansenView.image = UIImage(named: name)
        name_kanji.text     = menu.name_kanji + "新幹線"
        name_kana.text      = menu.name_kana + "しんかんせん"
        
/*
        section_kanji.text  = menu.section[0].name_kanji + " ~ " + menu.section[1].name_kanji
        section_kana.text   = menu.section[0].name_kana  + "   " + menu.section[1].name_kana
*/
        loadUserDefaluts()
        setSection()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController : QuizViewController = (segue.destination as? QuizViewController )!
        viewController.lineName = menu.name
        viewController.isOutbound = isOutbound.isOn
    }
 
    private func setSection() {
        
        var indexFrom   = 0,indexTo     = 1
        
        if !isOutbound.isOn {
            indexTo     = 0
            indexFrom    = 1
        }
        
        section_kanji.text  = menu.section[indexFrom].name_kanji +
            " ~ " + menu.section[indexTo].name_kanji
        section_kana.text   = menu.section[indexFrom].name_kana  + "   " + menu.section[indexTo].name_kana
    }
    private func loadUserDefaluts() {
    /*
        let k1 = UserDefaults.standard.integer(forKey: "yomiage_isAutomaticPlayNext")
        isAutomaticPlayNextSwitch.isOn = (k1 != 0)
        let k2:Int = UserDefaults.standard.integer(forKey: "yomiage_numberOfShimonokuRepeats")
        pickerView.selectRow(k2-1, inComponent:0, animated:true)
    */
    }
    @IBAction func onDirectionChanged(_ sender: Any) {
        setSection()
    }
}

extension QuizSetupViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfShimonokuRepeatList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfShimonokuRepeatList[row]
    }
}
