//
//  UIActivityViewController.swift
//  NotingAppDemo
//
//  Created by Rational Bits on 05/03/15.
//  Copyright (c) 2015 Rational Bits. All rights reserved.
//

import UIKit

class UIActivityViewController: UIViewController, UIScrollViewAccessibilityDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet var scrollView: UIScrollView!
    
    var imageView = UIImageView()
    
 /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        imageView.image = UIImage(named: "Settings.jpg")
        imageView.userInteractionEnabled = true
        
        scrollView.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "loadImage:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func loadImage(recognizer: UITapGestureRecognizer)
    {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Perform actions like "zoom" after image is selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        imageView.image = image
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)
        scrollView.contentSize = image.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Centers the scrollview image
    func centerScrollViewContents()
    {
        let boundsSize = scrollView.bounds.size
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
    
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    @IBAction func uploadImageButtonPressed(sender: AnyObject) {
       UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        let offset = scrollView.contentOffset
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y)
        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let alert = UIAlertController(title: "Image saved", message: "Image saved to your camera roll", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    */
}

