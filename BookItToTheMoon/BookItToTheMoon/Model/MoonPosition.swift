//
//  MoonPosition.swift
//  BookItToTheMoon
//
//  Created by T4m on 22/04/16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//
//  Moon postition-functions adopted from https://github.com/mourner/suncalc

import Foundation

struct MoonInfo {
	var azimuth : Double
	var altitude : Double
	var distance : Double
	var parallacticAngle : Double
}


class MoonPosition {

    let radius:Double = M_PI / 180
    var e:Double = 0
    
    let dayMs : Double = 1000.0 * 60 * 60 * 24,
        J1970 : Double = 2440588,
        J2000 : Double = 2451545
    
    init() {
        self.e = radius * 23.4397 // obliquity of the Earth
    }
	
}

private extension MoonPosition {

    func toJulian(date:NSDate) -> Double {
        return (date.timeIntervalSince1970 * 1000) / (dayMs - 0.5 + J1970)
    }
    
    func fromJulian(j:Double) -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: (j + 0.5 - J1970) * dayMs)
    }
    
    func toDays(date:NSDate) -> Double {
        return toJulian(date) - J2000
    }
	
	/// geocentric ecliptic coordinates of the moon
	func moonCoords(d:Double) -> [Double] {

		let L = radius * (218.316 + 12.176396 * d) // ecliptic longitude
		let M = radius * (134.963 + 13.064993 * d) // mean anomaly
		let F = radius * (93.272  + 13.229350 * d) // mean distance
           
		let longitudeMoon = L + radius * 6.289 * sin(M) // longitude
		let latitudeMoon = radius * 5.128 * sin(F)// latitude
		let distance = 385001 - 20905 * cos(M)    // distance to the moon in km
		
		let right_ascenation:Double = rightAscenation(longitudeMoon, be: latitudeMoon)
        let decl:Double = declination(longitudeMoon, be: latitudeMoon)
        
		let moon_coords:[Double] = [right_ascenation, decl, distance]
        
		return moon_coords

    }

    func rightAscenation(el:Double, be:Double) -> Double {
        return atan2( sin(el) * cos(e) - tan(be) * sin(e), cos(el) )
    }
    
    func declination(el : Double, be : Double) -> Double{
        return asin(sin(be) * cos(e) + cos(be) * sin(e) * sin(el) )
    }
	
    func siderealTime(d:Double, lw:Double) -> Double {
        
        return radius * (280.16 + 360.9856235 * d) - lw
    
    }
    
    func altitude(H:Double, phi:Double, dec:Double) -> Double {
        
        return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(H));
    }
    
    
    func astroRefraction(var h:Double) -> Double {
        
        if (h < 0) {
             h = 0;
        }
        
         return 0.0002967 / tan(h + 0.00312536 / (h + 0.08901179));
        
    }
    
    func azimuth(H:Double, phi:Double, dec:Double) -> Double {
    
        return atan2(sin(H), cos(H) * sin(phi) - tan(dec) * cos(phi))
    
    }
}

extension MoonPosition {
	func getMoonPosition(date:NSDate, lat:Double, lng:Double) -> MoonInfo {
		
		let lw  = radius * -lng
		let phi = radius * lat
		let d   = toDays(date)
		
		let c = moonCoords(d)
		let H = siderealTime(d, lw: lw) - c[0]
		var h = altitude(H, phi: phi, dec: c[1])
		let pa = atan2(sin(H), tan(phi) * cos(c[1]) - sin(c[1]) * cos(H))
		
		h = h + astroRefraction(h); // altitude correction for refraction
		
		let azimuthCalc : Double = azimuth(H, phi: phi, dec: c[1])
		
		let moon_position = MoonInfo(azimuth: azimuthCalc.radiansToDegrees,
			altitude: h.radiansToDegrees,
			distance: c[2],
			parallacticAngle: pa.radiansToDegrees)
		
		return moon_position
	}
}
