//
//  FlowLayout.swift
//  CycleScrollView
//
//  Created by huobanbengkui on 2018/7/4.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
// 此处有Bug
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arrayAttrs = NSArray(array: super.layoutAttributesForElements(in: rect)!, copyItems: true)
        let centerX = (collectionView?.contentOffset.x)! + (collectionView?.bounds.size.width)! * 0.5
        for arrt in arrayAttrs {
            let distance = abs((arrt as AnyObject).center.x - centerX)
            let factor: CGFloat = 0.01
            let scale = 1 / (1 + distance * factor)
            (arrt as! UICollectionViewLayoutAttributes).transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return arrayAttrs as? [UICollectionViewLayoutAttributes]
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
