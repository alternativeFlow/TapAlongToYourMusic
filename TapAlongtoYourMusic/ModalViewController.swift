//
//  ModalViewController.swift
//  TapAlongtoYourMusic2
//
//  Created by Dan Xue on 2015-07-25.
//  Copyright (c) 2015 Dan Xue. All rights reserved.
//

import Foundation
import UIKit


class ModalViewController: UIViewController {
    
    // Keeps track of which cell is selected for which tap
    var cellArrayForSelected = [[Bool]]()
    //tells the cell which tap view the current instantiation is from
    var fromTap: Int = 0
    var soundSetToReturn: [String] = ["place1", "place2", "place3"]
    var viewArray: [UIView] = []
    var selectSoundToSet = 0

    @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for i in 1...fromTap {
            let viewAdded = addSelectionView(mainView, number: i, color: UIColor.blackColor().CGColor)
            addLabel(viewAdded, text: "Select for Tap \(i)", color: UIColor.whiteColor())
            viewArray.append(viewAdded)
        }
        for i in 1...(8-fromTap){
            let viewAdded = addSelectionView(mainView, number: (i+fromTap), color: UIColor.blueColor().CGColor)
            addLabel(viewAdded, text: "Sound Set \(i)", color: UIColor.whiteColor())
            viewArray.append(viewAdded)
        }
        
 
        
    }
    
    func addLabel(addToView: UIView, text: String, color: UIColor) -> UILabel{
        let labelToAdd = UILabel()
        labelToAdd.text = text
        labelToAdd.textColor = color
        let x = addToView.bounds.origin.x
        let y = addToView.bounds.height/4
        let width = addToView.bounds.width
        let height = addToView.bounds.height/2
        labelToAdd.frame = CGRect(x: x, y: y, width: width, height: height)
        addToView.addSubview(labelToAdd)
        return labelToAdd
    }
    
    func addSelectionView(addToView: UIView, number: Int, color: CGColor) -> UIView{
        let viewToAdd = UIView()
        let height = addToView.frame.height/8
        let x = addToView.frame.origin.x
        let y = (height*CGFloat(number-1))
        let width = addToView.frame.width
        viewToAdd.frame = CGRect(x: x, y: y, width: width, height: height)
        viewToAdd.layer.backgroundColor = color
        addToView.addSubview(viewToAdd)
        return viewToAdd
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func back(){
        switch fromTap {
        case 1:
            performSegueWithIdentifier("return to one", sender: self)
        case 2:
            performSegueWithIdentifier("return to two", sender: self)
        case 3:
            performSegueWithIdentifier("return to three", sender: self)
        default:
            break
        }
    }

    @IBAction func returnToModal(segue: UIStoryboardSegue){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "show song selection" {
        if let dvc = segue.destinationViewController as? UINavigationController {
            if let tvc = dvc.topViewController as? UITableViewController {
                if let ssvc = tvc as? SongSelectionTableViewController {
                        ssvc.fromSelectSound = selectSoundToSet
                        ssvc.setToReturn = soundSetToReturn
                    
                }
            }
        }
        }
        
        let id = segue.identifier
        if (id=="return to one")||(id=="return to two")||(id=="return to three") {
            if let dvc = segue.destinationViewController as? OneViewController {
                dvc.soundSet = soundSetToReturn
            }
            if let dvc = segue.destinationViewController as? TwoViewController {
                dvc.soundSet = soundSetToReturn
            }
            if let dvc = segue.destinationViewController as? ThreeViewController {
                dvc.soundSet = soundSetToReturn
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(mainView)
        
        for selectedView in viewArray {
            if selectedView.frame.contains(location){
                    selectedView.layer.opacity = 0.5
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(mainView)
        
        for selectedView in viewArray {
            if !selectedView.frame.contains(location){
                //Add check for changed properties here
                selectedView.layer.opacity = 1
            }
            else if selectedView.frame.contains(location){
                    selectedView.layer.opacity = 0.5

                
            }
        }
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>!, withEvent event: UIEvent!) {
        for selectedView in viewArray {
            selectedView.layer.opacity = 1
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(mainView)
        
        for (index, selectedView) in viewArray.enumerate() {
            if selectedView.frame.contains(location){
                
                selectedView.layer.opacity = 1
                if index<fromTap {
                    selectSoundToSet=index+1
                    performSegueWithIdentifier("show song selection", sender: self)
                }
                else{
                    //unwind to tap
                    performSegueWithIdentifier("return to \(fromTap)", sender: self)
                }
            }
        }
        
    }
    
    
}