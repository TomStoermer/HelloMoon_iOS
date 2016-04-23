//
//  FactsViewController.swift
//  BookItToTheMoon
//
//  Created by Tom Störmer on 23.04.16.
//  Copyright © 2016 SpaceAppsChallenge. All rights reserved.
//

import UIKit

// TODO: - 1. Facts anzeigen
// TODO: - 1.1 Facts Cells
// TODO: - 1.2 Self sizing collection view cells
// TODO: - 2. Interaktion um Reason anzuzeigen (Set speichern)
// TODO: - 3. physics !


class PlanetFactsViewController: PlanetViewController {

    
    
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    var facts = [PlanetFact]()
    private var selectedFacts = Set<PlanetFact>()
    
    
    // MARK: - CollectionView Enums
    private enum Item: Int {
        case FactHeadline = 0
        case FactReason
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup collectionView
        collectionView.backgroundView = nil
        collectionView.backgroundColor = UIColor.clearColor()

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

extension PlanetFactsViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return facts.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // one row if fact is not selected, two rows if fact is selected
        let factAtSection = facts[section]
        return selectedFacts.contains(factAtSection) ? 2 : 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell!
        
        switch Item(rawValue: indexPath.item)! {
        case .FactHeadline:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            configureFactHeadlineCell(cell, atIndexPath: indexPath)
            
        case .FactReason:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            configureFactReasonCell(cell, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    private func configureFactHeadlineCell(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    private func configureFactReasonCell(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        
    }
    
}
