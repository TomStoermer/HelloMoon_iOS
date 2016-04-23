//
//  MoonFact.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation


struct PlanetFact {
    
    private let factHeadline: String
    private let factReason: String
    
    init(jsonDictionary: NSDictionary) {
        
        // guard
        guard let fact = jsonDictionary["fact"] as? String, let reason = jsonDictionary["reason"] as? String else {
            fatalError("Could not init MoonFact with dictionary \(jsonDictionary)")
        }

        // init values
        self.factHeadline = fact
        self.factReason = reason
        
    }

}



// MARK: Hashable

extension PlanetFact: Hashable {
    
    var hashValue: Int {
        return factHeadline.hashValue ^ factHeadline.hashValue
    }
}



// MARK: Equatable

func ==(lhs: PlanetFact, rhs: PlanetFact) -> Bool {
    return lhs.factHeadline == rhs.factHeadline && lhs.factReason == rhs.factReason
}