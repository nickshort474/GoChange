//
//  RetrieveAllNamesFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 04/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class RetrieveAllNamesFromFirebase:NSObject{
    
   
    init(completionHandler:(results:AnyObject)->Void){
        
        super.init()
        let nameRef = FIRDatabase.database().reference().child("problem/names")
        
        
        nameRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            completionHandler(results:snapshot)
           
        }, withCancelBlock:{ error in
                
           completionHandler(results:error.description)
            
        })
        
    }
    
    
}