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
    
    var refArray:[String] = []
    var resultNameArray:[String] = []
    var resultDetailArray:[String] = []
    var resultSolutionCountArray:[Int] = []
    
    
    //TODO: Display owner of problem somewhere
    var problemOwnerArray:[String] = []
    
    
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
        
        let problemName:String = self.resultNameArray[indexPath.row]
        let solutionCount:String = String(self.resultSolutionCountArray[indexPath.row])
        
        cell.textLabel!.text = problemName
        cell.detailTextLabel!.text = "\(solutionCount) solutions"
        
        return cell
        
    }
    
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        var controller:ViewResultViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ViewResultViewController") as! ViewResultViewController
        let navigationController = self.navigationController
        
        controller.problemName = self.resultNameArray[indexPath.row]
        controller.problemDetail = self.resultDetailArray[indexPath.row]
        controller.problemID = self.refArray[indexPath.row]
        controller.owner = self.problemOwnerArray[indexPath.row]
    
    
        navigationController?.pushViewController(controller,animated: true)
    
    }
  
    
}


