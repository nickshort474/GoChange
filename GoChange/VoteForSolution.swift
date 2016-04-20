//
//  VoteForSolution.swift
//  GoChange
//
//  Created by Nick Short on 20/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation

class VoteForSolution:NSObject{
    
    
    init(changeID:String,completionHandler:(result:AnyObject)->Void){
        super.init()
        
        addVoteToCoreData()
        addVoteToFirebase()
        
    }
    
    
    func addVoteToCoreData(){
        
    }
    
    
    func addVoteToFirebase(){
        
    }
    
    
}