//
//  TempChange.swift
//  GoChange
//
//  Created by Nick Short on 25/03/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import UIKit

class TempChange:NSObject{
    
    
    var changeName:String = ""
    var changeOwner:String = ""
    var changeDetail:String = ""
    
    
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
    
    //TODO: check whether newSoltuionOwnerArray is needed
    
    var newPetitionURLArray:[String] = []
    
    var currentPetitionValue:String = ""
    
    
    
    class func sharedInstance() -> TempChange{
        
        struct Static{
            static let instance = TempChange()
        }
        
        return Static.instance
    }
    
    
}