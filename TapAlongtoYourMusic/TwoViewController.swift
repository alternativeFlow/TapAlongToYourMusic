//
//  ViewController.swift
//  TapAlongtoYourMusic2
//
//  Created by Dan Xue on 2015-07-24.
//  Copyright (c) 2015 Dan Xue. All rights reserved.
//

import UIKit
import AVFoundation

class TwoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    
    
    
    
    var soundOne: NSURL?
    var soundSet = ["wavSampleSound", "wavSampleSound"]
    var audioPlayers: [AVAudioPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.grayColor()
        
        applyPlainShadow(oneTap)
        applyPlainShadow(twoTap)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        gesture.delegate = self
        oneTap.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action: "handleTap2:")
        gesture2.delegate = self
        twoTap.addGestureRecognizer(gesture2)
        
        let loadSoundModalGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenEdgePan:")
        loadSoundModalGesture.edges = .Left
        self.view.addGestureRecognizer(loadSoundModalGesture)
        
        //Instantiate the audioplayers
        for i in 0...7{
            if let url = loadSoundFilePath("wavSampleSound"){
                do { let audioPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
                audioPlayers.append(audioPlayer)
                } catch {
                    print("error")
                }
            }
        }
        
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
    func loadSoundPlayerAndPlay(soundName: String) {
        let count = audioPlayers.count
        for i in 0..<count {
            if audioPlayers[i].playing == false {
                if let url = loadSoundFilePath(soundName){
                    do {audioPlayers[i] = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
                    audioPlayers[i].prepareToPlay()
                    audioPlayers[i].play()
                    break
                    } catch {
                        print("error")
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
    
    func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        performSegueWithIdentifier("show modal view two", sender: self)
    }
    
    
    func handleTap(gesture: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.015625, delay: 0, options: .Autoreverse, animations: { [unowned self] in
            self.oneTap.frame.origin.y += 3
            self.oneTap.frame.size.width += 5
            }, completion: {[unowned self] (Bool) in
                self.oneTap.frame.origin.y -= 3
                self.oneTap.frame.size.width -= 5
                
            })
        loadSoundPlayerAndPlay(soundSet[0])
    }
    func handleTap2(gesture: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.015625, delay: 0, options: .Autoreverse, animations: { [unowned self] in
            self.twoTap.frame.origin.y += 3
            self.twoTap.frame.size.width += 5
            }, completion: {[unowned self] (Bool) in
                self.twoTap.frame.origin.y -= 3
                self.twoTap.frame.size.width -= 5
                
            })
        loadSoundPlayerAndPlay(soundSet[1])
    }
    
    @IBOutlet weak var oneTap: UIImageView!

    @IBOutlet weak var twoTap: UIImageView!
    
    
    @IBAction func cancelToViewControllerTwo(segue: UIStoryboardSegue){
    }
    
    @IBAction func backToMain(sender: UIButton) {
        self.performSegueWithIdentifier("backToMain", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? ModalViewController{
            dvc.fromTap = 2
            dvc.soundSetToReturn = soundSet            
        }
    }
}

