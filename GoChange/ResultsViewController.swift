//
//  ResultsViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ResultLinkButton(sender: UIButton) {
        //ChangeViewController
        
        var controller:CreateChangeViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateChangeViewController") as! CreateChangeViewController
        let navigationController = self.navigationController
        
        controller.sendingController = "results"
        controller.isOwner = "no"
        
        navigationController?.pushViewController(controller,animated: true)
        
        
    }
    
}


