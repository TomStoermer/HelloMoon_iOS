//
//  Planet.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit


/// Describes the basic properties of a planet.
protocol Planet {
    
    var planetName: String {get}
    var planetTitle: String {get}
    var planetDescription: String {get}
    var planetImage: UIImage {get}
    
}


