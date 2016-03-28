//
//  VideosViewController.swift
//  FirstMortgage
//
//  Created by Justin Davis on 2/16/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit
import Answers
import Crashlytics


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

    // Object Models
    let model = Model()
    
    //UIView
    let videosView = UIView()
    
    //Strings
    let youtubeURL = "https://www.youtube.com/watch?v="
    var titleLabel = "HELPFUL VIDEOS"
    let errorMessage = "This device currently has no internet connection. An internet connection is required to view videos."
//    let JSONurlString = "http://dev-fmc-cunningham.pantheon.io/app-video-json" /* This one is FOR TESTING ONLY */
    let JSONurlString = "https://www.firstmortgageco.com/app-video-json"  /* This one is REAL*/

    
    //NSArray
    var videoList = [videoModel]()
    
    //NSTimers
    var loadTimer: NSTimer!
    
    //NSActivityIndicator 
    var spinner = UIActivityIndicatorView()
    
    //CGRect
    var frame = CGRect()
    
    //UIlabel
    var bannerLabel = UILabel()
    
    //UIImageView
    var calcIcon = UIImageView()
    
    //MARK:
    //MARK: JSON Parse and object creation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.userInteractionEnabled = false
        
        //MARK:
        //MARK: THIS WILL AUTOMATICALLY CRASH THE APP LEAVE THIS ALONE UNLESS CRASHLYTICS TESTING
       /************************** Fabric Crashlytics ********************************************/
//        Crashlytics.sharedInstance().crash()       
        /**************************  End Fabric Crashlytics ********************************************/

        
         buildView()
        
        
         print(self.view.bounds.size.height)
        
        
        if (reachability.isConnectedToNetwork() == true) {
            showActivityIndicator()
            loadViewTimer()
        }else {
            // this will likely never get called
            let alertController = UIAlertController(title: "HomeIn", message: errorMessage, preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        }
        
        
    }
    
    func loadViewTimer(){
        loadTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(VideosViewController.parseJSON), userInfo: nil, repeats: false)
        

    }
    
    func timerEnded(){
        print("timer expired")
    }
    
    func parseJSON(){
        guard let videoURLData = NSURL(string: JSONurlString) else {
            print("unable to load video data from URL")
            return
        }
        
        let videoJSONData = NSData(contentsOfURL: videoURLData)
        
        let readableJSON = JSON(data: videoJSONData!, options: .MutableContainers, error: nil)
        
        
        
        if  readableJSON.isExists(){
            
            var yLocation = 0
            
            
            
            for i in 0...readableJSON.count - 1{
                //                 print("\(youtubeBaseURL)" + "\(readableJSON[i,"YouTube ID"])")
                
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
                    }else if result.height == 2001 {
                        print("zoomed in iPhone six plus")
                        self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                    }
                    }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                        print("iPad")

                        if  UIScreen.mainScreen().bounds.size.height == 1366 {
                            self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                            print("iPad Pro !!!!!!!!!!!!!")
                        }else {
                            self.frame = CGRect(x: 0, y: CGFloat(yLocation) + 20, width: self.view.bounds.size.width, height: self.view.bounds.size.height/3)
                            print("NOT iPAD PRO")
                        }
                    
                    
                    }
                
                
                let video = YTPlayerView.init(frame: frame)
                video.alpha = 0
                
                self.scrollView.addSubview(video)

                video.loadWithVideoId(newVideoInstance.videoYoutubeID)
                video.backgroundColor = UIColor.yellowColor()
                
                let titleLabel: UILabel = UILabel()
                
                // Video object labels
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
                descLabel.numberOfLines = 2
                descLabel.lineBreakMode = .ByWordWrapping
                descLabel.alpha = 0
                video.addSubview(descLabel)
                
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
                    }else if result.height == 2001 /*Zoomed in iPhone 6+*/{
                        titleLabel.frame = CGRectMake(10, 190, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/20)
                    }
                    }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    
                    if  UIScreen.mainScreen().bounds.size.height == 1366 {
                        print("iPad Pro!!!")
                        titleLabel.frame = CGRectMake(10, 420, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/35)

                    }else {
                        print("iPad")
                        titleLabel.frame = CGRectMake(10, 310, self.view.bounds.size.width,100)
                        titleLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/35)

                    }

                    
                }
             
                
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    var result = UIScreen.mainScreen().bounds.size
                    let scale = UIScreen.mainScreen().scale
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    if result.height == 1334 /*6*/{
                        print("iPhone 6")
                        descLabel.frame = CGRectMake(10, 210, self.view.bounds.size.width - 50, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }else if result.height == 960 /*4s*/ {
                        print("iPhone 4s")
                        descLabel.frame = CGRectMake(10, 135, self.view.bounds.size.width - 20, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/35)
                    }else if result.height == 2208 /*6+*/{
                        print("iPhone 6+")
                        descLabel.frame = CGRectMake(10, 235, self.view.bounds.size.width - 50, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }else if result.height == 1136 /*5/5s*/{
                        print("iPhone 5/5s")
                        descLabel.frame = CGRectMake(10, 175, self.view.bounds.size.width - 50, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }else if result.height == 2001 /*Zoomed in iPhone 6+*/{
                        descLabel.frame = CGRectMake(10, 210, self.view.bounds.size.width, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/33)
                    }
                    }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    
                    if  UIScreen.mainScreen().bounds.size.height == 1366 {
                        print("iPad Pro!!!!")
                        descLabel.frame = CGRectMake(10, 450, self.view.bounds.size.width - 200, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/60)
                        
                    }else {
                        print("iPad")
                        descLabel.frame = CGRectMake(10, 335, self.view.bounds.size.width - 200, 100)
                        descLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/80)

                        
                    }

                   
                }
                
                var sizeOfContent: CGFloat = 0
                let lLast: UIView = scrollView.subviews.last!
                let wd: CGFloat = lLast.frame.origin.y
                let ht: CGFloat = lLast.frame.size.height + 225
                sizeOfContent = wd + ht

                

                
          
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
                    var result = UIScreen.mainScreen().bounds.size
                    let scale = UIScreen.mainScreen().scale
                    result = CGSizeMake(result.width * scale, result.height * scale);
                    if result.height == 1334 /*6*/{
                        print("iPhone 6")
                        yLocation += 280
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent)
                    }else if result.height == 960 /*4s*/ {
                        print("iPhone 4s")
                        yLocation += 200
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent)
                    }else if result.height == 2208 /*6+*/{
                        print("iPhone 6+")
                        yLocation += 300
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent)
                    }else if result.height == 1136 /*5/5s*/{
                        print("iPhone 5/5s")
                        yLocation += 240
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent)
                    }else if result.height == 2001 /*Zoomed in iPhone 6+*/{
                        yLocation += 290
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent)
                    }
                }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    
                    if  UIScreen.mainScreen().bounds.size.height == 1366 {
                        print("iPad Pro!!!!")
                        yLocation += 550
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent)

                        
                    }else {
                        print("iPad")
                        yLocation += 400
                        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, sizeOfContent )

                    }

                    
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
        
