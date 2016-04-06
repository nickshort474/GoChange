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
    var resultNameArray:NSMutableArray = []
    var resultDetailArray:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "resultCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var changeName:String = self.resultNameArray[indexPath.row] as! String
        var changeDetail:String = self.resultDetailArray[indexPath.row] as! String
        
        cell.textLabel!.text = changeName
        cell.detailTextLabel!.text = changeDetail
        
        return cell
        
    }
    
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        var controller:CreateChangeViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateChangeViewController") as! CreateChangeViewController
        
        let navigationController = self.navigationController
        
        controller.sendingController = "results"
        controller.isOwner = "false"
    
        controller.changeName = self.resultNameArray[indexPath.row] as! String
        controller.changeDetail = self.resultDetailArray[indexPath.row] as! String
        controller.changeID = self.refArray[indexPath.row] as! String
        
        navigationController?.pushViewController(controller,animated: true)
    
    }
  
    
}


