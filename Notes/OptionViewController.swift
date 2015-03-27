//
//  OptionViewController.swift
//  Notes
//
//  Created by Pragnesh Dixit on 18/03/15.
//  Copyright (c) 2015 Nick Grosvenor. All rights reserved.
//

import Foundation
import uikit
class OptionViewController: UIViewController{

    // MARK:
    // MARK: UIVIewController LifeCycle Methods
    // MARK:
    override func viewDidLoad() {
        let logo = UIImage(named: "uploadistLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }

    // MARK:
    // MARK: UIButton Action Methods
    // MARK:
    
    @IBAction func btnLogout(sender: AnyObject) {
        var alert = UIAlertController(title: "Notes", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            PFUser.logOut()
            self.navigationController?.popViewControllerAnimated(true)

        }))
        self.presentViewController(alert, animated: true, completion: nil)
        }
    
    
    func handleCancel(alertView: UIAlertAction!)
    {
        println("User click cancel button")
    }

    
    @IBAction func btnReminders(sender: AnyObject) {
        
    }
    
    
    @IBAction func btnBook(sender: AnyObject) {
        var aboutVC: AboutUsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController") as AboutUsViewController
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }

}