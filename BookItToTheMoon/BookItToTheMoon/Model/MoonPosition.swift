//
//  MoonPosition.swift
//  BookItToTheMoon
//
//  Created by T4m on 22/04/16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//
//  Moon postition-functions adopted from https://github.com/mourner/suncalc

import Foundation


class MoonPosition {

    var radius:Double = M_PI / 180
    var e:Double = 0
    
    let dayMs : Double = 1000.0 * 60 * 60 * 24,
        J1970 : Double = 2440588,
        J2000 : Double = 2451545
    
    init() {
        self.e = radius * 23.4397 // obliquity of the Earth
    }
    
    func toJulian(date:NSDate) -> Double {
        return (date.timeIntervalSince1970 * 1000) / (dayMs - 0.5 + J1970)
    }
    
    func fromJulian(j:Double) -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: (j + 0.5 - J1970) * dayMs)
    }
    
    func toDays(date:NSDate) -> Double {
        return toJulian(date) - J2000
    }
    
    func moonCoords(d:Double) -> Array<Double>{

       let L = radius * (218.316 + 12.176396 * d), // ecliptic longitude
           M = radius * (134.963 + 13.064993 * d), // mean anomaly
           F = radius * (93.272  + 13.229350 * d), // mean distance
           
           l = L + radius * 6.289 * sin(M), // longitude
           b = radius * 5.128 * sin(F),     // latitude
           dt = 385001 - 20905 * cos(M);    // distance to the moon in km
        
           let right_ascenation:Double = rightAscenation(l, be: b)
           let decl:Double = declination(l, be:b)
        
           let moon_coords:[Double] = [right_ascenation, decl, dt]
        
           return moon_coords

    }

    func rightAscenation(el:Double, be:Double) -> Double{
        return atan2( sin(el) * cos(e) - tan(be) * sin(e), cos(el) )
    }
    
    func declination(el:Double, be:Double) -> Double{
        return asin(sin(be) * cos(e) + cos(be) * sin(e) * sin(el) )
    }
    
    func getMoonPosition(date:NSDate, lat:Double, lng:Double) -> Array<Double> {
    
         var lw  = radius * -lng,
             phi = radius * lat,
             d   = toDays(date),
    
             c = moonCoords(d),
             H = siderealTime(d, lw: lw) - c[1],
             h = altitude(H, phi: phi, dec: c[2]),
             pa = atan2(sin(H), tan(phi) * cos(c[2]) - sin(c[2]) * cos(H))
    
        h = h + astroRefraction(h); // altitude correction for refraction
    
        let azimuthCalc : Double = azimuth(H, phi: phi, dec: c[2])
        
        let moon_position : [Double] = [azimuthCalc, h, c[3], pa]
        
         return moon_position
        
         //return {
         //    azimuth: azimuth(H, phi, c.dec),
         //    altitude: h,
         //    distance: c.dist,
         //    parallacticAngle: pa
         //}
     }
    
    func siderealTime(d:Double, lw:Double) -> Double{
        
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