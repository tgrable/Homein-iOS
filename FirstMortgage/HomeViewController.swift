//
//  HomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:
    // MARK: Properties
    var model = Model()
    let modelName = UIDevice.currentDevice().modelName
    
    //UIView
    let homeView = UIView()
    let myHomesView = UIView()
    let addHomesView = UIView()
    let preQualifiedView = UIView()
    let caView = UIView()
    let loginView = UIView()
    let signUpView = UIView()
    let overlayView = UIView()
    let whiteBar = UIView()
    let loadingOverlay = UIView()
    
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
    
    //UIImageView
    var imageView = UIImageView()

    //UIGestureRecognizer
    let swipeRec = UISwipeGestureRecognizer()
    
    // UIButton
    let myHomesButton = UIButton()
    let addAHomeButton = UIButton()
    let mortgageCalculatorButton = UIButton()
    let refiCalculatorButton = UIButton()
    let findBranchButton = UIButton()
    let preQualifiedButton = UIButton()
    let userButton = UIButton()
    
    //Bool
    var locationServicesIsAllowed = Bool()
    var isLoginViewOpen = Bool()
    var isRegisterViewOpen = Bool()
    var isMortgageCalc = Bool()
    var isUserLoggedIn = Bool()
    var isLoginView = Bool()
    var isRegisterView = Bool()
    var hasLoanOfficer = Bool()
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    //String
    var officerNid = String()
    var officerName = String()
    var officerURL = String()
    
    //UILabel
    let loadingLabel = UILabel()
    
    //UIActivityIndicatorView
    var activityIndicator = UIActivityIndicatorView()
    
    //Reachability
    let reachability = Reachability()
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (PFUser.currentUser() != nil) {
            isUserLoggedIn = true
        }
        else {
            isUserLoggedIn = false
        }

        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .NotDetermined, .Restricted: //, .Denied:
                    self.locationServicesIsAllowed = false
                case .AuthorizedAlways, .AuthorizedWhenInUse:
                    self.locationServicesIsAllowed = true
                default:
                    self.locationServicesIsAllowed = false
                }
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        myHomesButton.enabled = true
        addAHomeButton.enabled = true
        mortgageCalculatorButton.enabled = true
        refiCalculatorButton.enabled = true
        findBranchButton.enabled = true
        preQualifiedButton.enabled = true
        
        self.view.backgroundColor = model.lightGrayColor
        
        // UIImageView
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        imageView.frame = (frame: CGRectMake((self.view.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        self.view.addSubview(imageView)
        
        if (PFUser.currentUser() != nil) {
            buildHomeView()
        }
        else {
            buildCreateAccountView()
            buildLoginView()
            buildSignUpView()
        }

        loadingOverlay.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height))
        loadingOverlay.backgroundColor = UIColor.darkGrayColor()
        loadingOverlay.alpha = 0.85
        loadingOverlay.hidden = true
        self.view.addSubview(loadingOverlay)
        
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:
    // MARK: Build Views
    func buildHomeView() {
        
        var labelDist = 65.0 as CGFloat
        if (modelName.rangeOfString("6") != nil) {
            labelDist = 75.0
        }
        
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
        
        /********************************************************* My Homes Button ********************************************************************/
        // UIView
        myHomesView.frame = (frame: CGRectMake(0, CGFloat(offset), self.view.bounds.size.width / 2, (self.view.bounds.size.width / 2) * 0.75))
        if (PFUser.currentUser() != nil) {
            let myHomesGradientLayer = CAGradientLayer()
            myHomesGradientLayer.frame = myHomesView.bounds
            myHomesGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
            myHomesView.layer.insertSublayer(myHomesGradientLayer, atIndex: 0)
            myHomesView.layer.addSublayer(myHomesGradientLayer)
        }
        else {
            myHomesView.backgroundColor = UIColor.grayColor()
            myHomesButton.enabled = false
        }
        scrollView.addSubview(myHomesView)
        
        let homeIcn = UIImage(named: "icn-firstTime") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((myHomesView.bounds.size.width / 2) - 18, 25, 36, 36))
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
        myHomesButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        myHomesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myHomesButton.backgroundColor = UIColor.clearColor()
        myHomesButton.layer.borderWidth = 2
        myHomesButton.layer.borderColor = UIColor.whiteColor().CGColor
        myHomesButton.tag = 0
        myHomesView.addSubview(myHomesButton)
        
        /********************************************************* Add Homes Button ********************************************************************/
        // UIView
        addHomesView.frame = (frame: CGRectMake(self.view.bounds.size.width / 2, CGFloat(offset), self.view.bounds.size.width / 2, (self.view.bounds.size.width / 2) * 0.75))
        if (PFUser.currentUser() != nil) {
            let addHomesGradientLayer = CAGradientLayer()
            addHomesGradientLayer.frame = addHomesView.bounds
            addHomesGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
            addHomesView.layer.insertSublayer(addHomesGradientLayer, atIndex: 0)
            addHomesView.layer.addSublayer(addHomesGradientLayer)
        }
        else {
            addHomesView.backgroundColor = UIColor.grayColor()
            addAHomeButton.enabled = false
        }
        scrollView.addSubview(addHomesView)
 
        let addIcn = UIImage(named: "add_icon") as UIImage?
        let addHomeIcon = UIImageView(frame: CGRectMake((myHomesView.bounds.size.width / 2) - 18, 25, 26, 26))
        addHomeIcon.image = addIcn
        addHomesView.addSubview(addHomeIcon)
        
        // UILabel
        let addHomesLabel = UILabel(frame: CGRectMake(0, labelDist, myHomesView.bounds.size.width, 48))
        addHomesLabel.text = "ADD A\nHOME"
        addHomesLabel.font = UIFont(name: "forza-light", size: 18)
        addHomesLabel.textAlignment = NSTextAlignment.Center
        addHomesLabel.textColor = UIColor.whiteColor()
        addHomesLabel.numberOfLines = 2
        addHomesView.addSubview(addHomesLabel)
        
        addAHomeButton.frame = (frame: CGRectMake(0, 0, myHomesView.bounds.size.width, myHomesView.bounds.size.height))
        addAHomeButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        addAHomeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addAHomeButton.backgroundColor = UIColor.clearColor()
        addAHomeButton.layer.borderWidth = 2
        addAHomeButton.layer.borderColor = UIColor.whiteColor().CGColor
        addAHomeButton.tag = 1
        addHomesView.addSubview(addAHomeButton)
        
        offset = ((width / 2) * 0.75) + 15
        
        /********************************************************* Mortgage Calculator Button ********************************************************************/
        // UIView
        let mortgageCalculatorView = UIView(frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        let mortgageCalculatorGradientLayer = CAGradientLayer()
        mortgageCalculatorGradientLayer.frame = mortgageCalculatorView.bounds
        mortgageCalculatorGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        mortgageCalculatorView.layer.insertSublayer(mortgageCalculatorGradientLayer, atIndex: 0)
        mortgageCalculatorView.layer.addSublayer(mortgageCalculatorGradientLayer)
        scrollView.addSubview(mortgageCalculatorView)
        
        let calcIcn = UIImage(named: "icn-calculator") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake((mortgageCalculatorView.bounds.size.width / 2) - 18, 25, 36, 36))
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
        mortgageCalculatorButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        mortgageCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mortgageCalculatorButton.backgroundColor = UIColor.clearColor()
        mortgageCalculatorButton.layer.borderWidth = 2
        mortgageCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        mortgageCalculatorButton.tag = 2
        mortgageCalculatorView.addSubview(mortgageCalculatorButton)
        
        /********************************************************* Refinance Calculator Button ********************************************************************/
        // UIView
        let refiCalculatorView = UIView(frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        let refiCalculatorGradientLayer = CAGradientLayer()
        refiCalculatorGradientLayer.frame = refiCalculatorView.bounds
        refiCalculatorGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        refiCalculatorView.layer.insertSublayer(refiCalculatorGradientLayer, atIndex: 0)
        refiCalculatorView.layer.addSublayer(refiCalculatorGradientLayer)
        scrollView.addSubview(refiCalculatorView)
        
        let calcIconTwo = UIImageView(frame: CGRectMake((refiCalculatorView.bounds.size.width / 2) - 18, 25, 36, 36))
        calcIconTwo.image = calcIcn
        refiCalculatorView.addSubview(calcIconTwo)
        
        // UILabel
        let refiCalculatorLabel = UILabel(frame: CGRectMake(0, labelDist, refiCalculatorView.bounds.size.width, 48))
        refiCalculatorLabel.text = "REFINANCING\nCALCULATOR"
        refiCalculatorLabel.font = UIFont(name: "forza-light", size: 18)
        refiCalculatorLabel.textAlignment = NSTextAlignment.Center
        refiCalculatorLabel.numberOfLines = 2
        refiCalculatorLabel.textColor = UIColor.whiteColor()
        refiCalculatorView.addSubview(refiCalculatorLabel)
        
        refiCalculatorButton.frame = (frame: CGRectMake(0, 0, refiCalculatorView.bounds.size.width, refiCalculatorView.bounds.size.height))
        refiCalculatorButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        refiCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refiCalculatorButton.backgroundColor = UIColor.clearColor()
        refiCalculatorButton.layer.borderWidth = 2
        refiCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        refiCalculatorButton.tag = 3
        refiCalculatorView.addSubview(refiCalculatorButton)
        
        offset = (((width / 2) * 0.75) + (width / 2)) + 15
        
        /********************************************************* Find Branch Button ********************************************************************/
        // UIView
        let findBranchView = UIView(frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        if (locationServicesIsAllowed && reachability.isConnectedToNetwork()) {
            let findBranchGradientLayer = CAGradientLayer()
            findBranchGradientLayer.frame = findBranchView.bounds
            findBranchGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
            findBranchView.layer.insertSublayer(findBranchGradientLayer, atIndex: 0)
            findBranchView.layer.addSublayer(findBranchGradientLayer)
        }
        else {
            findBranchView.backgroundColor = UIColor.grayColor()
            findBranchButton.enabled = false
        }
        scrollView.addSubview(findBranchView)
        
        let brnchIcn = UIImage(named: "branch_icon") as UIImage?
        let branchIcon = UIImageView(frame: CGRectMake((findBranchView.bounds.size.width / 2) - 18, 25, 36, 36))
        branchIcon.image = brnchIcn
        findBranchView.addSubview(branchIcon)
        
        // UILabel
        let findBranchLabel = UILabel(frame: CGRectMake(0, labelDist, findBranchView.bounds.size.width, 72))
        findBranchLabel.text = "FIND THE\nCLOSEST\nBRANCH"
        findBranchLabel.font = UIFont(name: "forza-light", size: 18)
        findBranchLabel.textAlignment = NSTextAlignment.Center
        findBranchLabel.numberOfLines = 3
        findBranchLabel.textColor = UIColor.whiteColor()
        findBranchView.addSubview(findBranchLabel)
        
        findBranchButton.frame = (frame: CGRectMake(0, 0, findBranchView.bounds.size.width, findBranchView.bounds.size.height))
        findBranchButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        findBranchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        findBranchButton.backgroundColor = UIColor.clearColor()
        findBranchButton.layer.borderWidth = 2
        findBranchButton.layer.borderColor = UIColor.whiteColor().CGColor
        findBranchButton.tag = 4
        findBranchView.addSubview(findBranchButton)
        
        /********************************************************* Get Prequalified Button ********************************************************************/
         // UIView
        preQualifiedView.frame = (frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        let user = PFUser.currentUser()
        var url = ""
        if (PFUser.currentUser() != nil) {
            if var _ = user!["officerURL"] {
                url = user!["officerURL"] as! String
            }
        }

        if (user != nil && url.characters.count > 0 && reachability.isConnectedToNetwork()) {
            let preQualifiedGradientLayer = CAGradientLayer()
            preQualifiedGradientLayer.frame = preQualifiedView.bounds
            preQualifiedGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
            preQualifiedView.layer.insertSublayer(preQualifiedGradientLayer, atIndex: 0)
            preQualifiedView.layer.addSublayer(preQualifiedGradientLayer)
        }
        else {
            preQualifiedView.backgroundColor = UIColor.grayColor()
            preQualifiedButton.enabled = false
        }
        scrollView.addSubview(preQualifiedView)
        
        let checkIcn = UIImage(named: "icn-applyOnline") as UIImage?
        let checkIcon = UIImageView(frame: CGRectMake((preQualifiedView.bounds.size.width / 2) - 18, 25, 36, 36))
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
        preQualifiedButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        preQualifiedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        preQualifiedButton.backgroundColor = UIColor.clearColor()
        preQualifiedButton.layer.borderWidth = 2
        preQualifiedButton.layer.borderColor = UIColor.whiteColor().CGColor
        preQualifiedButton.tag = 5
        preQualifiedView.addSubview(preQualifiedButton)
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: ((self.view.bounds.size.width / 2) * 2) + (135 + 15))
        
        userButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 50, 5, 34, 40))
        userButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        userButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        userButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        userButton.contentHorizontalAlignment = .Right
        whiteBar.addSubview(userButton)
        
        checkIfLoggedIn()
    }
    
    func buildCreateAccountView() {
        getBranchJSON()
        
        var fontSize = 16 as CGFloat
        if modelName.rangeOfString("5") != nil{
            fontSize = 14
        }
        
        caView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, self.view.bounds.size.height - 85))
        caView.backgroundColor = UIColor.whiteColor()
        caView.hidden = false
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
        descLabel.text = "When you create a HomeIn account, you’re building a personal portfolio of all of the homes you visit. And you’ll be able to HomeIn on all of the features you loved (or didn’t love) about each property on your home buying  journey.\n\nHere’s what you can do with a HomeIn account:"
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        contentScrollView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "blue_check") as UIImage?
        
        var offset = descLabel.bounds.size.height + 25.0 as CGFloat
        
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
        
        offset += optionOneLabel.bounds.size.height + 10.0
        
        let checkImageTwo = UIImageView(frame: CGRectMake(20, offset + 3, 25, 25))
        checkImageTwo.image = checkMarkImage
        contentScrollView.addSubview(checkImageTwo)
        
        let optionTwoLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionTwoLabel.textAlignment = NSTextAlignment.Left
        optionTwoLabel.font = UIFont(name: "Arial", size: fontSize)
        optionTwoLabel.text = "Make notes about your saved homes and every room and feature"
        optionTwoLabel.numberOfLines = 0
        optionTwoLabel.sizeToFit()
        contentScrollView.addSubview(optionTwoLabel)
        
        offset += optionTwoLabel.bounds.size.height + 10.0
        
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
        
        offset += optionThreeLabel.bounds.size.height + 10.0
        
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
        
        offset += optionFiveLabel.bounds.size.height + 10.0
        
        let setUpLabel = UILabel (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 0))
        setUpLabel.textAlignment = NSTextAlignment.Left
        setUpLabel.font = UIFont(name: "Arial", size: fontSize)
        setUpLabel.text = "Set up your own HomeIn account today!"
        setUpLabel.numberOfLines = 0
        setUpLabel.sizeToFit()
        contentScrollView.addSubview(setUpLabel)
        
        offset += setUpLabel.bounds.size.height + 15.0
        
        let getStartedView = UIView(frame: CGRectMake(35, offset, contentScrollView.bounds.size.width - 70, 40))
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
        
        let getStartedButton = UIButton (frame: CGRectMake(35, offset, contentScrollView.bounds.size.width - 70, 40))
        getStartedButton.setTitle("GET STARTED", forState: .Normal)
        getStartedButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        contentScrollView.addSubview(getStartedButton)
        
        let btnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let btnView = UIImageView(frame: CGRectMake(0, getStartedView.bounds.size.height, getStartedView.bounds.size.width, 15))
        btnView.image = btnImg
        getStartedView.addSubview(btnView)
        
        offset += getStartedView.bounds.size.height + 10.0
        
        let loginButtonView = UIView(frame: CGRectMake(35, offset, contentScrollView.bounds.size.width - 70, 40))
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
        
        let loginButton = UIButton (frame: CGRectMake(35, offset, contentScrollView.bounds.size.width - 70, 40))
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: "showHideLoginView", forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        contentScrollView.addSubview(loginButton)
        
        let loginImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let loginShadowView = UIImageView(frame: CGRectMake(0, getStartedView.bounds.size.height, getStartedView.bounds.size.width, 15))
        loginShadowView.image = loginImg
        loginButtonView.addSubview(loginShadowView)
        
        offset += loginButtonView.bounds.size.height + 10.0
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, offset, contentScrollView.bounds.size.width - 30, 40))
        continueWithoutButton.setTitle("CONTINUE WITHOUT", forState: .Normal)
        continueWithoutButton.addTarget(self, action: "continueWithoutLogin:", forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        continueWithoutButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        contentScrollView.addSubview(continueWithoutButton)
        
        contentScrollView.contentSize = CGSize(width: caView.bounds.size.width, height: 575)
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
        dismissButton.addTarget(self, action: "showHideLoginView", forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 42)
        loginView.addSubview(dismissButton)
        
        let bannerView = UIView(frame: CGRectMake(0, 85, model.deviceWidth(), 50))
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
        loginButton.addTarget(self, action: "checkInputFieldsButtonPress:", forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = model.darkBlueColor
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginButton.tag = 0
        loginView.addSubview(loginButton)
        
        let getStartedButton = UIButton (frame: CGRectMake(0, 310, self.view.bounds.size.width, 50))
        getStartedButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        getStartedButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.backgroundColor = model.lightRedColor
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginView.addSubview(getStartedButton)
        
        let forGotPasswordFormButton = UIButton (frame: CGRectMake(0, 370, contentScrollView.bounds.size.width / 2, 30))
        forGotPasswordFormButton.setTitle("FORGOT PASSWORD?", forState: .Normal)
        forGotPasswordFormButton.addTarget(self, action: "forgotPassord", forControlEvents: .TouchUpInside)
        forGotPasswordFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        forGotPasswordFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 15)
        loginView.addSubview(forGotPasswordFormButton)
        
        let closeSignUpFormButton = UIButton (frame: CGRectMake(contentScrollView.bounds.size.width / 2, 370, contentScrollView.bounds.size.width / 2, 30))
        closeSignUpFormButton.setTitle("CLOSE LOGIN FORM", forState: .Normal)
        closeSignUpFormButton.addTarget(self, action: "showHideLoginView", forControlEvents: .TouchUpInside)
        closeSignUpFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        closeSignUpFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 15)
        loginView.addSubview(closeSignUpFormButton)
    }
    
    func buildSignUpView() {
        let signUpView = UIView(frame: CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        signUpView.backgroundColor = UIColor.clearColor()
        loginView.addSubview(signUpView)
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        signUpView.addSubview(logoView)
        
        let dismissButton = UIButton (frame: CGRectMake(0, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 42)
        signUpView.addSubview(dismissButton)
        
        let bannerView = UIView(frame: CGRectMake(0, 85, model.deviceWidth(), 50))
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
        signUpButton.addTarget(self, action: "checkInputFieldsButtonPress:", forControlEvents: .TouchUpInside)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.backgroundColor = model.darkBlueColor
        signUpButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        signUpButton.tag = 1
        signUpView.addSubview(signUpButton)
        
        let closeSignUpFormButton = UIButton (frame: CGRectMake(15, 475, contentScrollView.bounds.size.width - 30, 40))
        closeSignUpFormButton.setTitle("CLOSE SIGNUP FORM", forState: .Normal)
        closeSignUpFormButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        closeSignUpFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        closeSignUpFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        signUpView.addSubview(closeSignUpFormButton)
        
        swipeRec.direction = UISwipeGestureRecognizerDirection.Right
        swipeRec.addTarget(self, action: "swipeBackToLogin")
        signUpView.addGestureRecognizer(swipeRec)
        signUpView.userInteractionEnabled = true
    }
    
    // MARK:
    // MARK: Overlay Views
    func buildOverlay() {
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = model.lightGrayColor
        self.view.addSubview(overlayView)
        
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 75, overlayView.bounds.size.width - 30, 0))
        overLayTextLabel.text = "Are you currently working with a loan officer?"
        overLayTextLabel.textAlignment = NSTextAlignment.Center
        overLayTextLabel.textColor = UIColor.darkTextColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 32)
        overLayTextLabel.numberOfLines = 0
        overLayTextLabel.sizeToFit()
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
        noButton.addTarget(self, action: "workingWithALoanOfficer:", forControlEvents: .TouchUpInside)
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
        yesButton.addTarget(self, action: "workingWithALoanOfficer:", forControlEvents: .TouchUpInside)
        yesButton.setTitle("YES", forState: .Normal)
        yesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        yesButton.backgroundColor = UIColor.clearColor()
        yesButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        yesButton.contentHorizontalAlignment = .Center
        yesButton.tag = 1
        yesView.addSubview(yesButton)
        
    }
    
    func buildLoanOfficerSeachOverLay(loArray: Array<Dictionary<String, String>>) {
        
        removeViews(overlayView)
        
        var yVal = 15.0
        var count = 0
        
        // UILabel
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 25, overlayView.bounds.size.width - 30, 0))
        overLayTextLabel.text = "Please select a loan officer from the list below or use the search box to find your loan officer."
        overLayTextLabel.textAlignment = NSTextAlignment.Center
        overLayTextLabel.textColor = UIColor.darkTextColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 18)
        overLayTextLabel.numberOfLines = 0
        overLayTextLabel.sizeToFit()
        overlayView.addSubview(overLayTextLabel)
        
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
        overlayView.addSubview(searchTxtField)
        
        scrollView.frame = (frame: CGRectMake(0, 135, overlayView.bounds.size.width, overlayView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        overlayView.addSubview(scrollView)
        
        for loanOfficer in loArray {
            let nodeDict = loanOfficer as NSDictionary
            buildLoanOfficerCard(nodeDict as! Dictionary<String, String>, yVal: CGFloat(yVal), count: count)
            
            scrollView.contentSize = CGSize(width: overlayView.bounds.size.width, height: CGFloat(loArray.count * 135))
            yVal += 130
            count++
        }
    }
    
    func buildLoanOfficerCard(nodeDict: Dictionary<String, String>, yVal: CGFloat, count: Int) -> UIView {
        // UIView
        let loView = UIView(frame: CGRectMake(15, yVal, scrollView.bounds.size.width - 30, 120))
        loView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(loView)
        
        let nameLabel = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 24))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.text = nodeDict["name"]
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "forza-light", size: 24)
        loView.addSubview(nameLabel)
        
        let emailLabel = UILabel (frame: CGRectMake(15, 35, loView.bounds.size.width - 30, 24))
        emailLabel.textAlignment = NSTextAlignment.Left
        emailLabel.text = nodeDict["email"]
        emailLabel.numberOfLines = 1
        emailLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(emailLabel)
        
        let officeLabel = UILabel (frame: CGRectMake(15, 60, loView.bounds.size.width - 30, 24))
        officeLabel.textAlignment = NSTextAlignment.Left
        officeLabel.text = nodeDict["office"]
        officeLabel.numberOfLines = 1
        officeLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(officeLabel)
        
        let mobileLabel = UILabel (frame: CGRectMake(15, 85, loView.bounds.size.width - 30, 24))
        mobileLabel.textAlignment = NSTextAlignment.Left
        mobileLabel.text = nodeDict["mobile"]
        mobileLabel.numberOfLines = 1
        mobileLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(mobileLabel)
        
        // UIButton
        let selectButton = UIButton (frame: CGRectMake(0, 0, loView.bounds.size.width, loView.bounds.size.height))
        selectButton.addTarget(self, action: "setLoanOfficer:", forControlEvents: .TouchUpInside)
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
        
        let nodes = self.model.getBranchLoanOfficers()
        
        self.loanOfficerArray.removeAll()
        self.tempArray.removeAll()
        
        for node in nodes {
            if let nodeDict = node as? NSDictionary {
                self.loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                self.tempArray.append(nodeDict as! Dictionary<String, String>)
            }
        }
        
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

    // MARK:
    // MARK: Parse Login/Sign up
    func loginSignupUser(sender: Int) {
        if sender == 0 {
            if (username.text!.isEmpty != true && password.text!.isEmpty != true) {
                PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        self.isUserLoggedIn = true
                        
                        self.username.text = ""
                        self.password.text = ""
                        
                        self.username.resignFirstResponder()
                        self.password.resignFirstResponder()
                        
                        self.contentScrollView.contentOffset.y = 0
                        
                        self.isLoginViewOpen = false
                        
                        self.checkIfLoggedIn()
                        self.caView.removeFromSuperview()
                        self.removeViews(self.homeView)
                        self.buildHomeView()
                        self.showHideLoginView()
                        
                    } else {
                        let message = error!.localizedDescription as String
                        let alertController = UIAlertController(title: "HomeIn", message: message, preferredStyle: .Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            // ...
                        }
                        alertController.addAction(OKAction)
                        
                        self.presentViewController(alertController, animated: true) {
                            // ...
                        }
                    }
                }
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
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {

                    self.removeViews(self.overlayView)
                    self.activityIndicator.startAnimating()
                    self.loadingOverlay.hidden = true
                    
                    let errorString = error.userInfo["error"] as? String
                    
                    let alertController = UIAlertController(title: "HomeIn", message: errorString, preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                } else {
                    // Hooray! Let them use the app now.
                    self.isUserLoggedIn = true
                    
                    self.namereg.text = ""
                    self.usernamereg.text = ""
                    self.emailreg.text = ""
                    self.passwordreg.text = ""
                    self.confirmpasswordreg.text = ""
                    
                    self.namereg.resignFirstResponder()
                    self.emailreg.resignFirstResponder()
                    self.usernamereg.resignFirstResponder()
                    self.passwordreg.resignFirstResponder()
                    self.confirmpasswordreg.resignFirstResponder()
                    
                    self.contentScrollView.contentOffset.y = 0
                    
                    self.checkIfLoggedIn()
                    self.caView.removeFromSuperview()
                    self.removeViews(self.homeView)
                    self.buildHomeView()
                    self.showHideSignUpView()
                    
                    self.activityIndicator.stopAnimating()
                    self.loadingOverlay.hidden = true
                    
                    // TODO: Uncomment this when ready to deploy
                    /*PFCloud.callFunctionInBackground("loanOfficer", withParameters: ["name" : self.namereg.text!, "email": self.emailreg.text!]) { (result: AnyObject?, error: NSError?) in
                    
                    print("----- Email LO -----")
                    // TODO: [Error]: success/error was not called (Code: 141, Version: 1.10.0)
                    }*/
                }
            }
        }
    }
    
    func forgotPassord() {
        let alertController = UIAlertController(title: "HomeIn", message: "Please enter your email address.", preferredStyle: .Alert)
        
        let loginAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            let emailTextField = alertController.textFields![0] as UITextField
            
            if self.model.isValidEmail(emailTextField.text!) {
                
                do {
                    try PFUser.requestPasswordResetForEmail(emailTextField.text!)
                    
                } catch {
                    let alertController = UIAlertController(title: "HomeIn", message: "We apologize but an error has occurred", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
                
                let alertController = UIAlertController(title: "HomeIn", message: "An email has been sent to the email address provided with instructions to reset your password.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
            else {
                let alertController = UIAlertController(title: "HomeIn", message: "Please Enter a valid email.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
            
        }
        loginAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email Address"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    // MARK:
    // MARK: Actions
    func navigateToOtherViews(sender: UIButton) {
        myHomesButton.enabled = false
        addAHomeButton.enabled = false
        mortgageCalculatorButton.enabled = false
        refiCalculatorButton.enabled = false
        findBranchButton.enabled = false
        preQualifiedButton.enabled = false
        
        switch sender.tag {
        case 0:
            performSegueWithIdentifier("myHomesViewController", sender: nil)
        case 1:
            performSegueWithIdentifier("addHomeViewController", sender: nil)
        case 2:
            isMortgageCalc = true
            performSegueWithIdentifier("calculatorsViewController", sender: nil)
        case 3:
            isMortgageCalc = false
            performSegueWithIdentifier("calculatorsViewController", sender: nil)
        case 4:
            let cvc = self.storyboard!.instantiateViewControllerWithIdentifier("findBranchViewController") as! FindBranchViewController
            self.navigationController!.pushViewController(cvc, animated: true)
        case 5:
            performSegueWithIdentifier("webViewController", sender: nil)
        case 6:
            showHideLoginView()
        case 7:
            let pvc = self.storyboard!.instantiateViewControllerWithIdentifier("profileViewController") as! ProfileViewController
            self.navigationController!.pushViewController(pvc, animated: true)
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
            
        }
    }
    
    func setLoanOfficer(sender: UIButton) {
        let dict = tempArray[sender.tag]
        
        hasLoanOfficer = true
        
        officerNid = dict["nid"]! as String
        officerName = dict["name"]! as String
        officerURL = dict["url"]! as String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("loanOfficerDict")
        defaults.setObject(dict, forKey: "loanOfficerDict")
    
        loginSignupUser(1)
    }
    
    func workingWithALoanOfficer(sender: UIButton) {
        switch sender.tag {
        case 0:
            let alertController = UIAlertController(title: "HomeIn", message: "Some features of this app may be unavailable until you select a loan officer. You will be able to select a loan officer on your profile page.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.loginSignupUser(1)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
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
        
        if segue.identifier == "profileViewController" {
            let destViewController: ProfileViewController = segue.destinationViewController as! ProfileViewController
            destViewController.loanOfficerArray = loanOfficerArray
            destViewController.tempArray = loanOfficerArray
        }
        
        if segue.identifier == "calculatorsViewController" {
            let destViewController: CalculatorsViewController = segue.destinationViewController as! CalculatorsViewController
            destViewController.isMortgageCalc = isMortgageCalc
        }
        
        if segue.identifier == "webViewController" {
            let webViewDestController: WebViewController = segue.destinationViewController as! WebViewController
            if let user = PFUser.currentUser() {
                if let url = user["officerURL"] {
                    webViewDestController.urlPath = url as! String
                }
            }
        }
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Login View
        if isLoginView {
            if textField == username {
                password.becomeFirstResponder()
                
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -75, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = true
                })
            }
            else {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
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
                        self.isLoginViewOpen = false
                })
            }
            else if textField == emailreg {
                usernamereg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -100, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else if textField == usernamereg {
                passwordreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -150, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else if textField == passwordreg {
                confirmpasswordreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -200, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, 0, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
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
                        self.isLoginViewOpen = false
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
                        self.isLoginViewOpen = false
                })
            }
            else if textField == emailreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -100, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else if textField == usernamereg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -150, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else if textField == passwordreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -200, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else if textField == confirmpasswordreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(self.view.bounds.width * -1, -200, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
                })
            }
            else {

            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
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
        buildLoanOfficerSeachOverLay(tempArray)
    }
    
    func checkIfLoggedIn() {
        let user = PFUser.currentUser()
        if (user == nil) {
            userButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 100, 0, 90, 50))
            userButton.setTitle("LOGIN", forState: .Normal)
            
            userButton.tag = 6
            
            myHomesButton.enabled = false
            addAHomeButton.enabled = false
            preQualifiedButton.enabled = false
        }
        else {
            userButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 50, 5, 34, 40))
            userButton.setTitle("", forState: .Normal)
            userButton.setBackgroundImage(UIImage(named: "account_icon"), forState: .Normal)
            
            userButton.tag = 7
            myHomesButton.enabled = true
            addAHomeButton.enabled = true
            
            var url = ""
            if var _ = user!["officerURL"] {
                url = user!["officerURL"] as! String
            }
            
            if (url.characters.count > 0) {
                preQualifiedButton.enabled = true
            }
            else {
                preQualifiedButton.enabled = false
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
                let alertController = UIAlertController(title: "HomeIn", message: "Plaese make sure you have filled out all the required fields.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
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
                            let alertController = UIAlertController(title: "HomeIn", message: "Please Enter a valid email.", preferredStyle: .Alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                // ...
                            }
                            alertController.addAction(OKAction)
                            
                            self.presentViewController(alertController, animated: true) {
                                // ...
                            }
                        }
                    }
                    else {
                        let alertController = UIAlertController(title: "HomeIn", message: "Your password needs to be at least 6 characters long.", preferredStyle: .Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            // ...
                        }
                        alertController.addAction(OKAction)
                        
                        self.presentViewController(alertController, animated: true) {
                            // ...
                        }
                    }
                }
                else {
                    let alertController = UIAlertController(title: "HomeIn", message: "Your passwords do not match.", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
            }
            else {
                let alertController = UIAlertController(title: "HomeIn", message: "Plaese make sure you have filled out all the required fields.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
        }
    }
    
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }
}