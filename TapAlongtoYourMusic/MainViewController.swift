//
//  MainViewController.swift
//  TapAlongtoYourMusic2
//
//  Created by Dan Xue on 2015-07-29.
//  Copyright (c) 2015 Dan Xue. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    // MARK - Model
    var avAudioSession = AVAudioSession()
    var systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        // Handle AVAudioSession
        do {try avAudioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
         _ = try avAudioSession.setActive(true)
        } catch {
            print("error")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set up audio notifications
        
        systemMusicPlayer.beginGeneratingPlaybackNotifications()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setMusicInfoLabel", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: nil)
    }
    

    //MARK - Segues
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        setMusicInfoLabel()
    }
    
    override func viewDidDisappear(animated: Bool) {
        systemMusicPlayer.endGeneratingPlaybackNotifications()
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.identifier {
            
        }
    }
    
    
    
    //MARK - systemMusicPlayer Controls
    
    @IBOutlet weak var musicInfoLabel: UILabel! 
    
    func setMusicInfoLabel() {
        let title = systemMusicPlayer.nowPlayingItem!.valueForProperty(MPMediaItemPropertyTitle) as! String
        let artist = systemMusicPlayer.nowPlayingItem!.valueForProperty(MPMediaItemPropertyArtist) as! String
        let album = systemMusicPlayer.nowPlayingItem!.valueForProperty(MPMediaItemPropertyAlbumTitle) as! String
        musicInfoLabel.text! = "\(title) - \(artist) - \(album)"
    }
    
    
    @IBAction func playMusic(sender: UIButton) {
        systemMusicPlayer.play()
    }
    
    @IBAction func pauseMusic(sender: UIButton) {
        systemMusicPlayer.pause()
    }
    
    @IBAction func returnToBeginningOfMusic(sender: UIButton) {
        systemMusicPlayer.skipToBeginning()
    }
    
    @IBAction func nextSong(sender: UIButton) {
        systemMusicPlayer.skipToNextItem()
    }
    
    @IBAction func lastSong(sender: UIButton) {
        systemMusicPlayer.skipToPreviousItem()
    }
}
