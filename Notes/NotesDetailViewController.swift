//
//  NotesDetailViewController.swift
//  Notes
//
//  Created by Pragnesh Dixit on 13/03/15.
//  Copyright (c) 2015 Nick Grosvenor. All rights reserved.
//

import Foundation
import UIKit
class NotesDetailViewController: UIViewController{
      @IBOutlet weak var lblTitleText: UILabel!
      @IBOutlet weak var imgView: UIImageView!
        var strTitle:String!
        var str:String!
        var strdate: NSDate!
        var indexofNote:Int!
        var noteObjects: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexofNote) as NSMutableDictionary
        strdate = object["date"] as NSDate
        imgView.image =  object["image"] as UIImage
        self.lblTitleText.text = strTitle
        var swipeUP = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUP.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUP)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexofNote) as NSMutableDictionary
        var dateFormatter = NSDateFormatter()
        var dateStr = object["date"] as? NSDate
        dateFormatter.dateFormat = "MMM dd,yyyy"
        var DateInFormat = dateFormatter.stringFromDate(dateStr!)
        NSLog(DateInFormat)
        self.title = DateInFormat

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
           // self.fetchAllObjectsFromLocalDataStore()
        //self.fetchAllObjects()
    }
    func fetchAllObjectsFromLocalDataStore(){
        
        var query: PFQuery = PFQuery(className: "Note")
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        query.orderByDescending("date")
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            
            if (error == nil){
                var temp: NSArray = objects as NSArray
                self.noteObjects = temp.mutableCopy() as NSMutableArray
                var object: PFObject = self.noteObjects.objectAtIndex(self.indexofNote) as PFObject
                self.strTitle = object["title"] as? String
                self.lblTitleText.text = self.strTitle
                
            } else {
                println(error.userInfo)
            }
            
        }
        
    }
    
    func fetchAllObjects(){
        
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query: PFQuery = PFQuery(className: "Note")
        
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        
        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            
            if (error == nil){
                
                PFObject.pinAllInBackground(objects, block: nil)
                
                self.fetchAllObjectsFromLocalDataStore()
                
            } else {
                
                println(error.userInfo)
                
            }
            
        }
    }
    
    
    @IBAction func btnpresentActivityController(sender: AnyObject) {
        
        let titleText:String! = lblTitleText.text?
        let imgShare:UIImage = imgView.image!
        let activityViewController = UIActivityViewController(
            activityItems: [imgShare],
            applicationActivities: nil)
        self.navigationController?.presentViewController(activityViewController, animated: true, completion: { () -> Void in
            
        });
    
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
           
            if(swipeGesture.direction == UISwipeGestureRecognizerDirection.Up){
                if(indexofNote < self.noteObjects.count-1)
                {
                    
                    self.indexofNote = self.indexofNote + 1
                    var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexofNote) as NSMutableDictionary
                     imgView.image =  object["image"] as UIImage
                    self.strTitle = object["title"] as? String
                    lblTitleText.text = strTitle
                     strdate = object["date"] as NSDate
                    
                    var dateFormatter = NSDateFormatter()
                    var dateStr = object["date"] as? NSDate
                    dateFormatter.dateFormat = "MMM dd,yyyy"
                    var DateInFormat = dateFormatter.stringFromDate(dateStr!)
                    self.title = DateInFormat
                    var animation:CATransition = CATransition()
                    animation.duration = 0.4
                    animation.type = kCATransitionPush
                    animation.subtype = kCATransitionFromTop
                    animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                    (self.view.layer).addAnimation(animation, forKey: nil)
                }
                
            }
            else if(swipeGesture.direction == UISwipeGestureRecognizerDirection.Down)
            {
                if(indexofNote > 0)
                {
                    self.indexofNote = self.indexofNote - 1
                    var animation:CATransition = CATransition()
                    animation.duration = 0.4
                    animation.type = kCATransitionPush
                    animation.subtype = kCATransitionFromBottom
                    animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                    (self.view.layer).addAnimation(animation, forKey: nil)
                    var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexofNote) as NSMutableDictionary
                    imgView.image =  object["image"] as UIImage
                     strdate = object["date"] as NSDate
                    self.strTitle = object["title"] as? String
                    lblTitleText.text = strTitle
                    var dateFormatter = NSDateFormatter()
                    var dateStr = object["date"] as? NSDate
                    dateFormatter.dateFormat = "MMM dd,yyyy"
                    var DateInFormat = dateFormatter.stringFromDate(dateStr!)
                    self.title = DateInFormat
                }
               
            }
        }
    }
  
    
    
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        var editNote:AddNoteTableViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("AddNoteTableViewController") as AddNoteTableViewController
        editNote.strDate = self.strdate
        editNote.isEdited = true
        editNote.imageObj = imgView.image
        editNote.strTitle = lblTitleText.text
        editNote.strNavTitle = self.title
        self.navigationController?.pushViewController(editNote, animated: true)

        
    }

}