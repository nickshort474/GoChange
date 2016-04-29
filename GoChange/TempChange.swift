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
    
    
    //var solutionNewOldArray:NSMutableArray = []
    
    var solutionIDArray:[String] = []
    
    var solutionOwnerArray:[String] = []
    
    var newSolutionIDArray:[[String]] = []
    var newSolutionNameArray:[String] = []
    var newSolutionDetailArray:[String] = []
    var newSolutionVoteArray:[Int] = []
    
    var tweakNameArray:[String] = []
    var tweakDetailArray:[String] = []
    
    //var addingSolutions:String = ""
    
    
    
    
    
    class func sharedInstance() -> TempChange{
        
        struct Static{
            static let instance = TempChange()
        }
        
        return Static.instance
    }
    
    
}