//
//  SongSelectionTableViewController.swift
//  TapAlongtoYourMusic2
//
//  Created by Dan Xue on 2015-07-31.
//  Copyright (c) 2015 Dan Xue. All rights reserved.
//

import UIKit

class SongSelectionTableViewController: UITableViewController{
    
    var fromSelectSound = 0
    var sounds: [String] = ["Cowbell", "HiHat", "Snare", "Bounce"]
    var nameToReturn: String = ""
    var setToReturn: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Select a Song"
        
        let leftBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "returnToPrevious")
        self.navigationItem.leftBarButtonItem = leftBackButton
        }
    
    func returnToPrevious() {
        performSegueWithIdentifier("return to previous", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "return to previous" {
        if let dvc = segue.destinationViewController as? ModalViewController {
            dvc.soundSetToReturn = setToReturn
            print("error")
        }
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        nameToReturn = sounds[indexPath.row]
        print("\(setToReturn), \(fromSelectSound)")
        setToReturn[fromSelectSound-1] = nameToReturn
        performSegueWithIdentifier("return to previous", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songCell", forIndexPath: indexPath)
        
        
        cell.textLabel!.text = sounds[indexPath.row]
        
        
        return cell
    }
    
}
