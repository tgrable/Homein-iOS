//
//  VideosViewController.swift
//  FirstMortgage
//
//  Created by Justin Davis on 2/16/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit


class VideosViewController: UIViewController {
    
    let reachability = Reachability()
    
    var cameFromHomeScreen = Bool()
    //MARK:
    //MARK: Properties
    let modelName = UIDevice.currentDevice().modelName
    
    // UIScrollView
    var scrollView = UIScrollView()
    
    //UIImageView
    var imageView = UIImageView()

    //UILabel
    var titleLabel = String()
    
    // Object Models
    let model = Model()
    
    //UIView
    let videosView = UIView()
    
    //Strings
    let youtubeURL = "https://www.youtube.com/watch?v="
    
    //NSArray
    var videoList = [videoModel]()
    
    //Int
    var itemCount = 0
    
    //NSTimers
    var loadTimer: NSTimer!
    
    //NSActivityIndicator 
    var spinner = UIActivityIndicatorView()
    
    //CGRect
    var frame = CGRect()
    
    //MARK:
    //MARK: JSON Parse and object creation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.userInteractionEnabled = false
        
         buildView()
        
        
        
        if (reachability.isConnectedToNetwork() == true) {
            showActivityIndicator()
            loadViewTimer()
        }else {
            // this will likely never get called
            let alertController = UIAlertController(title: "HomeIn", message: "This device currently has no internet connection. An internet connection is required to create a new account or login to an existing account.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.spinner.stopAnimating()
                self.spinner.removeFromSuperview()
                self.loadTimer.invalidate()
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        }
        
        
    }
    
    func loadViewTimer(){
        loadTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "parseJSON", userInfo: nil, repeats: false)
        

    }
    
    func timerEnded(){
        print("timer expired")
    }
    
    func parseJSON(){
        guard let videoURLData = NSURL(string: "http://dev-fmc-cunningham.pantheon.io/app-video-json") else {
            print("unable to load video data from URL")
            return
            
            /* REAL JSON FEED: https://www.firstmortgageco.com/app-video-json */
        }
        
        let videoJSONData = NSData(contentsOfURL: videoURLData)
        
        let readableJSON = JSON(data: videoJSONData!, options: .MutableContainers, error: nil)
        
        
        
        if  readableJSON.isExists(){
            
            var yLocation = 0
            
            
            
            for i in 0...readableJSON.count - 1{
                //                 print("\(youtubeURL)" + "\(readableJSON[i,"YouTube ID"])")
                
                let results = readableJSON[i]
                
                let titleInstance = results["title"]
                let newTitleInstance = titleInstance.string as String!
                
                let descriptionInstance = results["description"]
                let newDescriptionInstance = descriptionInstance.string as String!
                
                let youtubeIDInstance = results["id"]
                let newyoutubeIDInstannce = youtubeIDInstance.string as String!
                
                let newVideoInstance = videoModel(videoTitle: newTitleInstance, description: newDescriptionInstance, youtubeID: newyoutubeIDInstannce)
                self.videoList.append(newVideoInstance)
                print(self.videoList.count)
                
                print(newVideoInstance.videoYoutubeID)
                
//                frame = CGRect(x: -300, y: -300, width: 0, height: 0)
                
                
                
                if (modelName.rangeOfString("iPad") != nil) {
                    
                }else {
                    
                }
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    var result = UIScreen.mainScreen().bounds.size
                    let scale = UIScreen.mainScreen().scale
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    if result.height == 1334 /*6*/{
                        print("iPhone 6")
                        self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                    }else if result.height == 960 /*4s*/ {
                        print("iPhone 4s")
                        self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                    }else if result.height == 2208 /*6+*/{
                        print("iPhone 6+")
                        self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                    }else if result.height == 1136 /*5/5s*/{
                        print("iPhone 5/5s")
                        self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                    }
                }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    print("iPad")
                    self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)

                }
                
                
                let video = YTPlayerView.init(frame: frame)
                video.alpha = 0
                
                self.scrollView.addSubview(video)
                
                
            
                
                
                
                video.loadWithVideoId(newVideoInstance.videoYoutubeID)
                video.backgroundColor = UIColor.yellowColor()
                
                let titleLabel: UILabel = UILabel()
                
                if (modelName.rangeOfString("iPad") != nil) {
                    
                    print("iPad Detected")
                }else {
                    
                }
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    var result = UIScreen.mainScreen().bounds.size
                    let scale = UIScreen.mainScreen().scale
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    if result.height == 1334 /*6*/{
                        print("iPhone 6")
                        titleLabel.frame = CGRectMake(10, 190, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/20)
                    }else if result.height == 960 /*4s*/ {
                        print("iPhone 4s")
                        titleLabel.frame = CGRectMake(10, 120, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/20)
                        
                    }else if result.height == 2208 /*6+*/{
                        print("iPhone 6+")
                        titleLabel.frame = CGRectMake(10, 210, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/20)
                    }else if result.height == 1136 /*5/5s*/{
                        print("iPhone 5/5s")
                        titleLabel.frame = CGRectMake(10, 155, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/20)
                    }
                    }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                        print("iPad")
                        titleLabel.frame = CGRectMake(10, 310, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/35)
                    }
                
                
                

