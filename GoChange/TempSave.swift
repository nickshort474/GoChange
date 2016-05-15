//
//  TempSave.swift
//  GoChange
//
//  Created by Nick Short on 25/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class TempSave:NSObject{
    
    
    var problemName:String = ""
    var problemOwner:String = ""
    var problemDetail:String = ""
    
    
    var solutionNameArray:[String] = []
    var solutionDetailArray:[String] = []
    var solutionVoteArray:[Int] = []
    var solutionIDArray:[String] = []
    var solutionOwnerArray:[String] = []
    var petitionURLArray:[String] = []
    
    
    
    //TODO: check whether these are all needed
    
    var newSolutionNameArray:[String] = []
    var newSolutionDetailArray:[String] = []
    var newSolutionVoteArray:[Int] = []
    var newSolutionIDArray:[String] = []
    
    //TODO: check whether newSolutionOwnerArray is needed
    
    var newPetitionURLArray:[String] = []
    var currentPetitionValue:String = ""
    
    
    
    var retrievedRecentProblem:UIButton!
    var retrievedProblemFollowed:Bool = false
    var RetrievedProblemsCount:Int = 4
    var RetrievedProblemsEmpty:Bool = false
    
    class func sharedInstance() -> TempSave{
        
        struct Static{
            static let instance = TempSave()
        }
        
        return Static.instance
    }
    
    
}