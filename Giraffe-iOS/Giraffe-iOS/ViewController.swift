//
//  ViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/3/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.blueColor()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        // remote
        let image = FLAnimatedImage.init(animatedGIFData: NSData(contentsOfURL: NSURL(string: "https://media1.giphy.com/media/l46CpUy7GwBmjP8QM/200.gif")!))
        let imageView = FLAnimatedImageView()
        imageView.animatedImage = image
        imageView.frame = CGRect(origin: CGPoint(x:0.0, y: 0.0), size: CGSize(width:  100.0, height: 100.0) )
        self.view.addSubview(imageView)
        
        // local
        let pathForFile = NSBundle.mainBundle().pathForResource("02", ofType: "gif")
        let url = NSURL.fileURLWithPath(pathForFile!)
        let data = NSData(contentsOfURL: url)
        let imageLocal = FLAnimatedImage.init(animatedGIFData: data)
        let imageViewLocal = FLAnimatedImageView()
        imageViewLocal.animatedImage = imageLocal
        imageViewLocal.frame = CGRect(origin: CGPoint(x:100.0, y: 0.0), size: CGSize(width:  100.0, height: 100.0) )
        self.view.addSubview(imageViewLocal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

