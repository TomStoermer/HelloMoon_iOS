//
//  PlanetFactReasonCell.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

class PlanetFactReasonCell: BaseCollectionViewCell {

    @IBOutlet private weak var factReasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // label
        factReasonLabel.textColor = UIColor.whiteColor()
    }
    
    func configureFactReason(factReason: String) {
        factReasonLabel.text = factReason
    }

}
