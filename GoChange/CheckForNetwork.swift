//
//  CheckForNetwork.swift
//  GoChange
//
//  Created by Nick Short on 12/05/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase

class CheckForNetwork:NSObject{
    
    //var connectedRef = Firebase(url:"https://gochange.firebaseio.com/.info/connected")
    
    
    
    init(completionHandler:(result:String)->Void){
    
    super.init()
        
        let connectedRef = FIRDatabase.database().reference().child("/.info/connected")
        
        connectedRef.observeEventType(.Value, withBlock: { snapshot in
            
            let connected = snapshot.value as? Bool
            
            if connected != nil && connected! {
                
                completionHandler(result:"Connected")
                
            } else {
                
                completionHandler(result:"Not connected")
            }
        })
    
    }

    
}