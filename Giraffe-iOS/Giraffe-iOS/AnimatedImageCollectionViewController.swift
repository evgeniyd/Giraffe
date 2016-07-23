//
//  AnimatedImageCollectionViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import GiraffeKit

final class AnimatedImageCollectionViewController: UICollectionViewController {
    private let animatedImageCellIdentifier = "AnimatedImageCellIdentifier"
    private var flipBackgroundPatternCounter: Int = 0
    
    let rac_items = MutableProperty<[Item]>([])
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }
    
    // MARK: - Collection View Data Source -
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rac_items.value.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(animatedImageCellIdentifier, forIndexPath: indexPath)
        let animatedImageCell = cell as! AnimatedImageCell // check agains conforming to a protocol, not a concrete type
        animatedImageCell.bind(viewModel: self.viewModelFor(indexPath))
        flipBackgroundColorFor(cell: animatedImageCell, indexPath: indexPath)
        return animatedImageCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let width = collectionView.bounds.width
        return CGSizeMake(width/2.0, width/2.0)
    }
    
    // MARK: - RAC binding -
    
    private func setupBindings() {
        self.rac_items.producer.on (next: { _ in
            self.collectionView!.reloadData()
        }).start()
    }
    
    // MARK: - Data Helpers -
    
    private func viewModelFor(indexPath: NSIndexPath) -> AnimatedImageViewModel {
        let row = indexPath.row
        let model = self.rac_items.value[row]
        let viewModel = AnimatedImageViewModel(model: model)
        return viewModel
    }
    
    // MARK: - Styling -
    
    private func flipBackgroundColorFor(cell cell: UICollectionViewCell, indexPath: NSIndexPath) {
        
        // orange(1) yellow(2)
        // yellow(3) orange(4)
        // orange(5) yellow(6)
        // yelllow(7) orange(8)
        
        var shouldFlip = false
        
        flipBackgroundPatternCounter += 1
        if flipBackgroundPatternCounter > 4 {
            flipBackgroundPatternCounter = 1
        }
        
        switch flipBackgroundPatternCounter {
        case 1, 2:
            shouldFlip = true
        case 3, 4:
            shouldFlip = false
        default:
            shouldFlip = false
        }
        
        let row = indexPath.row
        if row % 2 == 0 {
            cell.contentView.backgroundColor = shouldFlip ? UIColor.giraffeOrange() : UIColor.giraffeYellow()
        }
        else {
            cell.contentView.backgroundColor = shouldFlip ? UIColor.giraffeYellow() : UIColor.giraffeOrange()
        }
    }
}
