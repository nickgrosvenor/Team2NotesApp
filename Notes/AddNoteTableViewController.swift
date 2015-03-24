//
//  AddNoteTableViewController.swift
//  Notes
//
//  Created by Nick Grosvenor on 2/19/15.
//  Copyright (c) 2015 Nick Grosvenor. All rights reserved.
//

import UIKit

class AddNoteTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate{
    
    
    @IBOutlet weak var titleField: UITextView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var backGroundImage: UIImageView!
    var imgUpload : UIImage!
    var imageObj : UIImage!
    var isImageSelected : Bool! = false;
    var isEdited: Bool!;
    var strTitle:String!
    var strDate:NSDate!
    var strNavTitle:String!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var object: PFObject!
     override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
         self.titleField.becomeFirstResponder()
    }
    override func viewWillAppear(animated: Bool) {
       
        self.titleField.text = strTitle
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        let currentDate = NSDate()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
           }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.isEdited == true){
            btnCamera.setBackgroundImage(self.imageObj, forState: UIControlState.Normal)
            lblPlaceHolder.hidden=true;
            btnClose.hidden=true;
            self.title=strNavTitle
        }
        else
        {
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            
            var DateInFormat = dateFormatter.stringFromDate(NSDate())
            self.title = DateInFormat
            
        }

        if(self.object != nil) {
            
            
            self.titleField?.text = self.object["title"] as? String
          
        } else {
            
            self.object = PFObject(className: "Note")
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if(self.isImageSelected == true){
            
            let imageData = UIImageJPEGRepresentation(self.imgUpload,0.7)
            let imageFile = PFFile(name:"image.png", data:imageData)
            self.object["image"] = imageFile
            
            
        }

        if(isEdited == true)
        {
            var query: PFQuery = PFQuery(className: "Note")
            query.fromLocalDatastore()
            query.whereKey("date", equalTo:strDate)
            
           query.getFirstObjectInBackgroundWithBlock({ (noteObject , error) -> Void in
            
            
             if (error == nil){
                if(self.isImageSelected == true){
                    
                    let imageData = UIImageJPEGRepresentation(self.imgUpload,0.7)
                    let imageFile = PFFile(name:"image.png", data:imageData)
                    noteObject["image"] = imageFile
                }

                    noteObject.setObject(self.titleField.text, forKey: "title")
                    noteObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if(success == true)
                        {
                               self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                        else
                        {
                            println(error)
                        }
                })
                
            }
                else
             {
                if(self.isImageSelected == true){
                
                    let imageData = UIImageJPEGRepresentation(self.imgUpload,0.7)
                    let imageFile = PFFile(name:"image.png", data:imageData)
                    self.object["image"] = imageFile
                    
                
                }
                self.object["username"] = PFUser.currentUser().username
                NSLog("user Name :-  %@", PFUser.currentUser().username)
                self.object["title"] = self.titleField!.text
                NSLog("title:-  %@",self.titleField!.text)
                var cdate = self.strDate
                var calender:NSCalendar = NSCalendar.currentCalendar()
                let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:cdate)
                components.hour = 0
                components.minute = 0
                components.second = 0
                var currentDate:NSDate = calender.dateFromComponents(components)!
                
                self.object["date"] = currentDate
                self.object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if(success == true)
                    {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    else
                    {
                        var alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        //                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        //                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    }
                )

//                self.object.saveEventually { (success, error) -> Void in
//                    
//                    if (error == nil){
//                        self.navigationController?.popToRootViewControllerAnimated(true)
//                    } else {
//                        var alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                        
//                    }
//                }
             }
            
           })
            
            

        }
        else
        {

            

            var query: PFQuery = PFQuery(className: "Note")
            query.fromLocalDatastore()
           
            var cdate = NSDate()
            var calender:NSCalendar = NSCalendar.currentCalendar()
            let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:cdate)
            components.hour = 0
            components.minute = 0
            components.second = 0
            var currentDate:NSDate = calender.dateFromComponents(components)!
            
            query.whereKey("date", equalTo:currentDate)
            query.getFirstObjectInBackgroundWithBlock({ (noteObject , error) -> Void in
                
                if (error == nil){
                    if(self.isImageSelected == true){
                        
                        let imageData = UIImageJPEGRepresentation(self.imgUpload,0.7)
                        let imageFile = PFFile(name:"image.png", data:imageData)
                        noteObject["image"] = imageFile
                        
                        
                    }
                    noteObject.setObject(self.titleField.text, forKey: "title")
                    noteObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                    })
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                else
                {
                    var noofdays: Int = 0
                    var lastDate:NSDate?
                    if( NSUserDefaults.standardUserDefaults().objectForKey("date") != nil)
                    {
                         lastDate = NSUserDefaults.standardUserDefaults().objectForKey("date") as NSDate

                    }
                    else
                    {
                        lastDate = NSDate()
                    }
                   
                    noofdays = self.numberOfDaysBetween(lastDate!)
                
                    if (noofdays == 0) {
                        if(self.isImageSelected == true){
                            
                            let imageData = UIImageJPEGRepresentation(self.imgUpload,0.7)
                            let imageFile = PFFile(name:"image.png", data:imageData)
                            self.object["image"] = imageFile
                            
                            
                        }

                        self.object["username"] = PFUser.currentUser().username
                        NSLog("user Name :-  %@", PFUser.currentUser().username)
                        self.object["title"] = self.titleField!.text
                        NSLog("title:-  %@",self.titleField!.text)
                        var cdate = NSDate()
                        var calender:NSCalendar = NSCalendar.currentCalendar()
                        let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:cdate)
                        components.hour = 0
                        components.minute = 0
                        components.second = 0
                        var currentDate:NSDate = calender.dateFromComponents(components)!

                        self.object["date"] = currentDate
                        self.object.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if(success == true)
                            {
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                            else
                            {
                                var alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                                //                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                //                        self.presentViewController(alert, animated: true, completion: nil)
                            }
                            }
                        )
//                        self.object.saveEventually { (success, error) -> Void in
//                        
//                        if (error == nil){
//                            self.navigationController?.popToRootViewControllerAnimated(true)
//                        } else {
//                            var alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                            self.presentViewController(alert, animated: true, completion: nil)
//                            
//                        }
//                    }

                }
                    else{
                        for(var i = 0; i<noofdays ; i++) {
                            self.object = PFObject(className: "Note")
                            self.object["username"] = PFUser.currentUser().username
                            if(i==0)
                            {
                                self.object["title"] = self.titleField!.text
                            }
                            else
                            {
                                self.object["title"] = ""
                            }
                            NSLog("title:-  %@",self.titleField!.text)
                            var cdate = NSDate()
                            var calender:NSCalendar = NSCalendar.currentCalendar()
                            let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:cdate)
                            components.day -= i
                            components.hour = 0
                            components.minute = 0
                            components.second = 0
                            var currentDate:NSDate = calender.dateFromComponents(components)!
                            
                            self.object["date"] = currentDate
                            self.object.saveEventually { (success, error) -> Void in
                                
                                if (error == nil){
                                   self.navigationController?.popViewControllerAnimated(true)
                                } else {
                                    var alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    
                                }
                        }
                    }
                    }
                }
                
             
            
                
            })
        
        

           
        
        }
        
       
        
    }
    
    

    @IBAction func btnCloseClick(sender: AnyObject) {
        NSLog("button click")
        self.lblPlaceHolder.hidden=true;
        self.btnClose.hidden=true;
        
    }
    
    
    
    
    @IBAction func btnCamera(sender: AnyObject) {
        if(!isImageSelected)
        {
            picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker!.delegate=self;
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone
            {
                self.presentViewController(picker!, animated: true, completion: nil)
            }
            else
                {
                    popover=UIPopoverController(contentViewController: picker!)
                    popover!.presentPopoverFromRect(sender.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                }
        }
        else
        {
           // let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Remove Photo",nil)
           

           // actionSheet.showInView(self.view)
         
        }
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        isImageSelected=true;
        let img = info[UIImagePickerControllerOriginalImage] as UIImage
        imgUpload = img
      //  self.btnCamera.setTitle(nil, forState:UIControlState.Normal)
        self.btnCamera.setBackgroundImage(img,  forState: UIControlState.Normal)
        self.btnCamera.setBackgroundImage(img,  forState: UIControlState.Selected)
        self.btnCamera.setBackgroundImage(img,  forState: UIControlState.Highlighted)
      //  imageView.image=info[UIImagePickerControllerOriginalImage] as UIImage
        //sets the selected image to image view
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func numberOfDaysBetween(date:NSDate)  -> Int{
        var calender: NSCalendar = NSCalendar.currentCalendar()
      
        var components:NSDateComponents = calender.components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: NSDate(), options: nil)
         return components.day;
    }
    
    
    
 
}
