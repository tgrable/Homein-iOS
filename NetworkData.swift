//
//  NetworkData.swift
//  FMCVideo
//
//  Created by Justin Davis on 8/25/16.
//  Copyright © 2016 Justin Davis. All rights reserved.
//

import Foundation

protocol NetworkDataDelegate: class {
    func videoDataLoaded(withThisArray: NSMutableArray)
    func videoDataNotLoaded()
}

class NetworkData {
    static let instance = NetworkData()
    
    weak var delegate: NetworkDataDelegate?
    
    let youtubeURL = "https://www.youtube.com/watch?v="
    let errorMessage = "This device currently has no internet connection. An internet connection is required to view videos."
    //    let JSONurlString = "http://dev-fmc-cunningham.pantheon.io/app-video-json" /* This one is FOR TESTING ONLY */
    let JSONurlString = "https://www.firstmortgageco.com/app-video-json"  /* This one is REAL*/
//    let JSONurlString = "https://www.badurl.org" /* This URL is bad on purpose */
    

    var videoArray: NSMutableArray = []
    
    func downloadVideoData(){
        print("Network data called")
        guard let videoURLData = NSURL( string: JSONurlString) else{
            print ("JSON Data not available")
            return
        }
        videoArray.removeAllObjects()
        if let videoJSONData = NSData(contentsOfURL: videoURLData) {
            let readableJSON = JSON(data: videoJSONData, options: .MutableContainers, error: nil)
//            print(readableJSON)
            for i in 0...readableJSON.count - 1 {
                let results = readableJSON[i]
                let titleInstance = results["title"].stringValue
                let descriptionInstance = results["description"].stringValue
                let youtubeIDInstance = results["id"].stringValue
                let newVideo = videoModel(videoTitle: titleInstance, description: descriptionInstance, youtubeID: youtubeIDInstance)
                videoArray.addObject(newVideo)
            }
            delegate?.videoDataLoaded(videoArray)
        }else{
            delegate?.videoDataNotLoaded()
            
        }
        
        
    }
    
    
    
}