//
//  MasterTableViewController.swift
//  Notes


import UIKit
class MasterTableViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tblNote: UITableView!
    @IBOutlet weak var tblImage: UITableView!
    var noteObjects: NSMutableArray! = NSMutableArray()
    var sectionMonth: NSMutableArray! = NSMutableArray()
    var bgTblContentSize : Float = 0
    
    
    
    // MARK:
    // MARK: ViewController LifeCycle Methods
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tblNote .addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        self.tblNote .addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tblNote.removeObserver(self, forKeyPath: "contentSize")
        self.tblNote.removeObserver(self, forKeyPath: "contentOffset")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil){
            self.tblNote.reloadData()
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
            tblImage.layoutIfNeeded()
            tblNote.layoutIfNeeded()
            self.tblImage.reloadData()
        }
        else if (keyPath == "contentOffset")
        {
            tblImage.layoutIfNeeded()
            tblNote.layoutIfNeeded()
            NSLog("ContentSize For Front : width- %f - height - %f",Float(self.tblNote.contentSize.width),Float(self.tblNote.contentSize.height))
            NSLog("ContentSize For Back : width- %f - height - %f",Float(self.tblImage.contentSize.width),Float(self.tblImage.contentSize.height))
            var front : UITableView = object as UITableView;
                    var frontTableHeight = Float(self.tblNote.contentSize.height)
            var backTableHeight = Float(self.tblImage.contentSize.height)
            
            if frontTableHeight == 0 {
                frontTableHeight = 1
            }
            
            var factor : Float = backTableHeight / frontTableHeight
           
            // this just ensures the backTable is scrolling together with the front table
            var contentoffSetFront = CGPointMake(front.contentOffset.x, front.contentOffset.y * CGFloat(factor))
            self.tblImage.contentOffset = contentoffSetFront;
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
                for (var index = 0; index <= noofDays.day; ++index) {
                    var objNote = NSMutableDictionary()
                    var cdate = NSDate()
                    var calender:NSCalendar = NSCalendar.currentCalendar()
                    let components = calender.components((NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate:cdate)
                    components.day -= index
                    components.hour = 0
                    components.minute = 0
                    components.second = 0
                    var currentDate:NSDate = calender.dateFromComponents(components)!
                    objNote["date"] = currentDate as NSDate
                    var randomNumber = arc4random() % 25;
                    var img = UIImage(named: NSString(format: "img%d", randomNumber))
                    objNote["image"] = img
                    objNote["aspectFactor"] = Float(img!.size.width/img!.size.height)
                    NSLog("%@",objNote)
                    var fHeight : Float = (Float(self.view.frame.size.height) / Float(img!.size.width/img!.size.height))
                    objNote["height"] = fHeight
                    objNote["isImage"] = false
                    self.bgTblContentSize += fHeight
                    for object  in arrnote{
                        var obj = object as PFObject
                        if(obj["date"] as? NSDate == currentDate)
                        {
                            objNote["title"] = obj["title"] as? String
                            var imageFile : AnyObject?  =  obj["image"]
                            if(imageFile != nil)
                            {
                                imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                                    var imageBackground = UIImage(data: data)
                                    objNote["image"] = imageBackground
                                    objNote["aspectFactor"] = Float(imageBackground!.size.width/imageBackground!.size.height)
                                    objNote["isImage"] = true
                                    NSLog("%@",objNote)
                                    
                                    var fHeight : Float = (Float(self.view.frame.size.height) / Float(imageBackground!.size.width/imageBackground!.size.height))
                                    objNote["height"] = fHeight
                                    self.tblNote.reloadData()
                                    
                                })
                            }
                        }
                        
                    }
                     self.noteObjects.addObject(objNote)
                }
                self.tblNote.reloadData()
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

    // MARK:
    // MARK:  Table view data source
    // MARK:
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteObjects.count ;
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView.tag==0){
        let cell = self.tblNote.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as MasterTableViewCell
        var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexPath.row) as NSMutableDictionary
        cell.masterTextLabel?.text = object["title"] as? String
        var dateStr = object["date"] as? NSDate
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "dd"
        var formatter1:NSDateFormatter = NSDateFormatter()
        formatter1.dateFormat = "EEEE"
        cell.dateLabel?.text = formatter.stringFromDate(dateStr!)
        cell.masterTitleLabel?.text = formatter1.stringFromDate(dateStr!)
        var bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = bgColorView
        return cell
        }
        else
        {
            var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexPath.row) as NSMutableDictionary
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as BackgroundCell
            cell.imgView.image = object["image"] as? UIImage
            return cell

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexPath.row) as NSMutableDictionary
        var addNote: NotesDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NotesDetailViewController") as NotesDetailViewController
        addNote.strTitle = object["title"] as? String
        addNote.indexofNote = indexPath.row
        addNote.noteObjects = self.noteObjects
        self.navigationController?.pushViewController(addNote, animated: true)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(tableView.tag != 0){
            var object: NSMutableDictionary = self.noteObjects.objectAtIndex(indexPath.row) as NSMutableDictionary
            var fHeight : Float = object["height"] as Float
            return CGFloat(fHeight)
        }
        return 150.0
    }
    
}
