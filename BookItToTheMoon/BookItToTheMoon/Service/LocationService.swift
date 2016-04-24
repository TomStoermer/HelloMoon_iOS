//
//  LocationService.swift
//  HelloMoon
//
//  Created by Max Winkler on 24.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
	func didUpdateHeading(heading : Double)
}

class LocationService : NSObject {
	
	var manager : CLLocationManager = CLLocationManager()
	var delegate : LocationServiceDelegate?
	
	func startLocationUpdates() {
		self.manager.delegate = self
		
		self.manager.startUpdatingHeading()
	}
	
	func stopLocationUpdates() {
		self.manager.stopUpdatingHeading()
	}
}

extension LocationService : CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		//let headingFloat = 0 - newHeading.magneticHeading;
		
		//rotateImg.transform = CGAffineTransformMakeRotation(headingFloat*radianConst);
		let value = newHeading.magneticHeading
		
		var text = ""
		
		if(value >= 0 && value < 23)
		{
			text = String(format: "%f° N",value)
		}
		else if(value >= 23 && value < 68)
		{
			text = String(format: "%f° NE",value)
		}
		else if(value >= 68 && value < 113)
		{
			text = String(format: "%f° E",value)
		}
		else if(value >= 113 && value < 185)
		{
			text = String(format:"%f° SE",value)
		}
		else if(value >= 185 && value < 203)
		{
			text = String(format: "%f° S",value)
		}
		else if(value >= 203 && value < 249)
		{
			text = String(format: "%f° SW",value)
		}
		else if(value >= 249 && value < 293)
		{
			text = String(format: "%f° W",value)
		}
		else if(value >= 293 && value < 360)
		{
			text = String(format: "%f° NW",value)
		}
		
		if let del = self.delegate {
			del.didUpdateHeading(value)
		}
	}
}