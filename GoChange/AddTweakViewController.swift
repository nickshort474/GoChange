//
//  AddTweakViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit


class AddTweakViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func addTweakClick(sender: UIButton) {
        
        
    }
    
   
    
    
    @IBAction func cancelClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


