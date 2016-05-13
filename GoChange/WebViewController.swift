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
    var linkPetitionButton:UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        linkPetitionButton = UIBarButtonItem(title: "Link Petition", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WebViewController.linkPetitionClick))
        self.navigationItem.rightBarButtonItem = linkPetitionButton
        
        //setup url and request
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
       
        //load request
        webView.loadRequest(request)
        
        
    }
    
    
   
    override func viewWillAppear(animated: Bool) {
        
        // hide petition button
        linkPetitionButton.enabled = false
        linkPetitionButton.tintColor = UIColor.clearColor()
        
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // once webview finsihed loading get curent url
        currentURL = webView.request!.URL?.absoluteString
        
        //set text to current url
        petitionText.text = currentURL
        
        // test to see if current url is not homepage and not currently viewing linked petition
        if(currentURL != GoChangeClient.Constants.basePetitionURL && self.status != "viewing"){
            
            //enable link petition button
            linkPetitionButton.enabled = true
            linkPetitionButton.tintColor = UIColor.blueColor()
            
            //set var to url
            var petitionViewText = webView.request!.URL?.absoluteString
            
            //get range of petition text from complete change.org url
            let range = petitionViewText?.rangeOfString("\(GoChangeClient.Constants.basePetitionURL)p/")
           
            //remove change.org part of url
            petitionViewText?.removeRange(range!)
            
            //display whats left
            petitionText.text = petitionViewText
            
        }
        
    }
    
    // link petition
    @IBAction func linkPetitionClick(sender: UIButton) {
        
        TempSave.sharedInstance().currentPetitionValue = currentURL
        self.navigationController!.popViewControllerAnimated(true)
        
    }
        
    
    
}


