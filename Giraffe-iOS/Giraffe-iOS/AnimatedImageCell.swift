//
//  AnimatedImageCell.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/9/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import FLAnimatedImage
import ReactiveCocoa
import Result

class AnimatedImageCell: UICollectionViewCell {
    
    // MARK: Outlets -
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    @IBOutlet weak var trendingIndicator: UIImageView!
    // MARK: prepareForReuse Signal -
    
    let racsignal_prepareForReuse: Signal<Void, NoError>
    let racobserver_prepareForReuse: Observer<Void, NoError>
    
    // MARK: Initialization -
    
    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        (racsignal_prepareForReuse, racobserver_prepareForReuse) = Signal<Void, NoError>.pipe()
        super.init(coder: aDecoder)
        contentView.backgroundColor = .giraffeLightGray()
    }
    
    // MARK: ViewType Protocol -
    
    private(set) var viewModel: AnimatedImageViewModel?
    
    // MARK: UICollectionReusableView overrides -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.racobserver_prepareForReuse.sendNext()
    }
    
    // MARK: Configuration -
    
    func bind(viewModel vm: AnimatedImageViewModel) {
        self.viewModel = vm
        
        self.animatedImageView.rac_animatedImage <~ self.viewModel!.image.producer.observeOn(UIScheduler()).takeUntil(self.racsignal_prepareForReuse)
        self.trendingIndicator.rac_hidden <~ self.viewModel!.shouldHideTrendingIndicator.producer.observeOn(UIScheduler()).takeUntil(self.racsignal_prepareForReuse)
        
        // ACTIVATE upon binding completes
        // DEACTIVATE loading upon prepare for reuse
        let (activeSignal, activeObserver) = Signal<Bool, NoError>.pipe()
        let inactiveSignal = self.racsignal_prepareForReuse.map { _ in false }
        self.viewModel!.isActive <~ Signal.merge([inactiveSignal,activeSignal])
        
        activeObserver.sendNext(true)
    }
}
