//
//  ProfileViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/15/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate {
    // MARK:
    // MARK: Properties
    let model = Model()
    let modelName = UIDevice.currentDevice().modelName
    
    //Reachability
    let reachability = Reachability()
    
    // UIView
    //let profileView = UIView()
    let overlayView = UIView()
    let calculateView = UIView()
    let loView = UIView()
    let loadingOverlay = UIView()
    
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
    
    var isTextFieldEnabled = Bool()
    var didComeFromAccountPage = Bool()

    var activityIndicator = UIActivityIndicatorView()
    
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        editButton.addTarget(self, action: "allowEdit:", forControlEvents: .TouchUpInside)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        whiteBar.addSubview(editButton)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(5, 0, 100, 50))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
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
        dismissButton.addTarget(self, action: "dismissOverlayView:", forControlEvents: .TouchUpInside)
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
        searchTxtField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        overlayView.addSubview(searchTxtField)
        
        scrollView.frame = (frame: CGRectMake(0, 135, overlayView.bounds.size.width, overlayView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        overlayView.addSubview(scrollView)
        
        buildProfileView()
    }

    override func viewDidAppear(animated: Bool) {
        if self.reachability.isConnectedToNetwork() == false {
            let alertController = UIAlertController(title: "HomeIn", message: "This device currently has no internet connection.\n\nUpdating a loan officer will not be possible until an internet connection is reestablished.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        else {
            if (self.loanOfficerArray.count <= 0) {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if (defaults.objectForKey("loanOfficerArray") != nil) {
                    print("from defaults")
                    self.loanOfficerArray = defaults.objectForKey("loanOfficerArray") as! Array
                    self.tempArray = defaults.objectForKey("loanOfficerArray") as! Array
                }
                else {
                    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                        print("from web")
                        let nodes = self.model.getBranchLoanOfficers()
                        
                        self.loanOfficerArray.removeAll()
                        self.tempArray.removeAll()
                        
                        for node in nodes {
                            if let nodeDict = node as? NSDictionary {
                                self.loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                                self.tempArray.append(nodeDict as! Dictionary<String, String>)
                            }
                        }
                        
                        // TODO: set a date to recheck these LO's
                        defaults.setObject(self.loanOfficerArray, forKey: "loanOfficerArray")
                    }
                }
            }
        }
    }
    
    func buildProfileView() {     
        let userView = UIView(frame: CGRectMake(15, 10, profileView.bounds.size.width - 30, 90))
        userView.backgroundColor = UIColor.whiteColor()
        profileView.addSubview(userView)
        
        let shadowImgOne = UIImage(named: "long_shadow") as UIImage?
        // UIImageView
        let shadowViewOne = UIImageView(frame: CGRectMake(0, userView.bounds.size.height, userView.bounds.size.width, 15))
        shadowViewOne.image = shadowImgOne
        userView.addSubview(shadowViewOne)
        
        var name = "Enter Your Name"
        if let un = user!["name"] {
            name = un as! String
        }
        else {
            if let ua = user!["additional"] {
                name = ua as! String
            }
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
        
        let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let loDict = defaults.dictionaryForKey(dictString) {
            buildLoanOfficerCard(loDict as! Dictionary<String, String>, yVal: 110, count: 0, view: profileView, isSingleView: true)
        }
        else {
            var userLo = ""
            if let _ = user!["officerName"] {
                userLo = user!["officerName"] as! String
                if loanOfficerArray.count > 0 {
                    let filteredVisitors = loanOfficerArray.filter({
                        $0["name"] == userLo
                    })
                    
                    // TODO: Fix DRYness here
                    var nodeDict = Dictionary<String, String>()
                    nodeDict["nid"] = filteredVisitors[0]["nid"]
                    nodeDict["email"] = filteredVisitors[0]["email"]
                    nodeDict["mobile"] = filteredVisitors[0]["mobile"]
                    nodeDict["office"] = filteredVisitors[0]["office"]
                    nodeDict["url"] = filteredVisitors[0]["url"]
                    nodeDict["name"] = filteredVisitors[0]["name"]
                    
                    let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.removeObjectForKey(dictString)
                    defaults.setObject(nodeDict, forKey: dictString)
                    
                    buildLoanOfficerCard(nodeDict, yVal: 110, count: 0, view: profileView, isSingleView: true)
                }
                else {
                    getBranchLoanOfficers()
                    
                    let filteredVisitors = loanOfficerArray.filter({
                        $0["name"] == userLo
                    })
                    
                    var nodeDict = Dictionary<String, String>()
                    nodeDict["nid"] = filteredVisitors[0]["nid"]
                    nodeDict["email"] = filteredVisitors[0]["email"]
                    nodeDict["mobile"] = filteredVisitors[0]["mobile"]
                    nodeDict["office"] = filteredVisitors[0]["office"]
                    nodeDict["url"] = filteredVisitors[0]["url"]
                    nodeDict["name"] = filteredVisitors[0]["name"]
                    
                    let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.removeObjectForKey(dictString)
                    defaults.setObject(nodeDict, forKey: dictString)
                    
                    buildLoanOfficerCard(nodeDict, yVal: 110, count: 0, view: profileView, isSingleView: true)
                }
            }
            else {
                // UIView
                let loView = UIView(frame: CGRectMake(15, 110, scrollView.bounds.size.width - 30, 125))
                loView.backgroundColor = UIColor.whiteColor()
                profileView.addSubview(loView)
                
                let loMessage = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 0))
                loMessage.textAlignment = NSTextAlignment.Left
                loMessage.text = "You are not currently assigned to a loan officer. Enable edit mode then press here to see a list avaliable loan officers."
                loMessage.font = UIFont(name: "forza-light", size: 18)
                loMessage.numberOfLines = 0
                loMessage.sizeToFit()
                loView.addSubview(loMessage)
                
                // UIButton
                let selectButton = UIButton (frame: CGRectMake(0, 0, loView.bounds.size.width, loView.bounds.size.height))
                selectButton.addTarget(self, action: "setLoanOfficer:", forControlEvents: .TouchUpInside)
                selectButton.backgroundColor = UIColor.clearColor()
                selectButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
                selectButton.contentHorizontalAlignment = .Right
                selectButton.tag = 999
                loView.addSubview(selectButton)
                
                let shadowImg = UIImage(named: "long_shadow") as UIImage?
                // UIImageView
                let shadowView = UIImageView(frame: CGRectMake(15, loView.bounds.size.height, loView.bounds.size.width, 15))
                shadowView.image = shadowImg
                loView.addSubview(shadowView)
            }
        }
        
        // UIView
        let logOutView = UIView(frame: CGRectMake(15, 250, profileView.bounds.size.width - 30, 50))
        let logOutGradientLayer = CAGradientLayer()
        logOutGradientLayer.frame = logOutView.bounds
        logOutGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        logOutView.layer.insertSublayer(logOutGradientLayer, atIndex: 0)
        logOutView.layer.addSublayer(logOutGradientLayer)
        profileView.addSubview(logOutView)
        
        let logOutArrow = UILabel (frame: CGRectMake(logOutView.bounds.size.width - 50, 0, 40, 50))
        logOutArrow.textAlignment = NSTextAlignment.Right
        logOutArrow.font = UIFont(name: "forza-light", size: 40)
        logOutArrow.text = ">"
        logOutArrow.textColor = UIColor.whiteColor()
        logOutView.addSubview(logOutArrow)
        
        // UIButton
        let logOutButton = UIButton (frame: CGRectMake(25, 0, profileView.bounds.size.width - 25, 50))
        logOutButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
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
        
        // UIView
        calculateView.frame = (frame: CGRectMake(15, 310, profileView.bounds.size.width - 30, 50))
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
        updateUserButton.addTarget(self, action: "updateUser:", forControlEvents: .TouchUpInside)
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
        
        profileView.contentSize = CGSize(width: userView.bounds.size.width, height: 475)
    }
    
    func buildSeachOverlay(loArray: Array<Dictionary<String, String>>) {
        var yVal = 15.0
        var count = 0
        
        overlayView.hidden = false
        for loanOfficer in loArray {
            let nodeDict = loanOfficer as NSDictionary
            buildLoanOfficerCard(nodeDict as! Dictionary<String, String>, yVal: CGFloat(yVal), count: count, view: scrollView, isSingleView: false)
            
            scrollView.contentSize = CGSize(width: profileView.bounds.size.width, height: CGFloat(loArray.count * 125))
            yVal += 135
            count++
        }
    }

    func getBranchLoanOfficers() {
        print("getBranchLoanOfficers")
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
            let alertController = UIAlertController(title: "HomeIn", message: "An error occurred getting the loan officer information.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
    }
    
    func buildLoanOfficerCard(nodeDict: Dictionary<String, String>, yVal: CGFloat, var count: Int, view: UIView, isSingleView: Bool) -> UIView {
        
        if isSingleView {
            count = 999
        }
        
        // UIView
        let loView = UIView(frame: CGRectMake(15, yVal, scrollView.bounds.size.width - 30, 125))
        loView.backgroundColor = UIColor.whiteColor()
        view.addSubview(loView)
        
        let nameLabel = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 24))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.text = nodeDict["name"]
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "forza-medium", size: 20)
        loView.addSubview(nameLabel)
        
        let emailLabel = UILabel (frame: CGRectMake(15, 35, loView.bounds.size.width - 30, 24))
        emailLabel.textAlignment = NSTextAlignment.Left
        emailLabel.text = nodeDict["email"]
        emailLabel.numberOfLines = 1
        emailLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(emailLabel)
        
        let office = UILabel (frame: CGRectMake(15, 65, 60, 24))
        office.textAlignment = NSTextAlignment.Left
        office.text = String(format: "Office: ")
        office.numberOfLines = 1
        office.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(office)
        
        let officePhone = (nodeDict["office"] != nil) ? nodeDict["office"] : ""
        let officeLabel = UILabel (frame: CGRectMake(75, 65, loView.bounds.size.width - 80, 24))
        officeLabel.textAlignment = NSTextAlignment.Left
        officeLabel.text = String(format: "%@", officePhone!)
        officeLabel.numberOfLines = 1
        officeLabel.font = UIFont(name: "forza-light", size: 18)
        officeLabel.textColor = model.darkBlueColor
        loView.addSubview(officeLabel)
        
        if isSingleView && officePhone?.characters.count > 0 {
            // UIButton
            let officeButton = UIButton (frame: CGRectMake(15, 65, loView.bounds.size.width - 30, 24))
            officeButton.addTarget(self, action: "phoneButtonPressed:", forControlEvents: .TouchUpInside)
            officeButton.backgroundColor = UIColor.clearColor()
            officeButton.setTitle(model.cleanPhoneNumnerString(officePhone!), forState: .Normal)
            officeButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
            officeButton.tag = 0
            loView.addSubview(officeButton)
        }
        
        let mobile = UILabel (frame: CGRectMake(15, 95, 65, 24))
        mobile.textAlignment = NSTextAlignment.Left
        mobile.text = String(format: "Mobile: ")
        mobile.numberOfLines = 1
        mobile.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(mobile)
        
        let mobilePhone = (nodeDict["mobile"] != nil) ? nodeDict["mobile"] : ""
        let mobileLabel = UILabel (frame: CGRectMake(80, 95, loView.bounds.size.width - 85, 24))
        mobileLabel.textAlignment = NSTextAlignment.Left
        mobileLabel.text = String(format: "%@", mobilePhone!)
        mobileLabel.numberOfLines = 1
        mobileLabel.font = UIFont(name: "forza-light", size: 18)
        mobileLabel.textColor = model.darkBlueColor
        loView.addSubview(mobileLabel)
        
        if isSingleView && mobilePhone?.characters.count > 0 {
            // UIButton
            let mobileButton = UIButton (frame: CGRectMake(15, 95, loView.bounds.size.width - 30, 24))
            mobileButton.addTarget(self, action: "phoneButtonPressed:", forControlEvents: .TouchUpInside)
            mobileButton.backgroundColor = UIColor.clearColor()
            mobileButton.setTitle(model.cleanPhoneNumnerString(mobilePhone!), forState: .Normal)
            mobileButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
            mobileButton.tag = 1
            loView.addSubview(mobileButton)
        }
        
        let h = isSingleView ? 60 : loView.bounds.size.height
        // UIButton
        let selectButton = UIButton (frame: CGRectMake(0, 0, loView.bounds.size.width, h))
        selectButton.addTarget(self, action: "setLoanOfficer:", forControlEvents: .TouchUpInside)
        selectButton.backgroundColor = UIColor.clearColor()
        selectButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        selectButton.contentHorizontalAlignment = .Right
        if reachability.isConnectedToNetwork() == false {
            selectButton.enabled = false
        }
        selectButton.tag = count
        loView.addSubview(selectButton)
        
        let shadowImg = UIImage(named: "long_shadow") as UIImage?
        // UIImageView
        let shadowView = UIImageView(frame: CGRectMake(15, loView.bounds.size.height, loView.bounds.size.width, 15))
        shadowView.image = shadowImg
        loView.addSubview(shadowView)
        
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
    }
    
    func setLoanOfficer(sender: UIButton) {
        if sender.tag == 999 {
            if isTextFieldEnabled {
                buildSeachOverlay(loanOfficerArray)
            }
        }
        else {
            let dict = tempArray[sender.tag]
            
            let nid = dict["nid"]! as String
            let name = dict["name"]! as String
            let officerURL = dict["url"]! as String
            
            let dictString = String(format: "loanOfficerDictfor%@", (user?.objectId)!)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey(dictString)
            defaults.setObject(dict, forKey: dictString)

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
    // MARK: Parse
    func saveLoanOfficerToParse(nid: String, name: String, url: String) {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        user!["officerNid"] = Int(nid)
        user!["officerName"] = name
        user!["officerURL"] = url
        
        user!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.removeViews(self.profileView)
                self.buildProfileView()
                self.overlayView.hidden = true
                
                self.loadingOverlay.hidden = true
                self.activityIndicator.stopAnimating()
            }
            else {
                let alertController = UIAlertController(title: "HomeIn", message: String(format: "%@", error!), preferredStyle: .Alert)
                
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
    
    func updateUser(sender: UIButton) {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        user!["name"] = (nameTxtField.text != "") ? nameTxtField.text : user!["name"]
        user!["additional"] = (nameTxtField.text != "") ? nameTxtField.text : user!["additional"]
        user!["email"] = (emailTxtField.text != "") ? emailTxtField.text : user!["email"]
        
        user!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            var message = ""
            if (success) {
                message = "Your profile information was updated."
            }
            else {
                message = String(format: "There was an error updating your profile information. %@", error!)
            }
            
            self.nameTxtField.enabled = false
            self.emailTxtField.enabled = false
            self.loButton.enabled = false
            
            self.isTextFieldEnabled = false
            self.editIcon.image = UIImage(named: "edit_icon")
            
            self.loadingOverlay.hidden = true
            self.activityIndicator.stopAnimating()
            
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
    
    // MARK: 
    // MARK: Acctions
    func dismissOverlayView(sender: UIButton) {
        self.overlayView.hidden = true
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 999 {
            if (textField.text != "") {
                searchLoanOfficerArray(searchTxtField.text!)
            }
            
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
    
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
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
            self.navigationController!.popToRootViewControllerAnimated(true)
        case 1:
            PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
                if (error == nil) {
                    let hvc = self.storyboard!.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
                    hvc.homeView.removeFromSuperview()
                    hvc.isUserLoggedIn = false
                    
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
                else {
                    print("logout error: ", error?.userInfo)
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
    
    func openPhoneApp(phoneNumber: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: String(format: "tel://%", phoneNumber))!)
    }
}
