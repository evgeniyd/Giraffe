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
    
    // MARK: - prepareForReuse Signal -
    
    let rac_prepareForReuse_Signal: Signal<Void, NoError>
    let rac_prepareForReuse_Observer:Observer<Void, NoError>
    
    let isViewDidAppear = MutableProperty<Bool>(false)
    
    // MARK: - Initialization -
    
    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let (signal, observer) = Signal<Void, NoError>.pipe()
        rac_prepareForReuse_Signal = signal
        rac_prepareForReuse_Observer = observer
        
        super.init(coder: aDecoder)
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
        
        self.viewModel!.isActive <~ self.isViewDidAppear
        
        // do we need .takeUntil(self.rac_prepareForReuse_Signal) ?
        self.animatedImageView.rac_animatedImage <~ self.viewModel!.image.producer.observeOn(UIScheduler())
        
        self.isViewDidAppear.value = true
        
        self.rac_prepareForReuse_Signal.observeNext { next in
            print("rac_prepareForReuse_Signal: \(next)")
        }
    }
}
