//
//  WebViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var petitionText: UITextField!
    
    var currentURL:String!
    var urlString:String = ""
    var status:String!
    
    var rightBarButton:UIBarButtonItem!
    
    //var petitionDisplayText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        //linkPetition.enabled = false
        //linkPetition.alpha = 0.5
        
        //petitionText.text = webView.request!.URL?.absoluteString
        
        rightBarButton = UIBarButtonItem(title: "Link Petition", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WebViewController.linkPetitionClick))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        rightBarButton.enabled = false
        rightBarButton.tintColor = UIColor.clearColor()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        currentURL = webView.request!.URL?.absoluteString
        
        //print(currentURL)
        
        petitionText.text = currentURL
        
        //print(currentURL)
        //print(GoChangeClient.Constants.basePetitionURL)
        
        if(currentURL != GoChangeClient.Constants.basePetitionURL){
            
            rightBarButton.enabled = true
            rightBarButton.tintColor = UIColor.clearColor()
            
            var petitionViewText = webView.request!.URL?.absoluteString
            
            let range = petitionViewText?.rangeOfString("\(GoChangeClient.Constants.basePetitionURL)p/")
            petitionViewText?.removeRange(range!)
            
            petitionText.text = petitionViewText
        }
        
    }
    
    
    @IBAction func linkPetitionClick(sender: UIButton) {
        
        
        //petitionString = webView.request!.URL?.absoluteString
        TempChange.sharedInstance().currentPetitionValue = currentURL
        
        self.navigationController!.popViewControllerAnimated(true)
    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}


