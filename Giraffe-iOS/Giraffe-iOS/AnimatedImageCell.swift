//
//  AnimatedImageCell.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/9/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import FLAnimatedImage

class AnimatedImageCell: UICollectionViewCell, ViewType {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    // MARK: - Initialization -
    
    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.backgroundColor = UIColor.giraffeOrange()
    }
    
    // MARK: - ViewType Protocol -
    
    private(set) var viewModel: AnimatedImageViewModel?
    
    func setupBindings() {
        // TODO: set isActive property of the viewModel to YES, when prepareForReuse is called
        // TODO: listen for image property from view model to know when image is downloaded
    }
    
    // MARK: - UICollectionReusableView overrides -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // some code...
    }
    
    // MARK: - Configuration -
    
    func configureWith(viewModel: AnimatedImageViewModel) {
        self.viewModel = viewModel

        // RAC 
        self.setupBindings()
        
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
    }
}
