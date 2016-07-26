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
    
    let rac_itemViewModels = MutableProperty<[AnimatedImageViewModel]>([])
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }
    
    // MARK: - Collection View Data Source -
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rac_itemViewModels.value.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(animatedImageCellIdentifier, forIndexPath: indexPath)
        let animatedImageCell = cell as! AnimatedImageCell // check agains conforming to a protocol, not a concrete type
        animatedImageCell.bind(viewModel: self.rac_itemViewModels.value[indexPath.row])
        return animatedImageCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let minSpaceForCells: CGFloat = 1.0
        let width = collectionView.bounds.width - minSpaceForCells
        return CGSizeMake(width/2.0, width/2.0)
    }
    
    // MARK: - RAC binding -
    
    private func setupBindings() {
        self.rac_itemViewModels.producer
            .observeOn(UIScheduler())
            .on (next: { _ in
                self.collectionView!.reloadData()
            })
            .start()
    }
}
