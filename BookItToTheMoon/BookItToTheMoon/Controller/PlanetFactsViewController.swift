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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundView = nil
        collectionView.backgroundColor = UIColor.clearColor()
        
        // flow layout
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 300, height: 80)
        }
        
        // register cells
        let factHeadlineNib = UINib(nibName: "PlanetFactHeadlineCell", bundle: nil)
        let factReasonNib = UINib(nibName: "PlanetFactReasonCell", bundle: nil)
        collectionView.registerNib(factHeadlineNib, forCellWithReuseIdentifier: "FactHeadlineCell")
        collectionView.registerNib(factReasonNib, forCellWithReuseIdentifier: "FactReasonCell")
        
        // prepare data source
        JSONRequester.requestMoonFacts { (moonFacts, error) in
            self.facts = moonFacts!
        }
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // setup estimated size
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: CGRectGetWidth(collectionView.frame), height: 80)
//            flowLayout.invalidateLayout()
//        }
//    }
    
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
//        let factAtSection = facts[section]
//        return selectedFacts.contains(factAtSection) ? 2 : 1
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell!
        
        switch Item(rawValue: indexPath.item)! {
        case .FactHeadline:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("FactHeadlineCell", forIndexPath: indexPath)
            configureFactHeadlineCell(cell as! PlanetFactHeadlineCell, atIndexPath: indexPath)
            
        case .FactReason:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("FactReasonCell", forIndexPath: indexPath)
            configureFactReasonCell(cell as! PlanetFactReasonCell, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    private func configureFactHeadlineCell(cell: PlanetFactHeadlineCell, atIndexPath indexPath: NSIndexPath) {
        
        let planetFact = facts[indexPath.section]
        cell.configureFactHeadline(planetFact.factHeadline)
        
    }
    
    private func configureFactReasonCell(cell: PlanetFactReasonCell, atIndexPath indexPath: NSIndexPath) {
        
        let planetFact = facts[indexPath.section]
        cell.configureFactReason(planetFact.factReason)
    }
    
}



// MARK: - 

extension PlanetFactsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        guard Item(rawValue: indexPath.item)! == Item.FactHeadline else {
//            return
//        }
//        
//        let fact = facts[indexPath.section]
//        switch selectedFacts.contains(fact) {
//        case true:
//            // remove item
//            selectedFacts.remove(fact)
//            
//            // delete animation
//            let deleteIndexPath = NSIndexPath(forItem: Item.FactReason.rawValue, inSection: indexPath.section)
//            collectionView.deleteItemsAtIndexPaths([deleteIndexPath])
//            
//        case false:
//            // add item
//            selectedFacts.insert(fact)
//            
//            // insert animation
//            let insertIndexPath = NSIndexPath(forItem: Item.FactReason.rawValue, inSection: indexPath.section)
//            collectionView.insertItemsAtIndexPaths([insertIndexPath])
//        }
        
    }
    
}



// MARK: - 

extension PlanetFactsViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        return CGSize(width: CGRectGetWidth(collectionView.frame), height: 180)
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame), height: 80)
    }
    
}
