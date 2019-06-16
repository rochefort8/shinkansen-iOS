//
//  QuizFinishedViewController.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/05/14.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuizFinishedViewController: UIViewController {

    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var doAgainButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var shinkansenView: UIImageView!
    
    @IBOutlet var message: UILabel!
    
    var lineName:String = ""
    var lineName_kanji = ""
    var numberOfStations = 0
    var numberOfCorrectAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let banner = GoogleMobileAds()
        banner.createBannarView(view: bannerView, parent: self)
        
        message.text = String(numberOfCorrectAnswers) + "個 (" + String(numberOfStations) + "駅)正解！"
        navigationItem.hidesBackButton = true
        navigationItem.title = lineName_kanji + "新幹線"
        let name = lineName + "_" + String(Int.random(in: 0 ... 2)) + ".jpg"
        shinkansenView.image = UIImage(named: name)
    }
    

    @IBAction func onBackButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onDoAgainButton(_ sender: Any) {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
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
