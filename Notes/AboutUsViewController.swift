//
//  AboutUsViewController.swift
//  Notes
//
//  Created by Pragnesh Dixit on 18/03/15.
//  Copyright (c) 2015 Nick Grosvenor. All rights reserved.
//

import Foundation
import Foundation
import UIKit
class AboutUsViewController: UIViewController,UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
   
    // MARK:
    // MARK: UIVIewController LifeCycle Methods
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "uploadistLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        let url = "http://www.example.com/"
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    // MARK:
    // MARK: UIWEBVIEW Delegate Methods
    // MARK:

     func webViewDidStartLoad(webView: UIWebView){
        self.indicator .startAnimating()
    }
     func webViewDidFinishLoad(webView: UIWebView){
        self.indicator .stopAnimating()
    }
    

    
}

    