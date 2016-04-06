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
    var detailRef = Firebase(url: "https://gochange.firebaseio.com/change/details")
    
    init(changeID:String,completionHandler:(results:FDataSnapshot)->Void){
        
        super.init()
        
        // if changeID == "" then coming from searchViewController use nameRef
        // else if changeID != "" coming from CreateChangeVC, use detailRef and append changeID
        if (changeID == ""){
            
            nameRef.observeEventType(.Value, withBlock: { snapshot in
            
                completionHandler(results:snapshot)
           
            }, withCancelBlock:{ error in
                
                print("error retrieving data")
                print(error.description)
            
            })
        }else{
            
            let newDetailRef = detailRef.childByAppendingPath(changeID)
            
            newDetailRef.observeEventType(.Value, withBlock: {snapshot in
                
                completionHandler(results:snapshot)
                
            },withCancelBlock:{ error in
                
                print(error.description)
                    
            })
            
        }
        
        
        
        
        
    }
    
    
}