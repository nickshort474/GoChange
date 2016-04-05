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
    
    var ref = Firebase(url: "https://gochange.firebaseio.com/change/names")
    //var results = FDataSnapshot()
    
    init(completionHandler:(results:FDataSnapshot)->Void){
        
        super.init()
        
        ref.queryOrderedByChild("ChangeName").observeEventType(.Value, withBlock: { snapshot in
            
           completionHandler(results:snapshot)
           // print(snapshot.value)
            
        }, withCancelBlock:{ error in
            print("error retrieving data")
            print(error.description)
            
        })
        
        //let results = [String:AnyObject]()
        
        
    }
    
    
}