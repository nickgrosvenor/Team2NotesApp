//
//  ShowNotesController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 09/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit



class ShowNotesController: UICollectionViewController, UIActionSheetDelegate {

    var imageArray: [String] = []
    var monthDate: String = " "
    var month: String = " "
    var deleteCompleted: Bool = false
    
    var mainTableView: TableViewController = TableViewController()
    var addNoteObject: AddNoteTableViewController = AddNoteTableViewController()
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView.pagingEnabled = true
        for i in 1...12{
            imageArray.append("\(i)BG.jpg")
        }
        
        monthDate = mainTableView.tableDate
        month = mainTableView.month
        println("1. \(monthDate) \(month)")
        
        if deleteCompleted{
            
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ShowNoteCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as ShowNoteCollectionCell
        
        cell.bgImage.image = UIImage(named: imageArray[indexPath.row])
        return cell
    }

  
    @IBAction func editButtonPressed(sender: AnyObject) {
        self.navigationItem.rightBarButtonItem?.title = "Done"
    }

    
//    @IBAction func removeButtonPressed(sender: AnyObject){
//        let optionMenu: UIAlertController = UIAlertController()
//       
//        let deleteAction = UIAlertAction(title: "Remove Photo", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            println("File Deleted")
//            self.removeCurrentImage()
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//            println("Cancelled")
//        })
//        
//        optionMenu.addAction(deleteAction)
//        optionMenu.addAction(cancelAction)
//        
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//    }
//    
//   
    
    func removeCurrentImage()
    {
        deleteCompleted = true
 //        var query = PFQuery(className: "NotesApp")
//        query.whereKey("User", equalTo:PFUser.currentUser())
//        
//        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
//            if !(error != nil)
//            {
//                for object in objects {
//                    PFUser.currentUser().removeObjectForKey("ImageFileData")
//                    PFUser.currentUser().saveInBackgroundWithBlock
//                    { (success: Bool, error: NSError!) -> Void in
//                        if (success) {
//                            println("success")
//                        }
//                        else {
//                            println(error)
//                       }
//                    }
//                }
//            }
//        }
    }
    
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        addNoteObject.loadImage()
    }

    
    
    
    
    
}