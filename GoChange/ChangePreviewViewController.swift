//
//  ChangePreviewViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit
import Firebase
import CoreData


class ChangePreviewViewController: UIViewController {
    
    let firebaseRef = Firebase(url:"https://gochange.firebaseio.com")
    var passedName:String = ""
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    var changeName:String!
    var changeDescription:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem?.title = "edit"
        
        print(passedName)
        
        let fetchChangeRequest = NSFetchRequest(entityName: "Change")
        
        let fetchPredicate = NSPredicate(format:"changeName == %@", passedName)
        
        fetchChangeRequest.predicate = fetchPredicate
        
        do{
            let returnedChange = try sharedContext.executeFetchRequest(fetchChangeRequest) //as! [Change]
            if let changeEntity = returnedChange.first{
                print(changeEntity)
                self.nameTextfield.text = changeEntity.changeName
                self.descriptionTextView.text = changeEntity.changeDescription
            }
           
        }catch{
            //TODO: deal with errors
        }

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var sharedContext:NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    @IBAction func saveChangeClick(sender: UIButton) {
        
                
        // upload chnage details to firebase
        
        //pop to root
        //self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func leftButtonAction(){
        
    }
    
}


