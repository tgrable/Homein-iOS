//
//  VideosViewController.swift
//  FirstMortgage
//
//  Created by Justin Davis on 2/16/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit


class VideosViewController: UIViewController {
    
    var cameFromHomeScreen = Bool()
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         buildView()
        guard let videoURLData = NSURL(string: "http://dev-fmc-cunningham.pantheon.io/app-video-json") else {
            print("unable to load video data from URL")
            return
        }
        
        let videoJSONData = NSData(contentsOfURL: videoURLData)
        
        let readableJSON = JSON(data: videoJSONData!, options: .MutableContainers, error: nil)
        
        
        
        if  readableJSON.isExists(){
            
            var yLocation = 0
         
            for i in 0...readableJSON.count - 1{
//                 print("\(youtubeURL)" + "\(readableJSON[i,"YouTube ID"])")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let results = readableJSON[i]
                    
                    let titleInstance = results["title"]
                    let newTitleInstance = titleInstance.string as String!
                    
                    let descriptionInstance = results["Video Description"]
                    let newDescriptionInstance = descriptionInstance.string as String!
                    
                    let youtubeIDInstance = results["YouTube ID"]
                    let newyoutubeIDInstannce = youtubeIDInstance.string as String!
                    
                    let newVideoInstance = videoModel(videoTitle: newTitleInstance, description: newDescriptionInstance, youtubeID: newyoutubeIDInstannce)
                    self.videoList.append(newVideoInstance)
                    print(self.videoList.count)
                    
                    //                print(newVideoInstance.title)
                    //                print(newVideoInstance.description)
                    print(newVideoInstance.videoYoutubeID)
                    
                    
                    let frame = CGRectMake(0, CGFloat(yLocation), self.view.bounds.size.width, 175)
                    let video = YTPlayerView.init(frame: frame)
                    self.scrollView.addSubview(video)
                    
                    video.loadWithVideoId(newVideoInstance.videoYoutubeID)
                    video.backgroundColor = UIColor.yellowColor()
                    
                    let titleLabel: UILabel = UILabel()
                    titleLabel.frame = CGRectMake(10,145, self.view.bounds.size.width,100)
                    titleLabel.textColor = UIColor.blackColor()
                    titleLabel.font = UIFont(name: "forza-light", size: 20)
                    titleLabel.textAlignment = .Left
                    titleLabel.text = newVideoInstance.title
                    video.addSubview(titleLabel)
                    
                    let descLabel: UILabel = UILabel()
                    descLabel.frame = CGRectMake(10, 165, self.view.bounds.size.width, 100)
                    descLabel.textColor = UIColor.blackColor()
                    descLabel.font = UIFont(name: "forza-light", size: 12)
                    descLabel.textAlignment = .Left
                    descLabel.text = newVideoInstance.description
//                    descLabel.text = "This is a very long sentence. This sentence is very long. This sentence should wrap."
                    descLabel.numberOfLines = 2
                    descLabel.lineBreakMode = .ByWordWrapping
//                    print(newVideoInstance.description)
                    video.addSubview(descLabel)

                    yLocation += 250
                    
                    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(self.videoList.count) * 300)
                })
                
                

            }
            


        }
        
       
        

        
    }
    
    

    
    func buildView(){

        videosView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        videosView.backgroundColor = model.lightGrayColor
        videosView.hidden = false
        self.view.addSubview(videosView)
        
        scrollView = UIScrollView(frame: CGRectMake(0,165, videosView.bounds.size.width, videosView.bounds.size.height))
        scrollView.backgroundColor = UIColor.clearColor()
        videosView.addSubview(scrollView)
     
        
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
        
        //TODO: UPDATE WITH VIDEO ICON ASSET
        
        let calcIcn = UIImage(named: "calculator_icon") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake(140, 12.5, 25, 25))
        
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
    
    // MARK: Navigation
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
