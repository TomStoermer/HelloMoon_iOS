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
	
	var currentPos = CGPoint(x: 0, y: 0)
	var moonPosition = CGPoint(x: 0, y: 0)
	
	
	init(frame: CGRect, startPos : CGPoint) {
		super.init(frame: frame)
		
//		self.scrollEnabled = false
//		self.setStartingPos(startPos)
		
	}

	required init?(coder aDecoder: NSCoder) {
		//fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
		
		let imageView = UIImageView(image: UIImage(imageLiteral: "examplecluster"))
		self.addSubview(imageView)
		self.contentSize = imageView.frame.size
		self.contentOffset = CGPoint(x: imageView.frame.size.width / 2, y: imageView.frame.size.height / 2)
		
		self.delegate = self
	}
    
	func setStartingPos(start : CGPoint) {
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
		if self.outOfBounds() {
			self.contentOffset = currentOrgPos()
		}
	}
	
	func outOfBounds() -> Bool {
		return false
	}
	
	func currentOrgPos() -> CGPoint {
		return CGPoint(x: 0, y: 0)
	}
}