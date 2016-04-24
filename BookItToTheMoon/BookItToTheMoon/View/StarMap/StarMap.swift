//
//  StarMap.swift
//  BookItToTheMoon
//
//  Created by Max Winkler on 22.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion


class StarMap : UIScrollView {
	
	@IBInspectable
	private var imageFromSB : UIImage?
	
	private let bgImageName = "degree" //"examplecluster"
	
	var currentPos = CGPoint(x: 0, y: 0)
	var moonPosition = CGPoint(x: 0, y: 0)
	var middelContentOffset = CGPoint(x: 0, y: 0)
	var globeHalf : Double = 0
	
	private var sizeOfOrgImage = CGSize(width: 0, height: 0)
	private var middleMap : UIImageView = UIImageView()
	
	private var jitterBuffer : Double = 0
	private var yawBuffer : Double = 0

	required init?(coder aDecoder: NSCoder) {
		//fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
		
		if let image = imageFromSB {
			self.createBackgroundMap(image)
		}
		else {
			self.createBackgroundMap(UIImage(imageLiteral: self.bgImageName))
		}
		
		self.delegate = self
		
		//print("did inti: Middle: \(self.middleMap)")
	}
	
	private func createBackgroundMap(image : UIImage) {
		let imageView = UIImageView(image: image)
		self.sizeOfOrgImage = imageView.frame.size
		//print("Org Img Size: \(self.sizeOfOrgImage)")
		
		let contSize = CGSize(width: self.sizeOfOrgImage.width * 3, height: self.sizeOfOrgImage.height * 3)
		
		var xPos : CGFloat = 0
		var yPos : CGFloat = -self.sizeOfOrgImage.height
		
		for i in 0..<9 {
			if i % 3 == 0 {
				yPos += self.sizeOfOrgImage.height
				xPos = 0
			}
			
			let newImageView = UIImageView(image: image)
			newImageView.frame.origin = CGPoint(x: xPos, y: yPos)
			self.addSubview(newImageView)
			
			if i == 4 {
				self.middleMap = newImageView
			}
			
			xPos += self.sizeOfOrgImage.width
			print("Added frame: \(newImageView.frame) - \(i % 3)")
		}
		
		self.contentSize = contSize
		
		let screenBounds = UIScreen.mainScreen().bounds
		let middleCenter = self.convertPoint(self.middleMap.center, fromView: self.middleMap)
		self.middelContentOffset = CGPoint(x: middleCenter.x  - screenBounds.width / 2 , y: middleCenter.y - screenBounds.height / 2)
		self.contentOffset = self.middelContentOffset
	}

}

// MARK: - Public Domain

extension StarMap {
	
	func changePositon(vector2D : CGVector) {
		// factor in scaling
		self.currentPos.x += vector2D.dx
		self.currentPos.y += vector2D.dy
		self.setContentOffset(self.currentPos, animated: true)
	}
}


// MARK: - ScrollViewDelegate

extension StarMap : UIScrollViewDelegate {
	// probably not needed
	// maybe doch, because of the reset of the position
	// 9 pictures  (half on the edges)
	// when overriding edges -> reset to normalized position
	// add scaling -
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		self.resetToOriginalMap()
	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		self.resetToOriginalMap()
	}
}

private extension StarMap {
	/// reset the position to some point on the original map, if necessary
	func resetToOriginalMap() {
		let boolPointPair = self.outOfBounds()
		if boolPointPair.bool {
			if boolPointPair.point.x < 0 {
				self.contentOffset.x += self.sizeOfOrgImage.width
			}
			else if boolPointPair.point.x > self.sizeOfOrgImage.width {
				self.contentOffset.x -= self.sizeOfOrgImage.width
			}
			
			if boolPointPair.point.y < 0 {
				self.contentOffset.y += self.sizeOfOrgImage.height
			}
			else if boolPointPair.point.y > self.sizeOfOrgImage.height {
				self.contentOffset.y -= self.sizeOfOrgImage.height
			}
		}
	}
	
	func outOfBounds() -> (bool : Bool,point: CGPoint) {
		let posToMid = self.convertPoint(self.contentOffset, toView: self.middleMap)
		if posToMid.x < 0 || posToMid.y < 0 {
			return (true, posToMid)
		}
		if posToMid.x > self.sizeOfOrgImage.width || posToMid.y > self.sizeOfOrgImage.height {
			return (true , posToMid)
		}
		return (false, posToMid)
	}
}


extension StarMap {
	
	// We Assume that South == 0/0
	// x -> pos change -> tilting phone upwards
	// y -> pos change -> rotate phone left
	// z -> pos change -> tilting phone left
	
	func calcMovementFromGyro(rotationRate : CMRotationRate) {
		let vec = CGVector(dx: rotationAmount(rotationRate.x, horizontal: true), dy: rotationAmount(rotationRate.y, horizontal: false))
		
		self.changePositon(vec)
        self.resetToOriginalMap()
	}
	
	func calcMovementFromHeading(heading : Double) {
//		let direction = (heading - 180.0) * (-1.0)
//		let percent = 1.0 - (direction / 180)
		let percent = (heading / 360)
		self.contentOffset.x = self.middelContentOffset.x + sizeOfOrgImage.width * CGFloat(percent)
		
		self.resetToOriginalMap()
	}
	
	func calcMovementFromAttitude(attitude : CMAttitude) {
		
		let yaw = attitude.yaw
		
		let fullAngle = 180.0
		let angle = yaw.radiansToDegrees
		let percent = abs(angle / fullAngle)
		
		if self.globeHalf > 0 {
			let newPos = self.sizeOfOrgImage.width / 2.0 * CGFloat(percent)
			self.contentOffset.x = self.middelContentOffset.x + newPos * (angle < 0 ? 1 : -1) - sizeOfOrgImage.width
		}
		else if self.globeHalf < 0 {
			let newPos = self.middelContentOffset.x / 2.0 * CGFloat((1-percent))
			self.contentOffset.x = self.middelContentOffset.x + newPos * (angle < 0 ? -1 : 1) - sizeOfOrgImage.width
		}
	}
	
	func yawDidChangeSign() -> Bool {
		return false
	}
	
	func calcMovementFromAccel(accelRate : CMAcceleration) {
		self.contentOffset.y = self.middelContentOffset.y - (self.sizeOfOrgImage.height / 2) * CGFloat(accelRate.z) - self.sizeOfOrgImage.height
		self.globeHalf = accelRate.z
	}
	
	private func rotationAmount(rotation : Double, horizontal: Bool) -> Double {
		let degrees = rotation.radiansToDegrees
		if horizontal {
			return (180.0 / 100.0 * degrees) * Double(self.sizeOfOrgImage.width)
		}
		else {
			return (90.0 / 100.0 * degrees) * Double(self.sizeOfOrgImage.height)
		}
	}
	
}
