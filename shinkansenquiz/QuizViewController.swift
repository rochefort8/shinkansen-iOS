//
//  QuizViewController.swift
//  shinkansenquiz
//
//  Created by Yuji Ogihara on 2019/05/12.
//  Copyright © 2019年 Yuji Ogihara. All rights reserved.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController, AVAudioPlayerDelegate {

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
    @IBOutlet var questionText: UILabel!
    
    var shinkansenLine:ShinkansenLine = ShinkansenLine()
    var numberOfStations:Int = 0
    var stations:[StationInfo] = [StationInfo()]
    var currentStationIndex = 0
    
    var answers:[Int] = [0,0,0]
    var correctButtonIndex = 0
    var audioPlayer:AVAudioPlayer!
    
    var coverNextStationView:UIImageView!
    
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
        
        let lineInfo = shinkansenLine.getLineInfo()
        navigationItem.title = lineInfo.name_kanji + "新幹線"
        createCoverView()
        
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
    
    @IBAction func onNext(_ sender: Any) {
        self.currentStationIndex += 1
        self.update()
    }
    
    @IBAction func onStop(_ sender: Any) {
        moveToFinalView()
    }

    private func enableAnswerButton(isEnabled:Bool) {
        answer1Button.isEnabled = isEnabled
        answer2Button.isEnabled = isEnabled
        answer3Button.isEnabled = isEnabled
    }

    private func moveToFinalView() {
        self.performSegue(withIdentifier: "toQuizFinishedView", sender: nil)
    }

    private func createCoverView() {

        let lineInfo = shinkansenLine.getLineInfo()

        let image:UIImage = UIImage(named:lineInfo.cover_view.name)!
        coverNextStationView = UIImageView(image:image)
        let width = image.size.width
        let height = image.size.height
        let scale = view.bounds.width / 640.0
        
        coverNextStationView.frame = CGRect(x:0, y:0, width:width*scale, height:height*scale)
        
        var x:CGFloat = 0.0, y = boardImageView.frame.origin.y
        if  (isOutbound == true) {
            x = x + lineInfo.cover_view.location_out.x * scale
            y = y + lineInfo.cover_view.location_out.y * scale
        } else {
            x = x + lineInfo.cover_view.location_in.x * scale
            y = y + lineInfo.cover_view.location_in.y * scale
        }
        coverNextStationView.layer.position = CGPoint(x: x, y: y)
        self.view.addSubview(coverNextStationView)
    }
    
    private func validateAnswerAndUpdate(index:Int) {
        if (answers[index] == currentStationIndex + 1) {
            
        /* Correct answer */
            print("Correct")
            collectMarkView.isHidden = false
            enableAnswerButton(isEnabled: false)
            coverNextStationView.isHidden = true
            questionText.text = "正解！"
            startAudio(isCorrect: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.coverNextStationView.isHidden = false
                self.questionText.text = "次の駅は？"
                self.enableAnswerButton(isEnabled: true)
                self.collectMarkView.isHidden = true
                self.currentStationIndex += 1
                self.update()
            }
        } else {

        /* Incorrect answer */
            enableAnswerButton(isEnabled: false)
            mapImageView.shake(duration: 1)
            answer1Button.shake(duration: 1)
            answer2Button.shake(duration: 1)
            answer3Button.shake(duration: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.enableAnswerButton(isEnabled: true)
                self.update()
            }
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
    
    private func startAudio(isCorrect:Bool) {
 
        var resourceName = "Quiz_"
        if (isCorrect == true) {
            resourceName += "correct"
        } else {
            // Cuurently no sound
            return
        }
        
        let audioPath = Bundle.main.path(forResource: resourceName, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        var audioError:NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        audioPlayer.play();
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio End with",flag)
    }
    
}

/*
 * Shaker
 * https://gist.github.com/mourad-brahim/cf0bfe9bec5f33a6ea66
 */
extension UIView {
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            ( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
}
