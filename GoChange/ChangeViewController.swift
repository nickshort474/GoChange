//
//  ChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {
    
    @IBOutlet weak var addIdeaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewIdeaClick(sender: UIButton) {
        
        
        var controller:IdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("IdeaViewController") as! IdeaViewController
        
        let navController = self.navigationController
        
        navController!.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func addIdeaClick(sender: UIButton) {
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
}

