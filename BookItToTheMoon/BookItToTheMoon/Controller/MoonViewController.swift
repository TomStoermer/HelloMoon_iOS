//
//  MoonViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit
import AVFoundation

class MoonViewController: PlanetViewController {

    
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var planetDescriptionLabel: UILabel!

    let moon: Moon = Moon(moonPhase: .FullMoon, moonDistance: 375_000.0, moonFacts: [])
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup imageView
        planetImageView.image = moon.planetImage
        planetImageView.alpha = 0.0
        planetImageView.contentMode = .ScaleAspectFit
        
        // setup labels
        planetTitleLabel.text = moon.planetTitle
        planetTitleLabel.alpha = 0.0
        planetDescriptionLabel.text = moon.planetDescription
        planetDescriptionLabel.alpha = 0.0
        
        // perpare audio player
        if let ambientSoundFile = NSBundle.mainBundle().URLForResource("AmbientSound", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOfURL: ambientSoundFile)
            audioPlayer?.volume = 0.6
            audioPlayer?.numberOfLoops = -1
        }
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // fade in planet image
        UIView.animateWithDuration(1.0, delay: 0.0, options: [.CurveEaseInOut], animations: {
            // fade in planet
            self.planetImageView.alpha = 1.0
            }, completion: nil)
        
        // fade in title, description
        UIView.animateWithDuration(0.5, delay: 1.5, options: [.CurveEaseInOut], animations: { 
            
            // fade in planet
            self.planetTitleLabel.alpha = 1.0
            self.planetDescriptionLabel.alpha = 0.8
            
        }) { (completed: Bool) in
            
            // play sound
            if self.audioPlayer?.playing == false {
                self.audioPlayer?.play()
            }
        }
        
        // fade in details and other actions
//        animateGradientBackground()
        startPlanetRotation(planetImageView)
        
    }
    
    private func startPlanetRotation(planetImageView: UIImageView) {
        
        // check if the animation is already known
        guard planetImageView.layer.animationForKey("rotationAnimation") == nil else {
            print("rotaton Animation on planet is active.")
            return
        }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
        rotationAnimation.duration = 60
        rotationAnimation.autoreverses = false
        rotationAnimation.removedOnCompletion = false
        rotationAnimation.repeatCount = Float(CGFloat.max)
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        planetImageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func animateGradientBackground() {
        
        // set the values
        let startingLocations = [NSNumber(float: 0.0), NSNumber(float: 0.8)]
        let endingLocations = [NSNumber(float: 0.4), NSNumber(float: 1.0)]
        
        // update model layer to final point
        backgroundGradient?.locations = endingLocations
        
        // animate location
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startingLocations
        animation.duration = 5.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        backgroundGradient?.addAnimation(animation, forKey: "animateGradientLocation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK: - IBAction

extension MoonViewController {
    
    @IBAction func closeBarButtonItemPressed(sender: UIBarButtonItem) {
        
        // dismiss view controller
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        // stop playing sound
        self.audioPlayer?.stop()
    }
}
