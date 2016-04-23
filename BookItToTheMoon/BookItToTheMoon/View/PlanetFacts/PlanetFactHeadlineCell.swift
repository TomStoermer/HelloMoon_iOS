//
//  PlanetFactHeadlineCell.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

class PlanetFactHeadlineCell: UICollectionViewCell {

    
    
    @IBOutlet private weak var headlineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // cell
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        
        // label
        headlineLabel.textColor = UIColor.whiteColor()
    }

}
