//
//  Moon.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

/// The Moon phases.
enum MoonPhrase {
    
    case NewMoon
    case WaxingCrescent
    case FirstQuarter
    case WaxingGibbous
    case FullMoon
    case WaningGibbous
    case LastQuarter
    case WaningCrescent
    
    /// Returns the localized moon phrase.
    func localizedMoonPhrase() -> String {
        
        let moonPhrase: String!
        
        switch self {
        case .NewMoon:
            moonPhrase = NSLocalizedString("MoonPhrase_NewMoon", comment: "Moon Phrase ENUM Case")
        default:
            moonPhrase = NSLocalizedString("MoonPhrase_Default", comment: "Moon Phrase ENUM Case")
        }
        
        return moonPhrase
        
    }
}


/// The Moon. Also known as Luna which is the latin word for Moon.
struct Moon: Planet {


    
    // -- Properties
    
    let moonPhase: MoonPhrase
    var moonDistance: CGFloat
    
    
    // -- Init
    init(moonPhase: MoonPhrase, moonDistance: CGFloat) {
        
        self.moonPhase = moonPhase
        self.moonDistance = moonDistance
    }
    
    
    
    // -- Update distance
    mutating func updateMoonDistance(newDistance: CGFloat) {
        self.moonDistance = newDistance
    }
    
    
    
    // -- Planet Protocol
    
    var planetName: String {
        return "Moon"
    }
    
    var planetTitle: String {
        return "The Moon..."
    }
    
    var planetDescription: String {
        return "The Moon was probably made 4.5 billion years ago when a large object hit the Earth and blasted out rocks that came together to orbit round the Earth. They eventually melted together, cooled down and became the Moon. For another 500 million years pieces of rock kept striking aginst the surface of the Moon."
    }
    
    var planetImage: UIImage {
        return UIImage(named: "Moon")!
    }
    
}