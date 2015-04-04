//
//  MasterTableViewController.swift
//  Notes


import UIKit
class MasterTableViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UIScrollViewDelegate,InfiniteVerticalScrollViewDelegate,InfiniteVerticalScrollViewDataSource {
    
    @IBOutlet weak var constraintScrollWidth: NSLayoutConstraint!
    @IBOutlet weak var dateScrollView: InfiniteVerticalScrollView!
    @IBOutlet weak var imageScrollView: InfiniteVerticalScrollView!
    var date:NSDate?
    
//    @IBOutlet weak var tblNote: UITableView!
//    @IBOutlet weak var tblImage: UITableView!
    var noteObjects: NSMutableArray! = NSMutableArray()
    var sectionMonth: NSMutableArray! = NSMutableArray()

    var bgTblContentSize : Float = 0
    var tblNoteYPos : Float = 0
    var imgData: NSMutableArray! = NSMutableArray()
    
    // MARK:
    // MARK: ViewController LifeCycle Methods
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.date == nil)
        {
            self.date =  NSDate()
        }
      
        constraintScrollWidth.constant = UIScreen.mainScreen().bounds.size.width
        self.title = "Timeline"
        let logo = UIImage(named: "uploadistLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        let button = UIButton(frame: CGRectMake(0, 0, 10, 10))
        
    }
    
    override func viewWillAppear(animated: Bool) {
      
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false;
       
        self.dateScrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        self.dateScrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
       // dateScrollView.removeFromSuperview();
        tblNoteYPos = Float(dateScrollView.contentOffset.y);
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.dateScrollView.removeObserver(self, forKeyPath: "contentSize")
        self.dateScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        imgData = appDelegate.imgData
        if (PFUser.currentUser() == nil){
            var logInViewController = PFLogInViewController()
            logInViewController.delegate = self
            var signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            logInViewController.signUpController = signUpViewController
            self.presentViewController(logInViewController, animated: true, completion: nil)
        } else {
            self.fetchAllObjects()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(keyPath == "contentSize"){
            self.imageScrollView.layoutIfNeeded()
            self.dateScrollView.layoutIfNeeded()
        }
        else if (keyPath == "contentOffset")
        {
            if(object as UIScrollView == dateScrollView){
                self.dateScrollView.layoutIfNeeded()
                self.imageScrollView.layoutIfNeeded()
                var front : UIScrollView = object as InfiniteVerticalScrollView;
                        var frontTableHeight = Float(self.dateScrollView.contentSize.height)
                var backTableHeight = Float(self.imageScrollView.contentSize.height)
                
                if frontTableHeight == 0 {
                    frontTableHeight = 1
                }
                var fDiff : Float =  Float(dateScrollView.contentOffset.y) - tblNoteYPos
                var view : UIView = imageScrollView.visibleLabels.objectAtIndex(0) as UIView
                var vHeight : Float =  Float(view.frame.size.height)
                var factor : Float = vHeight/150.0;
                var imgContentOffset : CGPoint = imageScrollView.contentOffset
                imgContentOffset.y = imgContentOffset.y + CGFloat(fDiff*factor)
                imageScrollView.setContentOffset(imgContentOffset, animated: false)
                tblNoteYPos = Float(dateScrollView.contentOffset.y);
            }
        }
        
    }
    
    // MARK:
    // MARK: get The Notes Object
    // MARK:
    
    func fetchAllObjectsFromLocalDataStore(){
        
        var query: PFQuery = PFQuery(className: "Note")
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        query.orderByDescending("date")
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if (error == nil){
               
                var temp: NSArray = objects as NSArray
                var arrnote = temp.mutableCopy() as NSMutableArray
                var firstObj: PFObject = arrnote.objectAtIndex(0) as PFObject
                var lastObj: PFObject = arrnote.objectAtIndex(arrnote.count-1) as PFObject
                var firstDate = firstObj["date"] as? NSDate
                 var currentDate = NSDate()
                NSUserDefaults.standardUserDefaults().setValue(firstDate, forKey: "date")
                var lastDate = lastObj["date"] as? NSDate
                var calendar = NSCalendar.currentCalendar()
                let components = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth
                var noofDays : NSDateComponents = calendar.components(components, fromDate: lastDate!, toDate: currentDate, options: nil)
                NSLog("no of days : %d",noofDays.day)
                NSLog("no of month : %d",noofDays.month)
                self.noteObjects = NSMutableArray()
                for (var index = 0; index <= temp.count; ++index) {
                    var obj = arrnote .objectAtIndex(index) as PFObject
                    var objNote = NSMutableDictionary()
                    var cdate = obj["date"] as NSDate
                    var calender:NSCalendar = NSCalendar.currentCalendar()
                    let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:cdate)
                    components.hour = 0
                    components.minute = 0
                    components.second = 0
                    var currentDate:NSDate = calender.dateFromComponents(components)!
                    objNote["date"] = currentDate as NSDate
                    var randomNumber = arc4random() % 25;
                    var img = UIImage(named: NSString(format: "img%d", randomNumber))
                    objNote["title"] = obj["title"] as? String
                    objNote["isImage"] = false
              
                  
                    var imageFile : AnyObject?  =  obj["image"]
                    if(imageFile != nil)
                    {
                            objNote["imageFile"] = obj["image"]
//                            imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                            var imageBackground = UIImage(data: data)
//                            objNote["image"] = imageBackground
//                            objNote["aspectFactor"] = Float(imageBackground!.size.width/imageBackground!.size.height)
//                            objNote["isImage"] = true
//                            NSLog("%@",objNote)
//                            var fHeight : Float = (Float(self.view.frame.size.height) / Float(imageBackground!.size.width/imageBackground!.size.height))
//                            objNote["height"] = fHeight
//                        
//                            self.imageScrollView.reloadAllData()
//                            
//                        })
                    }

                    self.noteObjects.addObject(objNote)
                }
                self.imageScrollView.reloadAllData()
                self.dateScrollView.reloadAllData()

                if(noofDays.month > 0)
                {
                    var arrNotes = NSMutableDictionary()
                    for(var i = 0; i<noofDays.month ; i--)
                    {
                        var cdate = NSDate()
                        var calender:NSCalendar = NSCalendar.currentCalendar()
                        let components = calender.components((NSCalendarUnit.CalendarUnitMonth), fromDate:cdate)
                        components.month -= 1
                        var currentDate:NSDate = calender.dateFromComponents(components)!
                        let componentsForDate = calender.components((NSCalendarUnit.CalendarUnitMonth), fromDate:currentDate)
                        var arrMonth = NSMutableArray()
                        
                        for object  in self.noteObjects{
                            var obj = object as NSMutableDictionary
                            var objdate = obj["date"] as? NSDate
                           let componentsForobjDate = calender.components((NSCalendarUnit.CalendarUnitMonth), fromDate:objdate!)
                            if(componentsForDate.month == componentsForobjDate.month){
                                arrMonth.addObject(obj)
                            }
                    }
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MMMM"
                        var DateInFormat = dateFormatter.stringFromDate(currentDate)
                        arrNotes.setObject(arrMonth, forKey: DateInFormat)
                    }
                }
                
            }
            else {
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
    // MARK: Parse login
    // MARK:
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("Failed to login")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        
        if let password = info?["password"] as? String{
            return password.utf16Count >= 5
        } else {
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        println("Failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        println("User dismissed signup")
    }

    
    // MARK:
    // MARK: IBAction Methods
    // MARK:
    
    @IBAction func btnAddClick(sender: AnyObject) {
        NSLog("button clicked")
        var addNote: AddNoteTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddNoteTableViewController") as AddNoteTableViewController
        addNote.isEdited=false;
        self.navigationController?.pushViewController(addNote, animated: true)
        
    }
    @IBAction func btnOptionClick(sender: AnyObject) {
        NSLog("button clicked")
        var optionVC: OptionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("OptionViewController") as OptionViewController
        self.navigationController?.pushViewController(optionVC, animated: true)
    }

  
    
    //MARK
    //MARK - UISCROLLVIEW DELEGATE
    //MARK
    
    func numberOfRowsInScrollView(scrollView:InfiniteVerticalScrollView) -> NSInteger{
             return 5 ;
    }
    
    func scrollview(scrollV:InfiniteVerticalScrollView,didSelectRowAtIndex index:NSInteger) -> Void{
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = index
        var calender:NSCalendar = NSCalendar.currentCalendar()
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
        components.hour = 0
        components.minute = 0
        components.second = 0
        var dictData : NSMutableDictionary = NSMutableDictionary()
        var currentDate:NSDate = calender.dateFromComponents(components)!
        var indexpath = -1
        for(var i = 0 ; i < self.noteObjects.count ; i++ )
        {
              var object: NSDictionary = self.noteObjects.objectAtIndex(i) as NSDictionary
              var dictData : NSDictionary = object as NSDictionary
                if(currentDate == dictData["date"] as NSDate)
                {
                    indexpath = i;
                }
        }
        
        var addNote: NotesDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NotesDetailViewController") as NotesDetailViewController
        addNote.strdate = dateToBeIncremented
        addNote.noteObjects = self.noteObjects
        if(indexpath == -1)
        {
            addNote.indexofNote = 0
        }
        else
        {
             var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexpath) as NSMutableDictionary
            addNote.indexofNote = indexpath
        }
        addNote.strTitle = dictData["title"] as? String
        self.navigationController?.pushViewController(addNote, animated: true)

    }
    
    func scrollview(scrollV:InfiniteVerticalScrollView,viewForRowAtIndex index:NSInteger) -> UIView{
        if(scrollV.tag==0){
            var flagisNotes = false
           
            var viewContainer: ContainerView = UIView.loadView("containerView") as ContainerView
            viewContainer.frame = CGRectMake(0, 0, scrollV.frame.size.width, viewContainer.frame.size.height)
            viewContainer.dateLabel.text = self.displaydate(index)
            viewContainer.monthLabel.text = self.displayMonthLabel(index)
            viewContainer.masterTitleLabel.text = self.displayMonth(index)
            viewContainer.masterTextLabel.text = self.displayNote(index)
            return viewContainer;
        }
        else
        {
            var viewContainer: ImageContainerView = UIView.loadView("imageContainerView") as ImageContainerView
//            var cdate = self.date
//            var flagisImage = false
//
//            
//            var iPageIndex : NSInteger = 0
//            if(dateScrollView.visibleLabels?.count > 0){
//                var lastView : UIView = dateScrollView.visibleLabels.objectAtIndex(0) as UIView;
//                iPageIndex = lastView.tag;
//                NSLog("Index : %d", iPageIndex)
//            }
//            var dayComponent:NSDateComponents = NSDateComponents()
//            dayComponent.day = iPageIndex
//            dayComponent.hour = 0
//            dayComponent.minute = 0
//            dayComponent.second = 0
//            
//            var calender:NSCalendar = NSCalendar.currentCalendar()
//            var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
//            
//            let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
//            components.hour = 0
//            components.minute = 0
//            components.second = 0
//            var currentDate:NSDate = calender.dateFromComponents(components)!
//            
//            var object:NSDictionary = NSDictionary()
//            var img:UIImage = UIImage()
//
//            
//            var predeicate : NSPredicate = NSPredicate(format: "self.date = %@",currentDate)!
//            var filterArray : NSArray = self.noteObjects.filteredArrayUsingPredicate(predeicate)
//            
//            if(filterArray.count > 0){
//                var timestamp = currentDate.timeIntervalSince1970
//                var imgDict : NSMutableDictionary = filterArray.objectAtIndex(0) as NSMutableDictionary
//                
//                var imageFile : AnyObject?  =  imgDict["imageFile"]
//                
//                var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//                var imagePath = paths.stringByAppendingPathComponent(NSString(format: "%ld%ld%ld.png",components.year,components.month,components.day))
//                var checkImage = NSFileManager.defaultManager()
//                var imageBackground:UIImage?
//                
//                if (checkImage.fileExistsAtPath(imagePath)) {
//                    
//                    let getImage = UIImage(contentsOfFile: imagePath)
//                    viewContainer.imgView.image = getImage
//                    
//                } else{
//                viewContainer.tag = iPageIndex
//                imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                    
//                    var dayComponent:NSDateComponents = NSDateComponents()
//                    dayComponent.day = viewContainer.tag
//                    dayComponent.hour = 0
//                    dayComponent.minute = 0
//                    dayComponent.second = 0
//                    
//                    var calender:NSCalendar = NSCalendar.currentCalendar()
//                    var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
//                    
//                    let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
//                    components.hour = 0
//                    components.minute = 0
//                    components.second = 0
//                    var currentDate:NSDate = calender.dateFromComponents(components)!
//                    var timestamp = currentDate.timeIntervalSince1970
//                    
//                    var imagePath = paths.stringByAppendingPathComponent(NSString(format: "%ld%ld%ld.png",components.year,components.month,components.day))
//                    data.writeToFile(imagePath, atomically: true)
//                    imageBackground   = UIImage(data: data)!
//                    viewContainer.imgView.image = imageBackground
//                    
//                    let sizeOfImage = imageBackground!.size
//                    var aspectFactor = Float(sizeOfImage.width / sizeOfImage.height)
//                    var fHeight : CGFloat = CGFloat((Float(self.view.frame.size.height) / Float(sizeOfImage.width / sizeOfImage.height)))
//                    viewContainer.imgView.frame = CGRectMake(0, 0, scrollV.frame.size.width, fHeight)
//                    viewContainer.frame = CGRectMake(0, 0, scrollV.frame.size.width, fHeight)
//                    
//                    
//                })
//                }
//                
////                img =  UIImage(named: NSString(format: "img%d", 1))!
////                viewContainer.imgView.image = img
////                var aspectFactor = Float(img.size.width/img.size.height)
////                var fHeight : CGFloat = CGFloat((Float(self.view.frame.size.height) / Float(img.size.width/img.size.height)))
////                viewContainer.imgView.frame = CGRectMake(0, 0, scrollV.frame.size.width, fHeight)
////                viewContainer.frame = CGRectMake(0, 0, scrollV.frame.size.width, fHeight)
//                
//                var obj = NSMutableDictionary()
//                obj["index"] = index as NSInteger
//                if(imageBackground != nil){
//                    obj["image"] = imageBackground
//                }
//                imgData.addObject(obj)
//                
//            }
//            else{
                var randomNumber = arc4random() % 25;
               var img  =  UIImage(named: NSString(format: "img%d", randomNumber))!
                var obj = NSMutableDictionary()
                obj["index"] = index as NSInteger
                obj["image"] = NSString(format:"img%d", randomNumber);
                imgData .addObject(obj)
                viewContainer.imgView.image = img
                
                var aspectFactor = Float(img.size.width/img.size.height)
                var fHeight : CGFloat = CGFloat((Float(self.view.frame.size.height) / Float(img.size.width/img.size.height)))
                viewContainer.imgView.frame = CGRectMake(0, 0, scrollV.frame.size.width, fHeight)
                viewContainer.frame = CGRectMake(0, 0, scrollV.frame.size.width, fHeight)
            //}
      
            return viewContainer
        }
    }
    
    func heightForScrollView(scrollView:InfiniteVerticalScrollView) -> CGFloat{
        if scrollView.tag == 1 {
            return 1070.28;
        }
        return 150;
    }
    
    
    func displaydate(row:NSInteger) ->NSString{
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = row
        var calender:NSCalendar = NSCalendar.currentCalendar()
       
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        
        var dateformat : NSDateFormatter = NSDateFormatter()
        dateformat.dateFormat = "dd"
        
        var datestr:NSString = dateformat.stringFromDate(dateToBeIncremented)
        return datestr
    }
    func displayMonthLabel(row:NSInteger) ->NSString{
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = row
        var calender:NSCalendar = NSCalendar.currentCalendar()
        
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        
        var dateformat : NSDateFormatter = NSDateFormatter()
        dateformat.dateFormat = "MMM-yyyy"
        
        var datestr:NSString = dateformat.stringFromDate(dateToBeIncremented)
        return datestr
    }

    func displayMonth(row:NSInteger) ->NSString{
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = row
        var calender:NSCalendar = NSCalendar.currentCalendar()
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        
        var dateformat : NSDateFormatter = NSDateFormatter()
        dateformat.dateFormat = "EEEE"
        
        var datestr:NSString = dateformat.stringFromDate(dateToBeIncremented)
        return datestr
    }
    func displayNote(row:NSInteger) ->NSString{
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = row
        var calender:NSCalendar = NSCalendar.currentCalendar()
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
        components.hour = 0
        components.minute = 0
        components.second = 0
        var currentDate:NSDate = calender.dateFromComponents(components)!
        for object in self.noteObjects{
            var dictData : NSMutableDictionary = object as NSMutableDictionary
            
            if(currentDate == dictData["date"] as NSDate)
            {
               
              return object["title"] as NSString
            }
        }
        return ""
        
        
    }
    func displayImage(row:NSInteger) ->UIImage{
        for object in self.imgData{
            if(object["index"] as NSInteger == row){
                return object["image"] as UIImage
            }
        }
        
        var flagimage = false;
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = row
        
        var calender:NSCalendar = NSCalendar.currentCalendar()
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:dateToBeIncremented)
        components.hour = 0
        components.minute = 0
        components.second = 0
        var currentDate:NSDate = calender.dateFromComponents(components)!
        var img:UIImage = UIImage()
        for object in self.noteObjects{
            var dictData : NSMutableDictionary = object as NSMutableDictionary
            
            if(currentDate == dictData["date"] as NSDate)
                {
                    var imageFile : AnyObject?  =  dictData["imageFile"]
                    var imageBackground:UIImage?
                    imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                                                   imageBackground   = UIImage(data: data)!
                })
                    flagimage = false
                    var obj = NSMutableDictionary()
                    obj["index"] = row as NSInteger
                    obj["image"] = imageBackground
                    imgData .addObject(obj)
                    return imageBackground!
            }
        }
        if(flagimage == false){
            var randomNumber = arc4random() % 25;
            img =  UIImage(named: NSString(format: "img%d", randomNumber))!
            var obj = NSMutableDictionary()
            obj["index"] = row as NSInteger
            obj["image"] = img as UIImage
            imgData .addObject(obj)
        }
        
        return img
        
    }
    func getDate(row:NSInteger) ->NSDate{
        var dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = row
        var calender:NSCalendar = NSCalendar.currentCalendar()
        
        var dateToBeIncremented: NSDate = calender.dateByAddingComponents(dayComponent, toDate: self.date!, options: NSCalendarOptions(0))!
        return dateToBeIncremented
    }
    

}

