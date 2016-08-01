//
//  AnimatedImageCollectionViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import GiraffeKit

final class AnimatedImageCollectionViewController: UICollectionViewController {
    private let animatedImageCellIdentifier = "AnimatedImageCellIdentifier"
    private let racobserver_didScrollToBottom: Observer<Void, NoError>
    private let distanceToReportDidScrollToBottom: CGFloat = 10.0
    
    let rac_itemViewModels = MutableProperty<[AnimatedImageViewModel]>([])
    let racsignal_didScrollToBottom: Signal<Void, NoError>
    
    // MARK: Initializer -
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        (racsignal_didScrollToBottom, racobserver_didScrollToBottom) = Signal<Void, NoError>.pipe()
        super.init(collectionViewLayout: layout)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        (racsignal_didScrollToBottom, racobserver_didScrollToBottom) = Signal<Void, NoError>.pipe()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        (racsignal_didScrollToBottom, racobserver_didScrollToBottom) = Signal<Void, NoError>.pipe()
        super.init(coder: aDecoder)
    }
    
    // MARK: View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }
    
    // MARK: Collection View Data Source -
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rac_itemViewModels.value.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(animatedImageCellIdentifier, forIndexPath: indexPath)
        let animatedImageCell = cell as! AnimatedImageCell // check agains conforming to a protocol, not a concrete type
        animatedImageCell.bind(viewModel: self.rac_itemViewModels.value[indexPath.row])
        return animatedImageCell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout -
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let minSpaceForCells: CGFloat = 1.0
        let width = collectionView.bounds.width - minSpaceForCells
        return CGSizeMake(width/2.0, width/2.0)
    }
    
    // MARK: RAC binding -
    
    private func setupBindings() {
        // ???: do we need some timeout, so reloadData is not called in the same run loop?
        self.rac_itemViewModels.producer
            .observeOn(UIScheduler())
            .on (next: { _ in
                self.collectionView!.reloadData()
            })
            .start()
    }
    
    // MARK: UIScrollViewDelegate - 
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y: CGFloat = offset.y + bounds.size.height - inset.bottom
        let h: CGFloat = size.height
        
        if (offset.y > 0.0 && y > h + distanceToReportDidScrollToBottom) {
            racobserver_didScrollToBottom.sendNext()
        }
    }
}
