//
//  AnimatedImageCollectionViewController.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/8/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit

class AnimatedImageCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.registerClass(AnimatedImageCell.self, forCellWithReuseIdentifier:"AnimatedImageCell")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnimatedImageCell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.blackColor()
        return cell
    }
}
