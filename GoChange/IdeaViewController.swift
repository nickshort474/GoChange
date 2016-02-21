//
//  IdeaViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTweakClick(sender: UIButton) {
        
        var controller:AddTweakViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddTweakViewController") as! AddTweakViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
}


