//
//  AddNoteController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 09/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit

extension Array {
    func shuffled() -> [T] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
}



class AddNoteController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
      var placeholderArray : [String] = ["What’d you do?","What upset you?","Learn anything?","Buy anything?","Go anywhere?","Looking forward to anything?","Talk to anyone different?","New ideas?","Tell me about this fine day?"]
        
//        @IBOutlet var placeholderLabel: UILabel!
//        @IBOutlet var crossButton: UIButton!
//        @IBOutlet var imageView: UIImageView!
//        @IBOutlet var textArea: UITextView!
        
        
        
        var object: PFObject!
        var imageArray : [String] = []
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            crossButton.hidden = true
            
            placeholderArray = placeholderArray.shuffled()
            var multiLineString = join("\n", placeholderArray)
            placeholderLabel.text = multiLineString
            placeholderLabel.numberOfLines = 0
            placeholderLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            placeholderLabel.sizeToFit()
            
            imageView.userInteractionEnabled = true
            if(placeholderLabel.hidden == false){
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showCrossMark:")
                tapGestureRecognizer.numberOfTapsRequired = 1
                imageView.addGestureRecognizer(tapGestureRecognizer)
            }
            
            
            if(imageView.image == nil){
                textArea.textColor = UIColor.blackColor()
            }else{
                textArea.textColor = UIColor.whiteColor()
            }
            
            if(self.object != nil) {
                //            self.titleField?.text = self.object["title"] as? String
                self.textArea?.text = self.object["text"] as? String
            } else {
                self.object = PFObject(className: "Note")
                
            }
            
            for i in 1...12{
                imageArray.append("\(i)BG.jpg")
            }
            
            
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        
        func showCrossMark(gesture: UIGestureRecognizer){
            crossButton.hidden = false
        }
        
        
        @IBAction func crossButtonPressed(sender: AnyObject) {
            placeholderLabel.hidden = true
            crossButton.hidden = true
        }
        
        
        @IBAction func cameraButtonPressed(sender: AnyObject){
            loadImage()
        }
        
        
        @IBAction func doneButtonPressed(sender: UIBarButtonItem)
        {
            //        self.object["username"] = PFUser.currentUser().username
            ////        self.object["title"] = self.titleField!.text
            //        self.object["text" ] = self.textArea?.text
            //
            //        self.object.saveEventually { (success, error) -> Void in
            //
            //            if (error == nil){
            //
            //            } else {
            //
            //                println(error.userInfo)
            //
            //            }
            //        }
            
            
            let view2 = self.storyboard?.instantiateViewControllerWithIdentifier("MainTimeline") as TableViewController
            self.navigationController?.pushViewController(view2, animated: true)
        }
        
        
        
        func loadImage()
        {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
        {
            var image = info[UIImagePickerControllerOriginalImage] as UIImage
            
            //         UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
            //
            //         var ctx: CGContextRef = UIGraphicsGetCurrentContext()
            //         var area: CGRect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)
            //
            //         CGContextSetAlpha(ctx, 0)
            //
            //         var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            //         UIGraphicsEndImageContext()
            
            imageView.image = image
            imageView.contentMode = UIViewContentMode.Center
            imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)
            centerImageViewContents()
            
            if(imageView.image == nil){
                textArea.textColor = UIColor.blackColor()
            }else{
                textArea.textColor = UIColor.whiteColor()
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        // Centers the imageview image
        func centerImageViewContents()
        {
            let boundsSize = imageView.bounds.size
            var contentsFrame = imageView.frame
            
            if contentsFrame.size.width < boundsSize.width{
                contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
            }else{
                contentsFrame.origin.x = 0
            }
            
            if contentsFrame.size.height < boundsSize.height{
                contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
            }else{
                contentsFrame.origin.y = 0
            }
            
            imageView.frame = contentsFrame
        }
        
        
        ///
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
        
        
        
        
        
        
        
        
}
