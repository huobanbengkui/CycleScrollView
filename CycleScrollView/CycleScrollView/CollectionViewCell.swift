//
//  CollectionViewCell.swift
//  CycleScrollView
//
//  Created by huobanbengkui on 2018/7/2.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var nameLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 40))
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
