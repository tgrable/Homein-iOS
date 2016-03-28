//
//  ProfileViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/15/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse
import Answers
import Crashlytics

class ProfileViewController: UIViewController, ParseDataDelegate, UITextFieldDelegate {
    // MARK:
    // MARK: Properties
    let model = Model()
    let modelName = UIDevice.currentDevice().modelName
    let parseObject = ParseDataObject()
    //Reachability
    let reachability = Reachability()
    
    // UIView
    //let profileView = UIView()
    let overlayView = UIView()
    let calculateView = UIView()
    let loView = UIView()
    let loadingOverlay = UIView()
    let singleLoView = UIView()
    
    // UIGradientLayer
    let calcGradientLayer = CAGradientLayer()
    
    //UIImageView
    let imageView = UIImageView() as UIImageView
    
    //UIScrollView
    let scrollView = UIScrollView() as UIScrollView
    let profileView = UIScrollView()
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    // UITextField
    let nameTxtField = UITextField() as UITextField
    let emailTxtField = UITextField() as UITextField
    let searchTxtField = UITextField() as UITextField
    
    // UIButton
    let updateUserButton = UIButton ()
    let editButton = UIButton ()
    let loButton = UIButton ()
    
    let editIcon = UIImageView()
    
    let overLayTextLabel = UILabel()
    let calculateArrow = UILabel ()
    let editModeLabel = UILabel()
    var officerEmail = String()
    
    var isTextFieldEnabled = Bool()
    var didComeFromAccountPage = Bool()

    var activityIndicator = UIActivityIndicatorView()
    let loActivityIndicator = UIActivityIndicatorView()
    
    let user = PFUser.currentUser()
    
