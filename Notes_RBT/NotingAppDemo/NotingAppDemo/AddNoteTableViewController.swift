//
//  AddNoteTableViewController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 05/03/15.
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



class AddNoteTableViewController: UIViewController, UIScrollViewAccessibilityDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    var placeholderArray : [String] = ["What’d you do?","What upset you?","Learn anything?","Buy anything?","Go anywhere?","Looking forward to anything?","Talk to anyone different?","New ideas?","Tell me about this fine day?"]
   
    var DateInFormat: String = ""
    var object: PFObject!
    var bgImage: UIImage!
    var kbHeight: CGFloat!
    
    @IBOutlet var textArea: UITextView!
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var crossButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crossButton.hidden = true
        
        self.textArea.contentSize = self.textArea.bounds.size
        
        var todaysDate: NSDate = NSDate()
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        DateInFormat = dateFormatter.stringFromDate(todaysDate)
        self.title = DateInFormat
        
        placeholderArray = placeholderArray.shuffled()
        var multiLineString = join("\n", placeholderArray)
        placeholderLabel.text = multiLineString
        placeholderLabel.userInteractionEnabled = true
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

//        if(self.object != nil) {
////            self.titleField?.text = self.object["title"] as? String
//            self.textArea?.text = self.object["text"] as? String
//        } else {
//            self.object = PFObject(className: "Note")
//        
//        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        return true;
    }
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool{
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView){
    
    }
    
    func textViewDidEndEditing(textView: UITextView){
    
    }
    
    
    
    func showCrossMark(gesture: UIGestureRecognizer){
       crossButton.hidden = false
    }
    

    @IBAction func crossButtonPressed(sender: AnyObject) {
        placeholderLabel.hidden = true
        crossButton.hidden = true
    }
    
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        loadImage()
    }
    
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem){
        // TODO : Place a Progress Hud here
        
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "Loading", andFooter: "Please Wait")
//       JHProgressHUD.sharedHUD.showInView(self.view)

        var imageFile : PFFile!
        var testObject : PFObject = PFObject(className: "NotesApp")
        testObject["User"] = PFUser.currentUser()
        testObject["Note"] = textArea.text
        testObject["Date"] = DateInFormat
        
        if(bgImage != nil){
            var imageData = UIImagePNGRepresentation(bgImage)
            var imageFile = PFFile(name:"Image.png", data:imageData)
            testObject["ImageFileData"] = imageFile
        }
        
        testObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                println("Success")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                println(error.userInfo)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    

    
    internal func loadImage()
    {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        bgImage = info[UIImagePickerControllerOriginalImage] as UIImage
       
//         UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
//         var ctx: CGContextRef = UIGraphicsGetCurrentContext()
////         var area: CGRect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)
////        
//         CGContextSetAlpha(ctx, 1)
////     
//         var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//         println("Image \(newImage)")
//         UIGraphicsEndImageContext()
        
        imageView.image = bgImage
      
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)
        centerImageViewContents()
        
        if(imageView.image == nil){
            println("Nil")
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
    
    
   
    



    

}