//                titleLabel.frame = CGRectMake(10,145, self.view.bounds.size.width,100)
                titleLabel.textColor = UIColor.blackColor()
                
                titleLabel.textAlignment = .Left
                titleLabel.text = newVideoInstance.title
                titleLabel.alpha = 0
                video.addSubview(titleLabel)
                
                let descLabel: UILabel = UILabel()
                
                descLabel.textColor = UIColor.blackColor()
                
                descLabel.textAlignment = .Left
                descLabel.text = newVideoInstance.description
                print(newVideoInstance.description)
//                                    descLabel.text = "This is a very long sentence. This sentence is very long. This sentence should wrap."
                descLabel.numberOfLines = 2
                descLabel.lineBreakMode = .ByWordWrapping
                descLabel.alpha = 0
                
                if (modelName.rangeOfString("iPad") != nil) {
                    
                }else{
                   
                }
                video.addSubview(descLabel)
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    var result = UIScreen.mainScreen().bounds.size
                    let scale = UIScreen.mainScreen().scale
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    if result.height == 1334 /*6*/{
                        print("iPhone 6")
                        descLabel.frame = CGRectMake(10, 210, self.view.bounds.size.width, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }else if result.height == 960 /*4s*/ {
                        print("iPhone 4s")
                         descLabel.frame = CGRectMake(10, 135, self.view.bounds.size.width, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }else if result.height == 2208 /*6+*/{
                        print("iPhone 6+")
                        descLabel.frame = CGRectMake(10, 230, self.view.bounds.size.width, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }else if result.height == 1136 /*5/5s*/{
                        print("iPhone 5/5s")
                         descLabel.frame = CGRectMake(10, 175, self.view.bounds.size.width, 100)
                         descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }
                }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    print("iPad")
                        descLabel.frame = CGRectMake(10, 330, self.view.bounds.size.width, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/50)
                }
                

                
          
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    var result = UIScreen.mainScreen().bounds.size
                    let scale = UIScreen.mainScreen().scale
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    if result.height == 1334 /*6*/{
                        print("iPhone 6")
                        yLocation += 280
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(self.videoList.count) * 340)
                    }else if result.height == 960 /*4s*/ {
                        print("iPhone 4s")
                        yLocation += 200
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(self.videoList.count) * 260)
                    }else if result.height == 2208 /*6+*/{
                        print("iPhone 6+")
                        yLocation += 300
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(self.videoList.count) * 360)
                    }else if result.height == 1136 /*5/5s*/{
                        print("iPhone 5/5s")
                        yLocation += 240
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(self.videoList.count) * 300)
                    }
                }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    print("iPad")
                    yLocation += 400
                    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(self.videoList.count) * 465 )
                }
              
                UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
                    video.alpha = 1.0
                    titleLabel.alpha = 1.0
                    descLabel.alpha = 1.0
                    }, completion: nil)
                
                
                
            }
            
            
            
            view.userInteractionEnabled = true
            loadTimer.invalidate()
            spinner.startAnimating()
            spinner.removeFromSuperview()
            
            
        }
    }
    
    

    
    //MARK:
    //MARK: Views
    
    func buildView(){

        videosView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        videosView.backgroundColor = model.lightGrayColor
        videosView.hidden = false
        self.view.addSubview(videosView)
        
        scrollView = UIScrollView(frame: CGRectMake(0,165, videosView.bounds.size.width, videosView.bounds.size.height))
        scrollView.backgroundColor = UIColor.clearColor()
        videosView.addSubview(scrollView)
        
        scrollView.setContentOffset(CGPoint(x: 300, y: 300), animated: true)

        
        
     
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((videosView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        videosView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        videosView.addSubview(whiteBar)
        
        let backIcn = UIImage(named: "back_grey") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 30, 30))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
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
        

        
        let calcIcn = UIImage(named: "video_icon") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake(130, 4, 40, 40))
        
        calcIcon.image = calcIcn
        videoBannerView.addSubview(calcIcon)
        
        titleLabel = "VIDEOS"

        let bannerLabel = UILabel(frame: CGRectMake(175, 0, videosView.bounds.size.width - 50, 50))
        bannerLabel.text = titleLabel
        bannerLabel.font = UIFont(name: "forza-light", size: CGFloat(22))
        bannerLabel.textAlignment = NSTextAlignment.Left
        bannerLabel.textColor = UIColor.whiteColor()
        videoBannerView.addSubview(bannerLabel)
        

    }
    
    //MARK:
    //MARK: UIActivityIndicator
    func showActivityIndicator(){
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.frame = CGRect(x: 0, y: 0, width: 80.0, height: 80.0)
        spinner.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    // MARK:
    // MARK: Navigation
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:
    // MARK: Memory Management
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }
    
    deinit {
        print("deinit being called in VideosViewController")
        removeViews(self.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}






