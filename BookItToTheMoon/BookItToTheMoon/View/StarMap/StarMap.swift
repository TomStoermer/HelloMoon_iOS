//
//  StarMap.swift
//  BookItToTheMoon
//
//  Created by Max Winkler on 22.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import Foundation
import UIKit


class StarMap : UIScrollView {
	
	@IBInspectable
	private let someName : String = ""
	
	private let bgImageName = "ff8" //"examplecluster"
	
	var currentPos = CGPoint(x: 0, y: 0)
	var moonPosition = CGPoint(x: 0, y: 0)
	
	private var sizeOfOrgImage = CGSize(width: 0, height: 0)
	private var middleMap : UIImageView = UIImageView()
	
	
	init(frame: CGRect, startPos : CGPoint) {
		super.init(frame: frame)
		
//		self.scrollEnabled = false
//		self.setStartingPos(startPos)
		
	}

	required init?(coder aDecoder: NSCoder) {
		//fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
		
		self.createBackgroundMap(UIImage(imageLiteral: self.bgImageName))
		self.delegate = self
	}
	
	private func createBackgroundMap(image : UIImage) {
		let imageView = UIImageView(image: image)
		self.sizeOfOrgImage = imageView.frame.size
		print("Org Img Size: \(self.sizeOfOrgImage)")
		
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
		
		self.contentSize = contSize //imageView.frame.size
		print("ContentSize Size: \(self.contentSize)")
		
		self.contentOffset = CGPoint(x: contSize.width / 2, y: contSize.height / 2)
	}
	
	private func setStartingPos(start : CGPoint) {
		self.currentPos = start
	}

}

extension StarMap {
	
	func changePositon(vector2D : CGVector) {
		// factor in scaling
		self.currentPos.x += vector2D.dx
		self.currentPos.y += vector2D.dy
		self.setContentOffset(self.currentPos, animated: true)
	}
}

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
			else if boolPointPair.point.y < 0 {
				self.contentOffset.y += self.sizeOfOrgImage.height
			}
			else if boolPointPair.point.y > self.sizeOfOrgImage.height {
				self.contentOffset.y -= self.sizeOfOrgImage.height
			}
		}
	}
	
	func outOfBounds() -> (bool : Bool,point: CGPoint) {
		let posToMid = convertPoint(self.contentOffset, toView: self.middleMap)
		if posToMid.x < 0 || posToMid.y < 0 {
			return (true, posToMid)
		}
		if posToMid.x > self.sizeOfOrgImage.width || posToMid.y > self.sizeOfOrgImage.height {
			return (true , posToMid)
		}
		return (false, posToMid)
	}
	
	func currentOrgPos() -> CGPoint {
		return CGPoint(x: 0, y: 0)
	}
}