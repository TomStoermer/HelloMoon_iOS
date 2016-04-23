//
//  ViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 22.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit
import CoreMotion
import GLKit

class ViewController: UIViewController {
    
    @IBOutlet weak var starMap: StarMap!
    @IBOutlet weak var rollValueLabel: UILabel!
    @IBOutlet weak var pitchValueLabel: UILabel!
    @IBOutlet weak var yawValueLabel: UILabel!
    
    @IBOutlet weak var moonElevationAngleLabel: UILabel!
    @IBOutlet weak var moonHorizontalAngleLabel: UILabel!
    
    let presentPlanetSegueIdentifier = "presentPlanet"


    // IMPORTANT: An app should create only a single instance of the CMMotionManager class
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.deviceMotionUpdateInterval = 1/40
        motionManager.gyroUpdateInterval = 1/60
        // Do any additional setup after loading the view, typically from a nib.
		
		
		// moon Test:
		let moonCalc = MoonPosition().getMoonPosition(NSDate(timeIntervalSinceNow: 0), lat: 51.333533, lng: 12.373037)
		print(moonCalc)
		
        // update moon label
        moonElevationAngleLabel.text = "Moon Elevation \(moonCalc.altitude.format(".2")) °"
        moonHorizontalAngleLabel.text = "Moon Horizontal \(moonCalc.azimuth.format(".2")) °"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startDeviceMotion()
//        startDeviceGyro()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopGyroUpdates()
        
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
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(.XMagneticNorthZVertical, toQueue: NSOperationQueue.mainQueue()) { [weak self](deviceMotion: CMDeviceMotion?, error: NSError?) in
            
            guard let deviceMotion = deviceMotion else {
                return
            }
			
            print("Attitude: - \(deviceMotion.attitude)")
            
			//print(deviceMotion.rotationRate)
            
            // update labels
			let chioce = 3
			
			switch (chioce) {
				
			case 1:
				self?.pitchValueLabel.text = "X: \(deviceMotion.rotationRate.x.format(".5")) °"
				self?.yawValueLabel.text = "Y: \(deviceMotion.rotationRate.y.format(".5")) °"
				self?.rollValueLabel.text = "Z: \(deviceMotion.rotationRate.z.format(".5")) °"
			
			case 2:
				self?.pitchValueLabel.text = "X: \(deviceMotion.gravity.x.format(".5"))"
				self?.yawValueLabel.text = "Y: \(deviceMotion.gravity.y.format(".5"))"
				self?.rollValueLabel.text = "Z: \(deviceMotion.gravity.z.format(".5"))"
			
			case 3:
				self?.pitchValueLabel.text = "X: \(deviceMotion.attitude.pitch.radiansToDegrees.format(".5")) °"
				self?.yawValueLabel.text = "Y: \(deviceMotion.attitude.roll.radiansToDegrees.format(".5")) °"
				self?.rollValueLabel.text = "Z: \(deviceMotion.attitude.yaw.radiansToDegrees.format(".5")) °"
				
			default:
				break
			}
			
			self?.starMap.calcMovementFromAccel(deviceMotion.gravity)
            
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
            
            // debug with labels
            self!.debugDeviceRotationWithGyroData(gyroData)
            
//            if fabs(gyroData.rotationRate.y) >= 0.1 {
//                
//                let targetX = self!.starMap.contentOffset.x - CGFloat(gyroData.rotationRate.y) * motionMovingRate
//                let targetY = self!.starMap.contentOffset.y - CGFloat(gyroData.rotationRate.x) * motionMovingRate
//                self!.starMap.contentOffset = CGPoint(x: targetX, y: targetY)
//				
//				let dx = -CGFloat(gyroData.rotationRate.y) * motionMovingRate
//				let dy = -CGFloat(gyroData.rotationRate.x) * motionMovingRate
//				self!.starMap.changePositon(CGVector(dx: dx, dy: dy))
//            }
			
			self?.starMap.calcMovementFromGyro(gyroData.rotationRate)
        }
    }
    
    private func debugDeviceRotationWithGyroData(gyroData: CMGyroData) {
        
        // update labels
        self.pitchValueLabel.text = "X: \(ceil((gyroData.rotationRate.x * 180.0 / M_PI)).format(".5")) °"
        self.yawValueLabel.text = "Y: \(ceil((gyroData.rotationRate.y * 180.0 / M_PI)).format(".5")) °"
        self.rollValueLabel.text = "Z: \(ceil((gyroData.rotationRate.z * 180.0 / M_PI)).format(".5")) °"
        
    }
    
}




// MARK: - GLKit Calculations

extension ViewController {
    
//    func calculate(view: UIView, attitude: CMAttitude) {
//        
//        // aspect
//        let aspect  = fabs(CGRectGetWidth(view.frame) / CGRectGetHeight(view.frame))
//        
//        // projection matrix
//        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0), Float(aspect), 0.1, 100.0)
//        let rotationMatrix = attitude.rotationMatrix
//        
//        //
//        let camFromIMU = GLKMatrix4Make(Float(rotationMatrix.m11), Float(rotationMatrix.m12), Float(rotationMatrix.m13), 0,
//                                        Float(rotationMatrix.m21), Float(rotationMatrix.m22), Float(rotationMatrix.m23), 0,
//                                        Float(rotationMatrix.m31), Float(rotationMatrix.m32), Float(rotationMatrix.m33), 0,
//                                        0,     0,     0,     1);
//        
//        let viewFromCam = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, 0)
//        let imuFromModel = GLKMatrix4Identity
//        let viewModel = GLKMatrix4Multiply(imuFromModel, GLKMatrix4Multiply(camFromIMU, viewFromCam))
//        
//        var isInvertible: Bool = true
//        let modelView = GLKMatrix4Invert(viewModel, &isInvertible)
//        
//        // view port
//        var viewport = UnsafeBufferPointer(start: <#T##UnsafePointer<Element>#>, count: <#T##Int#>)
//        
//        
//        var success: Bool = false
//        // center of the view
//        let vector3 = GLKVector3Make(Float(CGRectGetMidX(view.frame)), Float(CGRectGetMidY(view.frame)), 1.0)
//        let calculatedPoint = GLKMathUnproject(vector3, modelView, projectionMatrix, Int32(123), &success)
//        
//        
//    }
    
}




// MARK: - IBActions 

extension ViewController {
    
    @IBAction func presentPlanetButtonPressed(sender: UIButton) {
        
        performSegueWithIdentifier(presentPlanetSegueIdentifier, sender: nil)
    }
    
}
