//
//  FollowingViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load all core data saved changes
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func HomeButtonClick(sender: UIButton) {
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func FollowedChangeButton(sender: UIButton) {
        
        var controller:CreateChangeViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateChangeViewController") as! CreateChangeViewController
        
        let navigationController = self.navigationController
        
        controller.sendingController = "following"
        controller.isOwner = "yes"
        
        navigationController?.pushViewController(controller,animated: true)
        
    }
}


