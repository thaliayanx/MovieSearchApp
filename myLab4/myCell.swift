//
//  myCell.swift
//  myLab4
//
//  Created by thalia on 10/13/16.
//  Copyright © 2016 thalia. All rights reserved.
//

import UIKit

class myCell: UICollectionViewCell {
    var textLabel: UILabel!
    var imageView: UIImageView!
     override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        textLabel = UILabel(frame:  CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height/3))
        super.init(frame: frame)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
