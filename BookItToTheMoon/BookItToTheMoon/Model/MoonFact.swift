//
//  MoonFact.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation


struct MoonFact: PlanetFact {
    
    private let moonFactHeadline: String
    private let moonFactReason: String
    
    init(jsonDictionary: NSDictionary) {
        
        // guard
        guard let fact = jsonDictionary["fact"] as? String, let reason = jsonDictionary["reason"] as? String else {
            fatalError("Could not init MoonFact with dictionary \(jsonDictionary)")
        }

        // init values
        moonFactHeadline = fact
        moonFactReason = reason
        
    }
    
    
    
    // -- PlanetFact Protocol
    
    var factHeadline: String {
        return moonFactHeadline
    }
    
    var factReason: String {
        return moonFactReason
    }
}



// MARK: Hashable

extension MoonFact: Hashable {
    
    var hashValue: Int {
        return moonFactHeadline.hashValue ^ moonFactReason.hashValue
    }
}



// MARK: Equatable

func ==(lhs: MoonFact, rhs: MoonFact) -> Bool {
    return lhs.moonFactHeadline == rhs.moonFactHeadline && lhs.moonFactReason == rhs.moonFactReason
}