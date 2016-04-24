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
    
    class func requestMoonFacts(completion: (moonFacts: [PlanetFact]?, error: NSError?) -> Void) {
        
        // read data from file URL
        guard let factsData = NSData(contentsOfURL: factsURL) else {
            fatalError("Could not read facts data from factsURL \(factsURL)")
        }
        
        // serialize local json data
        let factsJsonData = try? NSJSONSerialization.JSONObjectWithData(factsData, options: .AllowFragments)
        
        // check the json value types
        guard let jsonDictionary = factsJsonData as? NSDictionary, let facts = jsonDictionary["facts"] as? [NSDictionary] else {
            fatalError("The returned facts.json is not valid.\n JSON content: \(factsJsonData)")
        }
        
        // create the data models
        let moonFacts = facts.map { (jsonDict: NSDictionary) -> PlanetFact in
            
            // init MoonFact with json dictionary
            return PlanetFact(jsonDictionary: jsonDict)
        }
        
        completion(moonFacts: moonFacts, error: nil)
    }
}