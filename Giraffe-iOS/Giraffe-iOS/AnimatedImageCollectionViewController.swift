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
    
    let rac_items = MutableProperty<[DataItem]>([])
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }
    
    // MARK: - Collection View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rac_items.value.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(animatedImageCellIdentifier, forIndexPath: indexPath)
        let animatedImageCell = cell as! AnimatedImageCell
        animatedImageCell.configureWith(self.viewModelFor(indexPath))
        return animatedImageCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let width = collectionView.bounds.width
        return CGSizeMake(width/2.0, width/2.0)
    }
    
    // MARK: - RAC binding
    
    private func setupBindings() {
        self.rac_items.producer.on (next: { _ in
            self.collectionView!.reloadData()
        }).start()
    }
    
    // MARK: - Data Helpers
    
    private func viewModelFor(indexPath: NSIndexPath) -> AnimatedImageViewModelType {
        let row = indexPath.row
        let model = self.rac_items.value[row]
        let viewModel = AnimatedImageViewModel(model: model)
        return viewModel
    }
}
