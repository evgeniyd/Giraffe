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
    @IBOutlet weak var staticImageView: UIImageView!
    
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
        self.contentView.backgroundColor = UIColor.giraffeOrange()
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
        
        self.staticImageView.rac_image <~ self.viewModel!.staticImage.producer.observeOn(UIScheduler())//.takeUntil(self.rac_prepareForReuse_Signal)
        
        self.isViewDidAppear.value = true
        
        self.rac_prepareForReuse_Signal.observeNext { next in
            print("rac_prepareForReuse_Signal: \(next)")
        }
    }
}


// local
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            let pathForFile = NSBundle.mainBundle().pathForResource("01", ofType: "gif")
//            let url = NSURL.fileURLWithPath(pathForFile!)
//            let data = NSData(contentsOfURL: url)
//            let imageLocal = FLAnimatedImage.init(animatedGIFData: data)
//            dispatch_async(dispatch_get_main_queue(), {
//                self.animatedImageView.animatedImage = imageLocal
//            })
//        }

// remote
//        let image = FLAnimatedImage.init(animatedGIFData: NSData(contentsOfURL: NSURL(string: "https://media1.giphy.com/media/l46CpUy7GwBmjP8QM/200.gif")!))
//        self.animatedImageView?.animatedImage = image

