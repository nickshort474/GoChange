//
//  ChangePreviewViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase

class ChangePreviewViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem?.title = "edit"
        
        
        /*
        var leftBarButton:UIBarButtonItem
        leftBarButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "leftButtonAction")
        self.navigationItem.leftBarButtonItem = leftBarButton
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveChangeClick(sender: UIButton) {
        
       
        //pop to root
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func leftButtonAction(){
        
    }
    
}


