//
//  FactsViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

// TODO: - 1. Facts anzeigen
// TODO: - 2. Interaktion um Reason anzuzeigen (Set speichern)
// TODO: - 3. physics !


class MoonFactsViewController: PlanetViewController {

    
    
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    var facts = [PlanetFact]()
    private var selectedFacts = Set<PlanetFact>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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



// MARK: - 

extension FactsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return facts.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
}
