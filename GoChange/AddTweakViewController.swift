//
//  AddTweakViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit


class AddTweakViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    var nameData:String?
    var detailData:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameText.delegate = self
        detailText.delegate = self
        
        nameButton.hidden = true
        detailButton.hidden = true
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------text delegate methods------------
    
    func textFieldDidBeginEditing(textField: UITextField) {
        nameButton.hidden = false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        nameButton.hidden = true
        detailButton.hidden = false
        detailText.text = ""
        detailText.textColor = UIColor.blackColor()
    }
    
    
    
    
    
    @IBAction func nameButtonClick(sender: UIButton) {
        nameText.resignFirstResponder()
        nameButton.hidden = true
        
        
        
        nameData = nameText.text
    }
    
    
    @IBAction func detailButtonClick(sender: UIButton) {
        detailText.resignFirstResponder()
        detailButton.hidden = true
        
        
        
        detailData = detailText.text
    }
    
    
    
    
    @IBAction func addTweakClick(sender: UIButton) {
        //TODO: add tweak details to TempChange
        TempChange.sharedInstance().tweakNameArray.addObject(nameText.text!)
        TempChange.sharedInstance().tweakDetailArray.addObject(detailText.text)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
   
    
    
    @IBAction func cancelClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


