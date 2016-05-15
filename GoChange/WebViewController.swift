//
//  WebViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    //@IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var petitionText: UITextField!
    
    @IBOutlet weak var webView: WKWebView!
    
    
    
    var currentURL:String!
    var urlString:String = ""
    var status:String!
    var linkPetitionButton:UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       webView.UIDelegate = self
        
        linkPetitionButton = UIBarButtonItem(title: "Link Petition", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WebViewController.linkPetitionClick))
        self.navigationItem.rightBarButtonItem = linkPetitionButton
        
        //setup url and request
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
       
        //load request
        //webView.loadRequest(request)
        
        //setPetitionURL()
        
        
        UIApplication.sharedApplication().openURL(url)
        
    }
    
    
   
    override func viewWillAppear(animated: Bool) {
        
        // hide petition button until conditions met below
        linkPetitionButton.enabled = false
        linkPetitionButton.tintColor = UIColor.clearColor()
        
    }
    
    func webViewDidStartLoad(webView: WKWebView) {
        print("start loading")
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
   
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        print("web view did finish loading")
        
        // once webview finsihed loading get curent url
        currentURL = webView.request!.URL?.absoluteString
        
        //let newString = webView.stringByEvaluatingJavaScriptFromString((webView.request?.mainDocumentURL)!)
        //let newnewString = webView.stringByEvaluatingJavaScriptFromString(webView.request!.URL?.absoluteURL)
        
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


