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
    var resultSolutionCountArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let barButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "resultCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        let changeName:String = self.resultNameArray[indexPath.row] as! String
        let solutionCount:String = String(self.resultSolutionCountArray[indexPath.row])
        
        cell.textLabel!.text = changeName
        cell.detailTextLabel!.text = solutionCount
        
        return cell
        
    }
    
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        var controller:ViewResultChangeViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewResultChangeViewController") as! ViewResultChangeViewController
        let navigationController = self.navigationController
        
        controller.isOwner = "false"
        controller.changeName = self.resultNameArray[indexPath.row] as! String
        controller.changeDetail = self.resultDetailArray[indexPath.row] as! String
        controller.changeID = self.refArray[indexPath.row] as! String
        
        navigationController?.pushViewController(controller,animated: true)
    
    }
  
    
}


