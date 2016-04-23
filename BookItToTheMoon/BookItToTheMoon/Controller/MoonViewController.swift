//
//  MoonViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

class MoonViewController: PlanetViewController {

    
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var planetTitleLabel: UILabel!
    @IBOutlet weak var planetDescriptionLabel: UILabel!

    let moon: Moon = Moon(moonPhase: .FullMoon, moonDistance: 375_000.0, moonFacts: [])
    
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
            }, completion: nil)
        
        // fade in details and other actions
        
        animateGradientBackground()
        
        // request facts
        JSONRequester.requestMoonFacts { (moonFacts, error) in
            print(moonFacts)
        }
        
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
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
