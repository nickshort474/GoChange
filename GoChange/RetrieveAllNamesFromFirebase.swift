//
//  RetrieveAllNamesFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 04/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class RetrieveAllNamesFromFirebase:NSObject{
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/problem/names")
    
    
    init(completionHandler:(results:AnyObject)->Void){
        
        super.init()
        
        nameRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            completionHandler(results:snapshot)
           
        }, withCancelBlock:{ error in
                
           completionHandler(results:error.description)
            
        })
        
    }
    
    
}