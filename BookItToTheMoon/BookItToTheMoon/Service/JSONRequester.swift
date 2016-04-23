//
//  JSONRequester.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation




class JSONRequester {
    
    class var factsURL: NSURL {
        guard let factsURL = NSBundle.mainBundle().URLForResource("facts", withExtension: "json") else {
            fatalError("Could not find facts.json file.")
        }
        return factsURL
    }
    
    class func requestMoonFacts(factsURL factsURL: NSURL) {
        
    }
}