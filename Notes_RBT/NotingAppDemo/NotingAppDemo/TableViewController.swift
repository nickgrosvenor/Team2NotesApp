//
//  TableViewController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 03/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit


//protocol Callback {
//    func OnComplete(arr : NSArray)
//}


class TableViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextViewDelegate {
    
    let date = NSDate()
    var noteObjects = NSMutableArray()
    
    var dateArray = [Int]()
    var parseData = [AnyObject]()
    var monthDaysDict : [String: [String]] = [ : ]
    var monthSection = []
    var mthSectionTitles = []
    var headerTxt = ""
    var bgImages = ["1BG.png","2BG.png","3BG.png","4BG.png"]//,"5BG.png"]
    var cellHasText = false
    var sectionTitle = ""
    var sectionDays = []
    internal var tableDate: String = ""
    internal var month: String = ""
    var year: Int = 0
    final var allImages = []
      
    @IBOutlet var cellTextLabel: UILabel!
    @IBOutlet var optionButton: UIBarButtonItem!
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if (PFUser.currentUser() != nil){
         //   if let call = callback as Callback!{
            //if callback != nil {
                fetchDataFromParse()//callback: Callback.self)
         //   }
        }
       
     //   var image = UIImage(named: "Option")
        
        println("1. \(bgImages.count)")
        println("2. \(allImages.count)")
        
        var imageView = UIImageView()
        for i in 1...bgImages.count {
            var randomIndex = Int(arc4random_uniform(UInt32(bgImages.count)))
            imageView.image = UIImage(named: "\(bgImages[randomIndex])")
            self.tableView.backgroundView = imageView
        }
        
        setParallaxEffect()
       
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        year = components.year
        let month = components.month
        let day = components.day

      
//     reloadDataForCal(year, month: currentMonthofDays(year, month: month), weekday:currentMonthFirstDayWeek(year, month:   month))

