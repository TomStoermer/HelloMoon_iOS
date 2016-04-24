//
//  PlanetDetailViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

class PlanetViewController: UIViewController {

    
    
    // MARK: - Properties
    weak var backgroundGradient: CAGradientLayer?
    private var topGradientColor: CGColor {
        return UIColor(colorLiteralRed: 60.0/255.0, green: 56.0/255.0, blue: 88.0/255.0, alpha: 1.0).CGColor
    }
    private var bottomGradientColor: CGColor {
        return UIColor(colorLiteralRed: 141.0/255.0, green: 105.0/255.0, blue: 136.0/255.0, alpha: 1.0).CGColor
    }
    
    
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare gradient 
        let gradient = CAGradientLayer()
        gradient.colors = [topGradientColor, bottomGradientColor]
        gradient.locations = [0.2, 0.9]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)

        // insert gradient
        backgroundGradient = gradient
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        // update gradient frame
        backgroundGradient?.frame = view.frame
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


// MARK: - Status Bar

extension PlanetViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Slide
    }
    
}
