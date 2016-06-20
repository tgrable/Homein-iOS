//
//  HomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse
import Answers
import Crashlytics



class HomeViewController: UIViewController, ParseDataDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    // MARK:
    // MARK: Properties
    var model = Model()
    let modelName = UIDevice.currentDevice().modelName
    let parseObject = ParseDataObject()
    let reachability = Reachability()
    
    //UIView
    let homeView = UIView()
    let caView = UIView()
    let loginView = UIView()
    let signUpView = UIView()
    let overlayView = UIView()
    let searchOverlayView = UIView()
    let whiteBar = UIView()
    let loadingOverlay = UIView()
    let myHomesOverlay = UIView()
    let addAHomeOverlay = UIView()
    let preQualifiedOverlay = UIView()
    let videoOverlay = UIView()
    let findBranchOverlay = UIView()
    
    //UIScrollView
    let scrollView = UIScrollView()
    let contentScrollView = UIScrollView()
    
    //UITextField
    let username = UITextField()
    let password = UITextField()
    let namereg = UITextField()
    let emailreg = UITextField()
    let usernamereg = UITextField()
    let passwordreg = UITextField()
    let confirmpasswordreg = UITextField()
    let searchTxtField = UITextField()

    //UIGestureRecognizer
    let swipeRec = UISwipeGestureRecognizer()
    let swipeRecReg = UISwipeGestureRecognizer()
    let swipeRecLog = UISwipeGestureRecognizer()
    
    // UIButton
    let myHomesButton = UIButton()
    let addAHomeButton = UIButton()
    let mortgageCalculatorButton = UIButton()
    let refiCalculatorButton = UIButton()
    let findBranchButton = UIButton()
    let preQualifiedButton = UIButton()
    let userButton = UIButton()
    let getStartedButton = UIButton ()
    let loginButton = UIButton ()
    
    //Bool
    var isLoginViewOpen = Bool()
    var isRegisterViewOpen = Bool()
    var isMortgageCalc = Bool()
    var isUserLoggedIn = Bool()
    var isLoginView = Bool()
    var isRegisterView = Bool()
    var hasLoanOfficer = Bool()
    var didContinueWithOut = Bool()
    var didComeFromAccountPage = Bool()
    var isOverlayAdded = Bool()
    var didDisplayNoConnectionMessage = Bool()
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    //String
    var officerNid = String()
    var officerName = String()
    var officerURL = String()
    var officerEmail = String()
    
    //UILabel
    let loadingLabel = UILabel()
    
    //UIActivityIndicatorView
    var activityIndicator = UIActivityIndicatorView()
    
    let manager = CLLocationManager()
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK:
        //MARK: THIS WILL AUTOMATICALLY CRASH THE APP LEAVE THIS ALONE UNLESS CRASHLYTICS TESTING
        /*************************** Fabric Crashlytics *********************************************/
        //        Crashlytics.sharedInstance().crash()
        /***************************  End Fabric Crashlytics *********************************************/
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                self.manager.requestWhenInUseAuthorization()
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(HomeViewController.activeAgain), name: UIApplicationWillEnterForegroundNotification, object:nil)
        
        parseObject.delegate = self
        
        didDisplayNoConnectionMessage = false
        
        if (PFUser.currentUser() != nil) {
            self.isUserLoggedIn = true
        }
        else {
            self.isUserLoggedIn = false
        }
        
        /*************************** was in viewWillAppear *****************************************/
        self.view.backgroundColor = model.lightGrayColor
        
        // UIImageView
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        let imageView = UIImageView(frame: CGRectMake((self.view.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        self.view.addSubview(imageView)
        
        buildHomeView()
        buildCreateAccountView()
        buildLoginView()
        buildSignUpView()

        loadingOverlay.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height))
        loadingOverlay.backgroundColor = UIColor.darkGrayColor()
        loadingOverlay.alpha = 0.85
        loadingOverlay.hidden = true
        
        loadingLabel.frame = (frame: CGRectMake(0, 75, loadingOverlay.bounds.size.width, 0))
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.font = UIFont(name: "Arial", size: 25)
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.text = "Creating Your Account"
        loadingLabel.numberOfLines = 1
        loadingOverlay.addSubview(loadingLabel)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = view.center
        loadingOverlay.addSubview(activityIndicator)
        
        
        /*************************** was in viewDidAppear *****************************************/
        if reachability.isConnectedToNetwork() == false {
            let getStartedOverlay = UIView(frame: CGRectMake(0, 0, getStartedButton.bounds.width, getStartedButton.bounds.size.height))
            getStartedOverlay.backgroundColor = UIColor.darkGrayColor()
            getStartedOverlay.alpha = 0.45
            getStartedButton.addSubview(getStartedOverlay)
            
            let loginOverlay = UIView(frame: CGRectMake(0, 0, loginButton.bounds.width, loginButton.bounds.size.height))
            loginOverlay.backgroundColor = UIColor.darkGrayColor()
            loginOverlay.alpha = 0.45
            loginButton.addSubview(loginOverlay)
        }
        

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isLoginViewOpen = false
        checkIfLoggedIn()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if didDisplayNoConnectionMessage != true {
            if self.reachability.isConnectedToNetwork() == false {
                let alertController = UIAlertController(title: "HomeIn", message: "This device currently has no internet connection. An internet connection is required to create a new account or login to an existing account.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.didDisplayNoConnectionMessage = true
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        displayMessage("HomeIn", message: "Your device is low on memory and may need to shut down this app.")
    }
    
    func activeAgain() {
        if reachability.isConnectedToNetwork() == false {
            findBranchOverlay.hidden = false
            videoOverlay.hidden = false
        }
        else {
            findBranchOverlay.hidden = true
            videoOverlay.hidden = true
        }
    }
    
    // MARK:
    // MARK: Build Views
    func buildHomeView() {
        
        /*************************** Fabric Analytics *********************************************/

        Answers.logContentViewWithName("Main_View_Displayed",
            contentType: nil,
            contentId: nil,
            customAttributes: [:])
        
        print("Main Menu Display Logged -> Fabric")
        

        
        /************************* End Fabric Analytics *******************************************/
        
        homeView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, self.view.bounds.size.height - 85))
        homeView.backgroundColor = model.lightGrayColor
        homeView.hidden = false
        self.view.addSubview(homeView)
        
        whiteBar.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        homeView.addSubview(whiteBar)
        
        
        
        let backgroundImage = UIImage(named: "homebackground") as UIImage?
        // UIImageView
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        backgroundImageView.image = backgroundImage
        homeView.addSubview(backgroundImageView)
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        homeView.addSubview(scrollView)
        
        var offset = 0.0
        let width = Double(self.view.bounds.size.width)
        
        var fullButtonheight = (self.view.bounds.size.width / 2) * 0.75
        
        if (self.view.bounds.size.width >= 768) {
            fullButtonheight = (self.view.bounds.size.width / 2) - 225
        }
        
        /********************************************************* My Homes Button ********************************************************************/
        // UIView
        let myHomesView = UIView(frame: CGRectMake(0, CGFloat(offset), self.view.bounds.size.width / 2, fullButtonheight))
        let myHomesGradientLayer = CAGradientLayer()
        myHomesGradientLayer.frame = myHomesView.bounds
        myHomesGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        myHomesView.layer.insertSublayer(myHomesGradientLayer, atIndex: 0)
        myHomesView.layer.addSublayer(myHomesGradientLayer)
        scrollView.addSubview(myHomesView)
        
        var yIconOffset = (Double(myHomesView.bounds.size.height) / 2.0) - 36
        var labelDist = CGFloat((Double(myHomesView.bounds.size.height) / 2.0) + 10)
        
        let homeIcn = UIImage(named: "home_icon") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((myHomesView.bounds.size.width / 2) - 18, CGFloat(yIconOffset), 36, 36))
        homeIcon.image = homeIcn
        myHomesView.addSubview(homeIcon)
        
        // UILabel
        let myHomesLabel = UILabel(frame: CGRectMake(0, labelDist, myHomesView.bounds.size.width, 24))
        myHomesLabel.text = "MY HOMES"
        myHomesLabel.font = UIFont(name: "forza-light", size: 18)
        myHomesLabel.textAlignment = NSTextAlignment.Center
        myHomesLabel.textColor = UIColor.whiteColor()
        myHomesLabel.numberOfLines = 1
        myHomesView.addSubview(myHomesLabel)
        
        // UIButton
        myHomesButton.frame = (frame: CGRectMake(0, 0, myHomesView.bounds.size.width, myHomesView.bounds.size.height))
        myHomesButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        myHomesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myHomesButton.backgroundColor = UIColor.clearColor()
        myHomesButton.layer.borderWidth = 2
        myHomesButton.layer.borderColor = UIColor.whiteColor().CGColor
        myHomesButton.tag = 0
        myHomesView.addSubview(myHomesButton)
        
        myHomesOverlay.frame = (frame: CGRectMake(0, 0, myHomesView.bounds.width, myHomesView.bounds.size.height))
        myHomesOverlay.backgroundColor = UIColor.darkGrayColor()
        myHomesOverlay.alpha = 0.45
        myHomesOverlay.hidden = true
        myHomesView.addSubview(myHomesOverlay)
        
        /********************************************************* Add Homes Button ********************************************************************/
        // UIView
        let addHomesView = UIView(frame: CGRectMake(self.view.bounds.size.width / 2, CGFloat(offset), self.view.bounds.size.width / 2, fullButtonheight))
        let addHomesGradientLayer = CAGradientLayer()
        addHomesGradientLayer.frame = addHomesView.bounds
        addHomesGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        addHomesView.layer.insertSublayer(addHomesGradientLayer, atIndex: 0)
        addHomesView.layer.addSublayer(addHomesGradientLayer)
        scrollView.addSubview(addHomesView)
 
        let addIcn = UIImage(named: "add_white") as UIImage?
        let addHomeIcon = UIImageView(frame: CGRectMake((myHomesView.bounds.size.width / 2) - 18, CGFloat(yIconOffset + 5), 26, 26))
        addHomeIcon.image = addIcn
        addHomesView.addSubview(addHomeIcon)
        
        // UILabel
        let addHomesLabel = UILabel(frame: CGRectMake(0, labelDist, myHomesView.bounds.size.width, 24))
        addHomesLabel.text = "ADD A HOME"
        addHomesLabel.font = UIFont(name: "forza-light", size: 18)
        addHomesLabel.textAlignment = NSTextAlignment.Center
        addHomesLabel.textColor = UIColor.whiteColor()
        addHomesLabel.numberOfLines = 1
        addHomesView.addSubview(addHomesLabel)
        
        addAHomeButton.frame = (frame: CGRectMake(0, 0, myHomesView.bounds.size.width, myHomesView.bounds.size.height))
        addAHomeButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        addAHomeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addAHomeButton.backgroundColor = UIColor.clearColor()
        addAHomeButton.layer.borderWidth = 2
        addAHomeButton.layer.borderColor = UIColor.whiteColor().CGColor
        addAHomeButton.tag = 1
        addHomesView.addSubview(addAHomeButton)
        
        addAHomeOverlay.frame = (frame: CGRectMake(0, 0, addHomesView.bounds.width, addHomesView.bounds.size.height))
        addAHomeOverlay.backgroundColor = UIColor.darkGrayColor()
        addAHomeOverlay.alpha = 0.45
        addAHomeOverlay.hidden = true
        addHomesView.addSubview(addAHomeOverlay)
        
        offset = ((width / 2) * 0.75) + 15
        var height = (self.view.bounds.size.width / 2) - 20
        /*if (modelName.rangeOfString("iPad") != nil) {
            height = (self.view.bounds.size.width / 2) - 225
            offset = Double((self.view.bounds.size.width / 2)) - 215.0
        }*/
        
        if (self.view.bounds.size.width >= 768) {
            height = (self.view.bounds.size.width / 2) - 225
            offset = Double((self.view.bounds.size.width / 2)) - 215.0
        }
        
        /********************************************************* Mortgage Calculator Button ********************************************************************/
        // UIView
        let mortgageCalculatorView = UIView(frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, height))
        let mortgageCalculatorGradientLayer = CAGradientLayer()
        mortgageCalculatorGradientLayer.frame = mortgageCalculatorView.bounds
        mortgageCalculatorGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        mortgageCalculatorView.layer.insertSublayer(mortgageCalculatorGradientLayer, atIndex: 0)
        mortgageCalculatorView.layer.addSublayer(mortgageCalculatorGradientLayer)
        scrollView.addSubview(mortgageCalculatorView)

        yIconOffset = (Double(mortgageCalculatorView.bounds.size.height) / 2.0) - 36
        labelDist = CGFloat((Double(mortgageCalculatorView.bounds.size.height) / 2.0) + 10)
        // ********* calcIcn is now the video_icon ******* //
        let calcIcn = UIImage(named: "calculator_icon") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake((mortgageCalculatorView.bounds.size.width / 2) - 18, CGFloat(yIconOffset), 36, 36))
        calcIcon.image = calcIcn
        mortgageCalculatorView.addSubview(calcIcon)
        
        // UILabel
        let mortgageCalculatorLabel = UILabel(frame: CGRectMake(0, labelDist, mortgageCalculatorView.bounds.size.width, 48))
        mortgageCalculatorLabel.text = "MORTGAGE\nCALCULATOR"
        mortgageCalculatorLabel.font = UIFont(name: "forza-light", size: 18)
        mortgageCalculatorLabel.textAlignment = NSTextAlignment.Center
        mortgageCalculatorLabel.numberOfLines = 2
        mortgageCalculatorLabel.textColor = UIColor.whiteColor()
        mortgageCalculatorView.addSubview(mortgageCalculatorLabel)
        
        // UIButton
        mortgageCalculatorButton.frame = (frame: CGRectMake(0, 0, mortgageCalculatorView.bounds.size.width, mortgageCalculatorView.bounds.size.height))
        mortgageCalculatorButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        mortgageCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mortgageCalculatorButton.backgroundColor = UIColor.clearColor()
        mortgageCalculatorButton.layer.borderWidth = 2
        mortgageCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        mortgageCalculatorButton.tag = 2
        mortgageCalculatorView.addSubview(mortgageCalculatorButton)
        
        /********************************************************* Refinance Calculator Button ********************************************************************/
         /***************************************** NO LONGER REFINACE!!!! This is now the video button!!! ********************************************************/
        // UIView
        let refiCalculatorView = UIView(frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, height))
        let refiCalculatorGradientLayer = CAGradientLayer()
        refiCalculatorGradientLayer.frame = refiCalculatorView.bounds
        refiCalculatorGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        refiCalculatorView.layer.insertSublayer(refiCalculatorGradientLayer, atIndex: 0)
        refiCalculatorView.layer.addSublayer(refiCalculatorGradientLayer)
        scrollView.addSubview(refiCalculatorView)
        
        
       
        let videoIcn = UIImage(named: "video_icon") as UIImage?
        
        let calcIconTwo = UIImageView(frame: CGRectMake((refiCalculatorView.bounds.size.width / 2) - 25, CGFloat(yIconOffset)-10,  55, 55))
        calcIconTwo.image = videoIcn
        refiCalculatorView.addSubview(calcIconTwo)
        
        // UILabel
        let refiCalculatorLabel = UILabel(frame: CGRectMake(0, labelDist, refiCalculatorView.bounds.size.width, 48))
        refiCalculatorLabel.text = "HELPFUL\nVIDEOS"

        refiCalculatorLabel.font = UIFont(name: "forza-light", size: 18)
        refiCalculatorLabel.textAlignment = NSTextAlignment.Center
        refiCalculatorLabel.numberOfLines = 2
        refiCalculatorLabel.textColor = UIColor.whiteColor()
        refiCalculatorView.addSubview(refiCalculatorLabel)
        
        // This now goes to the videos section - I left the button name the same for the sake of simplicity
        refiCalculatorButton.frame = (frame: CGRectMake(0, 0, refiCalculatorView.bounds.size.width, refiCalculatorView.bounds.size.height))
        refiCalculatorButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        refiCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refiCalculatorButton.backgroundColor = UIColor.clearColor()
        refiCalculatorButton.layer.borderWidth = 2
        refiCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        refiCalculatorButton.tag = 3
        refiCalculatorView.addSubview(refiCalculatorButton)
        
        videoOverlay.frame = (frame: CGRectMake(0, 0, refiCalculatorView.bounds.width, refiCalculatorView.bounds.size.height))
        videoOverlay.backgroundColor = UIColor.darkGrayColor()
        videoOverlay.alpha = 0.45
        videoOverlay.hidden = true
        refiCalculatorView.addSubview(videoOverlay)
        
        if (reachability.isConnectedToNetwork() == false) {
            videoOverlay.hidden = false
            
        }
        
        offset = (((width / 2) * 0.75) + (width / 2)) + 15
        /*if (modelName.rangeOfString("iPad") != nil) {
            offset = Double(self.view.bounds.size.width / 2) - 225 + Double(self.view.bounds.size.width / 2) - 215.0 + 10.0;
        }*/
        
        
        
        if (self.view.bounds.size.width >= 768) {
            offset = Double(self.view.bounds.size.width / 2) - 225 + Double(self.view.bounds.size.width / 2) - 215.0 + 10.0;
        }
        
        /********************************************************* Find Branch Button ********************************************************************/
        // UIView
        let findBranchView = UIView(frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, height))
        let findBranchGradientLayer = CAGradientLayer()
        findBranchGradientLayer.frame = findBranchView.bounds
        findBranchGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        findBranchView.layer.insertSublayer(findBranchGradientLayer, atIndex: 0)
        findBranchView.layer.addSublayer(findBranchGradientLayer)
        scrollView.addSubview(findBranchView)
        
        let brnchIcn = UIImage(named: "bank_icon") as UIImage?
        let branchIcon = UIImageView(frame: CGRectMake((findBranchView.bounds.size.width / 2) - 18, CGFloat(yIconOffset), 36, 36))
        branchIcon.image = brnchIcn
        findBranchView.addSubview(branchIcon)
        
        // UILabel
        let findBranchLabel = UILabel(frame: CGRectMake(0, labelDist - 7, findBranchView.bounds.size.width, 72))
        findBranchLabel.text = "FIND THE\nCLOSEST\nBRANCH"
        findBranchLabel.font = UIFont(name: "forza-light", size: 18)
        findBranchLabel.textAlignment = NSTextAlignment.Center
        findBranchLabel.numberOfLines = 3
        findBranchLabel.textColor = UIColor.whiteColor()
        findBranchView.addSubview(findBranchLabel)
        
        findBranchButton.frame = (frame: CGRectMake(0, 0, findBranchView.bounds.size.width, findBranchView.bounds.size.height))
        findBranchButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        findBranchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        findBranchButton.backgroundColor = UIColor.clearColor()
        findBranchButton.layer.borderWidth = 2
        findBranchButton.layer.borderColor = UIColor.whiteColor().CGColor
        findBranchButton.tag = 4
        findBranchView.addSubview(findBranchButton)
        
        findBranchOverlay.frame = (frame: CGRectMake(0, 0, findBranchView.bounds.width, findBranchView.bounds.size.height))
        findBranchOverlay.backgroundColor = UIColor.darkGrayColor()
        findBranchOverlay.alpha = 0.45
        findBranchOverlay.hidden = true
        findBranchView.addSubview(findBranchOverlay)
        
        /********************************************************* Get Prequalified Button ********************************************************************/
         // UIView
        let preQualifiedView = UIView(frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, height))
        let preQualifiedGradientLayer = CAGradientLayer()
        preQualifiedGradientLayer.frame = preQualifiedView.bounds
        preQualifiedGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        preQualifiedView.layer.insertSublayer(preQualifiedGradientLayer, atIndex: 0)
        preQualifiedView.layer.addSublayer(preQualifiedGradientLayer)
        scrollView.addSubview(preQualifiedView)
        
        let checkIcn = UIImage(named: "checkmark_white") as UIImage?
        let checkIcon = UIImageView(frame: CGRectMake((preQualifiedView.bounds.size.width / 2) - 18, CGFloat(yIconOffset), 36, 36))
        checkIcon.image = checkIcn
        preQualifiedView.addSubview(checkIcon)
        
        // UILabel
        let preQualifiedLabel = UILabel(frame: CGRectMake(0, labelDist, preQualifiedView.bounds.size.width, 48))
        preQualifiedLabel.text = "GET\nPREQUALIFIED"
        preQualifiedLabel.font = UIFont(name: "forza-light", size: 18)
        preQualifiedLabel.textAlignment = NSTextAlignment.Center
        preQualifiedLabel.numberOfLines = 2
        preQualifiedLabel.textColor = UIColor.whiteColor()
        preQualifiedView.addSubview(preQualifiedLabel)
        
        preQualifiedButton.frame = (frame: CGRectMake(0, 0, preQualifiedView.bounds.size.width, preQualifiedView.bounds.size.height))
        preQualifiedButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        preQualifiedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        preQualifiedButton.backgroundColor = UIColor.clearColor()
        preQualifiedButton.layer.borderWidth = 2
        preQualifiedButton.layer.borderColor = UIColor.whiteColor().CGColor
        preQualifiedButton.tag = 5
        preQualifiedView.addSubview(preQualifiedButton)
        
        preQualifiedOverlay.frame = (frame: CGRectMake(0, 0, preQualifiedView.bounds.width, preQualifiedView.bounds.size.height))
        preQualifiedOverlay.backgroundColor = UIColor.darkGrayColor()
        preQualifiedOverlay.alpha = 0.45
        preQualifiedOverlay.hidden = true
        preQualifiedView.addSubview(preQualifiedOverlay)
        
        if (reachability.isConnectedToNetwork() == false) {
            preQualifiedOverlay.hidden = false
        }
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: ((self.view.bounds.size.width / 2) * 2) + (135 + 15))
        
        
        
        if (modelName.rangeOfString("iPad") != nil) {
            scrollView.scrollEnabled = false
        }
        
        
        
        userButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 50, 5, 34, 40))
        userButton.addTarget(self, action: #selector(HomeViewController.navigateToOtherViews(_:)), forControlEvents: .TouchUpInside)
        userButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        userButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        userButton.contentHorizontalAlignment = .Right
        userButton.tag = 99
        whiteBar.addSubview(userButton)
        
        checkIfLoggedIn()
        
        var termsAndConditionsContainerViewFrame = CGRect()
        var termsAndConditionsButtonViewFrame = CGRect()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            var result = UIScreen.mainScreen().bounds.size
            let scale = UIScreen.mainScreen().scale
            result = CGSizeMake(result.width * scale, result.height * scale);
            if result.height == 1334 /*6*/{
                print("iPhone 6")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-5, y: 10 , width: 150, height: 50)

            
            }else if result.height == 960 /*4s*/ {
                print("iPhone 4s")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-25, y: 5 , width: 150, height: 50)
                
            }else if result.height == 2208 /*6 PLUS*/{
                print("iPhone 6 PLUS")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-5, y: 10 , width: 150, height: 50)
                
            }else if result.height == 1136 /*5/5s*/{
                print("iPhone 5/5s")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-25, y: 5 , width: 150, height: 50)
            }else if result.height == 2001 {
                print("zoomed in iPhone six plus")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-5, y: 10 , width: 150, height: 50)
                
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            print("iPad")
            
            if  UIScreen.mainScreen().bounds.size.height == 1366 {
                print("iPad Pro !!!!!!!!!!!!!")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-5, y: 10 , width: 150, height: 50)
            }else {
                print("NOT iPAD PRO")
                termsAndConditionsContainerViewFrame = CGRect(x: 10, y: -5 , width: 300, height: 50)
                termsAndConditionsButtonViewFrame = CGRect(x:-5, y: 10 , width: 150, height: 50)
            }
            
            
        }


        let termsAndConditionsContentView = UILabel(frame: termsAndConditionsContainerViewFrame)
        termsAndConditionsContentView.backgroundColor = UIColor.clearColor()
        termsAndConditionsContentView.text = "By using the HomeIn App you agree to our"
        
        whiteBar.addSubview(termsAndConditionsContentView)
        
        let termsAndConditionsButton = UIButton(frame: termsAndConditionsButtonViewFrame)
        termsAndConditionsButton.setTitle("terms and conditions", forState: .Normal)
        termsAndConditionsButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        termsAndConditionsButton.addTarget(self, action: #selector(HomeViewController.termsAndConditions), forControlEvents: .TouchUpInside)
        whiteBar.addSubview(termsAndConditionsButton)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            var result = UIScreen.mainScreen().bounds.size
            let scale = UIScreen.mainScreen().scale
            result = CGSizeMake(result.width * scale, result.height * scale);
            if result.height == 1334 /*6*/{
                print("iPhone 6")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 12)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 12)
                
            }else if result.height == 960 /*4s*/ {
                print("iPhone 4s")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 8)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 8)
                
            }else if result.height == 2208 /*6 PLUS*/{
                print("iPhone 6 PLUS")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 12)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 12)
            }else if result.height == 1136 /*5/5s*/{
                print("iPhone 5/5s")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 8)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 8)
                
            }else if result.height == 2001 {
                print("zoomed in iPhone six plus")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 12)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 12)
                
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            print("iPad")
            
            if  UIScreen.mainScreen().bounds.size.height == 1366 {
                print("iPad Pro !!!!!!!!!!!!!")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 12)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 12)
            }else {
                print("NOT iPAD PRO")
                termsAndConditionsContentView.font = UIFont(name: "forza-light", size: 12)
                termsAndConditionsButton.titleLabel?.font = UIFont(name: "forza-light", size: 12)
            }
            
            
        }

        
        
        
        
    }
    
    func buildCreateAccountView() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Check if loanOfficerArrayDateSet is set in NSUserDefaults
        if (defaults.objectForKey("loanOfficerArrayDateSet") != nil) {
            let now = NSDate()
            let setDate = defaults.objectForKey("loanOfficerArrayDateSet") as! NSDate
            
            let order = NSCalendar.currentCalendar().compareDate(now, toDate: setDate,
                toUnitGranularity: .Day)
            
            //order == .OrderedDescending the date has expired and JSON data needs to be fetched again.
            if order == .OrderedDescending {
                if reachability.isConnectedToNetwork() {
                    getBranchJSON()
                }
                else {
                    //Check if loanOfficerArray is set in NSUserDefaults
                    if (defaults.objectForKey("loanOfficerArray") != nil) {
                        if let _ = defaults.objectForKey("loanOfficerArray") {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            let val = defaults.objectForKey("loanOfficerArray")
                            let firstLo = val!.values!!.first as! Dictionary<String, String> // TODO: This doesnt seem right
                            
                            //Check that the nmls field has been set
                            //this was added later so there is a chance som users will not have this field set.
                            if let _ = firstLo["nmls"] {
                                self.loanOfficerArray = defaults.objectForKey("loanOfficerArray") as! Array
                                self.tempArray = defaults.objectForKey("loanOfficerArray") as! Array
                            }
                            else {
                                if reachability.isConnectedToNetwork() {
                                    getBranchJSON()
                                }
                            }
                        }
                        else {
                            if reachability.isConnectedToNetwork() {
                                getBranchJSON()
                            }
                        }
                    }
                    else {
                        if reachability.isConnectedToNetwork() {
                            getBranchJSON()
                        }
                    }
                }
            }
            else {
                if reachability.isConnectedToNetwork() {
                    getBranchJSON()
                }
            }
        }
        else {
            if reachability.isConnectedToNetwork() {
                getBranchJSON()
            }
        }

        var fontSize = 16 as CGFloat
        if modelName.rangeOfString("5") != nil{
            fontSize = 14
        }
        
        caView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, self.view.bounds.size.height - 85))
        caView.backgroundColor = UIColor.whiteColor()
        caView.hidden = false
        if ((PFUser.currentUser()) != nil) {
            caView.hidden = true
        }
        else {
            caView.hidden = false
        }
        self.view.addSubview(caView)
        
        let createAccountView = UIView(frame: CGRectMake(0, 0, caView.bounds.size.width, 40))
        let createAccountGradientLayer = CAGradientLayer()
        createAccountGradientLayer.frame = createAccountView.bounds
        createAccountGradientLayer.colors = [model.darkOrangeColor.CGColor, model.lightOrangeColor.CGColor]
        createAccountView.layer.insertSublayer(createAccountGradientLayer, atIndex: 0)
        createAccountView.layer.addSublayer(createAccountGradientLayer)
        caView.addSubview(createAccountView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, createAccountView.bounds.size.width, 40))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "CREATE AN ACCOUNT"
        createAccountLabel.numberOfLines = 1
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountView.addSubview(createAccountLabel)
        
        contentScrollView.frame = (frame: CGRectMake(0, 40, caView.bounds.size.width, caView.bounds.size.height - 50))
        contentScrollView.backgroundColor = UIColor.clearColor()
        caView.addSubview(contentScrollView)
        
        
       
        
        let descLabel = UILabel (frame: CGRectMake(15, 10, contentScrollView.bounds.size.width - 30, 0))
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.font = UIFont(name: "Arial", size: fontSize)
        descLabel.text = "When you create a HomeIn account, you’re building a personal portfolio of all of the homes you visit. And you’ll be able to HomeIn on all of the features you loved (or didn’t love) about each property on your home buying  journey."
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        contentScrollView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "checkmark_gray") as UIImage?
        
        var offset = descLabel.bounds.size.height + 25.0 as CGFloat
        
        var benLabelFontSize = 18 as CGFloat
        if modelName.rangeOfString("5") != nil || modelName.rangeOfString("4s") != nil {
            benLabelFontSize = 16
        }

        let benLabel = UILabel (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 24))
        benLabel.textAlignment = NSTextAlignment.Center
        benLabel.textColor = model.lightOrangeColor
        benLabel.font = UIFont(name: "forza-medium", size: benLabelFontSize)
        benLabel.text = "BENEFITS OF A HOMEIN ACCOUNT:"
        contentScrollView.addSubview(benLabel)
        
        offset = offset + 35.0 as CGFloat
        
        let checkImageOne = UIImageView(frame: CGRectMake(20, offset + 3, 25, 25))
        checkImageOne.image = checkMarkImage
        contentScrollView.addSubview(checkImageOne)
        
        let optionOneLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionOneLabel.textAlignment = NSTextAlignment.Left
        optionOneLabel.font = UIFont(name: "Arial", size: fontSize)
        optionOneLabel.text = "Take unlimited photos of the homes you visit and store them in your personal library"
        optionOneLabel.numberOfLines = 0
        optionOneLabel.sizeToFit()
        contentScrollView.addSubview(optionOneLabel)
        
        offset += optionOneLabel.bounds.size.height + 15.0
        
        let checkImageTwo = UIImageView(frame: CGRectMake(20, offset + 5, 25, 25))
        checkImageTwo.image = checkMarkImage
        contentScrollView.addSubview(checkImageTwo)
        
        let optionTwoLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionTwoLabel.textAlignment = NSTextAlignment.Left
        optionTwoLabel.font = UIFont(name: "Arial", size: fontSize)
        optionTwoLabel.text = "Make notes about your saved homes and every room and feature"
        optionTwoLabel.numberOfLines = 0
        optionTwoLabel.sizeToFit()
        contentScrollView.addSubview(optionTwoLabel)
        
        offset += optionTwoLabel.bounds.size.height + 15.0
        
        let checkImageThree = UIImageView(frame: CGRectMake(20, offset + 3, 25, 25))
        checkImageThree.image = checkMarkImage
        contentScrollView.addSubview(checkImageThree)
        
        let optionThreeLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.font = UIFont(name: "Arial", size: fontSize)
        optionThreeLabel.text = "Connect with an expert First Mortgage Company or Cunningham & Company Loan Officer to get pre-qualified for a home loan."
        optionThreeLabel.numberOfLines = 0
        optionThreeLabel.sizeToFit()
        contentScrollView.addSubview(optionThreeLabel)
        
        offset += optionThreeLabel.bounds.size.height + 15.0
        
        let checkImageFive = UIImageView(frame: CGRectMake(20, offset + 3, 25, 25))
        checkImageFive.image = checkMarkImage
        contentScrollView.addSubview(checkImageFive)
        
        let optionFiveLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionFiveLabel.textAlignment = NSTextAlignment.Left
        optionFiveLabel.font = UIFont(name: "Arial", size: fontSize)
        optionFiveLabel.text = "Share your home search portfolio with your family and friends."
        optionFiveLabel.numberOfLines = 0
        optionFiveLabel.sizeToFit()
        contentScrollView.addSubview(optionFiveLabel)
        
        offset += optionFiveLabel.bounds.size.height + 15.0
        
        let setUpLabel = UILabel (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 0))
        setUpLabel.textAlignment = NSTextAlignment.Left
        setUpLabel.font = UIFont(name: "Arial", size: fontSize)
        setUpLabel.text = "Set up your own HomeIn account today!"
        setUpLabel.numberOfLines = 0
        setUpLabel.sizeToFit()
        contentScrollView.addSubview(setUpLabel)
        
        offset += setUpLabel.bounds.size.height + 15.0
        
        let getStartedView = UIView(frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 40))
        let getStartedGradientLayer = CAGradientLayer()
        getStartedGradientLayer.frame = getStartedView.bounds
        getStartedGradientLayer.colors = [model.darkBlueColor.CGColor, model.lightBlueColor.CGColor]
        getStartedView.layer.insertSublayer(getStartedGradientLayer, atIndex: 0)
        getStartedView.layer.addSublayer(getStartedGradientLayer)
        contentScrollView.addSubview(getStartedView)
        
        let getStartedArrow = UILabel (frame: CGRectMake(getStartedView.bounds.size.width - 50, 0, 40, 40))
        getStartedArrow.textAlignment = NSTextAlignment.Right
        getStartedArrow.font = UIFont(name: "forza-light", size: 40)
        getStartedArrow.text = ">"
        getStartedArrow.textColor = UIColor.whiteColor()
        getStartedView.addSubview(getStartedArrow)
        
        var buttonFontSize = 23 as CGFloat
        if modelName.rangeOfString("4s") != nil || modelName.rangeOfString("5") != nil{
            buttonFontSize = 21
        }
        
        getStartedButton.frame = (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 40))
        getStartedButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        getStartedButton.addTarget(self, action: #selector(HomeViewController.showHideSignUpView), forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: buttonFontSize)
        contentScrollView.addSubview(getStartedButton)
        
        let btnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let btnView = UIImageView(frame: CGRectMake(0, getStartedView.bounds.size.height, getStartedView.bounds.size.width, 15))
        btnView.image = btnImg
        getStartedView.addSubview(btnView)
        
        offset += getStartedView.bounds.size.height + 10.0
        
        let loginButtonView = UIView(frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 40))
        let loginButtonGradientLayer = CAGradientLayer()
        loginButtonGradientLayer.frame = loginButtonView.bounds
        loginButtonGradientLayer.colors = [model.darkOrangeColor.CGColor, model.lightOrangeColor.CGColor]
        loginButtonView.layer.insertSublayer(loginButtonGradientLayer, atIndex: 0)
        loginButtonView.layer.addSublayer(loginButtonGradientLayer)
        contentScrollView.addSubview(loginButtonView)
        
        let loginArrow = UILabel (frame: CGRectMake(getStartedView.bounds.size.width - 50, 0, 40, 40))
        loginArrow.textAlignment = NSTextAlignment.Right
        loginArrow.font = UIFont(name: "forza-light", size: 40)
        loginArrow.text = ">"
        loginArrow.textColor = UIColor.whiteColor()
        loginButtonView.addSubview(loginArrow)
        
        loginButton.frame = (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 40))
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: #selector(HomeViewController.showHideLoginView), forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 24)
        contentScrollView.addSubview(loginButton)
        
        let loginImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let loginShadowView = UIImageView(frame: CGRectMake(0, getStartedView.bounds.size.height, getStartedView.bounds.size.width, 15))
        loginShadowView.image = loginImg
        loginButtonView.addSubview(loginShadowView)
        
        offset += loginButtonView.bounds.size.height + 10.0
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 40))
        continueWithoutButton.setTitle("CONTINUE WITHOUT", forState: .Normal)
        continueWithoutButton.addTarget(self, action: #selector(HomeViewController.continueWithoutLogin(_:)), forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        continueWithoutButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        contentScrollView.addSubview(continueWithoutButton)
        
        contentScrollView.contentSize = CGSize(width: caView.bounds.size.width, height: 590)
    }
    
    func buildLoginView() {
        loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width * 2, self.view.bounds.height))
        loginView.backgroundColor = model.lightGrayColor
         self.view.addSubview(loginView)
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        loginView.addSubview(logoView)
        
        let dismissButton = UIButton (frame: CGRectMake(0, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: #selector(HomeViewController.showHideLoginView), forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 32)
        loginView.addSubview(dismissButton)
        
        let bannerView = UIView(frame: CGRectMake(0, 85, self.view.bounds.width, 50))
        let bannerGradientLayer = CAGradientLayer()
        bannerGradientLayer.frame = bannerView.bounds
        bannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        bannerView.layer.insertSublayer(bannerGradientLayer, atIndex: 0)
        bannerView.layer.addSublayer(bannerGradientLayer)
        bannerView.hidden = false
        loginView.addSubview(bannerView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, bannerView.bounds.size.width, 50))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "LOG INTO YOUR ACCOUNT"
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountLabel.numberOfLines = 1
        bannerView.addSubview(createAccountLabel)
        
        // UITextField
        let unPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        username.frame = (frame: CGRectMake(0, 145, self.view.bounds.size.width, 50));
        username.layer.borderColor = model.lightGrayColor.CGColor
        username.layer.borderWidth = 1.0
        username.leftView = unPaddingView
        username.leftViewMode = UITextFieldViewMode.Always
        username.placeholder = "USER NAME"
        username.backgroundColor = UIColor.whiteColor()
        username.delegate = self
        username.returnKeyType = .Next
        username.keyboardType = UIKeyboardType.Default
        username.autocapitalizationType = .None
        username.autocorrectionType = .No
        username.font = UIFont(name: "forza-username", size: 45)
        loginView.addSubview(username)
        
        // UITextField
        let pwPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        password.frame = (frame: CGRectMake(0, 195, self.view.bounds.size.width, 50));
        password.layer.borderColor = model.lightGrayColor.CGColor
        password.layer.borderWidth = 1.0
        password.leftView = pwPaddingView
        password.leftViewMode = UITextFieldViewMode.Always
        password.placeholder = "PASSWORD"
        password.backgroundColor = UIColor.whiteColor()
        password.delegate = self
        password.returnKeyType = .Done
        password.keyboardType = UIKeyboardType.Default
        password.secureTextEntry = true
        password.autocapitalizationType = .None
        password.autocorrectionType = .No
        password.font = UIFont(name: "forza-username", size: 45)
        loginView.addSubview(password)
        
        let loginButton = UIButton (frame: CGRectMake(0, 250, self.view.bounds.size.width, 50))
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: #selector(HomeViewController.checkInputFieldsButtonPress(_:)), forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = model.darkBlueColor
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginButton.tag = 0
        loginView.addSubview(loginButton)
        
        let getStartedButton = UIButton (frame: CGRectMake(0, 310, self.view.bounds.size.width, 50))
        getStartedButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        getStartedButton.addTarget(self, action: #selector(HomeViewController.showHideSignUpView), forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.backgroundColor = model.lightRedColor
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginView.addSubview(getStartedButton)
        
        let forGotPasswordFormButton = UIButton (frame: CGRectMake(0, 370, contentScrollView.bounds.size.width / 2, 30))
        forGotPasswordFormButton.setTitle("FORGOT PASSWORD?", forState: .Normal)
        forGotPasswordFormButton.addTarget(self, action: #selector(HomeViewController.forgotPassord), forControlEvents: .TouchUpInside)
        forGotPasswordFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        forGotPasswordFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 15)
        loginView.addSubview(forGotPasswordFormButton)
        
        let closeSignUpFormButton = UIButton (frame: CGRectMake(contentScrollView.bounds.size.width / 2, 370, contentScrollView.bounds.size.width / 2, 30))
        closeSignUpFormButton.setTitle("CLOSE LOGIN FORM", forState: .Normal)
        closeSignUpFormButton.addTarget(self, action: #selector(HomeViewController.showHideLoginView), forControlEvents: .TouchUpInside)
        closeSignUpFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        closeSignUpFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 15)
        loginView.addSubview(closeSignUpFormButton)
        
        swipeRecLog.direction = UISwipeGestureRecognizerDirection.Down
        swipeRecLog.addTarget(self, action: #selector(HomeViewController.swipeDownToMoveLoginViewDown))
        loginView.addGestureRecognizer(swipeRecLog)
        
        signUpView.userInteractionEnabled = true
        
        let statusBarView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 25))
        statusBarView.backgroundColor = model.lightGrayColor
        self.view.addSubview(statusBarView)
    }
    
    func buildSignUpView() {
        signUpView.frame = (frame: CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        signUpView.backgroundColor = UIColor.clearColor()
        loginView.addSubview(signUpView)
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        signUpView.addSubview(logoView)
        
        let dismissButton = UIButton (frame: CGRectMake(0, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: #selector(HomeViewController.showHideSignUpView), forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 32)
        signUpView.addSubview(dismissButton)
        
        let bannerView = UIView(frame: CGRectMake(0, 85, self.view.bounds.width, 50))
        let bannerGradientLayer = CAGradientLayer()
        bannerGradientLayer.frame = bannerView.bounds
        bannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        bannerView.layer.insertSublayer(bannerGradientLayer, atIndex: 0)
        bannerView.layer.addSublayer(bannerGradientLayer)
        bannerView.hidden = false
        signUpView.addSubview(bannerView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, self.view.bounds.size.width, 50))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "CREATE AN ACCOUNT"
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountLabel.numberOfLines = 1
        bannerView.addSubview(createAccountLabel)
        
        // UITextField
        let nPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        namereg.frame = (frame: CGRectMake(0, 155, self.view.bounds.size.width, 50));
        namereg.layer.borderColor = model.lightGrayColor.CGColor
        namereg.layer.borderWidth = 1.0
        namereg.leftView = nPaddingView
        namereg.leftViewMode = UITextFieldViewMode.Always
        namereg.placeholder = "NAME"
        namereg.backgroundColor = UIColor.whiteColor()
        namereg.delegate = self
        namereg.returnKeyType = .Next
        namereg.keyboardType = UIKeyboardType.Default
        namereg.font = UIFont(name: "forza-username", size: 45)
        namereg.autocapitalizationType = .Words
        namereg.autocorrectionType = .No
        signUpView.addSubview(namereg)
        
        // UITextField
        let emPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        emailreg.frame = (frame: CGRectMake(0, 205, self.view.bounds.size.width, 50));
        emailreg.layer.borderColor = model.lightGrayColor.CGColor
        emailreg.layer.borderWidth = 1.0
        emailreg.leftView = emPaddingView
        emailreg.leftViewMode = UITextFieldViewMode.Always
        emailreg.placeholder = "EMAIL"
        emailreg.backgroundColor = UIColor.whiteColor()
        emailreg.delegate = self
        emailreg.returnKeyType = .Next
        emailreg.keyboardType = UIKeyboardType.EmailAddress
        emailreg.autocapitalizationType = .None
        emailreg.autocorrectionType = .No
        emailreg.font = UIFont(name: "forza-username", size: 45)
        signUpView.addSubview(emailreg)
        
        // UITextField
        let unPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        usernamereg.frame = (frame: CGRectMake(0, 255, self.view.bounds.size.width, 50));
        usernamereg.layer.borderColor = model.lightGrayColor.CGColor
        usernamereg.layer.borderWidth = 1.0
        usernamereg.leftView = unPaddingView
        usernamereg.leftViewMode = UITextFieldViewMode.Always
        usernamereg.placeholder = "USER NAME"
        usernamereg.backgroundColor = UIColor.whiteColor()
        usernamereg.delegate = self
        usernamereg.returnKeyType = .Next
        usernamereg.keyboardType = UIKeyboardType.Default
        usernamereg.autocapitalizationType = .None
        usernamereg.autocorrectionType = .No
        usernamereg.font = UIFont(name: "forza-username", size: 45)
        signUpView.addSubview(usernamereg)
        
        // UITextField
        let pwPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        passwordreg.frame = (frame: CGRectMake(0, 305, self.view.bounds.size.width, 50));
        passwordreg.layer.borderColor = model.lightGrayColor.CGColor
        passwordreg.layer.borderWidth = 1.0
        passwordreg.leftView = pwPaddingView
        passwordreg.leftViewMode = UITextFieldViewMode.Always
        passwordreg.placeholder = "PASSWORD"
        passwordreg.backgroundColor = UIColor.whiteColor()
        passwordreg.delegate = self
        passwordreg.returnKeyType = .Next
        passwordreg.keyboardType = UIKeyboardType.Default
        passwordreg.secureTextEntry = true
        passwordreg.autocapitalizationType = .None
        passwordreg.autocorrectionType = .No
        passwordreg.font = UIFont(name: "forza-username", size: 45)
        signUpView.addSubview(passwordreg)
        
        // UITextField
        let cpwPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        confirmpasswordreg.frame = (frame: CGRectMake(0, 355, self.view.bounds.size.width, 50));
        confirmpasswordreg.layer.borderColor = model.lightGrayColor.CGColor
        confirmpasswordreg.layer.borderWidth = 1.0
        confirmpasswordreg.leftView = cpwPaddingView
        confirmpasswordreg.leftViewMode = UITextFieldViewMode.Always
        confirmpasswordreg.placeholder = "CONFIRM PASSWORD"
        confirmpasswordreg.backgroundColor = UIColor.whiteColor()
        confirmpasswordreg.delegate = self
        confirmpasswordreg.returnKeyType = .Done
        confirmpasswordreg.keyboardType = UIKeyboardType.Default
        confirmpasswordreg.secureTextEntry = true
        confirmpasswordreg.autocapitalizationType = .None
        confirmpasswordreg.autocorrectionType = .No
        confirmpasswordreg.font = UIFont(name: "forza-username", size: 45)
        signUpView.addSubview(confirmpasswordreg)
        
        let signUpButton = UIButton (frame: CGRectMake(0, 425, self.view.bounds.size.width, 50))
        signUpButton.setTitle("SIGN UP", forState: .Normal)
        signUpButton.addTarget(self, action: #selector(HomeViewController.checkInputFieldsButtonPress(_:)), forControlEvents: .TouchUpInside)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.backgroundColor = model.darkBlueColor
        signUpButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        signUpButton.tag = 1
        signUpView.addSubview(signUpButton)
        
        let closeSignUpFormButton = UIButton (frame: CGRectMake(15, 475, contentScrollView.bounds.size.width - 30, 40))
        closeSignUpFormButton.setTitle("CLOSE SIGNUP FORM", forState: .Normal)
        closeSignUpFormButton.addTarget(self, action: #selector(HomeViewController.showHideSignUpView), forControlEvents: .TouchUpInside)
        closeSignUpFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        closeSignUpFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        signUpView.addSubview(closeSignUpFormButton)
        
        
        var termsFrame = CGRect()
        var termsButtonFrame = CGRect()
        
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            var result = UIScreen.mainScreen().bounds.size
            let scale = UIScreen.mainScreen().scale
            result = CGSizeMake(result.width * scale, result.height * scale);
            if result.height == 1334 /*6*/{
                print("iPhone 6")
                termsFrame = CGRect(x: 70, y: closeSignUpFormButton.frame.origin.y + 50, width: 300, height: 20)
                termsButtonFrame = CGRect(x: 68, y: closeSignUpFormButton.frame.origin.y + 70, width: 125, height: 20)
            }else if result.height == 960 /*4s*/ {
                print("iPhone 4s")
                
                termsFrame = CGRect(x: 10, y: signUpButton.frame.origin.y - 20 , width: 300, height: 20)
                termsButtonFrame = CGRect(x: 147, y: signUpButton.frame.origin.y - 20 , width: 125, height: 20)
            }else if result.height == 2208 /*6 PLUS*/{
                print("iPhone 6 PLUS")
                termsFrame = CGRect(x: 30, y: closeSignUpFormButton.frame.origin.y + 50, width: self.view.bounds.size.width, height: 20)
                termsButtonFrame = CGRect(x: 267, y: closeSignUpFormButton.frame.origin.y + 50, width: 125, height: 20)
            }else if result.height == 1136 /*5/5s*/{
                print("iPhone 5/5s")
                
                termsFrame = CGRect(x: 40, y: closeSignUpFormButton.frame.origin.y + 35, width: 300, height: 20)
                termsButtonFrame = CGRect(x: 38, y: closeSignUpFormButton.frame.origin.y + 50, width: 125, height: 20)
                
            }else if result.height == 2001 {
                print("zoomed in iPhone six plus")
                
                termsFrame = CGRect(x: 10, y: closeSignUpFormButton.frame.origin.y + 50, width: self.view.bounds.size.width, height: 20)
                termsButtonFrame = CGRect(x: 245, y: closeSignUpFormButton.frame.origin.y + 50, width: 125, height: 20)
              
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            print("iPad")
            
            if  UIScreen.mainScreen().bounds.size.height == 1366 {
                print("iPad Pro !!!!!!!!!!!!!")
                termsFrame = CGRect(x: 280, y: closeSignUpFormButton.frame.origin.y + 50, width: self.view.bounds.size.width, height: 20)
                termsButtonFrame = CGRect(x: 590, y: closeSignUpFormButton.frame.origin.y + 50, width: 175, height: 20)

            }else {
                print("NOT iPAD PRO")
                termsFrame = CGRect(x: 210, y: closeSignUpFormButton.frame.origin.y + 50, width: self.view.bounds.size.width, height: 20)
                termsButtonFrame = CGRect(x: 445, y: closeSignUpFormButton.frame.origin.y + 50, width: 125, height: 20)
            }
            
            
        }
        
        let termsAndConditions = UILabel(frame:termsFrame)
        let termsLink = UIButton(frame: termsButtonFrame)

        termsAndConditions.text = "By using the HomeIn App you agree to our"
        
        termsAndConditions.textColor = UIColor.blackColor()
        signUpView.addSubview(termsAndConditions)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            var result = UIScreen.mainScreen().bounds.size
            let scale = UIScreen.mainScreen().scale
            result = CGSizeMake(result.width * scale, result.height * scale);
            if result.height == 1334 /*6*/{
                print("iPhone 6")
                termsAndConditions.font = UIFont(name: "forza-light", size: 12)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 12)
            }else if result.height == 960 /*4s*/ {
                print("iPhone 4s")
                termsAndConditions.font = UIFont(name: "forza-light", size: 8)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 8)

            }else if result.height == 2208 /*6 PLUS*/{
                print("iPhone 6 PLUS")
                termsAndConditions.font = UIFont(name: "forza-light", size: 12)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 12)
                
            }else if result.height == 1136 /*5/5s*/{
                print("iPhone 5/5s")
                termsAndConditions.font = UIFont(name: "forza-light", size: 12)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 12)
                
            }else if result.height == 2001 {
                print("zoomed in iPhone six plus")
                termsAndConditions.font = UIFont(name: "forza-light", size: 12)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 12)
                
            }
        }else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            print("iPad")
            
            if  UIScreen.mainScreen().bounds.size.height == 1366 {
                print("iPad Pro !!!!!!!!!!!!!")
                termsAndConditions.font = UIFont(name: "forza-light", size: 16)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 16)

            }else {
                print("NOT iPAD PRO")
                termsAndConditions.font = UIFont(name: "forza-light", size: 12)
                termsLink.titleLabel?.font = UIFont(name: "forza-light", size: 12)

            }
            
            
        }
        
        
        termsLink.setTitle("terms and conditions.", forState: .Normal)
        termsLink.addTarget(self, action: #selector(HomeViewController.termsAndConditions), forControlEvents: .TouchUpInside)
        
        termsLink.setTitleColor(UIColor.blueColor(), forState: .Normal)
        signUpView.addSubview(termsLink)
        
        swipeRec.direction = UISwipeGestureRecognizerDirection.Right
        swipeRec.addTarget(self, action: #selector(HomeViewController.swipeBackToLogin))
        signUpView.addGestureRecognizer(swipeRec)
        
        swipeRecReg.direction = UISwipeGestureRecognizerDirection.Down
        swipeRecReg.addTarget(self, action: #selector(HomeViewController.swipeDownToMoveSignUpViewDown))
        signUpView.addGestureRecognizer(swipeRecReg)
        
        signUpView.userInteractionEnabled = true
        
        let statusBarView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 25))
        statusBarView.backgroundColor = model.lightGrayColor
        self.view.addSubview(statusBarView)
    }
    
    func termsAndConditions(){
        
        print("terms and conditions tapped")
        let urlString = "https://www.firstmortgageco.com/privacy-policy"
        
        guard let URL = NSURL(string: urlString) else {
            print("unable to open terms and conditions URL")
            return
        }
        
        UIApplication.sharedApplication().openURL(URL)
    }
    
    // MARK:
    // MARK: Overlay Views
    func buildOverlay() {
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = model.lightGrayColor
        self.view.addSubview(overlayView)
        
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 75, overlayView.bounds.size.width - 30, 100))
        overLayTextLabel.text = "Are you currently working with a loan officer?"
        overLayTextLabel.textAlignment = NSTextAlignment.Center
        overLayTextLabel.textColor = UIColor.darkTextColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 32)
        overLayTextLabel.numberOfLines = 3
        overlayView.addSubview(overLayTextLabel)
        
        // UIView
        let noView = UIView(frame: CGRectMake(15, 200, overlayView.bounds.size.width - 30, 50))
        let noGradientLayer = CAGradientLayer()
        noGradientLayer.frame = noView.bounds
        noGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        noView.alpha = 1.0
        noView.layer.insertSublayer(noGradientLayer, atIndex: 0)
        noView.layer.addSublayer(noGradientLayer)
        overlayView.addSubview(noView)
        
        // UIButton
        let noButton = UIButton (frame: CGRectMake(0, 0, noView.bounds.size.width, 50))
        noButton.addTarget(self, action: #selector(HomeViewController.workingWithALoanOfficer(_:)), forControlEvents: .TouchUpInside)
        noButton.setTitle("NO", forState: .Normal)
        noButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        noButton.backgroundColor = UIColor.clearColor()
        noButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        noButton.contentHorizontalAlignment = .Center
        noButton.tag = 0
        noView.addSubview(noButton)
        
        // UIView
        let yesView = UIView(frame: CGRectMake(15, 300, overlayView.bounds.size.width - 30, 50))
        let yesGradientLayer = CAGradientLayer()
        yesGradientLayer.frame = yesView.bounds
        yesGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        yesView.alpha = 1.0
        yesView.layer.insertSublayer(yesGradientLayer, atIndex: 0)
        yesView.layer.addSublayer(yesGradientLayer)
        overlayView.addSubview(yesView)
        
        // UIButton
        let yesButton = UIButton (frame: CGRectMake(0, 0, yesView.bounds.size.width, 50))
        yesButton.addTarget(self, action: #selector(HomeViewController.workingWithALoanOfficer(_:)), forControlEvents: .TouchUpInside)
        yesButton.setTitle("YES", forState: .Normal)
        yesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        yesButton.backgroundColor = UIColor.clearColor()
        yesButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        yesButton.contentHorizontalAlignment = .Center
        yesButton.tag = 1
        yesView.addSubview(yesButton)
        
    }
    
    func buildLoanOfficerSeachOverLay(loArray: Array<Dictionary<String, String>>) {
        
        overlayView.removeFromSuperview()
        
        searchOverlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        searchOverlayView.backgroundColor = model.lightGrayColor
        searchOverlayView.hidden = false
        self.view.addSubview(searchOverlayView)
        
        var yVal = 15.0
        var count = 0
        
        // UILabel
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 25, overlayView.bounds.size.width - 80, 0))
        overLayTextLabel.text = "Please select a loan officer from the list below or use the search box to find your loan officer."
        overLayTextLabel.textAlignment = NSTextAlignment.Left
        overLayTextLabel.textColor = UIColor.darkTextColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 16)
        overLayTextLabel.numberOfLines = 0
        overLayTextLabel.sizeToFit()
        searchOverlayView.addSubview(overLayTextLabel)
        
        let dismissButton = UIButton (frame: CGRectMake(overlayView.bounds.size.width - 50, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: #selector(HomeViewController.workingWithALoanOfficer(_:)), forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 32)
        dismissButton.tag = 0
        searchOverlayView.addSubview(dismissButton)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 22)!
        ]
        
        let searchTxtPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        searchTxtField.frame = (frame: CGRectMake(15, 85, overlayView.bounds.size.width - 30, 50))
        searchTxtField.attributedPlaceholder = NSAttributedString(string: "SEARCH LOAN OFFICER", attributes:attributes)
        searchTxtField.backgroundColor = UIColor.whiteColor()
        searchTxtField.delegate = self
        searchTxtField.leftView = searchTxtPaddingView
        searchTxtField.leftViewMode = UITextFieldViewMode.Always
        searchTxtField.returnKeyType = .Done
        searchTxtField.keyboardType = UIKeyboardType.Default
        searchTxtField.tag = 999
        searchTxtField.font = UIFont(name: "forza-light", size: 22)
        searchTxtField.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        searchOverlayView.addSubview(searchTxtField)
        
        scrollView.frame = (frame: CGRectMake(0, 145, overlayView.bounds.size.width, overlayView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        searchOverlayView.addSubview(scrollView)
        
        if loArray.count > 0 {
            for loanOfficer in loArray {
                let nodeDict = loanOfficer as NSDictionary
                buildLoanOfficerCard(nodeDict as! Dictionary<String, String>, yVal: CGFloat(yVal), count: count)
                
                scrollView.contentSize = CGSize(width: overlayView.bounds.size.width, height: CGFloat(loArray.count * 175))
                yVal += 175
                count += 1
            }
        }
        else {
            // UILabel
            let noLOTextLabel = UILabel(frame: CGRectMake(15, 150, overlayView.bounds.size.width - 80, 0))
            noLOTextLabel.text = "We apologize but an error has occurred while getting the loan officer data. Please use the the X in the top right to close this window and continue with the sign up process."
            noLOTextLabel.textAlignment = NSTextAlignment.Left
            noLOTextLabel.textColor = UIColor.darkTextColor()
            noLOTextLabel.font = UIFont(name: "forza-light", size: 16)
            noLOTextLabel.numberOfLines = 0
            noLOTextLabel.sizeToFit()
            searchOverlayView.addSubview(noLOTextLabel)
        }
    }
    
    func buildLoanOfficerCard(nodeDict: Dictionary<String, String>, yVal: CGFloat, count: Int) -> UIView {
        // UIView
        let loView = UIView(frame: CGRectMake(15, yVal, scrollView.bounds.size.width - 30, 150))
        loView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(loView)
        
        var name = ""
        if let _ = nodeDict["name"] {
            name = nodeDict["name"]!
        }
        let nameLabel = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 24))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.text = name
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "forza-medium", size: 20)
        loView.addSubview(nameLabel)
        
        var email = ""
        if let _ = nodeDict["email"] {
            email = nodeDict["email"]!
        }
        let emailLabel = UILabel (frame: CGRectMake(15, 35, loView.bounds.size.width - 30, 24))
        emailLabel.textAlignment = NSTextAlignment.Left
        emailLabel.text = email
        emailLabel.numberOfLines = 1
        emailLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(emailLabel)
        
        var officePhone = ""
        if let _ = nodeDict["office"] {
            officePhone = nodeDict["office"]!
        }
        let officeLabel = UILabel (frame: CGRectMake(15, 60, loView.bounds.size.width - 30, 24))
        officeLabel.textAlignment = NSTextAlignment.Left
        officeLabel.text = String(format: "Office: %@", officePhone) //nodeDict["office"]
        officeLabel.numberOfLines = 1
        officeLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(officeLabel)
        
        var mobilePhone = ""
        if let _ = nodeDict["mobile"] {
            mobilePhone = nodeDict["mobile"]!
        }
        let mobileLabel = UILabel (frame: CGRectMake(15, 85, loView.bounds.size.width - 30, 24))
        mobileLabel.textAlignment = NSTextAlignment.Left
        mobileLabel.text = String(format: "Mobile: %@", mobilePhone)
        mobileLabel.numberOfLines = 1
        mobileLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(mobileLabel)
        
        var nmls = ""
        if let _ = nodeDict["nmls"] {
            nmls = nodeDict["nmls"]!
        }
        let nmlsLabel = UILabel (frame: CGRectMake(15, 115, loView.bounds.size.width - 30, 0))
        nmlsLabel.font = UIFont(name: "forza-light", size: 18)
        nmlsLabel.textAlignment = NSTextAlignment.Left
        nmlsLabel.text = String(format: "%@", nmls)
        nmlsLabel.numberOfLines = 0
        nmlsLabel.sizeToFit()
        loView.addSubview(nmlsLabel)
        
        // UIButton
        let selectButton = UIButton (frame: CGRectMake(0, 0, loView.bounds.size.width, loView.bounds.size.height))
        selectButton.addTarget(self, action: #selector(HomeViewController.setLoanOfficer(_:)), forControlEvents: .TouchUpInside)
        selectButton.backgroundColor = UIColor.clearColor()
        selectButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        selectButton.contentHorizontalAlignment = .Right
        selectButton.tag = count
        loView.addSubview(selectButton)
        
        return loView
    }
    
    func getBranchJSON() {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let nodes = self.model.getBranchLoanOfficers()
        
        self.loanOfficerArray.removeAll()
        self.tempArray.removeAll()
        
        for node in nodes {
            if let nodeDict = node as? NSDictionary {
                self.loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                self.tempArray.append(nodeDict as! Dictionary<String, String>)
            }
        }

        let now = NSDate()
        defaults.setObject(now, forKey: "loanOfficerArrayDateSet")
        defaults.setObject(self.loanOfficerArray, forKey: "loanOfficerArray")
        
        self.activityIndicator.stopAnimating()
        self.loadingOverlay.hidden = true
    }

    // MARK:
    // MARK: Show/Hide Views
    func showHideLoginView() {
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        if (!isLoginViewOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width  * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isLoginViewOpen = true
                    self.isLoginView = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width  * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isLoginViewOpen = false
                    self.isLoginView = false
            })
        }
    }
    
    func showHideSignUpView() {
        namereg.resignFirstResponder()
        emailreg.resignFirstResponder()
        usernamereg.resignFirstResponder()
        passwordreg.resignFirstResponder()
        confirmpasswordreg.resignFirstResponder()
        
        if (!isRegisterViewOpen) {
            if self.isLoginViewOpen == false {
                self.loginView.frame = (frame: CGRectMake(self.view.bounds.size.width * -1, self.view.bounds.height, self.view.bounds.width  * 2, self.view.bounds.height))
                
                /*************************** Fabric Analytics *********************************************/
                Answers.logCustomEventWithName("SignUp_View_Displayed", customAttributes: ["Category":"User_Action"])
                print("SignUp_View_Displayed")
                /************************* End Fabric Analytics *******************************************/


            }
            
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(self.view.bounds.size.width * -1, 0, self.view.bounds.width  * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isRegisterViewOpen = true
                    self.isRegisterView = true
                    self.isLoginViewOpen = false
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {

                
                /*************************** Fabric Analytics *********************************************/
                Answers.logCustomEventWithName("SignUp_View_Dismissed", customAttributes: ["Category":"User_Action"])
                print("SignUp_View_Dismissed")
                /************************* End Fabric Analytics *******************************************/

                self.loginView.frame = (frame: CGRectMake(self.view.bounds.size.width * -1, self.view.bounds.height, self.view.bounds.width  * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width  * 2, self.view.bounds.height))
                    self.isRegisterViewOpen = false
                    self.isLoginViewOpen = false
                    self.isRegisterView = false
            })
        }
    }
    
    func swipeBackToLogin() {
        UIView.animateWithDuration(0.4, animations: {
            self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width  * 2, self.view.bounds.height))
            }, completion: {
                (value: Bool) in
                
                self.isLoginViewOpen = true
                self.isLoginView = true
                
                self.isRegisterViewOpen = false
                self.isRegisterView = false
        })
    }
    
    func swipeDownToMoveSignUpViewDown() {
        UIView.animateWithDuration(0.4, animations: {
            self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, 0, self.view.bounds.width * 2, self.view.bounds.height))
            }, completion: {
                (value: Bool) in
                self.isLoginViewOpen = false
        })
    }
    
    func swipeDownToMoveLoginViewDown() {
        UIView.animateWithDuration(0.4, animations: {
            self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width * 2, self.view.bounds.height))
            }, completion: {
                (value: Bool) in
        })
    }

    // MARK:
    // MARK: Parse Login/Sign up
    func loginSignupUser(sender: Int) {
        PFUser.logOut()
        
        self.view.addSubview(loadingOverlay)
        
        if sender == 0 {
            if (username.text!.isEmpty != true && password.text!.isEmpty != true) {
                parseObject.loginPFUser(username.text!, password: password.text!)
            }
        }
        else if sender == 1 {
            
            activityIndicator.startAnimating()
            self.loadingOverlay.hidden = false
            overlayView.removeFromSuperview()
            
            let user = PFUser()
            
            user["name"] = namereg.text
            user.username = usernamereg.text
            user.password = passwordreg.text
            user.email = emailreg.text

            if hasLoanOfficer {
                user["officerNid"] = Int(officerNid)
                user["officerName"] = officerName
                user["officerURL"] = officerURL
            }
            
            parseObject.signUpPFUser(user)
        }
    }
    
    func forgotPassord() {
        let alertController = UIAlertController(title: "HomeIn", message: "Please enter your email address.", preferredStyle: .Alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            let emailTextField = alertController.textFields![0] as UITextField
            
            if self.model.isValidEmail(emailTextField.text!) {
                
                do {
                    try PFUser.requestPasswordResetForEmail((emailTextField.text?.lowercaseString)!)

                    
                } catch {
                    self.displayMessage("HomeIn", message: "We apologize but an error has occurred.")
                }
                self.displayMessage("HomeIn", message: "An email has been sent to the email address provided with instructions to reset your password.")
    
                
                /*************************** Fabric Analytics *********************************************/
                Answers.logCustomEventWithName("Password_Reset_Email_Requested", customAttributes: ["Category":"User_Action"])
                print("Password_Reset_Email_Requested")
                /************************* End Fabric Analytics *******************************************/


            }
            else {
                self.displayMessage("HomeIn", message: "Please Enter a valid email.")
            }
            
        }
        submitAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email Address"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                submitAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func continueWithoutLogin(sender: UIButton) {
        
        /*************************** Fabric Analytics *********************************************/
        Answers.logCustomEventWithName("No_Login_Creds_Entered_Signup_Bypassed", customAttributes: ["Category":"User_Action"])
        print("No_Login_Creds_Entered_Signup_Bypassed")
        /************************* End Fabric Analytics *******************************************/

        
        didContinueWithOut = true
        
        self.checkIfLoggedIn()
        self.caView.removeFromSuperview()
    }
    
    // MARK:
    // MARK: Actions
    func navigateToOtherViews(sender: UIButton) {
        switch sender.tag {
        case 0:
            performSegueWithIdentifier("myHomesViewController", sender: nil)
            
            /*************************** Fabric Analytics *********************************************/
            Answers.logCustomEventWithName("Nav_to_My_Homes", customAttributes: ["Category":"User_Action"])
            print("Navigate to MyHomes")
            /************************* End Fabric Analytics *******************************************/
            
        case 1:
            performSegueWithIdentifier("addHomeViewController", sender: nil)
            /*************************** Fabric Analytics *********************************************/
            Answers.logCustomEventWithName("Nav_to_addHome_View", customAttributes: ["Category":"User_Action"])
            print("Navigate to addHomes View")
            /************************* End Fabric Analytics *******************************************/
        case 2:
            isMortgageCalc = true
            performSegueWithIdentifier("calculatorsViewController", sender: nil)
            /*************************** Fabric Analytics *********************************************/
            Answers.logCustomEventWithName("Nav_to_Calc_View", customAttributes: ["Category":"User_Action"])
            print("Navigate to Calc")
            /************************* End Fabric Analytics *******************************************/
        case 3:
            performSegueWithIdentifier("viewAvailableVideos", sender: nil)
            /*************************** Fabric Analytics *********************************************/
            Answers.logCustomEventWithName("Nav_to_Video_View", customAttributes: ["Category":"User_Action"])
            print("Navigate to Videos")
            /************************* End Fabric Analytics *******************************************/
        case 4:
            performSegueWithIdentifier("findBranchViewController", sender: nil)
            /*************************** Fabric Analytics *********************************************/
            Answers.logCustomEventWithName("Nav_to_Find_Branch", customAttributes: ["Category":"User_Action"])
            print("Navigate to Branch Locator")
            /************************* End Fabric Analytics *******************************************/
        case 5:
            if let user = PFUser.currentUser() {
                if let url = user["officerURL"] {
                    let urlPath = url as! String
                    let cleanUrlPath = urlPath.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    UIApplication.sharedApplication().openURL(NSURL(string: cleanUrlPath)!)
                    /*************************** Fabric Analytics *********************************************/
                    Answers.logCustomEventWithName("User_Dismiss_App_For_Prequalification", customAttributes: ["Category":"User_Action"])
                    print("Navigate to Branch Locator")
                    /************************* End Fabric Analytics *******************************************/
                    
                }
            }
            
        case 6:
            showHideLoginView()
        case 7:
            didComeFromAccountPage = false
            performSegueWithIdentifier("profileViewController", sender: nil)
        default:
            print("Default")
        }
    }
    
    func loginSignupUserButtonPress(sender: UIButton) {
        if sender.tag == 0 {
            loginSignupUser(0)
        }
        else if sender.tag == 1 {
            loginSignupUser(1)
        }
        else {
            print("Default")
        }
    }
    
    func setLoanOfficer(sender: UIButton) {
        
        searchTxtField.text = ""
        
        var dict: [String:String]
        if tempArray.count > 0 {
            if sender.tag < tempArray.count {
                dict = tempArray[sender.tag]
            }
            else {
                dict = loanOfficerArray[sender.tag]
            }
        }
        else {
            dict = loanOfficerArray[sender.tag]
        }
        
        hasLoanOfficer = true
        
        if let _ = dict["nid"] {
            officerNid = dict["nid"]! as String
        }
        
        if let _ = dict["name"] {
            officerName = dict["name"]! as String
        }
        
        if let _ = dict["url"] {
            officerURL = dict["url"]! as String
        }
        
        if let _ = dict["email"] {
            officerEmail = dict["email"]! as String
            print(officerEmail)
        }

        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("loanOfficerDict")
        defaults.setObject(dict, forKey: "loanOfficerDict")
    
        loginSignupUser(1)
    }
    
    func workingWithALoanOfficer(sender: UIButton) {
        switch sender.tag {
        case 0:
            hasLoanOfficer = false;
            loginSignupUser(1)
        case 1:
            buildLoanOfficerSeachOverLay(loanOfficerArray)
        default:
            print("Default")
        }
    }
    
    func checkInputFieldsButtonPress(sender: UIButton) {
        
        if sender.tag == 0 {
            username.resignFirstResponder()
            password.resignFirstResponder()
            
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isLoginViewOpen = false
            })
        }
        else {
            usernamereg.resignFirstResponder()
            emailreg.resignFirstResponder()
            namereg.resignFirstResponder()
            passwordreg.resignFirstResponder()
            confirmpasswordreg.resignFirstResponder()
            
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, 0, self.view.bounds.width * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isLoginViewOpen = false
            })
        }

        checkInputFields(sender.tag)
    }

    // MARK:
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        
        if segue.identifier == "addHomeViewController" {
            let destViewController: AddHomeViewController = segue.destinationViewController as! AddHomeViewController
            destViewController.cameFromHomeScreen = true
        }
        
        if segue.identifier == "profileViewController" {
            let destViewController: ProfileViewController = segue.destinationViewController as! ProfileViewController
            destViewController.didComeFromAccountPage = didComeFromAccountPage
            destViewController.loanOfficerArray = loanOfficerArray
            destViewController.tempArray = loanOfficerArray
        }
        
        if segue.identifier == "calculatorsViewController" {
            let destViewController: CalculatorsViewController = segue.destinationViewController as! CalculatorsViewController
            destViewController.isMortgageCalc = isMortgageCalc
        }
        
        if segue.identifier == "viewAvailableVideos" {
            let destViewController: VideosViewController = segue.destinationViewController as! VideosViewController
            destViewController.cameFromHomeScreen = true
            
            
        }
        
        
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == searchTxtField {
            searchLoanOfficerArray(textField.text!)
            textField.resignFirstResponder()
            return true
        }
        
        if isLoginView {
            if textField == username {
                password.becomeFirstResponder()
                
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -75, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
                textField.resignFirstResponder()
                self.checkInputFields(0)
            }
        }
        
        //Register View
        if isRegisterView {
            if textField == self.namereg {
                self.emailreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -50, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else if textField == emailreg {
                usernamereg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -100, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else if textField == usernamereg {
                passwordreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -150, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else if textField == passwordreg {
                confirmpasswordreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -200, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, 0, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
                
                textField.resignFirstResponder()
                checkInputFields(1)
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Login View
        if isLoginView {
            if textField == password {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -65, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
        }
        
        //Register View
        if isRegisterView {
            if textField == self.namereg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -50, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else if textField == emailreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -100, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else if textField == usernamereg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -150, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
 
                })
            }
            else if textField == passwordreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -200, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else if textField == confirmpasswordreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -200, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in

                })
            }
            else {

            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        textField.becomeFirstResponder()
        searchLoanOfficerArray(textField.text!)
    }
    
    // MARK:
    // MARK: Utility Methods
    func searchLoanOfficerArray(searchText: String) {
        removeViews(scrollView)
        tempArray.removeAll()
        for loanOfficer in loanOfficerArray {
            if let lo = loanOfficer["name"] {
                if lo.containsString(searchText) {
                    tempArray.append(loanOfficer)
                }
            }
        }
        if tempArray.count > 0 {
            buildLoanOfficerSeachOverLay(tempArray)
        }
        else {
            buildLoanOfficerSeachOverLay(loanOfficerArray)

            if (searchText.characters.count > 0) {
                displayMessage("HomeIn", message: "We could not find any loan officers with that name.")
            }
        }
    }
    
    func checkIfLoggedIn() {

        let user = PFUser.currentUser()
        if (user == nil) {
            
            userButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 100, 0, 90, 50))
            userButton.setTitle("LOGIN", forState: .Normal)
            userButton.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            userButton.tag = 6
            
            if reachability.isConnectedToNetwork() == false {
                userButton.enabled = false
            }
            else {
                userButton.enabled = true

                
            }
            
            myHomesOverlay.hidden = false
            addAHomeOverlay.hidden = false
            preQualifiedOverlay.hidden = false
        }
        else {

            userButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 50, 5, 34, 40))
            userButton.setTitle("", forState: .Normal)
            userButton.setBackgroundImage(UIImage(named: "profile_icon"), forState: .Normal)
            
            userButton.tag = 7
            myHomesButton.enabled = true
            addAHomeButton.enabled = true
            
            if reachability.isConnectedToNetwork() {
                var url = ""
                if var _ = user!["officerURL"] {
                    let officerURL = user!["officerURL"] as! String
                    let trimmedOfficerURL = officerURL.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    url = trimmedOfficerURL
                }
                if (url.characters.count > 0) {
                    preQualifiedOverlay.hidden = true
                }
                else {
                    preQualifiedOverlay.hidden = false
                }
            }
            else {
                preQualifiedOverlay.hidden = false
            }
        }
    }
    
    func checkInputFields(sender: Int) {
        
        if (sender == 0) {
            self.username.resignFirstResponder()
            self.password.resignFirstResponder()
            if (username.text!.isEmpty != true && password.text!.isEmpty != true) {
                self.loginSignupUser(0)
            }
            else {
                displayMessage("HomeIn", message: "Plaese make sure you have filled out all the required fields.")
            }
        }
        else {
            self.namereg.resignFirstResponder()
            self.emailreg.resignFirstResponder()
            self.usernamereg.resignFirstResponder()
            self.passwordreg.resignFirstResponder()
            self.confirmpasswordreg.resignFirstResponder()
            
            if (namereg.text!.isEmpty != true && emailreg.text!.isEmpty != true && usernamereg.text!.isEmpty != true && passwordreg.text!.isEmpty != true && confirmpasswordreg.text!.isEmpty != true) {
                if (passwordreg.text == confirmpasswordreg.text) {
                    if (passwordreg.text?.characters.count > 5) {
                        if (model.isValidEmail(emailreg.text!)) {
                            buildOverlay()
                        }
                        else {
                            displayMessage("HomeIn", message: "Please Enter a valid email.")
                        }
                    }
                    else {
                        displayMessage("HomeIn", message: "Your password needs to be at least 6 characters long.")
                    }
                }
                else {
                    displayMessage("HomeIn", message:  "Your passwords do not match.")
                }
            }
            else {
                displayMessage("HomeIn", message: "Plaese make sure you have filled out all the required fields.")
            }
        }
    }
    
    // MARK:
    // MARK: Memory Management
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }
    
    // MARK:
    // MARK: ParseDataObject Delegate Methods
    func loginSucceeded() {
        
        /*************************** Fabric Analytics *********************************************/
        Answers.logLoginWithMethod("Parse",
            success: true,
            customAttributes: nil)
        print("Registered_User_login")
        /************************* End Fabric Analytics *******************************************/

        self.isUserLoggedIn = true
        
        self.username.text = ""
        self.password.text = ""
        
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
        
        self.contentScrollView.contentOffset.y = 0
        
        self.isLoginViewOpen = true
        self.caView.hidden = true
        self.myHomesOverlay.hidden = true
        self.addAHomeOverlay.hidden = true
        
        self.checkIfLoggedIn()
        self.showHideLoginView()
    }
    
    func loginFailed(errorMessage: String) {
        let errorMessageString = String(format: "%@ \n Username and password are case sensitive.", errorMessage)
        self.displayMessage("HomeIn", message: errorMessageString)
    }
    
    func signupSucceeded() {
   
        self.isUserLoggedIn = true
        
        self.namereg.resignFirstResponder()
        self.emailreg.resignFirstResponder()
        self.usernamereg.resignFirstResponder()
        self.passwordreg.resignFirstResponder()
        self.confirmpasswordreg.resignFirstResponder()
        
        self.contentScrollView.contentOffset.y = 0
        
        self.myHomesOverlay.hidden = true
        self.addAHomeOverlay.hidden = true
        
        self.checkIfLoggedIn()
        self.searchOverlayView.removeFromSuperview()
        self.caView.removeFromSuperview()
        self.showHideSignUpView()
        
        self.activityIndicator.stopAnimating()
        self.loadingOverlay.hidden = true
        
        self.didComeFromAccountPage = true
        self.performSegueWithIdentifier("profileViewController", sender: nil)
        
        if (self.hasLoanOfficer) {
            if (self.officerEmail.characters.count > 0) {
                

                parseObject.emailLoanOfficer(self.namereg.text!, email: self.emailreg.text!, loanOfficer: self.officerEmail)

                
            }
        }
        else {
            let alertController = UIAlertController(title: "HomeIn", message: "Some features of this app may be unavailable until you select a loan officer. You will be able to select a loan officer on your profile page.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
        self.namereg.text = ""
        self.usernamereg.text = ""
        self.emailreg.text = ""
        self.passwordreg.text = ""
        self.confirmpasswordreg.text = ""
    }
    
    func signupFailed(errorMessage: String) {
        
        /*************************** Fabric Analytics *********************************************/
            Answers.logCustomEventWithName("SignUp_Attempt_Failed", customAttributes: ["Category":"User_Action"])
            print("SignUp_Attempt_Failed")
        /************************* End Fabric Analytics *******************************************/
        
        self.removeViews(self.overlayView)
        self.activityIndicator.startAnimating()
        self.loadingOverlay.hidden = true
        
        self.displayMessage("HomeIn", message: errorMessage)
        self.searchOverlayView.hidden = true
    }
    
    // MARK:
    // MARK: UIAlert Method (Generic)
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
}