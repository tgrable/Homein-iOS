//
//  ViewController.swift
//  FMCVideo
//
//  Created by Justin Davis on 8/25/16.
//  Copyright © 2016 Justin Davis. All rights reserved.
//

import UIKit
import Answers
import Crashlytics

class VideosViewController: UIViewController, NetworkDataDelegate {
    
    // Network and Model objects
    let ND: NetworkData = NetworkData.instance
    let model = Model()
    let reachability = Reachability()
    
    // Strings
    var titleLabel = "HELPFUL VIDEOS"
    let errorMessage = "This device currently has no internet connection. An internet connection is required to view videos."
    let appName = "HomeIn"

    // Video Data
    var videoData: NSMutableArray = []
    var currentVideos: NSMutableArray = []
    
    // Collection View Objects
    var collectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    
    //NSActivityIndicator
    var spinner = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUserInterface()
        showActivityIndicator()
        ND.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if (reachability.isConnectedToNetwork() == true) {
            print("Calling Network data")
            ND.downloadVideoData()
        }else {
            addAlert(withThisMessage: errorMessage, andThisTitle: appName)
        }

        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildUserInterface(){
        let videosView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        videosView.backgroundColor = model.lightGrayColor
        videosView.hidden = false
        view.addSubview(videosView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        let headerImage = UIImageView(frame: CGRectMake((self.view.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        headerImage.image = fmcLogo
        headerImage.contentMode = .ScaleAspectFit
        videosView.addSubview(headerImage)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        videosView.addSubview(whiteBar)
        
        let backIcn = UIImage(named: "back_grey") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 30, 30))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: #selector(VideosViewController.navigateBackHome(_:)), forControlEvents: .TouchUpInside)
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)

        let videoBannerView = UIView(frame: CGRectMake(0, 135, videosView.bounds.size.width, 50))
        let videoBannerViewGradientLayer = CAGradientLayer()
        videoBannerViewGradientLayer.frame = videoBannerView.bounds
        videoBannerViewGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        
        videoBannerView.layer.insertSublayer(videoBannerViewGradientLayer, atIndex: 0)
        videoBannerView.layer.addSublayer(videoBannerViewGradientLayer)
        videoBannerView.hidden = false
        videosView.addSubview(videoBannerView)
        
        let bannerLabel = UILabel(frame: CGRectMake(15, 0, videoBannerView.bounds.size.width, 50))
        bannerLabel.text = titleLabel
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.font = UIFont(name: "forza-light", size: 25)
        videoBannerView.addSubview(bannerLabel)

        let homeIcn = UIImage(named: "video_icon") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((videoBannerView.bounds.size.width / 2) - (25 + 100), 7, 35, 35))
        homeIcon.image = homeIcn
        videoBannerView.addSubview(homeIcon)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
       
        var itemSizePerDevice = CGSize()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            itemSizePerDevice = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height/2)
        }else{
            itemSizePerDevice = CGSize(width: self.view.bounds.size.width, height: 400)
        }
        layout.itemSize = itemSizePerDevice
        
        collectionView = UICollectionView(frame: CGRectMake(0, videoBannerView.frame.origin.y + videoBannerView.frame.size.height, self.view.frame.width, self.view.frame.height - 180), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.alwaysBounceVertical = true
        collectionView.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        videosView.addSubview(collectionView)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh videos")
        refreshControl.addTarget(self, action: #selector(VideosViewController.refreshCollectionView), forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)

        
       
    

    }
    
    func showActivityIndicator(){
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.frame = CGRect(x: 0, y: 0, width: 80.0, height: 80.0)
        spinner.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        view.addSubview(spinner)
        spinner.startAnimating()
    }

    
    func refreshCollectionView(){
        print("data refreshed")
        
        if (reachability.isConnectedToNetwork() == true) {
            print("Calling Network data")
            videoData.removeAllObjects()
            ND.downloadVideoData()
        }else {
            addAlert(withThisMessage: errorMessage, andThisTitle: appName)
        }
        

      
    }
    
    //MARK:: NetworkData Delegate Methods
    
    func videoDataLoaded(withThisArray: NSMutableArray) {
        print("network data loaded")
        spinner.stopAnimating()
        refreshControl.endRefreshing()
        videoData = withThisArray
        collectionView.reloadData()
    }
    
    func videoDataNotLoaded() {
        spinner.stopAnimating()
        collectionView.removeFromSuperview()
    }

    
    //MARK:: Navigation
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // UIAlert Controller 
    
    func addAlert(withThisMessage message: String, andThisTitle title: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }

        
    }
    
    
}



extension VideosViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, YTPlayerViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! VideoCollectionViewCell
        
        let currentVideo = videoData[indexPath.row] as? videoModel
        if let currentVideoBeingUsed = currentVideo{
        cell.playerView.loadWithVideoId(currentVideoBeingUsed.videoYoutubeID)
        cell.playerView.tag = indexPath.row
        cell.playerView.delegate = self
        cell.titleLabel.text = "\(currentVideoBeingUsed.title)"
        cell.descriptionLabel.text = "\(currentVideoBeingUsed.description)"
        return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        
        if playerView.playerState() == .Playing {
            print("Video is playing")
            print(playerView.tag)
            let currentVideoInArray = videoData[playerView.tag] as! videoModel
            
            Answers.logCustomEventWithName("Video Played", customAttributes: ["Youtube ID":"\(currentVideoInArray.videoYoutubeID)"])
        }
    }

}




