//
//  videoModel.swift
//  FirstMortgage
//
//  Created by Justin Davis on 2/16/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import Foundation


class videoModel {
    
    //Object properites are not directly accessable
    private var _title: String!
    private var _description: String!
    private var _youtubeID: String!
    

    var title: String {
        return _title
    }
    
    var description: String {
        return _description
    }
    
    var videoYoutubeID: String {
        return _youtubeID
    }
    
    init(videoTitle: String, description: String, youtubeID: String){
        _title = videoTitle
        _description = description
        _youtubeID = youtubeID
        
    }
}