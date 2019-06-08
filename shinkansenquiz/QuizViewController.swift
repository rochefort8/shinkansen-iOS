//
//  QuizViewController.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/05/12.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    var name:String = ""
    var isOutbound:Bool = true
    
    @IBOutlet var collectMarkView: UIImageView!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var boardImageView: UIImageView!

    @IBOutlet var answer1Button: UIButton!
    @IBOutlet var answer2Button: UIButton!
    @IBOutlet var answer3Button: UIButton!
    
    @IBOutlet var answer1Text_Kanji: UILabel!
    @IBOutlet var answer2Text_Kanji: UILabel!
    @IBOutlet var answer3Text_Kanji: UILabel!
    @IBOutlet var answer1Text_Kana: UILabel!
    @IBOutlet var answer2Text_Kana: UILabel!
    @IBOutlet var answer3Text_Kana: UILabel!
    
    var shinkansenLine:ShinkansenLine = ShinkansenLine()
    var numberOfStations:Int = 0
    var stations:[StationInfo] = [StationInfo()]
    var currentStationIndex = 0
    
    var answers:[Int] = [0,0,0]
    var correctButtonIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Hide tabbar and back button in navigation bar for this view
        // not neccesary when reading..
        tabBarController?.tabBar.isHidden = true
        navigationItem.hidesBackButton = true
        
        shinkansenLine.create(name:name)
        numberOfStations = shinkansenLine.getStationCount()
        stations = shinkansenLine.getStations()
        if !isOutbound {
            stations.reverse()
        }
        navigationItem.title = shinkansenLine.getLineInfo().name_kanji + "新幹線"
        
        answer1Button.titleLabel?.numberOfLines = 2
        answer2Button.titleLabel?.numberOfLines = 2
        answer3Button.titleLabel?.numberOfLines = 2
        
        currentStationIndex = 0
        update()
    }
    
    @IBAction func onAnswer1Button(_ sender: Any) {
        validateAnswerAndUpdate(index:0)
    }
    
    @IBAction func onAnswer2Button(_ sender: Any) {
        validateAnswerAndUpdate(index:1)
    }
    
    @IBAction func onAnswer3Button(_ sender: Any) {
        validateAnswerAndUpdate(index:2)
    }
    
    private func validateAnswerAndUpdate(index:Int) {
        if (answers[index] == currentStationIndex + 1) {
            print("Correct")
            currentStationIndex += 1
        } else {
            print("Wrong")
            
        }
        /* For testing */
        /*
        if (currentStationIndex > 2) {
            performSegue(withIdentifier: "toQuizFinishedView",sender: nil)
        }
 */
        update()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func update() {
        if (currentStationIndex >= numberOfStations - 1) {
            print("Nothig to do..")
            return
        }
        let correctStationIndex = currentStationIndex + 1   /* Next station (Correct) */
        var closeToTheNextIndex = 0                         /* Previios station */
        var randomIndex = 0
        
        if (correctStationIndex < numberOfStations - 2) {
            /* Next or "Next next" from the corrent station */
            closeToTheNextIndex = correctStationIndex + 1 + Int.random(in: 0 ... 1)
        } else {
            if (correctStationIndex == numberOfStations - 2) {
                closeToTheNextIndex = correctStationIndex + 1
            } else {
                closeToTheNextIndex = currentStationIndex - 1
            }
        }
        
        while (true) {
            randomIndex = Int.random(in: 0 ... numberOfStations - 1)
            if (randomIndex != currentStationIndex) &&
               (randomIndex != correctStationIndex) &&
                (randomIndex != closeToTheNextIndex) {
                break
            }
        }
        answers[0] = correctStationIndex
        answers[1] = closeToTheNextIndex
        answers[2] = randomIndex
        
        /* Shuffle answer */
        for i in 0...answers.count - 1 {
            let j = i + Int.random(in: 0...answers.count-i-1)
            let tmp = answers[i]
            answers[i] = answers[j]
            answers[j] = tmp
        }
        
        /* Update View */
        /*
        let boardString = (name + "_" +
                    String(format: "%02d",currentStationIndex + 1) + "_" +
                    stations[currentStationIndex].name).lowercased()
         */
        let boardString = (name + "_board_" +
//            String(format: "%02d",stations.count - currentStationIndex) + "_" +
            stations[currentStationIndex].name).lowercased()

        /*
        let mapString = (name + "_map_out_" +
                    String(format: "%02d",currentStationIndex + 1) + "_" +
                    stations[currentStationIndex].name).lowercased()
         */
        var directionString = "_map_out_"
        if !isOutbound {
            directionString = "_map_in_"
        }
        let mapString = (name + directionString +
            String(format: "%02d",currentStationIndex + 1) + "_" +
            stations[currentStationIndex].name).lowercased()
        boardImageView.image = UIImage(named: boardString + ".jpg" )
//        boardImageView.layer.borderWidth = 1
//        boardImageView.layer.borderColor = UIColor.black.cgColor
        mapImageView.image  = UIImage(named: mapString + ".jpg")
        mapImageView.layer.borderWidth = 1
        mapImageView.layer.borderColor = UIColor.black.cgColor
        
        answer1Text_Kanji.text  = stations[answers[0]].name_kanji
        answer2Text_Kanji.text  = stations[answers[1]].name_kanji
        answer3Text_Kanji.text  = stations[answers[2]].name_kanji
        answer1Text_Kana.text   = stations[answers[0]].name_kana
        answer2Text_Kana.text   = stations[answers[1]].name_kana
        answer3Text_Kana.text   = stations[answers[2]].name_kana
    }
}
