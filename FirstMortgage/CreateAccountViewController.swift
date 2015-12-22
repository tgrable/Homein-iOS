//
//  CreateAccountViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse
import ParseUI

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
    let scrollView = UIScrollView() as UIScrollView
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    // Login View
    let registerView = UIView()
    
    //UITextField
    let namereg = UITextField()
    let emailreg = UITextField()
    let usernamereg = UITextField()
    let passwordreg = UITextField()
    let confirmpasswordreg = UITextField()
    let searchTxtField = UITextField()
    
    // UITextView
    let addressRegister = UITextView()
    
    // Bool
    var optionOne = Bool()
    var optionTwo = Bool()
    var optionThree = Bool()
    var isRegisterViewOpen = Bool()
    
    var imageView = UIImageView() as UIImageView
    
    let locationManager = CLLocationManager()
    
    var activityIndicator = UIActivityIndicatorView()
    
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
        
        optionOne = true
        optionTwo = true
        optionThree = true
        
        buildCreateAccountView()
        buildSignUpView()
        
        loadingOverlay.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height))
        loadingOverlay.backgroundColor = UIColor.darkGrayColor()
        loadingOverlay.alpha = 0.85
        self.view.addSubview(loadingOverlay)
        
        let loadingLabel = UILabel (frame: CGRectMake(10, 75, loadingOverlay.bounds.size.width - 20, 0))
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.font = UIFont(name: "Arial", size: 25)
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.text = "Welcome to the HomeIn\n\nPlease hold tight while we gather up a bit of information."
        loadingLabel.numberOfLines = 0
        loadingLabel.sizeToFit()
        loadingOverlay.addSubview(loadingLabel)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        loadingOverlay.addSubview(activityIndicator)
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
        var fontSize = 18 as CGFloat
        if modelName.rangeOfString("5") != nil{
            fontSize = 12
        }
        
        registerView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, self.view.bounds.size.height - 85))
        registerView.backgroundColor = UIColor.whiteColor()
        registerView.hidden = false
        self.view.addSubview(registerView)
        
        let createAccountView = UIView(frame: CGRectMake(15, 50, registerView.bounds.size.width - 30, 40))
        let createAccountGradientLayer = CAGradientLayer()
        createAccountGradientLayer.frame = createAccountView.bounds
        createAccountGradientLayer.colors = [model.darkOrangeColor.CGColor, model.lightOrangeColor.CGColor]
        createAccountView.layer.insertSublayer(createAccountGradientLayer, atIndex: 0)
        createAccountView.layer.addSublayer(createAccountGradientLayer)
        registerView.addSubview(createAccountView)
        
        let createAccountButton = UIButton (frame: CGRectMake(15, 50, registerView.bounds.size.width - 30, 40))
        createAccountButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        createAccountButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        createAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        createAccountButton.backgroundColor = UIColor.clearColor()
        createAccountButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        createAccountButton.tag = 0
        registerView.addSubview(createAccountButton)
        
        let descLabel = UILabel (frame: CGRectMake(35, 115, registerView.bounds.size.width - 70, 40))
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.font = UIFont(name: "Arial", size: fontSize)
        descLabel.text = "Bacon ipsum dolor amet ribeye ball tip andouille, tail chuck t-bone turducken. Hamburger capicola prosciutto tenderloin."
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        registerView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "blue_check") as UIImage?
        
        let optionOneButton = UIButton (frame: CGRectMake(35, descLabel.bounds.size.height + 150, 25, 25))
        optionOneButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionOneButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionOneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionOneButton.tag = 1
        registerView.addSubview(optionOneButton)
        
        let optionOneLabel = UILabel (frame: CGRectMake(70, descLabel.bounds.size.height + 150, registerView.bounds.size.width - 125, 25))
        optionOneLabel.textAlignment = NSTextAlignment.Left
        optionOneLabel.font = UIFont(name: "Arial", size: fontSize)
        optionOneLabel.text = "Sausage drumstick salami"
        optionOneLabel.numberOfLines = 1
        registerView.addSubview(optionOneLabel)

        let optionTwoButton = UIButton (frame: CGRectMake(35, descLabel.bounds.size.height + 190, 25, 25))
        optionTwoButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionTwoButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionTwoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionTwoButton.tag = 2
        registerView.addSubview(optionTwoButton)
        
        let optionTwoLabel = UILabel (frame: CGRectMake(70, descLabel.bounds.size.height + 195, registerView.bounds.size.width - 125, 25))
        optionTwoLabel.textAlignment = NSTextAlignment.Left
        optionTwoLabel.font = UIFont(name: "Arial", size: fontSize)
        optionTwoLabel.text = "t-bone porchetta fatback jowl"
        optionTwoLabel.numberOfLines = 1
        registerView.addSubview(optionTwoLabel)
        
        let optionThreeButton = UIButton (frame: CGRectMake(35, descLabel.bounds.size.height + 230, 25, 25))
        optionThreeButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionThreeButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionThreeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionThreeButton.tag = 3
        registerView.addSubview(optionThreeButton)
        
        let optionThreeLabel = UILabel (frame: CGRectMake(70, descLabel.bounds.size.height + 235, registerView.bounds.size.width - 125, 25))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.font = UIFont(name: "Arial", size: fontSize)
        optionThreeLabel.text = "Prosciutto andouille biltong"
        optionThreeLabel.numberOfLines = 1
        registerView.addSubview(optionThreeLabel)
        
        let getStartedView = UIView(frame: CGRectMake(35, descLabel.bounds.size.height + 290, registerView.bounds.size.width - 70, 40))
        let getStartedGradientLayer = CAGradientLayer()
        getStartedGradientLayer.frame = getStartedView.bounds
        getStartedGradientLayer.colors = [model.darkBlueColor.CGColor, model.lightBlueColor.CGColor]
        getStartedView.layer.insertSublayer(getStartedGradientLayer, atIndex: 0)
        getStartedView.layer.addSublayer(getStartedGradientLayer)
        registerView.addSubview(getStartedView)
        
        let getStartedArrow = UILabel (frame: CGRectMake(getStartedView.bounds.size.width - 50, 0, 40, 40))
        getStartedArrow.textAlignment = NSTextAlignment.Right
        getStartedArrow.font = UIFont(name: "forza-light", size: 40)
        getStartedArrow.text = ">"
        getStartedArrow.textColor = UIColor.whiteColor()
        getStartedView.addSubview(getStartedArrow)
        
        let getStartedButton = UIButton (frame: CGRectMake(35, descLabel.bounds.size.height + 290, registerView.bounds.size.width - 70, 40))
        getStartedButton.setTitle("GET STARTED", forState: .Normal)
        getStartedButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        registerView.addSubview(getStartedButton)
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 340, registerView.bounds.size.width - 30, 40))
        continueWithoutButton.setTitle("CONTINUE WITHOUT", forState: .Normal)
        continueWithoutButton.addTarget(self, action: "continueWithoutLogin:", forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        continueWithoutButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        registerView.addSubview(continueWithoutButton)
    }
    
    func buildSignUpView() {
        loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height))
        loginView.backgroundColor = model.lightGrayColor
        self.view.addSubview(loginView)
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        loginView.addSubview(logoView)
        
        let dismissButton = UIButton (frame: CGRectMake(0, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: "showHideSignUpView", forControlEvents: .TouchUpInside)
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
        loginView.addSubview(namereg)
        
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
        loginView.addSubview(emailreg)
        
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
        loginView.addSubview(usernamereg)
        
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
        loginView.addSubview(passwordreg)
        
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
        loginView.addSubview(confirmpasswordreg)
        
        let signUpButton = UIButton (frame: CGRectMake(0, 425, self.view.bounds.size.width, 50))
        signUpButton.setTitle("SIGN UP", forState: .Normal)
        signUpButton.addTarget(self, action: "checkInputFields", forControlEvents: .TouchUpInside)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.backgroundColor = model.darkBlueColor
        signUpButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        signUpButton.tag = 1
        loginView.addSubview(signUpButton)
    }
    
    func showHideSignUpView() {
       
        if (!isRegisterViewOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                }, completion: {
                    (value: Bool) in
                    self.isRegisterViewOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height))
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
        
        if (passwordreg.text == confirmpasswordreg.text) {
            if (namereg.text!.isEmpty != true && emailreg.text!.isEmpty != true && usernamereg.text!.isEmpty != true && passwordreg.text!.isEmpty != true && confirmpasswordreg.text!.isEmpty != true) {
                buildOverlay()
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

    func optionChecked(sender: UIButton) {
        let checkMarkCheckedImage = UIImage(named: "blue_check") as UIImage?
        let checkMarkUncheckedImage = UIImage(named: "white_check") as UIImage?
        
        switch sender.tag {
        case 1:
            if optionOne {
                sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
                optionOne = false
            }
            else {
                sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
                optionOne = true
            }
        case 2:
            if optionTwo {
                sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
                optionTwo = false
            }
            else {
                sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
                optionTwo = true
            }
        case 3:
            if optionThree {
                sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
                optionThree = false
            }
            else {
                sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
                optionThree = true
            }
        default:
            print("")
            
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
                if lo.containsString(searchText) {
                    tempArray.append(loanOfficer)
                }
            }
        }
        buildLoanOfficerSeachOverLay(tempArray)
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
            else {
                UIView.animateWithDuration(0.4, animations: {
                    self.loginView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
                    }, completion: nil)
                
                textField.resignFirstResponder()
                checkInputFields()
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.namereg {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, -50, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == emailreg {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, -100, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == usernamereg {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, -150, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == passwordreg {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, -200, self.view.bounds.width, self.view.bounds.height))
                }, completion: nil)
        }
        else if textField == confirmpasswordreg {
            UIView.animateWithDuration(0.4, animations: {
                self.loginView.frame = (frame: CGRectMake(0, -200, self.view.bounds.width, self.view.bounds.height))
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
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 0.85
        self.view.addSubview(overlayView)
        
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 75, overlayView.bounds.size.width - 30, 0))
        overLayTextLabel.text = "Are you currently working with a loan officer?"
        overLayTextLabel.textAlignment = NSTextAlignment.Left
        overLayTextLabel.textColor = UIColor.whiteColor()
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
        overLayTextLabel.text = "You currently not assigned to a loan officer. Please select one from the list below."
        overLayTextLabel.textAlignment = NSTextAlignment.Left
        overLayTextLabel.textColor = UIColor.whiteColor()
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
    
    func setLoanOfficer(sender: UIButton) {
        let dict = tempArray[sender.tag]
        
        let nid = dict["nid"]! as String
        let name = dict["name"]! as String
        let officerURL = dict["url"]! as String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("loanOfficerDict")
        defaults.setObject(dict, forKey: "loanOfficerDict")
        
        print(dict)
        
        saveUserToParse(true, nid: nid, name: name, url: officerURL)
    }
    
    // MARK:
    // MARK: Parse
    func saveUserToParse(isWorkingWithAdvisor: Bool, nid: String, name: String, url: String) {
        print("saveUserOptionToParse")
        let user = PFUser()
        
        user["name"] = namereg.text
        user["optionOne"] = optionOne
        user["optionTwo"] = optionTwo
        user["optionThree"] = optionThree
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
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            } else {
                // Hooray! Let them use the app now.
                self.namereg.resignFirstResponder()
                self.emailreg.resignFirstResponder()
                self.usernamereg.resignFirstResponder()
                self.passwordreg.resignFirstResponder()
                self.confirmpasswordreg.resignFirstResponder()
                
                self.performSegueWithIdentifier("userLoggedIn", sender: self)
            }
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
