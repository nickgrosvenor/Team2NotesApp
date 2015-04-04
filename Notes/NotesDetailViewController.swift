//
//  NotesDetailViewController.swift
//  Notes
//
//  Created by Pragnesh Dixit on 13/03/15.
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
        var indexofDate:Int!
    // MARK:
    // MARK: UIVIewController LifeCycle Methods
    // MARK:

    override func viewDidLoad() {
        super.viewDidLoad()
        indexofDate=0
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
        var DateInFormat = dateFormatter.stringFromDate(strdate!)
        NSLog(DateInFormat)
        self.title = DateInFormat
        var calender:NSCalendar = NSCalendar.currentCalendar()
        let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:strdate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        var currentDate:NSDate = calender.dateFromComponents(components)!
        for object in self.noteObjects{
            var dictData : NSMutableDictionary = object as NSMutableDictionary
            
            if(currentDate == dictData["date"] as NSDate)
            {
                var img:UIImage?
                var imageFile : PFFile?  =  dictData["imageFile"] as? PFFile
                if(imageFile != nil){
                    imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        img =  UIImage(data: data)
                        self.imgView.image = img
                    })
              
                }

                self.strTitle = dictData["title"] as? String
                lblTitleText.text = strTitle
                break
            }
            else
            {
                imgView.image =  nil
                lblTitleText.text = ""
            }
        }


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        


    }
    
    // MARK:
    // MARK: Get Object of Notes From Parse
    // MARK:

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

    // MARK:
    // MARK: UIButton Action Methods
    // MARK:

    @IBAction func btnpresentActivityController(sender: AnyObject) {
        let titleText:String! = lblTitleText.text?
        let imgShare:UIImage = imgView.image!
        let activityViewController = UIActivityViewController(
            activityItems: [imgShare],
            applicationActivities: nil)
        self.navigationController?.presentViewController(activityViewController, animated: true, completion: { () -> Void in
        });
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
    
    
    // MARK:
    // MARK: UISWIPE GESTURE METHODS
    // MARK:
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
           
            if(swipeGesture.direction == UISwipeGestureRecognizerDirection.Up){
                
                    self.indexofDate = self.indexofDate + 1
                    var dayComponent:NSDateComponents = NSDateComponents()
                    dayComponent.day = self.indexofDate
                    var calender:NSCalendar = NSCalendar.currentCalendar()
                    
                    var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: strdate, options: NSCalendarOptions(0))!
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMM dd,yyyy"
                    var DateInFormat = dateFormatter.stringFromDate(dateToBeIncremented)
                    
                    self.title = DateInFormat
                    var animation:CATransition = CATransition()
                    animation.duration = 0.4
                    animation.type = kCATransitionPush
                    animation.subtype = kCATransitionFromTop
                    animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                    (self.view.layer).addAnimation(animation, forKey: nil)
                    let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
                    components.hour = 0
                    components.minute = 0
                    components.second = 0
                    var currentDate:NSDate = calender.dateFromComponents(components)!
                    for object in self.noteObjects{
                        var dictData : NSMutableDictionary = object as NSMutableDictionary
                        
                        if(currentDate == dictData["date"] as NSDate)
                        {
                            var img:UIImage?
                            var imageFile : PFFile?  =  dictData["imageFile"] as? PFFile
                            if(imageFile != nil){
                                imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                                    img =  UIImage(data: data)
                                    self.imgView.image = img
                                })
                                
                            }
                                                else
                                                {
                                                    imgView.image =  nil
                                                }
                                                self.strTitle = dictData["title"] as? String
                                                lblTitleText.text = strTitle
                                                break
                            }
                        else
                        {
                                imgView.image =  nil
                                lblTitleText.text = ""
                        }
                
                    
            }
                
            }
            else if(swipeGesture.direction == UISwipeGestureRecognizerDirection.Down)
            {
                    self.indexofDate = self.indexofDate - 1
                    var dayComponent:NSDateComponents = NSDateComponents()
                    dayComponent.day = self.indexofDate
                    var calender:NSCalendar = NSCalendar.currentCalendar()
                    var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: strdate, options: NSCalendarOptions(0))!
                    var dateFormatter = NSDateFormatter()
                    var dateStr = strdate
                    dateFormatter.dateFormat = "MMM dd,yyyy"
                    var DateInFormat = dateFormatter.stringFromDate(dateToBeIncremented)
                    self.title = DateInFormat
                    var animation:CATransition = CATransition()
                    animation.duration = 0.4
                    animation.type = kCATransitionPush
                    animation.subtype = kCATransitionFromBottom
                    animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                    (self.view.layer).addAnimation(animation, forKey: nil)
                    let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
                    components.hour = 0
                    components.minute = 0
                    components.second = 0
                    var currentDate:NSDate = calender.dateFromComponents(components)!
                for object in self.noteObjects{
                    var dictData : NSMutableDictionary = object as NSMutableDictionary
                    
                    if(currentDate == dictData["date"] as NSDate)
                    {
                        var img:UIImage?
                        var imageFile : PFFile?  =  dictData["imageFile"] as? PFFile
                        if(imageFile != nil){
                            imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                                img =  UIImage(data: data)
                                self.imgView.image = img
                            })
                            
                        }                        else
                        {
                            imgView.image =  nil
                        }
                        self.strTitle = dictData["title"] as? String
                        lblTitleText.text = strTitle
                        break
                    }
                    else
                    {
                        imgView.image =  nil
                        lblTitleText.text = ""
                    }
                }
            
                }
               
            }
        }
    }
  
