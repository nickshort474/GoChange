//
//  CreateChangeViewController.swift
//  GoChange
//
//  Created by Nick Short on 06/02/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import UIKit

class CreateChangeViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var inputTextView: UITextView!
    
    var savedText:String = ""
    var currentField:String = ""
    
    var currentNameData:String = ""
    var currentDetailData:String = ""
    
    let nameInputPrompt:String = "Please input a name for the change you would like to see, either in the world or yourself"
    
    let detailInputPrompt:String = "Please input some details about the change you would like to see, maybe some specifics of the change or even the reasons behind wanting the change"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameTextfield.delegate = self
        
        detailsTextView.delegate = self
        
        inputTextView.delegate = self
        
        inputTextView.hidden = true
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func homeButtonClick(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    // Name textfield clicked
    func textFieldDidBeginEditing(textField: UITextField) {
        
        currentField = "Name"
        
        // show input box
        inputTextView.hidden = false
        
        // show prompt string if first time
        if(nameTextfield.text == ""){
            inputTextView.text = nameInputPrompt
        }else{
            inputTextView.text = currentNameData
        }
        
        
        nameTextfield.resignFirstResponder()
        
       
    }
    
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        // if detail text view
        if(textView.tag == 2){
            
            currentField = "Details"
            inputTextView.hidden = false
            
            // show prompt data if first time
            if(detailsTextView.text == ""){
                 inputTextView.text = detailInputPrompt
            }else{
                inputTextView.text = currentDetailData
            }
            detailsTextView.resignFirstResponder()
            
        }
        
        // if input popup textView clicked
        if(textView.tag == 1){
            
            inputTextView.becomeFirstResponder()
            
            if(inputTextView.text == nameInputPrompt || inputTextView.text == detailInputPrompt){
                inputTextView.text = ""
            }
        }
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n" && textView.tag == 1 && currentField == "Name"){
            
            nameTextfield.text = inputTextView.text
            currentNameData = inputTextView.text
            inputTextView.resignFirstResponder()
            inputTextView.hidden = true
            
            
        }else if(text == "\n" && textView.tag == 1 && currentField == "Details"){
            
            detailsTextView.text = inputTextView.text
            currentDetailData = inputTextView.text
            inputTextView.resignFirstResponder()
            inputTextView.hidden = true
        }
        return true
        
    }
   
    
   
    
    
    @IBAction func previewChange(sender: UIButton) {
        
        var controller:ChangePreviewViewController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("ChangePreviewViewController") as! ChangePreviewViewController
        let navController = self.navigationController
        
        navController?.pushViewController(controller, animated: true)
        
    }
    
}


