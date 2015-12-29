//
//  CreateAccountViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    // MARK:
    // MARK: Properties
    let model = Model()
    var parseUser = PFUser()
    let modelName = UIDevice.currentDevice().modelName
    
    //UIView
    let overlayView = UIView()
    let loadingOverlay = UIView()
    let loginView = UIView()
    let signUpView = UIView()
    
    //UIScrollView
    let scrollView = UIScrollView()
    let contentScrollView = UIScrollView()
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    // Login View
    let registerView = UIView()
    
    //UITextField
    let username = UITextField()
    let password = UITextField()
    
    let namereg = UITextField()
    let emailreg = UITextField()
    let usernamereg = UITextField()
    let passwordreg = UITextField()
    let confirmpasswordreg = UITextField()
    let searchTxtField = UITextField()
    
    // UITextView
    let addressRegister = UITextView()
    
    // Bool
    var isRegisterViewOpen = Bool()
    var isLoginViewOpen = Bool()
    
    var imageView = UIImageView()
    
    let locationManager = CLLocationManager()
    
    var activityIndicator = UIActivityIndicatorView()
    
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // UIImage
        let fmcLogo = UIImage(named: "home_in") as UIImage?

        // UIImageView
        imageView.frame = (frame: CGRectMake((self.view.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        self.view.addSubview(imageView)
        
        self.view.backgroundColor = model.lightGrayColor
        
        buildCreateAccountView()
        buildLoginView()
        buildSignUpView()
        
        loadingOverlay.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height))
        loadingOverlay.backgroundColor = UIColor.darkGrayColor()
        loadingOverlay.alpha = 0.85
        self.view.addSubview(loadingOverlay)
        
        loadingLabel.frame = (frame: CGRectMake(10, 75, loadingOverlay.bounds.size.width - 20, 0))
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.font = UIFont(name: "Arial", size: 25)
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.text = "Welcome to HomeIn\n\nPlease hold tight while we gather up the latest information from HomeIn."
        loadingLabel.numberOfLines = 0
        loadingLabel.sizeToFit()
        loadingOverlay.addSubview(loadingLabel)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = view.center
        loadingOverlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    override func viewDidAppear(animated: Bool) {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10;
        self.locationManager.requestWhenInUseAuthorization()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildCreateAccountView() {
        var fontSize = 16 as CGFloat
        if modelName.rangeOfString("5") != nil{
            fontSize = 14
        }
        
        registerView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, self.view.bounds.size.height - 85))
        registerView.backgroundColor = UIColor.whiteColor()
        registerView.hidden = false
        self.view.addSubview(registerView)
        
        let createAccountView = UIView(frame: CGRectMake(0, 0, registerView.bounds.size.width, 40))
        let createAccountGradientLayer = CAGradientLayer()
        createAccountGradientLayer.frame = createAccountView.bounds
        createAccountGradientLayer.colors = [model.darkOrangeColor.CGColor, model.lightOrangeColor.CGColor]
        createAccountView.layer.insertSublayer(createAccountGradientLayer, atIndex: 0)
        createAccountView.layer.addSublayer(createAccountGradientLayer)
        registerView.addSubview(createAccountView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, createAccountView.bounds.size.width, 40))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "CREATE AN ACCOUNT"
        createAccountLabel.numberOfLines = 1
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountView.addSubview(createAccountLabel)
        
        contentScrollView.frame = (frame: CGRectMake(0, 40, registerView.bounds.size.width, registerView.bounds.size.height - 50))
        contentScrollView.backgroundColor = UIColor.clearColor()
        registerView.addSubview(contentScrollView)
        
        let descLabel = UILabel (frame: CGRectMake(15, 10, contentScrollView.bounds.size.width - 30, 0))
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.font = UIFont(name: "Arial", size: fontSize)
        descLabel.text = "When you create a HomeIn account, you’re building a personal portfolio of all of the homes you visit. And you’ll be able to HomeIn on all of the features you loved (or didn’t love) about each property on your home buying  journey.\n\nHere’s what you can do with a HomeIn account:"
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        contentScrollView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "blue_check") as UIImage?
        
        var offset = descLabel.bounds.size.height + 25.0 as CGFloat
        
        let checkImageOne = UIImageView(frame: CGRectMake(20, offset, 25, 25))
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

        let checkImageTwo = UIImageView(frame: CGRectMake(20, offset, 25, 25))
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
        
        let checkImageThree = UIImageView(frame: CGRectMake(20, offset, 25, 25))
        checkImageThree.image = checkMarkImage
        contentScrollView.addSubview(checkImageThree)
        
        let optionThreeLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.font = UIFont(name: "Arial", size: fontSize)
        optionThreeLabel.text = "Connect with an expert First Mortgage Company  or Cunningham & Company Loan Officer to get pre-qualified for a home loan."
        optionThreeLabel.numberOfLines = 0
        optionThreeLabel.sizeToFit()
        contentScrollView.addSubview(optionThreeLabel)
        
        offset += optionThreeLabel.bounds.size.height + 10.0
        
        let checkImageFour = UIImageView(frame: CGRectMake(20, offset, 25, 25))
        checkImageFour.image = checkMarkImage
        contentScrollView.addSubview(checkImageFour)
        
        let optionFourLabel = UILabel (frame: CGRectMake(55, offset, contentScrollView.bounds.size.width - 65, 0))
        optionFourLabel.textAlignment = NSTextAlignment.Left
        optionFourLabel.font = UIFont(name: "Arial", size: fontSize)
        optionFourLabel.text = "Access valuable tools, such as a Mortgage Calculator and a Refinancing Calculator."
        optionFourLabel.numberOfLines = 0
        optionFourLabel.sizeToFit()
        contentScrollView.addSubview(optionFourLabel)
        
        offset += optionFourLabel.bounds.size.height + 10.0
        
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
        
        contentScrollView.contentSize = CGSize(width: registerView.bounds.size.width, height: 525)
    }
    
    func buildLoginView() {
        loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height))
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
        loginButton.addTarget(self, action: "loginUser", forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = model.darkBlueColor
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        loginButton.tag = 0
        loginView.addSubview(loginButton)
        
        let forGotPasswordFormButton = UIButton (frame: CGRectMake(15, 325, contentScrollView.bounds.size.width - 30, 40))
        forGotPasswordFormButton.setTitle("FORGOT PASSWORD?", forState: .Normal)
        forGotPasswordFormButton.addTarget(self, action: "forgotPassord", forControlEvents: .TouchUpInside)
        forGotPasswordFormButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        forGotPasswordFormButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        loginView.addSubview(forGotPasswordFormButton)
    }
    
    func buildSignUpView() {
        signUpView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height))
        signUpView.backgroundColor = model.lightGrayColor
        self.view.addSubview(signUpView)
        
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
        signUpButton.addTarget(self, action: "checkInputFields", forControlEvents: .TouchUpInside)
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
    }
    
    // MARK:
    // MARK: Show/Hide Views
    func showHideLoginView() {
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        if (!isLoginViewOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isLoginViewOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isLoginViewOpen = false
            })
        }
    }
    
    func showHideSignUpView() {
        self.namereg.resignFirstResponder()
        self.emailreg.resignFirstResponder()
        self.usernamereg.resignFirstResponder()
        self.passwordreg.resignFirstResponder()
        self.confirmpasswordreg.resignFirstResponder()
        
        if (!isRegisterViewOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isRegisterViewOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isRegisterViewOpen = false
            })
        }
    }
    
    func checkInputFields() {
        self.namereg.resignFirstResponder()
        self.emailreg.resignFirstResponder()
        self.usernamereg.resignFirstResponder()
        self.passwordreg.resignFirstResponder()
        self.confirmpasswordreg.resignFirstResponder()
        
        UIView.animateWithDuration(0.4, animations: {
            self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
            }, completion: nil)
        
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
                    let alertController = UIAlertController(title: "HomeIn", message: "Please Enter a valid password.", preferredStyle: .Alert)
                    
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

    func continueWithoutLogin(sender: UIButton) {
        performSegueWithIdentifier("userLoggedIn", sender: self)
    }
    
    func searchLoanOfficerArray(searchText: String) {
        removeViews(scrollView)
        tempArray.removeAll()
        for loanOfficer in loanOfficerArray {
            if let lo = loanOfficer["name"] {
                if lo.lowercaseString.containsString(searchText.lowercaseString) {
                    tempArray.append(loanOfficer)
                }
            }
        }
        if tempArray.count > 0 {
            buildLoanOfficerSeachOverLay(tempArray)
        }
        else {
            buildLoanOfficerSeachOverLay(loanOfficerArray)
            
            let alertController = UIAlertController(title: "HomeIn", message: "We could not find any loan officers with that name.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 999 {
            searchLoanOfficerArray(searchTxtField.text!)
        }
        else {
            if textField == self.namereg {
                self.emailreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -50, self.view.bounds.width, self.view.bounds.height))
                    }, completion: nil)
            }
            else if textField == emailreg {
                usernamereg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -100, self.view.bounds.width, self.view.bounds.height))
                    }, completion: nil)
            }
            else if textField == usernamereg {
                passwordreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -150, self.view.bounds.width, self.view.bounds.height))
                    }, completion: nil)
            }
            else if textField == passwordreg {
                confirmpasswordreg.becomeFirstResponder()
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, -200, self.view.bounds.width, self.view.bounds.height))
                    }, completion: nil)
            }
            else if textField == confirmpasswordreg {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                    }, completion: nil)
                
                textField.resignFirstResponder()
                checkInputFields()
            }
            else if textField == username {
                password.becomeFirstResponder()
            }
            else if textField == password {
                loginUser()
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.namereg {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, -50, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == emailreg {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, -100, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == usernamereg {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, -150, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == passwordreg {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, -200, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == confirmpasswordreg {
            UIView.animateWithDuration(0.4, animations: {
                self.signUpView.frame = (frame: CGRectMake(0, -200, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else {
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }

    func buildOverlay() {

        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = model.lightGrayColor
        self.view.addSubview(overlayView)
        
        showHideSignUpView()
        
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 75, overlayView.bounds.size.width - 30, 0))
        overLayTextLabel.text = "Are you currently working with a loan officer?"
        overLayTextLabel.textAlignment = NSTextAlignment.Left
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
        let yesView = UIView(frame: CGRectMake(15, 275, overlayView.bounds.size.width - 30, 50))
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
        searchTxtField.autocapitalizationType = .Words
        searchTxtField.autocorrectionType = .No
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
    
    func setLoanOfficer(sender: UIButton) {
        
        let dict = tempArray[sender.tag]
        
        let nid = dict["nid"]! as String
        let name = dict["name"]! as String
        let officerURL = dict["url"]! as String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("loanOfficerDict")
        defaults.setObject(dict, forKey: "loanOfficerDict")
        
        saveUserToParse(true, nid: nid, name: name, url: officerURL)
    }
    
    // MARK:
    // MARK: Parse Login/Sign up
    func saveUserToParse(isWorkingWithAdvisor: Bool, nid: String, name: String, url: String) {
        
        activityIndicator.startAnimating()
        self.loadingOverlay.hidden = false
        loadingLabel.text = "Creating Your Account"
        overlayView.removeFromSuperview()
        
        let user = PFUser()
        
        user["name"] = namereg.text
        user.username = usernamereg.text
        user.password = passwordreg.text
        user.email = emailreg.text
        
        if isWorkingWithAdvisor {
            user["officerNid"] = Int(nid)
            user["officerName"] = name
            user["officerURL"] = url
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
                
                self.activityIndicator.stopAnimating()
                self.performSegueWithIdentifier("userLoggedIn", sender: self)
                
                // TODO: Uncomment this when ready to deploy
                /*PFCloud.callFunctionInBackground("loanOfficer", withParameters: ["name" : self.namereg.text!, "email": self.emailreg.text!]) { (result: AnyObject?, error: NSError?) in
                    
                    print("----- Email LO -----")
                    // TODO: [Error]: success/error was not called (Code: 141, Version: 1.10.0)
                }*/
            }
        }
    }

    func loginUser() {
        if (username.text!.isEmpty != true && password.text!.isEmpty != true) {
            PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    self.username.resignFirstResponder()
                    self.password.resignFirstResponder()
                    
                    self.showHideLoginView()
                    self.performSegueWithIdentifier("userLoggedIn", sender: self)
                    
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
    
    func forgotPassord() {
        let alertController = UIAlertController(title: "HomeIn", message: "Please enter your email address.", preferredStyle: .Alert)
        
        let loginAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            let emailTextField = alertController.textFields![0] as UITextField
            
            if self.model.isValidEmail(emailTextField.text!) {

                do {
                    try PFUser.requestPasswordResetForEmail(emailTextField.text!)
                    
                } catch {
                    print("Error!")
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
    
    func workingWithALoanOfficer(sender: UIButton) {
        switch sender.tag {
        case 0:
            let alertController = UIAlertController(title: "HomeIn", message: "Some features of this app may be unavailable until you select a loan officer. You will be able to select a loan officer on your profile page.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.saveUserToParse(false, nid: "0", name: "", url: "")
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
    
    // MARK:
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "userLoggedIn") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! HomeViewController
            // your new view controller should have property that will store passed value
            viewController.loanOfficerArray = loanOfficerArray
            viewController.tempArray = loanOfficerArray
        }
    }
}