        monthDaysDict =
        [
            "JANUARY" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "FEBRUARY" : ["28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "MARCH" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "APRIL" : ["30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "MAY" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "JUNE" : ["30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "JULY" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "AUGUST" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "SEPTEMBER" : ["30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "OCTOBER" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "NOVEMBER" : ["30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"],
            "DECEMBER" : ["31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"]
        ];
        
        monthSection = ["JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"]
        
        checkForLeapYear(year)
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
      
        if (PFUser.currentUser() == nil){
            var logInViewController = PFLogInViewController()
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            self.presentViewController(logInViewController, animated: true, completion: nil)
        }
    }
    
    
       // Method for Parse Login & Delegates
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
    
    // Method for Parse SignUp & Delegates
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        
        if let password = info?["password"] as? String{
            return true
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
   

    func setParallaxEffect(){
        // Set vertical effect
        var verticalMotionEffect : UIInterpolatingMotionEffect =
        UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -10
        verticalMotionEffect.maximumRelativeValue = 10
        
        // Set horizontal effect
        var horizontalMotionEffect : UIInterpolatingMotionEffect =
        UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -10
        horizontalMotionEffect.maximumRelativeValue = 10
        
        // Create group to combine both
        var group : UIMotionEffectGroup = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        self.view.addMotionEffect(group)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return monthSection.count
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return monthSection.objectAtIndex(section) as NSString
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle : String = monthSection.objectAtIndex(section) as String
        var sectionMonth = monthDaysDict[sectionTitle]! as Array
        return sectionMonth.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as TableViewCell
        
//        userImageFile.getDataInBackgroundWithBlock { (imageData: NSData!, error: NSError!) -> Void in
//            if error == nil {
//                var eventImage = UIImage(data:imageData)
//                var img: String = "\(eventImage).jpg"
//                self.bgImages.append(img)
//            }
//        }
       
        sectionTitle = monthSection.objectAtIndex(indexPath.section) as String
        sectionDays = monthDaysDict[sectionTitle]! as Array
        var monthDate = sectionDays[indexPath.row] as String
        var dayString : String = getDayOfWeek("2015-\(sectionTitle)-\(monthDate)")
        
        cell.dayLabel.text = dayString as String
        cell.dateLabel.text = monthDate as String
       
//        if {
//        
//        }
        cell.noteLabel.text = "text" as String

        return cell
    }
   
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell") as TableViewCell
        var sectionTitle = monthSection.objectAtIndex(section) as String
      
        var headerView = UIView(frame: CGRectMake(0,0, tableView.frame.width, 1))
        var headerLabel = UILabel()
        headerLabel.frame = CGRectMake(5, 20, tableView.frame.size.width-5, 20)
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.text = sectionTitle
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.font = UIFont.boldSystemFontOfSize(27)
        headerView.addSubview(headerLabel)
  
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableDate = sectionDays[indexPath.row] as String
        
        var tableMonth: String = dropFirst(sectionTitle).lowercaseString
        var index = advance(tableMonth.startIndex, 2)
        tableMonth = tableMonth.substringToIndex(index)
        
        var letter = sectionTitle[advance(sectionTitle.startIndex, 0)]
        
        month = String(letter) + tableMonth
        var selectedDate: String = tableDate + " " + month
        println("SelectedDate: \(selectedDate)")
        
        var fetchQuery = PFQuery(className: "NotesApp")
        fetchQuery.whereKey("date", hasPrefix: selectedDate)
        
        fetchQuery.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            if (error == nil){
                var temp: NSArray = objects as NSArray
                println(temp.count)
            } else {
                println(error.userInfo)
            }
        }
//
//        let view2 = self.storyboard?.instantiateViewControllerWithIdentifier("ShowNote") as ShowNotesController
//        self.navigationController?.pushViewController(view2, animated: true)
    }


    
    func fetchDataFromParse()//call : Callback)
    {
        var userImageFile : PFFile = PFFile()

        var findQuery = PFQuery(className: "NotesApp")
        findQuery.whereKey("User", equalTo: PFUser.currentUser())
        
        findQuery.findObjectsInBackgroundWithBlock { (objects: Array!, error : NSError!) -> Void in
            if error == nil && (objects.count > 0)
            {
                for object in objects {
                    if var imageObj = object["ImageFileData"] as? PFFile{
                       userImageFile = imageObj as PFFile
                    }

                    var userNote = object["Note"] as String
                    var date = object["Date"] as String
                    var dict = ["Image":userImageFile, "Note":userNote, "Date":date]
                    self.parseData.append(dict)
                  
                    userImageFile.getDataInBackgroundWithBlock {(imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            if var uploadImage = imageData as NSData! {
                                var image = UIImage(data: uploadImage)
                                var img: String = "\(uploadImage).png"
                                self.bgImages.append(img)
                            }

                            self.allImages = self.bgImages
//                          println(self.allImages.count)
                            println(self.bgImages.count)
//                            call.OnComplete(self.allImages)
//                            setBGImageForMain()
                        }
                    }
                }
              
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            else{
                println("Error: \(error)")
            }
        }
    }
    
    
//    func setBGImageForMain(){
//        var imageView = UIImageView()
//        for i in 1...bgImages.count {
//            var randomIndex = Int(arc4random_uniform(UInt32(bgImages.count)))
//            imageView.image = UIImage(named: "\(bgImages[randomIndex])")
//            self.tableView.backgroundView = imageView
//        }
//    }
    
    
    func checkForLeapYear(year: Int){
        if year%400 == 0 || ((year%4 == 0)&&(year%100 != 0)){
            monthDaysDict["FEBRUARY"] = ["29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"]
        }
        else{
             monthDaysDict["FEBRUARY"] = ["28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","10","09","08","07","06","05","04","03","02","01"]
        }
   }
    

    func getDayOfWeek(today: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MMMM-dddd"
        let todayDate = formatter.dateFromString(today)!
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
       
        let componentWeek = calendar?.components(.WeekdayCalendarUnit, fromDate: todayDate)
        let weekDay = componentWeek?.weekday
        
        var day : String = "" //weekDay as String
        
        switch weekDay! {
            case 1:      day = "Sunday"
            case 2:      day = "Monday"
            case 3:      day = "Tuesday"
            case 4:      day = "Wednesday"
            case 5:      day = "Thursday"
            case 6:      day = "Friday"
            case 7:      day = "Saturday"
            default:     day = ""
            break
        }
        
        return day
    }
    
    
    func getMonth(today: Int) -> String {
        
        var currentMonth = ""
        switch today {
        case 1:      currentMonth = "JANUARY"
        case 2:      currentMonth = "FEBRUARY"
        case 3:      currentMonth = "MARCH"
        case 4:      currentMonth = "APRIL"
        case 5:      currentMonth = "MAY"
        case 6:      currentMonth = "JUNE"
        case 7:      currentMonth = "JULY"
        case 8:      currentMonth = "AUGUST"
        case 9:      currentMonth = "SEPTEMBER"
        case 10:     currentMonth = "OCTOBER"
        case 11:     currentMonth = "NOVEMBER"
        case 12:     currentMonth = "DECEMBER"
        default:     currentMonth = ""
            break
        }
        
        return currentMonth
    }
    
   
    func currentMonthofDays(year:Int,month:Int)->Int{
        
        if month==1 || month==3 || month==5 || month == 7 || month == 8 || month == 10 || month == 12{
            return 31;
        }
        else
        {
            if month == 2
            {
                if year%400 == 0 || ((year%4 == 0)&&(year%100 != 0))
                {
                    return 29;
                }
                else
                {
                    return 28;
                }
                
            }
            else{
                return 30;
            }
        }
        
    }
    
    // Some Random Calculation for Day & Dates
    func currentMonthFirstDayWeek(year :Int,month:Int)->Int{
        var sumdays = 0
        
        for (var i = 1900; i < year; i++)
        {
            if (i%400 == 0 )||((i%4 == 0)&&(i%100 != 0))
            {
                sumdays += 366
            }
            else
            {
                sumdays += 365
            }
        }
        
        for (var i = 1; i < month; i++ )
        {
            if (i == 1 )||( i == 3 )||(i == 5) || (i == 7) || (i == 8 ) || (i == 10 )||(i == 12)
            {
                sumdays += 31;
            }
            else
            {
                sumdays += 30;
            }
        }
        
        
        if month > 2
        {
            if year%400 == 0 || ((year%4 == 0)&&(year%100 != 0))
            {
                sumdays -= 1
            }
            else
            {
                sumdays -= 2
            }
            
        }
        
        return firstWeekday(sumdays);
        
    }
    
    
    func firstWeekday(sumdays:Int)->Int{
        var weekday = sumdays%7+1;
        return weekday
    }
    
    
    func reloadDataForCal(year:Int,month:Int , weekday:Int){
        
        for(var i = weekday; i < weekday+month; i++){
            dateArray.append(i-weekday+1)
        }
        
     //   println(dateArray)
    }
}