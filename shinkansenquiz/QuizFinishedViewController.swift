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
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        let banner = GoogleMobileAds()
        banner.createBannarView(view: bannerView, parent: self)
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
