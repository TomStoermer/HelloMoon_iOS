//
//  Utility.swift
//  BookItToTheMoon
//
//  Created by Max Winkler on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation

extension Double {
	var degreesToRadians: Double { return self * M_PI / 180 }
	var radiansToDegrees: Double { return self * 180 / M_PI }
}