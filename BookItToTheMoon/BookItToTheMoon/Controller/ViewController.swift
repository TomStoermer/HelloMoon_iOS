//
//  ViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 22.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var starMap: StarMap!
    // IMPORTANT: An app should create only a single instance of the CMMotionManager class
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.gyroUpdateInterval = 1/60
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startDeviceGyro()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



// MARK: - CMMotionManager

extension ViewController {
    
    func startDeviceMotion() {
        
        guard motionManager.deviceMotionAvailable == true else {
            print("WARNING: Device Motion is not available.")
            return
        }
        
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak self](deviceMotion: CMDeviceMotion?, error: NSError?) in
            
            guard let deviceMotion = deviceMotion else {
                return
            }
			
            print(deviceMotion.attitude)
            
            
            
        }
        
    }
    
    func startDeviceGyro() {
        
        let motionMovingRate = CGFloat(4)
        
        guard motionManager.deviceMotionAvailable == true else {
            print("WARNING: Device Motion is not available.")
            return
        }
        
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak self](gyroData: CMGyroData?, error: NSError?) in
            
            guard let gyroData = gyroData else {
                return
            }
            
            guard self != nil else {
                return
            }
            
            if fabs(gyroData.rotationRate.y) >= 0.1 {
                
//                let targetX = self!.starMap.contentOffset.x - CGFloat(gyroData.rotationRate.y) * motionMovingRate
//                let targetY = self!.starMap.contentOffset.y - CGFloat(gyroData.rotationRate.x) * motionMovingRate
//                self!.starMap.contentOffset = CGPoint(x: targetX, y: targetY)
				
				let dx = -CGFloat(gyroData.rotationRate.y) * motionMovingRate
				let dy = -CGFloat(gyroData.rotationRate.x) * motionMovingRate
				self!.starMap.changePositon(CGVector(dx: dx, dy: dy))
                
            }
        }
        
    }
    
}
