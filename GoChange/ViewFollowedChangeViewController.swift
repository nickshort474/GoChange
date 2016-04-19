//
//  ViewFollowedChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 15/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class ViewFollowedChangeViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var solutionTable: UITableView!
    
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var addASolutionButton: UIButton!
    @IBOutlet weak var followChangeButton: UIButton!
    @IBOutlet weak var postChangeButton: UIButton!
    
    
    /*
    var isOwner:String!
    
    var changeName:String!
    var changeDetail:String!
    */
    
    var changeClicked:Change!
    var localSolutionCount:Int!
    var changeID:String!
    var changeIDArray:NSMutableArray = []
    
    
    var sendingController:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //set delegates
        nameField.delegate = self
        detailsField.delegate = self
        solutionTable.delegate = self
        
        
        postChangeButton.enabled = false
        postChangeButton.alpha = 0.5
        
        
        //TODO: Decide whether to allow owner of change to edit question once posted
        nameButton.hidden = true
        detailButton.hidden = true
        
        nameField.enabled = false
        detailsField.selectable = false
        
        
        self.title = "Following"
        
        
        //if coming from ViewResultChangeViewController need tback button to go home
        if(sendingController == "ViewResult"){
            let barButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewFollowedChangeViewController.goBackHome))
            self.navigationItem.leftBarButtonItem = barButtonItem
            
        }else if(sendingController == "Following"){
            
        }
       
        
        //TODO: Check whether any new solutions added then enable postChange button
        //TODO: make sure to unload view when going back so that viewDidLoad will run every time coming to VC
        
        //if coming from followed (or results) retrieve from core data using changeClicked var (new completion handler for results)
        
        
        nameField.text = changeClicked.changeName
        detailsField.text = changeClicked.changeDescription
        localSolutionCount = changeClicked.solutionCount as Int
        changeID = changeClicked.changeID
        
        //add changeID to changeID array ready for passing to RetrieveSolutions
        changeIDArray.addObject(changeID)
        
        
        
        //check to see whether solution count in database matches that in core data
       //Even if coming from results can check to see whether any new solutions added since search was conducted
        
        
        
        _ = RetrieveSolutionCountFirebase(changeArray: changeIDArray, completionHandler: {
            (result) in
            
            //TODO: process returned snapshot
            let firebaseSolutionCount = result[0] as! Int
            
            // if new solutions exist
            if (firebaseSolutionCount != self.localSolutionCount){
                
                //retrieve from firebase
                _ = RetrieveSolutionsFromFirebase(changeID: self.changeID, completionHandler: {
                    (result) in
                    
                    // empty TempArrays ready to be populate with new data
                    TempChange.sharedInstance().solutionNameArray = []
                    TempChange.sharedInstance().solutionDetailArray = []
                    TempChange.sharedInstance().solutionNewOldArray = []
                    
                    //loop through returned array to extract data
                    for name in result.children.allObjects as! [FDataSnapshot]{
                        
                       //assign results from firebase to Temp solutionArrays
                        TempChange.sharedInstance().solutionNameArray.addObject(name.value["SolutionName"]!!)
                        TempChange.sharedInstance().solutionDetailArray.addObject(name.value["SolutionDescription"]!!)
                        TempChange.sharedInstance().solutionNewOldArray.addObject("old")
                    }
                    
                    
                    //save the new set of solutions to core data
                    let postType:String = "updateCoreDataSolutions"
                    
                    //TODO: decide whether need owner for solutions, or just for change itself
                    //have only solutions tagged as new saved to core data with owner as true
                    
                    //let owner:String = self.changeClicked.owner
                                        
                    _ = SaveData(postType:postType,change:self.changeClicked!){
                        (result) in
                        
                        //TODO: do i need returned result here?
                    }
                    
                    self.solutionTable.reloadData()
                    
                })
            }else{
                //No new solutions to download so gather existing ones from core data
                
                _ = RetrieveSolutions(change:self.changeClicked!){
                    (result) in
                    
                    // empty TempArrays ready to be populate with new data
                    TempChange.sharedInstance().solutionNameArray = []
                    TempChange.sharedInstance().solutionDetailArray = []
                    TempChange.sharedInstance().solutionNewOldArray = []
                    
                    //assign results from coreData return to temp array then use TempArray for table
                    for solution in result as! [Solution]{
                        
                        TempChange.sharedInstance().solutionNameArray.addObject(solution.solutionName)
                        TempChange.sharedInstance().solutionDetailArray.addObject(solution.solutionDescription)
                        TempChange.sharedInstance().solutionNewOldArray.addObject("old")
                        
                    }
                    self.solutionTable.reloadData()
                    
                }
                
            }
            
            
        })
        
        
        // if coming from recently followed result...
        
        //retrieve info from TempArray
        
        //

    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(TempChange.sharedInstance().addingSolutions == "true"){
            self.postChangeButton.enabled = true
            self.postChangeButton.alpha = 1
        }
        
        self.solutionTable.reloadData()
        
    }

    @IBAction func addNameClick(sender: UIButton) {
        // if owner == true
        //enable button
    }


    @IBAction func addDetailClick(sender: UIButton) {
        // if owner == true
        //enable button
    }


    @IBAction func addSolutionClick(sender: UIButton) {
        
        //if adding a new solution set back button title to cancel
        let barButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "adding"
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }




    @IBAction func postChangeClick(sender: UIButton) {
        
        
        
        //loop through solutionNewOldArray to check for the newly added solutions
        for var i in 0 ..<  TempChange.sharedInstance().solutionNewOldArray.count{
                
            if(TempChange.sharedInstance().solutionNewOldArray[i] as! String == "new"){
                    
                // add newly added solutions to newSolution arrays
                TempChange.sharedInstance().newSolutionNameArray.addObject(TempChange.sharedInstance().solutionNameArray[i])
                TempChange.sharedInstance().newSolutionDetailArray.addObject(TempChange.sharedInstance().solutionDetailArray[i])
                    
            }
        }
            
        // then run saveData with postType
        let postType:String = "coreDataFirebaseSolutionPost"
        
        //TODO: have only solutions tagged as new saved to core data with owner as true
        //let owner:String = self.changeClicked.owner
        
        let change:Change = self.changeClicked! //TODO: returned from new completion handler
        
         
            
        _ = SaveData(postType:postType,change:change){
            (result) in
            
            //TODO: do i nedd result here? (change object)
            
            
        }
        
        //set addingSolutions back to false
        TempChange.sharedInstance().addingSolutions = "false"
        self.postChangeButton.enabled = false
        self.postChangeButton.alpha = 0.5
        
        //empty newSolutionArrays ready for any addtional solutions to be added
        TempChange.sharedInstance().newSolutionNameArray = []
        TempChange.sharedInstance().newSolutionDetailArray = []
    }

    
    
    
    //---------------------textView methods------------
    func textViewDidBeginEditing(textView: UITextView) {
        
        
        
    }
    
    
    
    
    
    //--------------------Table view methods--------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempChange.sharedInstance().solutionNameArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID = "solutionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        var solutionName:String = ""
        solutionName = TempChange.sharedInstance().solutionNameArray[indexPath.row] as! String
        cell.textLabel!.text = solutionName
        
        return cell
        
    }
    
    func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        //change back button on addIdeaVC to Back instead of "Cancel Idea"
        
        
        
        var controller:AddIdeaViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddIdeaViewController") as! AddIdeaViewController
        
        controller.viewControllerStatus = "viewing"
        controller.loadedNameData = TempChange.sharedInstance().solutionNameArray[indexPath.row] as? String
        controller.loadedDetailData = TempChange.sharedInstance().solutionDetailArray[indexPath.row] as? String
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func goBackHome(){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func unfollowChange(sender: UIButton) {
        
        print("Change unfollowed")
        
    }
    
}