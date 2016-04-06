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
        
    var results:NSMutableArray = []
    
    init(userRefArray:NSMutableArray,completionHandler:(results:NSMutableArray)->Void){
        
        super.init()
        
        for var i in 0 ..< userRefArray.count{
            
            var changeRef = ref.childByAppendingPath(userRefArray[i] as! String)
            
            changeRef.observeEventType(.Value, withBlock: { snapshot in
                
                self.results.addObject(snapshot.value["ChangeDetail"] as! String)
                
                if(self.results.count == userRefArray.count){
                    
                    completionHandler(results:self.results)
                    
                }
                
            
            }, withCancelBlock:{ error in
                print("error retrieving data")
                print(error.description)
                
            })
            
            
            
        }
        
        // if results.count == userRefArray
        
    }
    
    
}