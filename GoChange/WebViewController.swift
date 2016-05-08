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
    
    //var petitionDisplayText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        linkPetitionButton = UIBarButtonItem(title: "Link Petition", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WebViewController.linkPetitionClick))
        
        self.navigationItem.rightBarButtonItem = linkPetitionButton
        
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        linkPetitionButton.enabled = false
        linkPetitionButton.tintColor = UIColor.clearColor()
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        currentURL = webView.request!.URL?.absoluteString
        petitionText.text = currentURL
        
        
        if(currentURL != GoChangeClient.Constants.basePetitionURL && self.status != "viewing"){
            
            linkPetitionButton.enabled = true
            linkPetitionButton.tintColor = UIColor.blueColor()
            
            var petitionViewText = webView.request!.URL?.absoluteString
            
            let range = petitionViewText?.rangeOfString("\(GoChangeClient.Constants.basePetitionURL)p/")
            petitionViewText?.removeRange(range!)
            
            petitionText.text = petitionViewText
            
        }
        
    }
    
    
    @IBAction func linkPetitionClick(sender: UIButton) {
        
        TempSave.sharedInstance().currentPetitionValue = currentURL
        self.navigationController!.popViewControllerAnimated(true)
        
    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}


