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
    
    // MARK: - Outlets -
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    @IBOutlet weak var trendingIndicator: UIImageView!
    // MARK: - prepareForReuse Signal -
    
    let rac_prepareForReuse_Signal: Signal<Void, NoError>
    let rac_prepareForReuse_Observer:Observer<Void, NoError>
    
    // MARK: - Initialization -
    
    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let (signal, observer) = Signal<Void, NoError>.pipe()
        rac_prepareForReuse_Signal = signal
        rac_prepareForReuse_Observer = observer
        super.init(coder: aDecoder)
        contentView.backgroundColor = .giraffeLightGray()
    }
    
    // MARK: - ViewType Protocol -
    
    private(set) var viewModel: AnimatedImageViewModel?
    
    // MARK: - UICollectionReusableView overrides -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.rac_prepareForReuse_Observer.sendNext()
    }
    
    // MARK: - Configuration -
    
    func bind(viewModel vm: AnimatedImageViewModel) {
        self.viewModel = vm
        
        self.animatedImageView.rac_animatedImage <~ self.viewModel!.image.producer.observeOn(UIScheduler()).takeUntil(self.rac_prepareForReuse_Signal)
        self.trendingIndicator.rac_hidden <~ self.viewModel!.shouldHideTrendingIndicator.producer.observeOn(UIScheduler()).takeUntil(self.rac_prepareForReuse_Signal)
        
        // START loading upon binding completes
        // FINISH loading upon prepare for reuse
        let (activeSignal, activeObserver) = Signal<Bool, NoError>.pipe()
        let inactiveSignal = self.rac_prepareForReuse_Signal.map { _ in false }
        self.viewModel!.isActive <~ Signal.merge([inactiveSignal,activeSignal])
        
        activeObserver.sendNext(true)
        
        // DEBUG:
//        self.rac_prepareForReuse_Signal.observeNext { next in
//            print("rac_prepareForReuse_Signal: \(next)")
//        }
    }
}
