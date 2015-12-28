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
    
    let homeView = UIView()
    let myHomesView = UIView()
    let addHomesView = UIView()
    let preQualifiedView = UIView()
    let loginView = UIView()
    let signUpView = UIView()
    let overlayView = UIView()
    
    //UIScrollView
    let scrollView = UIScrollView()
    
    let username = UITextField()
    let password = UITextField()
    
    let namereg = UITextField()
    let emailreg = UITextField()
    let usernamereg = UITextField()
    let passwordreg = UITextField()
    let confirmpasswordreg = UITextField()
    let searchTxtField = UITextField()
    
    var imageView = UIImageView()

    var isMortgageCalc = Bool()
    let whiteBar = UIView()
    
    let swipeRec = UISwipeGestureRecognizer()
    
    // UIButton
    let myHomesButton = UIButton()
    let addAHomeButton = UIButton()
    let mortgageCalculatorButton = UIButton()
    let refiCalculatorButton = UIButton()
    let findBranchButton = UIButton()
    let preQualifiedButton = UIButton()
    let userButton = UIButton()
    
    var locationServicesIsAllowed = Bool()
    var isLoginViewOpen = Bool()
    var isRegisterViewOpen = Bool()
    
    var isLoginView = Bool()
    var isRegisterView = Bool()
    var hasLoanOfficer = Bool()
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    var officerNid = String()
    var officerName = String()
    var officerURL = String()
    
    let loadingOverlay = UIView()
    let loadingLabel = UILabel()
    
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
        buildHomeView()
        buildLoginView()
        buildSignUpView()
        
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
        
        homeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        homeView.backgroundColor = model.lightGrayColor
        homeView.hidden = false
        self.view.addSubview(homeView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((homeView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        homeView.addSubview(imageView)
        
        whiteBar.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        homeView.addSubview(whiteBar)
        
        let backgroundImage = UIImage(named: "homebackground") as UIImage?
        // UIImageView
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 135, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        backgroundImageView.image = backgroundImage
        homeView.addSubview(backgroundImageView)
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 135, self.view.bounds.size.width, self.view.bounds.size.height - 135))
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
            print("Should be blue")
        }
        else {
            addHomesView.backgroundColor = UIColor.grayColor()
            addAHomeButton.enabled = false
            print("Should be gray")
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
        if (locationServicesIsAllowed) {
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

        if (user != nil && url.characters.count > 0) {
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
    
    func buildLoginView() {
        loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width * 2, self.view.bounds.height))
        loginView.backgroundColor = model.lightGrayColor
        self.view.addSubview(loginView)
        
        print(loginView.bounds.size.width)
        
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
        username.frame = (frame: CGRectMake(0, 155, self.view.bounds.size.width, 50));
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
        password.frame = (frame: CGRectMake(0, 205, self.view.bounds.size.width, 50));
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
        
        let loginButton = UIButton (frame: CGRectMake(0, 275, self.view.bounds.size.width, 50))
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: "checkInputFieldsButtonPress:", forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = model.darkBlueColor
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginButton.tag = 0
        loginView.addSubview(loginButton)
        
        let getStartedButton = UIButton (frame: CGRectMake(0, 350, self.view.bounds.size.width, 50))
        getStartedButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        getStartedButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.backgroundColor = model.lightRedColor
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginView.addSubview(getStartedButton)
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
    
    
    
    // MARK:
    // MARK: Show/Hide Views
    func showHideLoginView() {
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
        self.isLoginView = false
        
        if (!isRegisterViewOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(self.view.bounds.size.width * -1, 0, self.view.bounds.width  * 2, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isRegisterViewOpen = true
                    self.isRegisterView = true
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
                        self.username.resignFirstResponder()
                        self.password.resignFirstResponder()
                        
                        self.checkIfLoggedIn()
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
                    self.namereg.resignFirstResponder()
                    self.emailreg.resignFirstResponder()
                    self.usernamereg.resignFirstResponder()
                    self.passwordreg.resignFirstResponder()
                    self.confirmpasswordreg.resignFirstResponder()
                    
                    self.checkIfLoggedIn()
                    self.removeViews(self.homeView)
                    self.buildHomeView()
                    self.showHideSignUpView()
                    
                    self.activityIndicator.stopAnimating()
                    self.loadingOverlay.hidden = true
                }
            }
        }
    }
    
    // MARK:
    // MARK: Actions
    func navigateToOtherViews(sender: UIButton) {
        switch sender.tag {
        case 0:
            let mhvc = self.storyboard!.instantiateViewControllerWithIdentifier("myHomesViewController") as! MyHomesViewController
            self.navigationController!.pushViewController(mhvc, animated: true)
        case 1:
            let ahvc = self.storyboard!.instantiateViewControllerWithIdentifier("addHomeViewController") as! AddHomeViewController
            self.navigationController!.pushViewController(ahvc, animated: true)
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
        
        removeViews(homeView)
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
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "profileViewController" {
            let destViewController: ProfileViewController = segue.destinationViewController as! ProfileViewController
            print(loanOfficerArray.count)
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
                    print(url)
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
                    self.loginView.frame = (frame: CGRectMake(0, -65, self.view.bounds.width * 2, self.view.bounds.height))
                    }, completion: {
                        (value: Bool) in
                        self.isLoginViewOpen = false
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