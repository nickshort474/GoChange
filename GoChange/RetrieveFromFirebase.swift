//
//  RetrieveFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 04/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class RetrieveFromFirebase:NSObject{
    
    var nameRef = Firebase(url: "https://gochange.firebaseio.com/change/names")
    
    
    init(completionHandler:(results:FDataSnapshot)->Void){
        
        super.init()
        
        nameRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            completionHandler(results:snapshot)
           
        }, withCancelBlock:{ error in
                
            print(error.description)
            
        })
        
    }
    
    
}