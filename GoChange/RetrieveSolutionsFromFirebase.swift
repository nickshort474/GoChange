//
//  RetrieveSolutionsFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 06/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase

class RetrieveSolutionsFromFirebase:NSObject{
    
    var ref = Firebase(url:"https://gochange.firebaseio.com/change/solutions")
    
    
    init(changeID:String,completionHandler:(result:FDataSnapshot)->Void){
        super.init()
        
        var changeRef = ref.childByAppendingPath(changeID)
        
        changeRef.observeEventType(.Value, withBlock: {snapshot in
            
            completionHandler(result: snapshot)
            
            
        },withCancelBlock: {error in
            print(error.description)
        })
        
        
    }
    
    
    
}