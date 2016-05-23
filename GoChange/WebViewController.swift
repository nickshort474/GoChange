//
//  WebViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController{
    
    
    @IBOutlet weak var changeOrg: UIButton!
    @IBOutlet weak var linkPetition: UIButton!
    @IBOutlet weak var petitionText: UITextField!
    
    @IBOutlet weak var petitionView: UIView!
    @IBOutlet weak var petitionActivity: UIActivityIndicatorView!
    
    
    var urlString:String!
    var timer:NSTimer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIPasteboard.generalPasteboard().string = " "
        
        self.petitionView.alpha = 1
        self.petitionActivity.stopAnimating()
        self.petitionActivity.alpha = 0
        self.linkPetition.alpha = 0
        self.linkPetition.enabled = false
        
    }
    
        
    @IBAction func changeOrgClick(sender: UIButton) {
        
        //get url passed in
        let newURL = NSURL(string: urlString)
        
        //open in safari / (not webView due to problem with gathering url from some pages loaded in webView)
        UIApplication.sharedApplication().openURL(newURL!)
        
        //setup timer
        setupTimer()
        
    }
    
    @IBAction func linkPetitionClick(sender: UIButton) {
        
        //get petition url from pasteboard
        TempSave.sharedInstance().currentPetitionValue =  UIPasteboard.generalPasteboard().string!
        
        //pop view controller
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func setupTimer(){
        
        //set timer
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    func onTimer(){
       
        var capturedPasteValue:String
        
        //get value of pasteboard string
        if let pasteValue = UIPasteboard.generalPasteboard().string{
            
            capturedPasteValue = pasteValue
            
            if(capturedPasteValue != " "){
            
                self.petitionView.alpha = 0.5
                self.petitionActivity.startAnimating()
                self.petitionActivity.alpha = 1
                self.changeOrg.enabled = false
                
                /*
                 //set petition text to copied url
                 let baseURL = GoChangeClient.Constants.basePetitionURL
                 let fullURL = UIPasteboard.generalPasteboard().string!
                 let range = fullURL.rangeOfString("\(baseURL)p/")
                 let displayURL = fullURL.stringByReplacingCharactersInRange(range!, withString: "")
                 */
            
                //get petition data from change.org
                _ = ChangeOrgCode(petitionURL:UIPasteboard.generalPasteboard().string!){
                    result in
                
                
                    //get tilte
                    if let resultTitle = result["title"]{
                        if let resultTitle = resultTitle{
                        
                            dispatch_async(dispatch_get_main_queue(),{
                                self.petitionText.text  = resultTitle as? String
                                self.petitionView.alpha = 1
                                self.petitionActivity.stopAnimating()
                                self.petitionActivity.alpha = 0
                                self.linkPetition.enabled = true
                                self.linkPetition.alpha = 1
                                self.changeOrg.enabled = true
                                
                                
                            })
                        
                        }
                    
                    }
                
                }
            
                //stop timer
                timer.invalidate()
            
            }

        }
                        
    }
}


