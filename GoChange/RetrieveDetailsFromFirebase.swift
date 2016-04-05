//
//  RetrieveDetailsFromFirebase.swift
//  GoChange
//
//  Created by Nick Short on 05/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase


class RetrieveDetailsFromFirebase:NSObject{
    
    var ref = Firebase(url: "https://gochange.firebaseio.com/change/details")
    //var results = FDataSnapshot()
    
    var results:NSMutableArray = []
    
    init(userRefArray:NSMutableArray,completionHandler:(results:FDataSnapshot)->Void){
        
        super.init()
        
        
        for var i in 0 ..< userRefArray.count{
            
            var changeRef = ref.childByAppendingPath(userRefArray[i] as! String)
            
            changeRef.observeEventType(.Value, withBlock: { snapshot in
            
            completionHandler(results:snapshot)
                print(snapshot.value)
            
            }, withCancelBlock:{ error in
                print("error retrieving data")
                print(error.description)
                
        })

            
        }
                
        //let results = [String:AnyObject]()
        
        
    }
    
    
}