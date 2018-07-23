//
//  ViewController.swift
//  TapAlongtoYourMusic2
//
//  Created by Dan Xue on 2015-07-24.
//  Copyright (c) 2015 Dan Xue. All rights reserved.
//

import UIKit
import AVFoundation



class OneViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var soundOne: NSURL?
    var soundSet = ["Bounce"]
    var audioPlayers: [AVAudioPlayer] = []
    var audioPlayerIDs: [[Int]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor.grayColor().CGColor
        applyPlainShadow(oneTap)

        let loadSoundModalGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenEdgePan:")
        loadSoundModalGesture.edges = .Left
        self.view.addGestureRecognizer(loadSoundModalGesture)
        
        //Instantiate the audioplayers
        for _ in 0...7{
            if let url = loadSoundFilePath("Bounce"){
                
                //check if necessary to instantiate with URL
                do {let audioPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
            audioPlayers.append(audioPlayer)
                } catch {
                    print("error")
                }
            }
        }
        audioPlayerIDs.append([Int]())

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    func applyPlainShadow(image: UIImageView) {
        var layer = image.layer
        
        layer.shadowColor =  UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
    }
    
    
    //MARK - AudioPlayer Methods
    func loadSoundPlayerAndPlay(soundName: String, tapNumber: Int) {
        let count = audioPlayers.count
        for i in 0..<count {
            if audioPlayers[i].playing == false {
                if let url = loadSoundFilePath(soundName){
                    do {audioPlayers[i] = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
                    audioPlayers[i].prepareToPlay()
                    audioPlayers[i].play()
                    audioPlayerIDs[tapNumber].append(i)
                    break
                    } catch {
                        print("Error")
                    }
                }
                }
            }
        }
    

    func loadSoundFilePath(soundName: String)-> NSURL? {
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "wav")!)
        return url
    }


    //MARK - Gestures
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(self.view)
        
        handleIfTouchesBeganInTap(oneTap, tapNumber: 1, location: location)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(view)
        let previousLocation = touch!.previousLocationInView(view)
        
        
        // Very haphazard, Volume level not changing
        if oneTap.frame.contains(previousLocation){
            if oneTap.frame.contains(location) {
//                let x = location.x - previousLocation.x
                let y = location.y - previousLocation.y
//                let z = sqrt(abs(x) + abs(y))
//                let length = sqrt(z)
                for i in 0..<audioPlayers.count {
                    if audioPlayers[i].playing == true {
                        for j in 0..<audioPlayerIDs[1].count {
                            if audioPlayerIDs[1][j] == i {
//                                println("x:\(x), y:\(y), z:\(z), length:\(length) \(oneTap.frame.width)")
                                    audioPlayers[i].volume -= Float(y/100)
                            }
                        }
                    }
                }
            }
        }
        handleIfTouchesMovedOutOfTapFrame(oneTap, tapNumber: 1, location: location)
    }
    
    override func touchesCancelled(touches: Set<UITouch>!, withEvent event: UIEvent?) {
        handleIfTouchesCancelled(oneTap)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(view)
        
        handleIfTouchesEndedInTap(oneTap, tapNumber: 1, location: location)
    }
    
    func handleIfTouchesBeganInTap(tap: UIImageView, tapNumber: Int, location: CGPoint){
        if tap.frame.contains(location) {
            loadSoundPlayerAndPlay(soundSet[0], tapNumber: tapNumber)
            UIView.animateWithDuration(0.015625, delay: 0, options: .Autoreverse, animations: { [unowned self] in
                tap.frame.origin.y += 3
                tap.frame.size.width += 5
                }, completion: nil)
        }
    }
    
    func handleIfTouchesMovedOutOfTapFrame(tap: UIImageView, tapNumber: Int, location: CGPoint){
        if !tap.frame.contains(location) {
            for i in 0..<audioPlayers.count {
                if audioPlayers[i].playing == true {
                    for j in 0..<audioPlayerIDs[1].count {
                        if audioPlayerIDs[tapNumber][j] == i {
                            audioPlayers[i].stop()
                            audioPlayerIDs[tapNumber].removeAtIndex(j)
                            UIView.animateWithDuration(0.015625, delay: 0, options: .CurveEaseIn, animations: {
                                [unowned self] in
                                tap.frame.origin.y -= 3
                                tap.frame.size.width -= 5
                                }, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    //NEVER TESTED AND POTENTIALLY IMPROPERLY IMPLEMENTED
    func handleIfTouchesCancelled(tap: UIImageView){
        for i in 0..<audioPlayers.count {
            if audioPlayers[i].playing == true {
                audioPlayers[i].stop()
                for j in 0..<audioPlayerIDs[1].count {
                    if audioPlayerIDs[1][j] == i{
                        audioPlayerIDs[1].removeAtIndex(j)
                        UIView.animateWithDuration(0.015625, delay: 0, options: .CurveEaseIn, animations: {
                            [unowned self] in
                            tap.frame.origin.y -= 3
                            tap.frame.size.width -= 5
                            }, completion: nil)
                    }
                }
            }
        }
        
    }
    
    func handleIfTouchesEndedInTap(tap: UIImageView, tapNumber: Int, location: CGPoint) {
        if tap.frame.contains(location){
            //from i=0 to count of elements in audioPlayers array, if the i th element of audioplayers array is playing, check in the audioplayersID array for the existence of the index number by going through the array of the tapCircle contained in the audioPlayersID array that we're checking
            for i in 0..<audioPlayers.count {
                
                //IF SOUND ENDS WITHOUT FINGER BEING REMOVED, STATEMENT BELOW NEVER EXECUTES AND LEADS TO ERROR
                if audioPlayers[i].playing == true {
                    for j in 0..<audioPlayerIDs[tapNumber].count{
                        //If index of audioplayer in it's array exists as an element in the ID array, stop the audioplayer as this indicates it's playing and is associated with the tap, then set it from the ID array
                        if audioPlayerIDs[tapNumber][j] == i{
                            audioPlayers[i].stop()
                            audioPlayerIDs[tapNumber].removeAtIndex(j)
                            UIView.animateWithDuration(0.015625, delay: 0, options: .CurveEaseIn, animations: {
                                [unowned self] in
                                tap.frame.origin.y -= 3
                                tap.frame.size.width -= 5
                                }, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        performSegueWithIdentifier("show modal view one", sender: self)
    }

    
    @IBOutlet weak var oneTap: UIImageView!
    

    @IBAction func cancelToViewControllerOne(segue: UIStoryboardSegue){
    }
    
    @IBAction func backToMain(sender: UIButton) {
        self.performSegueWithIdentifier("backToMain", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? ModalViewController{
            dvc.fromTap = 1
            dvc.soundSetToReturn = soundSet
        
        }
    }
}

