//
//  VideoCollectionViewCell.swift
//  FirstMortgage
//
//  Created by Justin Davis on 8/27/16.
//
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    var playerView = YTPlayerView()
    var titleLabel = VideoInsetLabel()
    var descriptionLabel = VideoInsetLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var playerViewFrame = CGRect()
        
        if DeviceType.IS_IPAD {
            playerViewFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: UIScreen.mainScreen().bounds.size.height * 0.40)
        }else {
            playerViewFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height * 2/3)
        }
        playerView.frame = playerViewFrame
        titleLabel.frame = CGRect(x: 0, y: playerView.frame.size.height, width: frame.size.width, height: 30)
        titleLabel.font = UIFont(name: "forza-light", size: 16)
        titleLabel.adjustsFontSizeToFitWidth = true
       
        descriptionLabel.frame = CGRect(x: 0, y: playerView.frame.size.height + titleLabel.frame.size.height, width: frame.size.width, height: 80)
        descriptionLabel.font = UIFont(name: "forza-light", size: 12)
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.adjustsFontSizeToFitWidth = true
        addSubview(playerView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
