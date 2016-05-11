//
//  SearchController.swift
//  GoChange
//
//  Created by Nick Short on 29/04/2016.
//  Copyright © 2016 Nick Short. All rights reserved.
//

import Foundation
import Firebase

class SearchController:NSObject{
    
    
    var searchText:String!
    
    var returnedNameArray:[String] = []
    var returnedRefArray:[String] = []
    
    var matchedNameArray:[String] = []
    var countArray:[Int] = []
    var matchedRefArray:[String] = []
    
    
    var useNameArray:[String] = []
    var useOwnerArray:[String] = []
    
    var useDetailArray:[String] = []
    var useSolutionCountArray:[Int] = []
    
    
    
    var refsNotInCoreData:[String] = []
    
    
    init(searchText:String,completionHandler:(nameResult:[String] ,detailResult:[String],ownerResult:[String],solutionCountResult:[Int],refResult:[String],matchType:String)->Void){
        super.init()
        
        self.searchText = searchText
        
        //clear arrays after previous search
        returnedRefArray = []
        returnedNameArray = []
        
         _ = RetrieveAllNamesFromFirebase(){
            (snapshot) in
            
            for name in snapshot.children.allObjects as! [FDataSnapshot]{
                
                //add value of returned item to array
                self.returnedNameArray.append(name.value["ProblemName"]!! as! String)
                
                //add ref to item to another array
                self.returnedRefArray.append(String(name.key))
            }
            
            self.checkResults()
            
            if(self.matchedNameArray.count == 0){
                
                completionHandler(nameResult:[],detailResult:[],ownerResult:[],solutionCountResult: [],refResult:[],matchType:"noFirebaseMatches")
                
            }else{
                
                self.createRefArray(){
                (nameResult,detailResult,ownerResult,solutionCountResult,refResult,matchType) in
                
                    completionHandler(nameResult: nameResult,detailResult: detailResult,ownerResult: ownerResult,solutionCountResult: solutionCountResult,refResult: refResult,matchType:matchType)
                
                }

            }
            
                        
        }

        
    }
    
    
    
    func checkResults(){
        
        //clear matched array after previous search
        matchedNameArray = []
        countArray = []
        
        
        let searchTerm = self.searchText
        let capitalisedTerm = searchTerm.capitalizedString
        let searchArray = searchTerm.componentsSeparatedByString(" ")
        
        
        
        var count = 0
        
        for value in returnedNameArray{
            
            //search for complete search term
            if (value.rangeOfString("\(searchTerm)") != nil){
                
                //if found add to matchedNameArray
                matchedNameArray.append(value)
                
                // add location of matched item within returned array to count array
                countArray.append(count)
                
            }
            
            //search for captilazed version of search term
            else if(value.rangeOfString("\(capitalisedTerm)") != nil){
                
                matchedNameArray.append(value)
                countArray.append(count)
            }
            
            //search for individual strings from search term both normal and capitalized
            else{
                for i in 0 ..< searchArray.count{
                    if((value.rangeOfString(searchArray[i])) != nil){
                        matchedNameArray.append(value)
                        countArray.append(count)
                    }
                }
                for i in 0 ..< searchArray.count{
                    if((value.rangeOfString(searchArray[i].capitalizedString)) != nil){
                        matchedNameArray.append(value)
                        countArray.append(count)
                    }
                }
            }
            
            count += 1
        }
        
        
        
        
        
    }
    
    func createRefArray(completionHandler:(nameResult:[String],detailResult:[String],ownerResult:[String],solutionCountResult:[Int],refResult:[String],matchType:String)->Void){
        
        //clear array after coming back from previous search
        useNameArray = []
        useOwnerArray = []
        useDetailArray = []
        matchedRefArray = []
        useSolutionCountArray = []
        
        // for all results that match search term add their unique reference to useRefArray using countArray
        for num in countArray{
            matchedRefArray.append(returnedRefArray[num])
        }
        
        //use useRefArray to Check if in core data based on reference
        self.checkIfInCoreData()
        
        if(refsNotInCoreData.count == 0){
            
            completionHandler(nameResult:[],detailResult:[],ownerResult:[],solutionCountResult:[],refResult:[],matchType: "coreDataMatch")
        }else{
        
            // use refsNotInCoreData to collect all data from firebase
            _ = RetrieveDetailsFromFirebase(userRefArray: refsNotInCoreData){
                (detailResults) in
            
                self.useDetailArray = detailResults
            
                _ = RetrieveSolutionCountFirebase(problemArray:self.refsNotInCoreData){
                    (solutionCountResults) in
                
                    self.useSolutionCountArray = solutionCountResults
                
                    _  = RetrieveNamesFromFirebase(problemArray:self.refsNotInCoreData){
                        (nameResults,ownerResults) in
                    
                        self.useNameArray = nameResults
                        self.useOwnerArray = ownerResults
                    
                        completionHandler(nameResult:nameResults,detailResult:detailResults,ownerResult:ownerResults,solutionCountResult:solutionCountResults,refResult:self.refsNotInCoreData,matchType:"matched")
                    }
                }
            }
        }
        
    }
    
    func checkIfInCoreData(){
        
        //create array to hold references of coreData problems
        var followedRefArray:[String] = []
        
        // loop through search string matched useRefArray
        for i in 0 ..< matchedRefArray.count{
            
            _ = RetrieveProblem(problemID: matchedRefArray[i] ){
                (resultName,resultID) in
                
                followedRefArray.append(resultID)
                
            }
            
        }
        
        //gets useRef Array
        let setA = Set(followedRefArray)
        let setB = Set(matchedRefArray)
        
        let diff = setB.subtract(setA)
        refsNotInCoreData = Array(diff)
        
        
        
    }
    
    
}