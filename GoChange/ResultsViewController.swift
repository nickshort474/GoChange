//
//  ResultsViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    
    var refArray:NSMutableArray = []
    var resultArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //TODO: If viewing change load from core data
        return resultArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "resultCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = self.resultArray[indexPath.row] as! String
        
        
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    
    
    
    
    
    func ResultLinkButton(sender: UIButton) {
        //ChangeViewController
        
        var controller:CreateChangeViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateChangeViewController") as! CreateChangeViewController
        let navigationController = self.navigationController
        
        controller.sendingController = "results"
        controller.isOwner = "no"
        
        navigationController?.pushViewController(controller,animated: true)
        
        
    }
    
}


