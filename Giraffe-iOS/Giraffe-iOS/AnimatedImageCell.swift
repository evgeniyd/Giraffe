//
//  AnimatedImageCell.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/9/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import FLAnimatedImage

class AnimatedImageCell: UICollectionViewCell {
    
    private func testGIFsAnimation() {
        
        // remote
        let image = FLAnimatedImage.init(animatedGIFData: NSData(contentsOfURL: NSURL(string: "https://media1.giphy.com/media/l46CpUy7GwBmjP8QM/200.gif")!))
        let imageView = FLAnimatedImageView()
        imageView.animatedImage = image
        imageView.frame = CGRect(origin: CGPoint(x:0.0, y: 0.0), size: CGSize(width: contentView.bounds.width, height: contentView.bounds.height) )
        self.contentView.addSubview(imageView)
        
        // local
//        let pathForFile = NSBundle.mainBundle().pathForResource("02", ofType: "gif")
//        let url = NSURL.fileURLWithPath(pathForFile!)
//        let data = NSData(contentsOfURL: url)
//        let imageLocal = FLAnimatedImage.init(animatedGIFData: data)
//        let imageViewLocal = FLAnimatedImageView()
//        imageViewLocal.animatedImage = imageLocal
//        imageViewLocal.frame = CGRect(origin: CGPoint(x:100.0, y: 0.0), size: CGSize(width:  100.0, height: 100.0) )
//        self.contentView.addSubview(imageViewLocal)
    }
    
}
