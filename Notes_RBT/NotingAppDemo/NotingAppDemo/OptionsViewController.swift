//
//  OptionsViewController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 13/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit


class OptionsViewController: UIViewController {
 
    @IBOutlet weak var imageView: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Reminder BG")!)
        
    imageView.image = UIImage(named: "Reminder BG")
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    @IBAction func reminderButtonPressed(sender: AnyObject) {
        
    }


    @IBAction func signOutButtonPressed(sender: AnyObject) {
       	PFUser.logOut()

        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainTimeline") as TableViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
  
    @IBAction func bookAMonthButtonPressed(sender: AnyObject) {
        var url  = NSURL(string: "www.google.com")
      
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.google.com")!)
    }
    
    
    


    

}