//        scrollView.setContentOffset(CGPoint(x: 300, y: 300), animated: true)

        
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
        
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            var result = UIScreen.mainScreen().bounds.size
            let scale = UIScreen.mainScreen().scale
            result = CGSizeMake(result.width * scale, result.height * scale);
            if result.height == 1334 /*6*/{
                print("iPhone 6")
                 bannerLabel = UILabel(frame: CGRectMake(100, 0, videosView.bounds.size.width - 50, 50))
                 bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/15)
                 calcIcon = UIImageView(frame: CGRectMake(60, 4, 40, 40))
            }else if result.height == 960 /*4s*/ {
                print("iPhone 4s")
                 bannerLabel = UILabel(frame: CGRectMake(90, 0, videosView.bounds.size.width - 50, 50))
                 bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/15)
                 calcIcon = UIImageView(frame: CGRectMake(50, 4, 40, 40))
            }else if result.height == 2208 /*6+*/{
                print("iPhone 6+")
                 bannerLabel = UILabel(frame: CGRectMake(110, 0, videosView.bounds.size.width - 50, 50))
                 bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/15)
                 calcIcon = UIImageView(frame: CGRectMake(65, 4, 40, 40))
            }else if result.height == 1136 /*5/5s*/{
                print("iPhone 5/5s")
                 bannerLabel = UILabel(frame: CGRectMake(90, 0, videosView.bounds.size.width - 50, 50))
                 bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/15)
                 calcIcon = UIImageView(frame: CGRectMake(50, 4, 40, 40))
            }else if result.height == 2001 /*Zoomed in iPhone 6+*/{
                 bannerLabel = UILabel(frame: CGRectMake(110, 0, videosView.bounds.size.width - 50, 50))
                 bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/15)
                 calcIcon = UIImageView(frame: CGRectMake(65, 4, 40, 40))            }
            }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {

            
            if  UIScreen.mainScreen().bounds.size.height == 1366 {
                print("iPad Pro!!!!")
                bannerLabel = UILabel(frame: CGRectMake(350, 0, videosView.bounds.size.width - 50, 50))
                calcIcon = UIImageView(frame: CGRectMake(310, 4, 40, 40))
                bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/25)
                
                
                
            }else {
                print("iPad")
                bannerLabel = UILabel(frame: CGRectMake(275, 0, videosView.bounds.size.width - 50, 50))
                calcIcon = UIImageView(frame: CGRectMake(230, 4, 40, 40))
                bannerLabel.font = UIFont(name: "forza-light", size: self.view.bounds.size.width/25)
                
            }
                }

        let calcIcn = UIImage(named: "video_icon") as UIImage?
        calcIcon.image = calcIcn
        videoBannerView.addSubview(calcIcon)

       
        bannerLabel.text = titleLabel
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