    var buttonOffset = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseObject.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        displayMessage("HomeIn", message: "Your device is low on memory and may need to shut down this app.")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = model.lightGrayColor

        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 22)!
        ]
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((self.view.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        self.view.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(whiteBar)
        
        if didComeFromAccountPage == false {
            let backIcn = UIImage(named: "back_grey") as UIImage?
            let backIcon = UIImageView(frame: CGRectMake(20, 10, 30, 30))
            backIcon.image = backIcn
            whiteBar.addSubview(backIcon)
        }
        
        // UILabel
        editModeLabel.frame = (frame: CGRectMake(25, 0, whiteBar.bounds.size.width - 50, 50))
        editModeLabel.text = "EDIT MODE"
        editModeLabel.textAlignment = NSTextAlignment.Center
        editModeLabel.textColor = UIColor.whiteColor()
        editModeLabel.font = UIFont(name: "forza-light", size: 24)
        whiteBar.addSubview(editModeLabel)
        
        // UIButton
        let editIcn = UIImage(named: "edit_icon") as UIImage?
        editIcon.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 55, 7.5, 41.25, 35))
        editIcon.image = editIcn
        whiteBar.addSubview(editIcon)
        
        editButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 60, 0, 60, 50))
        editButton.addTarget(self, action: #selector(ProfileViewController.allowEdit(_:)), forControlEvents: .TouchUpInside)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        whiteBar.addSubview(editButton)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(5, 0, 100, 50))
        homeButton.addTarget(self, action: #selector(ProfileViewController.navigateBackHome(_:)), forControlEvents: .TouchUpInside)
        if (didComeFromAccountPage) {
            homeButton.setTitle("HOME", forState: .Normal)
        }
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)!
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, self.view.bounds.size.width, 50))
        let addHomeBannerGradientLayer = CAGradientLayer()
        addHomeBannerGradientLayer.frame = addHomeBannerView.bounds
        addHomeBannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        addHomeBannerView.layer.insertSublayer(addHomeBannerGradientLayer, atIndex: 0)
        addHomeBannerView.layer.addSublayer(addHomeBannerGradientLayer)
        addHomeBannerView.hidden = false
        self.view.addSubview(addHomeBannerView)
        
        //UIImageView
        let homeIcn = UIImage(named: "profile_white") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((addHomeBannerView.bounds.size.width / 2) - (12.5 + 125), 12.5, 25, 25))
        homeIcon.image = homeIcn
        addHomeBannerView.addSubview(homeIcon)
        
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(15, 0, addHomeBannerView.bounds.size.width, 50))
        bannerLabel.text = "USER PROFILE"
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.font = UIFont(name: "forza-light", size: 25)
        addHomeBannerView.addSubview(bannerLabel)
        
        profileView.frame = (frame: CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        profileView.backgroundColor = model.lightGrayColor
        profileView.hidden = false
        self.view.addSubview(profileView)
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = model.lightGrayColor
        overlayView.hidden = true
        self.view.addSubview(overlayView)
        
        // UILabel
        overLayTextLabel.frame = (frame: CGRectMake(15, 25, overlayView.bounds.size.width - 80, 0))
        overLayTextLabel.text = "Please select a loan officer from the list below or use the search box to find your loan officer."
        overLayTextLabel.textAlignment = NSTextAlignment.Left
        overLayTextLabel.textColor = UIColor.darkTextColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 16)
        overLayTextLabel.numberOfLines = 0
        overLayTextLabel.sizeToFit()
        overlayView.addSubview(overLayTextLabel)
        
        let dismissButton = UIButton (frame: CGRectMake(overlayView.bounds.size.width - 50, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: #selector(ProfileViewController.dismissOverlayView(_:)), forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 32)
        overlayView.addSubview(dismissButton)
        
        let searchTxtPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        searchTxtField.frame = (frame: CGRectMake(15, 85, profileView.bounds.size.width - 30, 50))
        searchTxtField.attributedPlaceholder = NSAttributedString(string: "SEARCH LOAN OFFICER", attributes:attributes)
        searchTxtField.backgroundColor = UIColor.whiteColor()
        searchTxtField.delegate = self
        searchTxtField.leftView = searchTxtPaddingView
        searchTxtField.leftViewMode = UITextFieldViewMode.Always
        searchTxtField.returnKeyType = .Done
        searchTxtField.keyboardType = UIKeyboardType.Default
        searchTxtField.autocorrectionType = .No
        searchTxtField.autocapitalizationType = .Words
        searchTxtField.tag = 999
        searchTxtField.font = UIFont(name: "forza-light", size: 22)
        searchTxtField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        overlayView.addSubview(searchTxtField)
        
        scrollView.frame = (frame: CGRectMake(0, 145, overlayView.bounds.size.width, overlayView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        overlayView.addSubview(scrollView)
        
        loActivityIndicator.center = CGPointMake(profileView.frame.size.width / 2, 225);
        loActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loActivityIndicator.startAnimating()
        profileView.addSubview(loActivityIndicator)
        
        buildProfileView()
    }

    override func viewDidAppear(animated: Bool) {
        getUserAndLoInfo()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if self.reachability.isConnectedToNetwork() == false {
            if (defaults.objectForKey("loanOfficerArray") != nil) {
                self.loanOfficerArray = defaults.objectForKey("loanOfficerArray") as! Array
                self.tempArray = defaults.objectForKey("loanOfficerArray") as! Array
            }
            getLoInfoFromDictionary()
            
            displayMessage("HomeIn", message: "This device currently has no internet connection.\n\nUpdating a loan officer will not be possible until an internet connection is reestablished.")
        }
        else {
            
            if (defaults.objectForKey("loanOfficerArray") != nil) {
                self.loanOfficerArray = defaults.objectForKey("loanOfficerArray") as! Array
                self.tempArray = defaults.objectForKey("loanOfficerArray") as! Array
            }
            else {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
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
                }
            }
            
//            if (self.loanOfficerArray.count <= 0) {
//                print("self.loanOfficerArray.count <= 0")
//            }
//            else {
//                print("self.loanOfficerArray.count >= 0")
//            }
        }
    }
    
    deinit {
        print("deinit being called in ProfileViewController")
    }
    
    func buildProfileView() {     
        let userView = UIView(frame: CGRectMake(15, 10, profileView.bounds.size.width - 30, 90))
        userView.backgroundColor = UIColor.whiteColor()
        profileView.addSubview(userView)
        
        let shadowImgOne = UIImage(named: "Long_shadow") as UIImage?
        // UIImageView
        let shadowViewOne = UIImageView(frame: CGRectMake(0, userView.bounds.size.height, userView.bounds.size.width, 15))
        shadowViewOne.image = shadowImgOne
        userView.addSubview(shadowViewOne)
        
        var name = "Enter Your Name"
        if let un = user!["name"] {
            name = un as! String
        }
        
        // UITextField
        nameTxtField.frame = (frame: CGRectMake(15, 10, profileView.bounds.size.width - 30, 30))
        nameTxtField.text = name
        nameTxtField.backgroundColor = UIColor.clearColor()
        nameTxtField.delegate = self
        nameTxtField.returnKeyType = .Next
        nameTxtField.keyboardType = UIKeyboardType.Default
        nameTxtField.font = UIFont(name: "forza-light", size: 22)
        nameTxtField.enabled = false
        nameTxtField.autocapitalizationType = .Words
        userView.addSubview(nameTxtField)
        
        var email = "Email Address"
        if let em = user!["email"] {
            email = em as! String
        }

        // UITextField
        emailTxtField.frame = (frame: CGRectMake(15, 50, profileView.bounds.size.width - 30, 30))
        emailTxtField.text = email
        emailTxtField.backgroundColor = UIColor.clearColor()
        emailTxtField.delegate = self
        emailTxtField.returnKeyType = .Done
        emailTxtField.keyboardType = UIKeyboardType.EmailAddress
        emailTxtField.font = UIFont(name: "forza-light", size: 22)
        emailTxtField.enabled = false
        userView.addSubview(emailTxtField)

        buttonOffset = 325
        
        // UIView
        let logOutView = UIView(frame: CGRectMake(15, CGFloat(buttonOffset), profileView.bounds.size.width - 30, 50))
        let logOutGradientLayer = CAGradientLayer()
        logOutGradientLayer.frame = logOutView.bounds
        logOutGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        logOutView.layer.insertSublayer(logOutGradientLayer, atIndex: 0)
        logOutView.layer.addSublayer(logOutGradientLayer)
        if reachability.isConnectedToNetwork() {
            profileView.addSubview(logOutView)
        }
        
        let logOutArrow = UILabel (frame: CGRectMake(logOutView.bounds.size.width - 50, 0, 40, 50))
        logOutArrow.textAlignment = NSTextAlignment.Right
        logOutArrow.font = UIFont(name: "forza-light", size: 40)
        logOutArrow.text = ">"
        logOutArrow.textColor = UIColor.whiteColor()
        logOutView.addSubview(logOutArrow)
        
        // UIButton
        let logOutButton = UIButton (frame: CGRectMake(25, 0, profileView.bounds.size.width - 25, 50))
        logOutButton.addTarget(self, action: #selector(ProfileViewController.navigateBackHome(_:)), forControlEvents: .TouchUpInside)
        logOutButton.setTitle("LOG OUT", forState: .Normal)
        logOutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        logOutButton.backgroundColor = UIColor.clearColor()
        logOutButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        logOutButton.contentHorizontalAlignment = .Left
        logOutButton.tag = 1
        logOutView.addSubview(logOutButton)
        
        let logoutBtnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let logoutBtnView = UIImageView(frame: CGRectMake(0, logOutView.bounds.size.height, logOutView.bounds.size.width, 15))
        logoutBtnView.image = logoutBtnImg
        logOutView.addSubview(logoutBtnView)
        
        if reachability.isConnectedToNetwork() {
            buttonOffset += 60
        }
        
        // UIView
        let changeLoView = UIView(frame: CGRectMake(15, CGFloat(buttonOffset), profileView.bounds.size.width - 30, 50))
        let changeLoGradientLayer = CAGradientLayer()
        changeLoGradientLayer.frame = changeLoView.bounds
        changeLoGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        changeLoView.layer.insertSublayer(changeLoGradientLayer, atIndex: 0)
        changeLoView.layer.addSublayer(changeLoGradientLayer)
        if reachability.isConnectedToNetwork() {
            profileView.addSubview(changeLoView)
        }
        
        let changeLoArrow = UILabel(frame: CGRectMake(logOutView.bounds.size.width - 50, 0, 40, 50))
        changeLoArrow.textAlignment = NSTextAlignment.Right
        changeLoArrow.font = UIFont(name: "forza-light", size: 40)
        changeLoArrow.text = ">"
        changeLoArrow.textColor = UIColor.whiteColor()
        changeLoView.addSubview(changeLoArrow)
        
        var fontSize = 25
        if modelName.rangeOfString("5") != nil || modelName.rangeOfString("4s") != nil {
            fontSize = 20
        }
        
        // UIButton
        let changeLoButton = UIButton(frame: CGRectMake(25, 0, profileView.bounds.size.width - 25, 50))
        changeLoButton.addTarget(self, action: #selector(ProfileViewController.showSearchOverLay(_:)), forControlEvents: .TouchUpInside)
        changeLoButton.setTitle("CHANGE LOAN OFFICER", forState: .Normal)
        changeLoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        changeLoButton.backgroundColor = UIColor.clearColor()
        changeLoButton.titleLabel!.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        changeLoButton.contentHorizontalAlignment = .Left
        changeLoButton.tag = 1
        changeLoView.addSubview(changeLoButton)
        
        let changeLoBtnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let changeLoBtnView = UIImageView(frame: CGRectMake(0, logOutView.bounds.size.height, logOutView.bounds.size.width, 15))
        changeLoBtnView.image = changeLoBtnImg
        changeLoView.addSubview(changeLoBtnView)
        
        if reachability.isConnectedToNetwork() {
            buttonOffset += 60
        }

        var userLo = ""
        if let _ = user!["officerName"] {
            userLo = user!["officerName"] as! String
            
            if userLo.characters.count > 0 {
                // UIView
                let deleteLoView = UIView(frame: CGRectMake(15, CGFloat(buttonOffset), profileView.bounds.size.width - 30, 50))
                let deleteLoGradientLayer = CAGradientLayer()
                deleteLoGradientLayer.frame = deleteLoView.bounds
                deleteLoGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
                deleteLoView.layer.insertSublayer(deleteLoGradientLayer, atIndex: 0)
                deleteLoView.layer.addSublayer(deleteLoGradientLayer)
                if reachability.isConnectedToNetwork() {
                    profileView.addSubview(deleteLoView)
                }
                
                let deleteLoArrow = UILabel(frame: CGRectMake(logOutView.bounds.size.width - 50, 0, 40, 50))
                deleteLoArrow.textAlignment = NSTextAlignment.Right
                deleteLoArrow.font = UIFont(name: "forza-light", size: 40)
                deleteLoArrow.text = ">"
                deleteLoArrow.textColor = UIColor.whiteColor()
                deleteLoView.addSubview(deleteLoArrow)
                
                // UIButton
                let deleteLoButton = UIButton(frame: CGRectMake(25, 0, profileView.bounds.size.width - 25, 50))
                deleteLoButton.addTarget(self, action: #selector(ProfileViewController.removeLoanOfficerFromParseUser), forControlEvents: .TouchUpInside)
                deleteLoButton.setTitle("DELETE LOAN OFFICER", forState: .Normal)
                deleteLoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                deleteLoButton.backgroundColor = UIColor.clearColor()
                deleteLoButton.titleLabel!.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
                deleteLoButton.contentHorizontalAlignment = .Left
                deleteLoButton.tag = 1
                deleteLoView.addSubview(deleteLoButton)
                
                let deleteLoBtnImg = UIImage(named: "right_shadow") as UIImage?
                // UIImageView
                let deleteLoBtnView = UIImageView(frame: CGRectMake(0, logOutView.bounds.size.height, logOutView.bounds.size.width, 15))
                deleteLoBtnView.image = deleteLoBtnImg
                deleteLoView.addSubview(deleteLoBtnView)
                
                if reachability.isConnectedToNetwork() {
                    buttonOffset += 60
                }
            }
        }
        
        // UIView
        calculateView.frame = (frame: CGRectMake(15, CGFloat(buttonOffset), profileView.bounds.size.width - 30, 50))
        calculateView.alpha = 0
        calcGradientLayer.hidden = true
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        profileView.addSubview(calculateView)
        
        calculateArrow.frame = (frame: CGRectMake(calculateView.bounds.size.width - 50, 0, 40, 50))
        calculateArrow.textAlignment = NSTextAlignment.Right
        calculateArrow.alpha = 0
        calculateArrow.font = UIFont(name: "forza-light", size: 40)
        calculateArrow.text = ">"
        calculateArrow.textColor = UIColor.whiteColor()
        calculateView.addSubview(calculateArrow)
        
        // UIButton
        updateUserButton.frame = (frame: CGRectMake(25, 0, profileView.bounds.size.width - 25, 50))
        updateUserButton.addTarget(self, action: #selector(ProfileViewController.updateUser(_:)), forControlEvents: .TouchUpInside)
        updateUserButton.setTitle("SAVE USER", forState: .Normal)
        updateUserButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updateUserButton.backgroundColor = UIColor.clearColor()
        updateUserButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        updateUserButton.contentHorizontalAlignment = .Left
        updateUserButton.tag = 0
        updateUserButton.enabled = false
        calculateView.addSubview(updateUserButton)
        
        let saveBtnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let saveBtnView = UIImageView(frame: CGRectMake(0, logOutView.bounds.size.height, logOutView.bounds.size.width, 15))
        saveBtnView.image = saveBtnImg
        calculateView.addSubview(saveBtnView)
        
        loadingOverlay.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height))
        loadingOverlay.backgroundColor = UIColor.darkGrayColor()
        loadingOverlay.hidden = true
        loadingOverlay.alpha = 0.85
        self.view.addSubview(loadingOverlay)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = view.center
        loadingOverlay.addSubview(activityIndicator)
        
        profileView.contentSize = CGSize(width: userView.bounds.size.width, height: CGFloat(200 + buttonOffset))
    }
    
    func getUserAndLoInfo() {
        let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let loDict = defaults.dictionaryForKey(dictString) {
            if let _ = loDict["nmls"] {
                buildLoanOfficerCard(loDict as! Dictionary<String, String>, yVal: 110, cardCount: 0, view: profileView, isSingleView: true)
            }
            else {
                if reachability.isConnectedToNetwork() {
                    getLoInfoFromDictionary()
                }
            }
        }
        else {
            if reachability.isConnectedToNetwork() {
                getLoInfoFromDictionary()
            }
        }
        
        loActivityIndicator.stopAnimating()
    }
    
    func getLoInfoFromDictionary() {
        var userLo = ""
        if loanOfficerArray.count > 0 {
            if let _ = user!["officerName"] {
                userLo = user!["officerName"] as! String
                
                if userLo.characters.count > 0 {
                    let filteredArray = loanOfficerArray.filter({
                        $0["name"] == userLo
                    })
                    
                    if filteredArray.count > 0 {
                        var nodeDict = Dictionary<String, String>()
                        nodeDict["nid"] = filteredArray[0]["nid"]
                        nodeDict["email"] = filteredArray[0]["email"]
                        nodeDict["mobile"] = filteredArray[0]["mobile"]
                        nodeDict["office"] = filteredArray[0]["office"]
                        nodeDict["url"] = filteredArray[0]["url"]
                        nodeDict["name"] = filteredArray[0]["name"]
                        nodeDict["image"] = filteredArray[0]["image"]
                        nodeDict["nmls"] = filteredArray[0]["nmls"]
                        
                        let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.removeObjectForKey(dictString)
                        defaults.setObject(nodeDict, forKey: dictString)
                        
                        buildLoanOfficerCard(nodeDict, yVal: 110, cardCount: 0, view: profileView, isSingleView: true)
                    }
                    else {
                        buildNoLoCard()
                    }
                }
                else {
                    buildNoLoCard()
                }
            }
            else {
                buildNoLoCard()
            }
        }
        else {
            if reachability.isConnectedToNetwork() {
                UpdateLoanOfficerArray()
            }
        }
    }
    
    func UpdateLoanOfficerArray() {
        let endpoint = NSURL(string: "https://www.firstmortgageco.com/loan-officers-json")
        let data = NSData(contentsOfURL: endpoint!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            if let nodes = json as? NSArray {
                for node in nodes {
                    if let nodeDict = node as? NSDictionary {
                        loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                        tempArray.append(nodeDict as! Dictionary<String, String>)
                    }
                }
                
                getLoInfoFromDictionary()
            }
        }
        catch {
            displayMessage("HomeIn", message: "An error occurred getting the loan officer information.")
        }
    }
    
    func buildNoLoCard() {
        // UIView
        let loView = UIView(frame: CGRectMake(15, 110, scrollView.bounds.size.width - 30, 200))
        loView.backgroundColor = UIColor.whiteColor()
        profileView.addSubview(loView)
        
        let loMessage = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 0))
        loMessage.textAlignment = NSTextAlignment.Left
        loMessage.text = "You are not currently assigned to a loan officer. Use the change loan officer button to assign a loan officer to your account."
        loMessage.font = UIFont(name: "forza-light", size: 18)
        loMessage.textColor = UIColor.darkTextColor()
        loMessage.numberOfLines = 0
        loMessage.sizeToFit()
        loView.addSubview(loMessage)
        
        let shadowImg = UIImage(named: "Long_shadow") as UIImage?
        // UIImageView
        let shadowView = UIImageView(frame: CGRectMake(15, loView.bounds.size.height, loView.bounds.size.width, 15))
        shadowView.image = shadowImg
        loView.addSubview(shadowView)
        
        buttonOffset += 125
    }
    
    func buildSeachOverlay(loArray: Array<Dictionary<String, String>>) {
        var yVal = 15.0
        var count = 0
        
        scrollView.contentOffset.y = 0
        overlayView.hidden = false
        for loanOfficer in loArray {
            let nodeDict = loanOfficer as NSDictionary

            self.buildLoanOfficerCard(nodeDict as! Dictionary<String, String>, yVal: CGFloat(yVal), cardCount: count, view: self.scrollView, isSingleView: false)
            
            self.scrollView.contentSize = CGSize(width: self.profileView.bounds.size.width, height: CGFloat(loArray.count * 175))
            yVal += 175
            count += 1
        }
    }

    func getBranchLoanOfficers() {
        let endpoint = NSURL(string: "https://www.firstmortgageco.com/loan-officers-json")
        let data = NSData(contentsOfURL: endpoint!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            if let nodes = json as? NSArray {
                for node in nodes {
                    if let nodeDict = node as? NSDictionary {
                        loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                        tempArray.append(nodeDict as! Dictionary<String, String>)
                    }
                }
            }
        }
        catch {
            displayMessage("HomeIn", message: "An error occurred getting the loan officer information.")
        }
    }
    
    func buildLoanOfficerCard(nodeDict: Dictionary<String, String>, yVal: CGFloat, cardCount: Int, view: UIView, isSingleView: Bool) -> UIView {
        
        var count = cardCount
        if isSingleView {
            count = 999
        }
        
        if isSingleView {
            
            // UIView
            singleLoView.frame = (frame: CGRectMake(15, yVal, scrollView.bounds.size.width - 30, 160))
            singleLoView.backgroundColor = UIColor.whiteColor()
            view.addSubview(singleLoView)
            
            let loImageView = UIImageView(frame: CGRectMake(5, 5, 100, 120))
            loImageView.contentMode = .ScaleAspectFit
            loImageView.image = UIImage(named: "default_lo")
            singleLoView.addSubview(loImageView)
            
            if reachability.isConnectedToNetwork() != false {
                if let nodeImage = nodeDict["image"] {
                    let urlString = nodeImage as String
                    if let checkedUrl = NSURL(string: urlString) {
                        let data = NSData(contentsOfURL: checkedUrl) //make sure your image in this url does exist, otherwise unwrap in a if let check
                        loImageView.image = UIImage(data: data!)
                    }
                }
                else {
                    loImageView.image = UIImage(named: "default_lo")
                }
            }
            else {
                loImageView.image = UIImage(named: "default_lo")
            }
            
            var offset = 0.0
            
            var name = ""
            if let _ = nodeDict["name"] {
                name = nodeDict["name"]!
            }
            let nameLabel = UILabel (frame: CGRectMake(115, 10, singleLoView.bounds.size.width - 120, 0))
            nameLabel.textAlignment = NSTextAlignment.Left
            nameLabel.text = name
            nameLabel.font = UIFont(name: "forza-medium", size: 20)
            nameLabel.numberOfLines = 0
            nameLabel.sizeToFit()
            singleLoView.addSubview(nameLabel)
            
            offset += Double(nameLabel.bounds.size.height) + 10.0
            
            let office = UILabel (frame: CGRectMake(115, CGFloat(offset), singleLoView.bounds.size.width - 120, 24))
            office.textAlignment = NSTextAlignment.Left
            office.text = String(format: "Office:")
            office.numberOfLines = 1
            office.font = UIFont(name: "forza-light", size: 18)
            singleLoView.addSubview(office)
            
            offset += 25.0
            
            var officePhone = ""
            if let _ = nodeDict["office"] {
                officePhone = model.formatPhoneString(nodeDict["office"]!)
            }
            let officeLabel = UILabel (frame: CGRectMake(115, CGFloat(offset), singleLoView.bounds.size.width - 115, 0))
            officeLabel.textAlignment = NSTextAlignment.Left
            officeLabel.text = String(format: "%@", officePhone)
            officeLabel.font = UIFont(name: "forza-light", size: 18)
            officeLabel.textColor = model.darkBlueColor
            officeLabel.numberOfLines = 0
            officeLabel.sizeToFit()
            officeLabel.adjustsFontSizeToFitWidth = true
            singleLoView.addSubview(officeLabel)
            
            let officeButton = UIButton (frame: CGRectMake(115, CGFloat(offset), singleLoView.bounds.size.width - 120, officeLabel.bounds.size.height))
            officeButton.addTarget(self, action: #selector(ProfileViewController.phoneButtonPressed(_:)), forControlEvents: .TouchUpInside)
            officeButton.backgroundColor = UIColor.clearColor()
            officeButton.setTitle(model.cleanPhoneNumnerString(officePhone), forState: .Normal)
            officeButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
            officeButton.tag = 0
            singleLoView.addSubview(officeButton)
            
            offset += Double(officeLabel.bounds.size.height)
            
            let mobile = UILabel (frame: CGRectMake(115, CGFloat(offset), 65, 24))
            mobile.textAlignment = NSTextAlignment.Left
            mobile.text = String(format: "Mobile: ")
            mobile.numberOfLines = 1
            mobile.font = UIFont(name: "forza-light", size: 18)
            singleLoView.addSubview(mobile)
            
            offset += 25.0
            
            var mobilePhone = ""
            if let _ = nodeDict["mobile"] {
                mobilePhone = model.formatPhoneString(nodeDict["mobile"]!)
            }
            let mobileLabel = UILabel (frame: CGRectMake(115, CGFloat(offset), singleLoView.bounds.size.width - 120, 0))
            mobileLabel.textAlignment = NSTextAlignment.Left
            mobileLabel.text = String(format: "%@", mobilePhone)
            mobileLabel.font = UIFont(name: "forza-light", size: 18)
            mobileLabel.textColor = model.darkBlueColor
            mobileLabel.numberOfLines = 0
            mobileLabel.sizeToFit()
            mobileLabel.adjustsFontSizeToFitWidth = true
            singleLoView.addSubview(mobileLabel)
            
            let mobileButton = UIButton (frame: CGRectMake(115, CGFloat(offset), singleLoView.bounds.size.width - 120, mobileLabel.bounds.size.height))
            mobileButton.addTarget(self, action: #selector(ProfileViewController.phoneButtonPressed(_:)), forControlEvents: .TouchUpInside)
            mobileButton.backgroundColor = UIColor.clearColor()
            mobileButton.setTitle(model.cleanPhoneNumnerString(mobilePhone), forState: .Normal)
            mobileButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
            mobileButton.tag = 1
            singleLoView.addSubview(mobileButton)
            
            var emailAttributedString = ""
            if let _ = nodeDict["email"] {
                emailAttributedString = nodeDict["email"]!
            }
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: emailAttributedString as String!, attributes: underlineAttribute)
            
            offset += Double(mobileLabel.bounds.size.height)
            if (offset < 130) {
                offset = 130
            }
            
            let emailLabel = UILabel (frame: CGRectMake(15, CGFloat(offset), singleLoView.bounds.size.width - 30, 24))
            emailLabel.textAlignment = NSTextAlignment.Left
            emailLabel.attributedText = underlineAttributedString
            emailLabel.numberOfLines = 1
            emailLabel.font = UIFont(name: "forza-light", size: 18.0)
            emailLabel.adjustsFontSizeToFitWidth = true
            emailLabel.textColor = model.darkBlueColor
            singleLoView.addSubview(emailLabel)
            
            var email = ""
            if let _ = nodeDict["email"] {
                email = nodeDict["email"]!
            }
            let emailButton = UIButton (frame: CGRectMake(15, CGFloat(offset), singleLoView.bounds.size.width - 30, 24))
            emailButton.addTarget(self, action: #selector(ProfileViewController.emailButtonPressed(_:)), forControlEvents: .TouchUpInside)
            emailButton.backgroundColor = UIColor.clearColor()
            emailButton.setTitle(email as String, forState: .Normal)
            emailButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
            emailButton.tag = 1
            singleLoView.addSubview(emailButton)
            
            offset += 35.0
            
            var nmls = ""
            if let _ = nodeDict["nmls"] {
                nmls = nodeDict["nmls"]!
            }
            let nmlsLabel = UILabel (frame: CGRectMake(15, CGFloat(offset), singleLoView.bounds.size.width - 30, 0))
            nmlsLabel.font = UIFont(name: "forza-light", size: 18)
            nmlsLabel.textAlignment = NSTextAlignment.Left
            nmlsLabel.text = String(format: "%@", nmls)
            nmlsLabel.numberOfLines = 0
            nmlsLabel.sizeToFit()
            singleLoView.addSubview(nmlsLabel)
            
            offset += 35.0
            buttonOffset = offset
            
            singleLoView.frame = CGRectMake(15, yVal, scrollView.bounds.size.width - 30, CGFloat(offset))
            
            let shadowImg = UIImage(named: "Long_shadow") as UIImage?
            // UIImageView
            let shadowView = UIImageView(frame: CGRectMake(15, singleLoView.bounds.size.height, singleLoView.bounds.size.width, 15))
            shadowView.image = shadowImg
            singleLoView.addSubview(shadowView)
        }
        else {

            // UIView
            let loView = UIView(frame: CGRectMake(15, yVal, scrollView.bounds.size.width - 30, 150))
            loView.backgroundColor = UIColor.whiteColor()
            view.addSubview(loView)
            
            let shadowImg = UIImage(named: "Long_shadow") as UIImage?
            // UIImageView
            let shadowView = UIImageView(frame: CGRectMake(15, loView.bounds.size.height, loView.bounds.size.width, 15))
            shadowView.image = shadowImg
            loView.addSubview(shadowView)
            
            var name = ""
            if let _ = nodeDict["name"] {
                name = nodeDict["name"]!
            }
            let nameLabel = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 24))
            nameLabel.textAlignment = NSTextAlignment.Left
            nameLabel.text = name
            nameLabel.numberOfLines = 1
            nameLabel.font = UIFont(name: "forza-medium", size: 20)
            nameLabel.adjustsFontSizeToFitWidth = true
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
            emailLabel.adjustsFontSizeToFitWidth = true
            loView.addSubview(emailLabel)
            
            let office = UILabel (frame: CGRectMake(15, 65, 60, 24))
            office.textAlignment = NSTextAlignment.Left
            office.text = String(format: "Office: ")
            office.numberOfLines = 1
            office.font = UIFont(name: "forza-light", size: 18)
            loView.addSubview(office)
            
            var officePhone = ""
            if let _ = nodeDict["office"] {
                officePhone = model.formatPhoneString(nodeDict["office"]!)
            }
            let officeLabel = UILabel (frame: CGRectMake(75, 65, loView.bounds.size.width - 80, 24))
            officeLabel.textAlignment = NSTextAlignment.Left
            officeLabel.text = String(format: "%@", officePhone)
            officeLabel.numberOfLines = 1
            officeLabel.font = UIFont(name: "forza-light", size: 18)
            officeLabel.textColor = model.darkBlueColor
            loView.addSubview(officeLabel)

            let mobile = UILabel (frame: CGRectMake(15, 95, 65, 24))
            mobile.textAlignment = NSTextAlignment.Left
            mobile.text = String(format: "Mobile: ")
            mobile.numberOfLines = 1
            mobile.font = UIFont(name: "forza-light", size: 18)
            loView.addSubview(mobile)
            
            var mobilePhone = ""
            if let _ = nodeDict["mobile"] {
                mobilePhone = model.formatPhoneString(nodeDict["mobile"]!)
            }
            let mobileLabel = UILabel (frame: CGRectMake(80, 95, loView.bounds.size.width - 85, 24))
            mobileLabel.textAlignment = NSTextAlignment.Left
            mobileLabel.text = String(format: "%@", mobilePhone)
            mobileLabel.numberOfLines = 1
            mobileLabel.font = UIFont(name: "forza-light", size: 18)
            mobileLabel.textColor = model.darkBlueColor
            loView.addSubview(mobileLabel)
            
            var nmls = ""
            if let _ = nodeDict["nmls"] {
                nmls = nodeDict["nmls"]!
            }
            let nmlsLabel = UILabel (frame: CGRectMake(15, 125, loView.bounds.size.width - 30, 0))
            nmlsLabel.font = UIFont(name: "forza-light", size: 18)
            nmlsLabel.textAlignment = NSTextAlignment.Left
            nmlsLabel.text = String(format: "%@", nmls)
            nmlsLabel.numberOfLines = 0
            nmlsLabel.sizeToFit()
            loView.addSubview(nmlsLabel)
            
            let h = isSingleView ? 60 : loView.bounds.size.height
            
            // UIButton
            let selectButton = UIButton (frame: CGRectMake(0, 0, loView.bounds.size.width, h))
            selectButton.addTarget(self, action: #selector(ProfileViewController.setLoanOfficer(_:)), forControlEvents: .TouchUpInside)
            selectButton.backgroundColor = UIColor.clearColor()
            selectButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
            selectButton.contentHorizontalAlignment = .Right
            if reachability.isConnectedToNetwork() == false {
                selectButton.enabled = false
            }
            selectButton.tag = count
            loView.addSubview(selectButton)
        }

        return loView
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
            buildSeachOverlay(tempArray)
        }
        else {
            buildSeachOverlay(loanOfficerArray)
            
            if (searchText.characters.count > 0) {
                displayMessage("HomeIn", message: "We could not find any loan officers with that name.")
            }
        }
    }
    
    func setLoanOfficer(sender: UIButton) {
        if sender.tag == 999 {
            if isTextFieldEnabled {
                buildSeachOverlay(loanOfficerArray)
            }
        }
        else {
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
            
            var nid = ""
            if let _ = dict["nid"] {
                nid = dict["nid"]! as String
            }

            var name = ""
            if let _ = dict["name"] {
                name = dict["name"]! as String
            }

            var officerURL = ""
            if let _ = dict["url"] {
                officerURL = dict["url"]! as String
            }
            
            if let _ = dict["email"] {
                officerEmail = dict["email"]! as String
            }
            
            let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey(dictString)
            defaults.setObject(dict, forKey: dictString)
            
            if let nodeImage = dict["image"] {
                if let nid = dict["nid"] {
                    
                    if reachability.isConnectedToNetwork() {
                        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                            let urlString = nodeImage as String
                            if let checkedUrl = NSURL(string: urlString) {
                                let data = NSData(contentsOfURL: checkedUrl) //make sure your image in this url does exist, otherwise unwrap in a if let check
                                let image = UIImage(data: data!)
                                var documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                                documentsPath = String(format: "%@/%@.png", documentsPath, nid as String)
                                UIImageJPEGRepresentation(image!,1.0)!.writeToFile(documentsPath, atomically: true)
                            }
                        }
                    }
                }
            }
            
            defaults.synchronize()

            nameTxtField.enabled = false
            emailTxtField.enabled = false
            loButton.enabled = false
            
            isTextFieldEnabled = false
            editIcon.image = UIImage(named: "edit_icon")
            
            searchTxtField.resignFirstResponder()
            saveLoanOfficerToParse(nid, name: name, url: officerURL)
        }
    }
    
    // MARK: 
    // MARK: Update User Information
    func saveLoanOfficerToParse(nid: String, name: String, url: String) {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        user!["name"] = (nameTxtField.text != "") ? nameTxtField.text : user!["name"]
        user!["email"] = (emailTxtField.text != "") ? emailTxtField.text?.lowercaseString : user!["email"]
        user!["officerNid"] = Int(nid)
        user!["officerName"] = name
        user!["officerURL"] = url
        
        
        if reachability.isConnectedToNetwork() {
            parseObject.saveUser(user!, officerEmail: officerEmail)
        }
        else {
            parseObject.saveUserEventually(user!, officerEmail: officerEmail)
        }
    }
    
    func removeLoanOfficerFromParseUser() {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        user!["name"] = (nameTxtField.text != "") ? nameTxtField.text : user!["name"]
        user!["email"] = (emailTxtField.text != "") ? emailTxtField.text?.lowercaseString : user!["email"]
        user!["officerURL"] = ""
        user!["officerName"] = ""
        user!["officerNid"] = 0
        
        if reachability.isConnectedToNetwork() {
            parseObject.saveUser(user!, officerEmail: officerEmail)
        }
        else {
            parseObject.saveUserEventually(user!, officerEmail: officerEmail)
        }
        
    }
    
    func updateUser(sender: UIButton) {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        user!["name"] = (nameTxtField.text != "") ? nameTxtField.text : user!["name"]
        user!["email"] = (emailTxtField.text != "") ? emailTxtField.text?.lowercaseString : user!["email"]
        
        if reachability.isConnectedToNetwork() {
            parseObject.saveUser(user!, officerEmail: "")
        }
        else {
            parseObject.saveUserEventually(user!, officerEmail: "")
        }
        
    }
    
    // MARK: 
    // MARK: Acctions
    func dismissOverlayView(sender: UIButton) {
        removeViews(scrollView)
        tempArray.removeAll()
        searchTxtField.text = ""
        nameTxtField.resignFirstResponder()
        emailTxtField.resignFirstResponder()
        searchTxtField.resignFirstResponder()
        overlayView.hidden = true
    }
    
    func showSearchOverLay(sender: UIButton) {
        buildSeachOverlay(loanOfficerArray)
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 999 {
            textField.resignFirstResponder()
        }
        else if textField == nameTxtField {
            emailTxtField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
    
    func textFieldDidChange(textField: UITextField) {
        textField.becomeFirstResponder()
        searchLoanOfficerArray(textField.text!)
    }

    func allowEdit(sender: UIButton) {
        calculateView.alpha = 1
        calculateArrow.alpha = 1
        calcGradientLayer.hidden = false
        updateUserButton.enabled = true
        
        if (!isTextFieldEnabled) {
            nameTxtField.enabled = true
            emailTxtField.enabled = true
            loButton.enabled = true
            
            isTextFieldEnabled = true
            editIcon.image = UIImage(named: "edit_red")
            
            editModeLabel.textColor = model.lightRedColor
        }
        else {
            nameTxtField.enabled = false
            emailTxtField.enabled = false
            loButton.enabled = false
            
            isTextFieldEnabled = false
            editIcon.image = UIImage(named: "edit_icon")
            
            editModeLabel.textColor = UIColor.whiteColor()
        }
    }
    
    // MARK:
    // MARK: Navigation
    func navigateBackHome(sender: UIButton) {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        switch sender.tag {
        case 0:
            removeViews(self.view)
            
            self.navigationController!.popToRootViewControllerAnimated(true)
        case 1:
            
            if reachability.isConnectedToNetwork() {
                PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
                    if (error == nil) {
                        let hvc = self.storyboard!.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
                        hvc.isUserLoggedIn = false
                        hvc.isLoginViewOpen = false
                        
                        //Remove all NSUserDefaults on logout
                        for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
                        }
                        
                        self.navigationController!.popToRootViewControllerAnimated(true)
                    }
                    else {
                        print("logout error: ", error?.userInfo)
                    }
                }
            }
            else {
                
                let alertController = UIAlertController(title: "HomeIn", message: "You currently do not have an internet connection. Please wait while we try to log you out.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    PFUser.logOut()
                    
                    let hvc = self.storyboard!.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
                    hvc.isUserLoggedIn = false
                    hvc.isLoginViewOpen = false
                    
                    //Remove all NSUserDefaults on logout
                    for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
                        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
                    }
                    
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
                
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    
                }
            }

        default:
            break
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func phoneButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "HomeIn", message: String(format: "Call %@", model.formatPhoneString((sender.titleLabel?.text)!)), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.openPhoneApp((sender.titleLabel?.text)!)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func emailButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: String(format: "mailto:%@", sender.titleLabel!.text!))!)
    }
    
    func openPhoneApp(phoneNumber: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: String(format: "tel://%", phoneNumber))!)
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
    func saveSucceeded() {
        /*************************** Fabric Analytics *********************************************/
                Answers.logCustomEventWithName("User_Profile_Updated", customAttributes: ["Category":"User_Action"])
                print("User_Profile_Updated")
        /************************* End Fabric Analytics *******************************************/
        
        removeViews(self.profileView)
        
        singleLoView.removeFromSuperview()
        removeViews(self.singleLoView)
        
        buildProfileView()
        getUserAndLoInfo()
        editModeLabel.textColor = UIColor.whiteColor()
        overlayView.hidden = true
        
        nameTxtField.resignFirstResponder()
        emailTxtField.resignFirstResponder()
        searchTxtField.resignFirstResponder()
        
        loadingOverlay.hidden = true
        activityIndicator.stopAnimating()
        
        tempArray.removeAll()
        removeViews(scrollView)
        
        displayMessage("HomeIn", message: "Your profile information was updated.")
        
        /****************************************/
        nameTxtField.enabled = false
        emailTxtField.enabled = false
        loButton.enabled = false
        isTextFieldEnabled = false
        editIcon.image = UIImage(named: "edit_icon")
        editModeLabel.textColor = UIColor.whiteColor()

        var loNid = 0
        if let _ = user!["officerNid"] {
            loNid = user!["officerNid"] as! Int
        }
        
        if loNid == 0 {
            let dictString = String(format: "loanOfficerDictfor%@", (self.user?.objectId)!)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey(dictString)
            
            buildNoLoCard()
        }
    }
    
    func saveFailed(errorMessage: String) {
        loadingOverlay.hidden = true
        activityIndicator.stopAnimating()
        displayMessage("HomeIn", message: String(format: "An error occurred trying to save your information.  If you continue to see this message you may need to log out of the app and log back in. \n %@", errorMessage))
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