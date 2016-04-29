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
    @IBOutlet weak var linkPetition: UIButton!
    @IBOutlet weak var petitionText: UITextField!
    
    //var baseURL:String = "https://www.change.org/"
    var petitionString:String!
    var urlString:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        linkPetition.enabled = false
        linkPetition.alpha = 0.5
        
        //petitionText.text = webView.request!.URL?.absoluteString
        
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        if(webView.request!.URL?.absoluteString != GoChangeClient.Constants.dynamicPetitionURL){
            
            linkPetition.enabled = true
            linkPetition.alpha = 1
            
            var petitionViewText = webView.request!.URL?.absoluteString
            
            let range = petitionViewText?.rangeOfString("\(GoChangeClient.Constants.dynamicPetitionURL)p/")
            petitionViewText?.removeRange(range!)
            
            print(petitionViewText)
            
            petitionText.text = petitionViewText
        }
    }
    
    
    @IBAction func linkPetitionClick(sender: UIButton) {
        
        
        petitionString = webView.request!.URL?.absoluteString
        GoChangeClient.Constants.dynamicPetitionURL = petitionString
        
        self.navigationController!.popViewControllerAnimated(true)
    }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}


