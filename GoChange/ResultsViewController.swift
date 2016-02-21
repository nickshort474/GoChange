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
        
        var controller:ChangeViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ChangeViewController") as! ChangeViewController
        let navigationController = self.navigationController
        
        navigationController?.pushViewController(controller,animated: true)
        
        
    }
    
}


