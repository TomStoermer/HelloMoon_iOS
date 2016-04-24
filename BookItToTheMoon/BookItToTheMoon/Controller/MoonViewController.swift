//
//  MoonViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

// TODO: - refactor planet image view to planet view with image and buttons

class MoonViewController: PlanetViewController {

    
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var planetDescriptionLabel: UILabel!
    @IBOutlet weak var factsButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!


    let moon: Moon = Moon(moonPhase: .FullMoon, moonDistance: 375_000.0, moonFacts: [])
    private var audioPlayer: AVAudioPlayer?
    private let presentVideoSegueIdentifier = "presentVideo"
    private let showPlanetFactsSegueIdentifier = "showPlanetFacts"
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        rotateFactsButton()
        rotateButtonsTowardsPlanet(buttons: [factsButton, movieButton])
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
    
    private func rotateButtonsTowardsPlanet(buttons buttons: [UIButton]) {

        // center of planet
        let planetCenter = planetImageView.center

        for button in buttons {
            
            let buttonCenter = button.center
            let angle = atan2(planetCenter.y - buttonCenter.y, planetCenter.x - buttonCenter.x)
            var rotationTransform = CGAffineTransformIdentity
            rotationTransform = CGAffineTransformMakeRotation(angle - CGFloat(M_PI_2))
            button.transform = rotationTransform
        }
    }
    
//    private func rotateFactsButton() {
//        
//        /*
//         CGFloat angle = atan2f(point2.y - point1.y, point2.x - point1.x);
//         CGAffineTransform rotationTransform = CGAffineTransformIdentity;
//         rotationTransform = CGAffineTransformMakeRotation(angle);
//         arrow.transform = rotationTransform;
//         */
//        
//        let planetCenter = planetImageView.center
//        let factsCenter = factsButton.center
//        
//        let angle = atan2(planetCenter.y - factsCenter.y, planetCenter.x - factsCenter.x)
//        var rotationTransform = CGAffineTransformIdentity
//        rotationTransform = CGAffineTransformMakeRotation(angle - CGFloat(M_PI_2))
////        rotationTransform = CGAffineTransformMakeRotation(CGFloat(M_PI_2)) // add 90 degree
//        factsButton.transform = rotationTransform
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
            
        case .Some(presentVideoSegueIdentifier):
            
            // setup player view controller
            let playerVC = segue.destinationViewController as!
            AVPlayerViewController
            playerVC.allowsPictureInPicturePlayback = false

            // stop current sound
            audioPlayer?.stop()
            
            // set the movie source
            let movieURL = NSBundle.mainBundle().URLForResource("MoonMovie", withExtension: "mp4")
            playerVC.player = AVPlayer(URL: movieURL!)
            playerVC.player?.play()
                        
        default:
            break
            
        }
        
    }

}



// MARK: - IBAction

extension MoonViewController {
    
    @IBAction func closeBarButtonItemPressed(sender: UIBarButtonItem) {
        
        // dismiss view controller
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        // stop playing sound
        self.audioPlayer?.stop()
    }
    
    @IBAction func planetFactsButtonPressed(sender: UIButton) {
        
        performSegueWithIdentifier(showPlanetFactsSegueIdentifier, sender: nil)
    }

    @IBAction func movieButtonPressed(sender: UIButton) {
        
        performSegueWithIdentifier(presentVideoSegueIdentifier, sender: nil)
    }
    
    @IBAction func poemButtonPressed(sender: UIButton) {
                
    }
    
    @IBAction func quotesButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func galleryButtonPressed(sender: UIButton) {
        
    }
}

