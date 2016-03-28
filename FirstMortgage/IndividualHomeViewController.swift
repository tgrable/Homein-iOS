//
//  IndividualHomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 11/18/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class IndividualHomeViewController: UIViewController, ParseDataDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    // MARK:
    // MARK: Properties
    
    //Reachability
    let reachability = Reachability()
    let parseObject = ParseDataObject()
    let model = Model()
    let modelName = UIDevice.currentDevice().modelName
    
    // UIView
    let myHomesView = UIView()
    let overlayView = UIView()
    let homeTray = UIView()
    let calcTray = UIView()
    let saveDeleteTray = UIView()
    let loadingOverlay = UIView()
    let homeAddressBorderView = UIView()
    let homeNameBorderView = UIView()
    let calcBannerView = UIView()
    let calcBannerGradientLayer = CAGradientLayer()
    
    // UIScrollView
    let scrollView = UIScrollView()
    let imageScollView = UIScrollView()
    
    // UITextField
    let homeNameTxtField = UITextField()
    let homePriceTxtField = UITextField()
    let homeAddressTxtField = UITextField()
    let bedsTxtField = UITextField()
    let bathsTxtField = UITextField()
    let sqFeetTxtField = UITextField()
    let descTxtView = UITextView()
    var userRating = Int()
    
    // UITextField
    let loanAmountTxtField = UITextField() as UITextField
    let mortgageTxtField = UITextField() as UITextField
    let interestTxtField = UITextField() as UITextField
    let downPaymentTxtField = UITextField() as UITextField
    
    // UIImagePickerController
    let picker = UIImagePickerController()
    var img = UIImage()
    var newImg = UIImage()
    
    // UILabel
    var paymentLabel = UILabel() as UILabel
    let editModeLabel = UILabel()
    let homeAddressLabel = UILabel()
    let homeNameLabel = UILabel()
    let bedsLabel = UILabel()
    let bathsLabel = UILabel()
    let sqFeetLabel = UILabel()
    let imageCountLabel = UILabel()
    
    var estimatedPaymentDefault = 1835.26
    
    var homeObject: PFObject!
    var imageArray: [PFFile] = []
    var ratingButtonArray: [UIButton] = []
    
    var imageView = UIImageView()
    let defaultImageView = UIImageView()
    let expandIcon = UIImageView()
    
    var isSmallerScreen = Bool()
    var isTextFieldEnabled = Bool()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var isCalcTrayOpen = Bool()
    var didEnterEditMode = Bool()
    var didDisplayNoConnectionMessage = Bool()
    
    let estPaymentLabel = UILabel()
    let imageIndexLabel = UILabel()
    
    let saveView = UIView()
    let saveButton = UIButton ()
    let editButton = UIButton ()
    let editIcon = UIImageView()
    let saveImageDefaultButton = UIButton()
    let deleteDefaultButton = UIButton()
    
    let hideKeyboardButton = UIButton()
    
    var contentOffSet = 0.0 as CGFloat
    var imageIndex = 0
    var scrollLocation = 0.0 as CGFloat
    
    var yOffset = 0.0 as CGFloat
    
    var homeNameString = String()
    var homeAddressString = String()
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(IndividualHomeViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(IndividualHomeViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        parseObject.delegate = self
        picker.delegate = self
        buildView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true);
        
        if self.reachability.isConnectedToNetwork() == false {
            if didDisplayNoConnectionMessage != true {
                if self.reachability.isConnectedToNetwork() == false {
                    
                    displayMessage("HomeIn", message: "This device currently has no internet connection.\n\nAny images added will be saved to the photo library on this device. Once an internet connection is reestablished, images may be added to any existing home.")
                    
                    self.didDisplayNoConnectionMessage = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        displayMessage("HomeIn", message: "Your device is low on memory and may need to shut down this app.")
    }
    
    deinit {
        print("deinit being called in IndividualHomeViewController")
        removeViews(self.view)
    }
    
    // MARK:
    // MARK: Build Views
    func buildView() {
        myHomesView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        myHomesView.backgroundColor = model.lightGrayColor
        myHomesView.hidden = false
        self.view.addSubview(myHomesView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((myHomesView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        myHomesView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        myHomesView.addSubview(whiteBar)
        
        let backIcn = UIImage(named: "back_grey") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 30, 30))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
        // UILabel
        editModeLabel.frame = (frame: CGRectMake(25, 0, whiteBar.bounds.size.width - 50, 50))
        editModeLabel.text = "EDIT MODE"
        editModeLabel.textAlignment = NSTextAlignment.Center
        editModeLabel.textColor = UIColor.whiteColor()
        editModeLabel.font = UIFont(name: "forza-light", size: 24)
        whiteBar.addSubview(editModeLabel)
        
        // UIButton
        hideKeyboardButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 50, 5, 40, 40))
        hideKeyboardButton.addTarget(self, action: #selector(IndividualHomeViewController.tapGesture), forControlEvents: .TouchUpInside)
        hideKeyboardButton.setImage(UIImage(named: "hide_keyboard"), forState: .Normal)
        hideKeyboardButton.backgroundColor = UIColor.clearColor()
        hideKeyboardButton.tag = 0
        hideKeyboardButton.enabled = false
        hideKeyboardButton.alpha = 0
        whiteBar.addSubview(hideKeyboardButton)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: #selector(IndividualHomeViewController.navigateBackHome(_:)), forControlEvents: .TouchUpInside)
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, myHomesView.bounds.size.width, 50))
        let addHomeBannerGradientLayer = CAGradientLayer()
        addHomeBannerGradientLayer.frame = addHomeBannerView.bounds
        addHomeBannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        addHomeBannerView.layer.insertSublayer(addHomeBannerGradientLayer, atIndex: 0)
        addHomeBannerView.layer.addSublayer(addHomeBannerGradientLayer)
        addHomeBannerView.hidden = false
        myHomesView.addSubview(addHomeBannerView)
        
        let labelFontSize = isSmallerScreen ? 20.0 : 24.0;
        
        //UIImageView
        let homeIcn = UIImage(named: "home_icon") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((addHomeBannerView.bounds.size.width / 2) - (12.5 + 100), 12.5, 25, 25))
        homeIcon.image = homeIcn
        addHomeBannerView.addSubview(homeIcon)
        
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(0, 0, addHomeBannerView.bounds.size.width, 50))
        bannerLabel.text = "MY HOMES"
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.font = UIFont(name: "forza-light", size: CGFloat(labelFontSize))
        addHomeBannerView.addSubview(bannerLabel)
        
        scrollView.frame = (frame: CGRectMake(0, 185, myHomesView.bounds.size.width, myHomesView.bounds.size.height - 185))
        scrollView.backgroundColor = UIColor.clearColor()
        myHomesView.addSubview(scrollView)
        
        buildCalcTray()
        buildHomeTray()
        
        yOffset += 164
        
        buildSaveDeleteTray()
        
        var fontSize = 24 as CGFloat
        if modelName.rangeOfString("5") != nil{
            fontSize = 18
        }
        
        calcBannerView.frame = (frame: CGRectMake(0, yOffset, scrollView.bounds.size.width, 50))
        calcBannerGradientLayer.frame = calcBannerView.bounds
        calcBannerGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        calcBannerView.layer.insertSublayer(calcBannerGradientLayer, atIndex: 0)
        calcBannerView.layer.addSublayer(calcBannerGradientLayer)
        calcBannerView.hidden = false
        scrollView.addSubview(calcBannerView)
        
        let calcIcn = UIImage(named: "calculator_icon") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake(15, 12.5, 25, 25))
        calcIcon.image = calcIcn
        calcBannerView.addSubview(calcIcon)
        
        // UILabel
        let calcBannerLabel = UILabel(frame: CGRectMake(50, 0, calcBannerView.bounds.size.width - 50, 50))
        calcBannerLabel.text = "MORTGAGE CALCULATOR"
        calcBannerLabel.font = UIFont(name: "forza-light", size: fontSize)
        calcBannerLabel.textAlignment = NSTextAlignment.Left
        calcBannerLabel.textColor = UIColor.whiteColor()
        calcBannerView.addSubview(calcBannerLabel)
        
        let expandIcn = UIImage(named: "expand_white") as UIImage?
        expandIcon.frame = (frame: CGRectMake(calcBannerView.bounds.size.width - 50, 0, 50, 50))
        expandIcon.image = expandIcn
        calcBannerView.addSubview(expandIcon)
        
        let calcBannerButton = UIButton(frame: CGRectMake(0, 0, calcBannerView.bounds.size.width, calcBannerView.bounds.size.height))
        calcBannerButton.addTarget(self, action: #selector(IndividualHomeViewController.showHideCalcTray(_:)), forControlEvents: .TouchUpInside)
        calcBannerButton.backgroundColor = UIColor.clearColor()
        calcBannerView.addSubview(calcBannerButton)
        
        loadingOverlay.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.size.height))
        loadingOverlay.backgroundColor = UIColor.darkGrayColor()
        loadingOverlay.hidden = true
        loadingOverlay.alpha = 0.85
        self.view.addSubview(loadingOverlay)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = view.center
        loadingOverlay.addSubview(activityIndicator)
        
        scrollView.contentSize = CGSize(width: myHomesView.bounds.size.width, height: yOffset + 250)
    }

    func buildHomeTray() {
        
        var h = 670.0
        if (modelName.rangeOfString("iPad") != nil) {
            h = 920.0
        }
        
        homeTray.frame = (frame: CGRectMake(0, 0, scrollView.bounds.size.width, CGFloat(h)))
        homeTray.backgroundColor = model.lightGrayColor
        scrollView.addSubview(homeTray)
        
        var y = 250.0
        //if (modelName.rangeOfString("iPad") != nil) {
        if (self.view.bounds.size.width >= 768) {
            y = 500.0
        }
        
        defaultImageView.frame = (frame: CGRectMake(0, 0, scrollView.bounds.size.width, CGFloat(y)))
        defaultImageView.contentMode = .ScaleAspectFill
        defaultImageView.clipsToBounds = true
        defaultImageView.image = UIImage(named: "default_home") as UIImage?
        homeTray.addSubview(defaultImageView)
        
        let imageCountView = UIView(frame: CGRectMake(self.defaultImageView.bounds.size.width - 85, 10, 75, 25))
        imageCountView.backgroundColor = UIColor.darkGrayColor()
        imageCountView.alpha = 0.85
        defaultImageView.addSubview(imageCountView)
        
        // UILabel
        self.imageCountLabel.frame = (frame: CGRectMake(0, 0, imageCountView.bounds.size.width, 25))
        self.imageCountLabel.font = UIFont(name: "Arial", size: 15)
        self.imageCountLabel.text = String(format: "0 of 0", self.imageArray.count)
        self.imageCountLabel.textAlignment = NSTextAlignment.Center
        self.imageCountLabel.textColor = UIColor.whiteColor()
        imageCountView.addSubview(self.imageCountLabel)
        
        let homeNameborder = CALayer()
        let width = CGFloat(1.0)
        
        var homeName = ""
        if let _ = homeObject["name"] {
            homeName = homeObject["name"] as! String
        }
        else {
            homeObject["name"] = homeName
        }
        
        // UITextField
        homeNameTxtField.frame = (frame: CGRectMake(10, CGFloat(y), homeTray.bounds.size.width - 125, 40))
        homeNameborder.borderColor = UIColor.lightGrayColor().CGColor
        homeNameborder.frame = CGRect(x: 0, y: homeNameTxtField.frame.size.height - width, width:  homeNameTxtField.frame.size.width, height: homeNameTxtField.frame.size.height)
        homeNameborder.borderWidth = width
        homeNameTxtField.layer.addSublayer(homeNameborder)
        homeNameTxtField.layer.masksToBounds = true
        homeNameTxtField.text = homeName as String
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.returnKeyType = .Next
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        homeNameTxtField.font = UIFont(name: "forza-light", size: 22)
        homeNameTxtField.enabled = false
        homeNameTxtField.hidden = true
        homeTray.addSubview(homeNameTxtField)
        
        // UILabel
        homeNameLabel.frame = (frame: CGRectMake(10, CGFloat(y + 7), homeTray.bounds.size.width - 125, 0))
        homeNameLabel.text = homeNameTxtField.text
        homeNameLabel.textColor = UIColor.darkTextColor()
        homeNameLabel.textAlignment = NSTextAlignment.Left
        homeNameLabel.font = UIFont(name: "forza-light", size: 22)
        homeNameLabel.hidden = false
        homeNameLabel.numberOfLines = 0
        homeNameLabel.sizeToFit()
        homeTray.addSubview(homeNameLabel)
        
        y += (Double(homeNameLabel.bounds.size.height) > 40) ? Double(homeNameLabel.bounds.size.height) + 10.0 : 40.0
        
        homeNameBorderView.frame = (frame: CGRectMake(10, CGFloat(y), homeTray.bounds.size.width - 125, 1))
        homeNameBorderView.backgroundColor = UIColor.lightGrayColor()
        homeNameBorderView.hidden = false
        homeTray.addSubview(homeNameBorderView)
        
        let attributes = [
            NSForegroundColorAttributeName:  UIColor.lightGrayColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        
        var price = 0.0
        if let _ = homeObject["price"] {
            price = homeObject["price"] as! Double
        }
        else {
            homeObject["price"] = price
        }
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let homePrice = formatter.stringFromNumber(price)! as String
        
        let homePriceborder = CALayer()
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, CGFloat(y), homeTray.bounds.size.width - 20, 40))
        homePriceborder.borderColor = UIColor.lightGrayColor().CGColor
        homePriceborder.frame = CGRect(x: 0, y: homePriceTxtField.frame.size.height - width, width:  homePriceTxtField.frame.size.width, height: homePriceTxtField.frame.size.height)
        homePriceborder.borderWidth = width
        homePriceTxtField.layer.addSublayer(homePriceborder)
        homePriceTxtField.layer.masksToBounds = true
        if (price > 0) {
            homePriceTxtField.text = homePrice as String
        }
        else {
            homePriceTxtField.attributedPlaceholder = NSAttributedString(string: homePrice as String, attributes:attributes)
        }
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Next
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        homePriceTxtField.font = UIFont(name: "forza-light", size: 22)
        homePriceTxtField.enabled = false
        homeTray.addSubview(homePriceTxtField)
        
        y += Double(homePriceTxtField.bounds.size.height) + 5.0

        var homeAddress = ""
        if let _ = homeObject["address"] {
            homeAddress = homeObject["address"] as! String
        }
        else {
            homeObject["address"] = homeAddress
        }
        
        let homeAddressborder = CALayer()
        //UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, CGFloat(y), homeTray.bounds.size.width - 20, 40))
        homeAddressborder.borderColor = UIColor.lightGrayColor().CGColor
        homeAddressborder.frame = CGRect(x: 0, y: homeAddressTxtField.frame.size.height - width, width:  homeAddressTxtField.frame.size.width, height: homeAddressTxtField.frame.size.height)
        homeAddressborder.borderWidth = width
        homeAddressTxtField.layer.addSublayer(homeAddressborder)
        homeAddressTxtField.layer.masksToBounds = true
        if (homeAddress.characters.count > 0) {
            homeAddressTxtField.text = homeAddress as String
        }
        else {
            homeAddressTxtField.attributedPlaceholder = NSAttributedString(string: "ADDRESS" as String, attributes:attributes)
        }
        homeAddressTxtField.backgroundColor = UIColor.clearColor()
        homeAddressTxtField.delegate = self
        homeAddressTxtField.returnKeyType = .Next
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        homeAddressTxtField.font = UIFont(name: "forza-light", size: 22)
        homeAddressTxtField.enabled = false
        homeAddressTxtField.hidden = true
        homeTray.addSubview(homeAddressTxtField)
        
        // UILabel
        homeAddressLabel.frame = (frame: CGRectMake(10, CGFloat(y + 5), homeTray.bounds.size.width - 20, 0))
        if (homeAddress.characters.count > 0) {
            homeAddressLabel.text = homeAddressTxtField.text
            homeAddressLabel.textColor = UIColor.darkTextColor()
        }
        else {
            homeAddressLabel.text = "ADDRESS"
            homeAddressLabel.textColor = UIColor.lightGrayColor()
        }
        homeAddressLabel.textAlignment = NSTextAlignment.Left
        homeAddressLabel.font = UIFont(name: "forza-light", size: 22)
        homeAddressLabel.hidden = false
        homeAddressLabel.numberOfLines = 0
        homeAddressLabel.sizeToFit()
        homeTray.addSubview(homeAddressLabel)
        
        y += (Double(homeAddressLabel.bounds.size.height) > 40) ? Double(homeAddressLabel.bounds.size.height) + 7 : 40.0
        
        homeAddressBorderView.frame = (frame: CGRectMake(10, CGFloat(y), homeTray.bounds.size.width - 20, 1))
        homeAddressBorderView.backgroundColor = UIColor.lightGrayColor()
        homeAddressBorderView.hidden = false
        homeTray.addSubview(homeAddressBorderView)
        
        var buttonY = 250.0
        if (modelName.rangeOfString("iPad") != nil) {
            buttonY = 500.0
        }
        
        // UIButton
        let addIcn = UIImage(named: "camera_icon") as UIImage?
        let addIcon = UIImageView(frame: CGRectMake(homeTray.bounds.size.width - 105, CGFloat(buttonY + 5), 34.29, 30))
        addIcon.image = addIcn
        homeTray.addSubview(addIcon)
        
        let addImagesButton = UIButton (frame: CGRectMake(homeTray.bounds.size.width - 120, CGFloat(buttonY), 60, 50))
        addImagesButton.addTarget(self, action: #selector(IndividualHomeViewController.selectWhereToGetImage(_:)), forControlEvents: .TouchUpInside)
        addImagesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addImagesButton.backgroundColor = UIColor.clearColor()
        addImagesButton.tag = 0
        homeTray.addSubview(addImagesButton)
        
        // UIButton
        let editIcn = UIImage(named: "edit_icon") as UIImage?
        editIcon.frame = (frame: CGRectMake(homeTray.bounds.size.width - 55, CGFloat(buttonY + 5), 34.27, 30))
        editIcon.image = editIcn
        homeTray.addSubview(editIcon)
        
        editButton.frame = (frame: CGRectMake(homeTray.bounds.size.width - 60, CGFloat(buttonY), 60, 50))
        editButton.addTarget(self, action: #selector(IndividualHomeViewController.allowEdit(_:)), forControlEvents: .TouchUpInside)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        homeTray.addSubview(editButton)
        
        y += 10.0
        var xOffset = 0
        userRating = 0
        if let _ = homeObject["rating"] {
            userRating = homeObject["rating"] as! Int
        }
        else {
            homeObject["rating"] = userRating
        }
        
        for i in 1...5 {
            // UIButton
            let ratingButton = UIButton(frame: CGRectMake(CGFloat(10 + xOffset), CGFloat(y), 35, 35))
            ratingButton.addTarget(self, action: #selector(IndividualHomeViewController.setRating(_:)), forControlEvents: .TouchUpInside)
            ratingButton.backgroundColor = model.darkBlueColor
            if i <= userRating {
                ratingButton.setImage(UIImage(named: "star_on_icon"), forState: .Normal)
            }
            else {
                ratingButton.setImage(UIImage(named: "star_off_icon"), forState: .Normal)
            }
            ratingButton.tag = i
            scrollView.addSubview(ratingButton)
            
            ratingButtonArray.append(ratingButton)
            
            xOffset += 40
        }
        
        y += 45.0
        var bed = 0
        if let _ = homeObject["beds"] {
            bed = (homeObject["beds"] as? Int)!
        }
        else {
            homeObject["beds"] = bed
        }
        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(15, CGFloat(y), (homeTray.bounds.size.width / 3) - 20, 30))
        let bedPaddingView = UIView(frame: CGRectMake(0, 0, (bedsTxtField.bounds.size.width / 2) - 5, 50))
        bedsTxtField.leftView = bedPaddingView
        bedsTxtField.leftViewMode = UITextFieldViewMode.Always
        if (bed > 0) {
            bedsTxtField.text = String(format: "%d", bed)
        }
        else {
            bedsTxtField.attributedPlaceholder = NSAttributedString(string: String(format: "%d", bed), attributes:attributes)
        }
        bedsTxtField.backgroundColor = model.lightGrayColor
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Next
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
        bedsTxtField.font = UIFont(name: "Arial", size: 14)
        bedsTxtField.enabled = false
        homeTray.addSubview(bedsTxtField)
        
        bedsLabel.frame = (frame: CGRectMake(15, CGFloat(y + 20), (homeTray.bounds.size.width / 3) - 20, 30))
        bedsLabel.text = "Beds"
        bedsLabel.textAlignment = NSTextAlignment.Center
        bedsLabel.numberOfLines = 1
        bedsLabel.font = bedsLabel.font.fontWithSize(14)
        bedsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bedsLabel)
        
        let vertDividerTwoView = UIView(frame: CGRectMake(homeTray.bounds.size.width / 3, CGFloat(y), 1, 50))
        vertDividerTwoView.backgroundColor = UIColor.lightGrayColor()
        vertDividerTwoView.hidden = false
        homeTray.addSubview(vertDividerTwoView)
        
        var bath = 0.0
        if let _ = homeObject["baths"] {
            bath = (homeObject["baths"] as? Double)!
        }
        else {
            homeObject["baths"] = bath
        }

        // UITextField
        bathsTxtField.frame = (frame: CGRectMake((homeTray.bounds.size.width / 3) + 5, CGFloat(y), (homeTray.bounds.size.width / 3) - 20, 30))
        let bathPaddingView = UIView(frame: CGRectMake(0, 0, (bedsTxtField.bounds.size.width / 2) - 5, 50))
        bathsTxtField.leftView = bathPaddingView
        bathsTxtField.leftViewMode = UITextFieldViewMode.Always
        if (bath > 0) {
            bathsTxtField.text = String(format: "%.1f", bath)
        }
        else {
            bathsTxtField.attributedPlaceholder = NSAttributedString(string: String(format: "%.1f", bath), attributes:attributes)
        }
        bathsTxtField.backgroundColor = model.lightGrayColor
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Next
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
        bathsTxtField.font = UIFont(name: "Arial", size: 14)
        bathsTxtField.enabled = false
        homeTray.addSubview(bathsTxtField)
        
        bathsLabel.frame = (frame: CGRectMake((homeTray.bounds.size.width / 3) + 10, CGFloat(y + 20), (homeTray.bounds.size.width / 3) - 20, 30))
        bathsLabel.text = "Baths"
        bathsLabel.textAlignment = NSTextAlignment.Center
        bathsLabel.numberOfLines = 1
        bathsLabel.font = bathsLabel.font.fontWithSize(14)
        bathsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bathsLabel)
        
        let vertDividerThreeView = UIView(frame: CGRectMake(homeTray.bounds.size.width * 0.66, CGFloat(y), 1, 50))
        vertDividerThreeView.backgroundColor = UIColor.lightGrayColor()
        vertDividerThreeView.hidden = false
        homeTray.addSubview(vertDividerThreeView)

        var homeSqft = 0
        if let _ = homeObject["footage"] {
            homeSqft = (homeObject["footage"] as? Int)!
        }
        else {
            homeObject["footage"] = homeSqft
        }
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake((homeTray.bounds.size.width * 0.66) + 10, CGFloat(y), (homeTray.bounds.size.width / 3) - 20, 30))
        let sqFeetPaddingView = UIView(frame: CGRectMake(0, 0, (bedsTxtField.bounds.size.width / 2) - 15, 50))
        sqFeetTxtField.leftView = sqFeetPaddingView
        sqFeetTxtField.leftViewMode = UITextFieldViewMode.Always
        if (homeSqft > 0) {
            sqFeetTxtField.text = String(format: "%d", homeSqft)
        }
        else {
            sqFeetTxtField.attributedPlaceholder = NSAttributedString(string: String(format: "%d", homeSqft), attributes:attributes)
        }
        sqFeetTxtField.backgroundColor = model.lightGrayColor
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Next
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
        sqFeetTxtField.font = UIFont(name: "Arial", size: 14)
        sqFeetTxtField.enabled = false
        homeTray.addSubview(sqFeetTxtField)
        
        sqFeetLabel.frame = (frame: CGRectMake((homeTray.bounds.size.width * 0.66) + 10, CGFloat(y + 20), (homeTray.bounds.size.width / 3) - 20, 30))
        sqFeetLabel.text = "Sq. Ft."
        sqFeetLabel.textAlignment = NSTextAlignment.Center
        sqFeetLabel.numberOfLines = 1
        sqFeetLabel.font = sqFeetLabel.font.fontWithSize(14)
        sqFeetLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(sqFeetLabel)
        
        y += 65
        
        var desc = ""
        if let _ = self.homeObject["desc"] {
            desc =  self.homeObject["desc"] as! String
        }
        else {
            self.homeObject["desc"] = desc
        }
        
        //Create textview
        self.descTxtView.frame = (frame : CGRectMake(10, CGFloat(y), self.homeTray.bounds.size.width - 20, 150))
        self.descTxtView.backgroundColor = UIColor.whiteColor()
        self.descTxtView.text = desc
        self.descTxtView.autocorrectionType = .Yes
        self.descTxtView.editable = false
        if desc == "Add notes about this house." {
            self.descTxtView.textColor = UIColor.lightGrayColor()
        }
        self.descTxtView.font = UIFont(name: "forza-light", size: 22)
        self.descTxtView.delegate = self
        self.homeTray.addSubview(self.descTxtView)
        
        yOffset = CGFloat(y)
        
        setDefaultImage()
    }
    
    func buildCalcTray() {
        calcTray.frame = (frame: CGRectMake(0, 0, scrollView.bounds.size.width, 450))
        calcTray.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(calcTray)
        
        let mortView = UIView(frame: CGRectMake(0, 0, calcTray.bounds.size.width, 250))
        mortView.backgroundColor = UIColor.whiteColor()
        calcTray.addSubview(mortView)
        
        //mortgageView.buildMortgageCalcView(mortView)
        /********************************************************* Loan Amount ********************************************************************/
        // UILabel
        let loanAmountLabel = UILabel(frame: CGRectMake(10, 25, (mortView.bounds.size.width / 2) - 20, 40))
        loanAmountLabel.text = "SALE PRICE = "
        loanAmountLabel.font = UIFont(name: "forza-light", size: 14)
        loanAmountLabel.textAlignment = NSTextAlignment.Right
        loanAmountLabel.textColor = UIColor.darkTextColor()
        mortView.addSubview(loanAmountLabel)
        
        // UITextField
        let loanAmountPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        loanAmountTxtField.frame = (frame: CGRectMake((mortView.bounds.size.width / 2) + 10, 25,(mortView.bounds.size.width / 2) - 20, 40));
        loanAmountTxtField.layer.borderColor = model.lightGrayColor.CGColor
        loanAmountTxtField.layer.borderWidth = 1.0
        loanAmountTxtField.layer.cornerRadius = 2.0
        loanAmountTxtField.leftView = loanAmountPaddingView
        loanAmountTxtField.leftViewMode = UITextFieldViewMode.Always
        loanAmountTxtField.placeholder = "$250,000"
        loanAmountTxtField.backgroundColor = UIColor.clearColor()
        loanAmountTxtField.delegate = self
        loanAmountTxtField.returnKeyType = .Done
        loanAmountTxtField.keyboardType = UIKeyboardType.NumberPad
        loanAmountTxtField.font = UIFont(name: "forza-light", size: 22)
        mortView.addSubview(loanAmountTxtField)
        
        /********************************************************* Mortgage Term ********************************************************************/
         // UILabel
        let mTermLabel = UILabel(frame: CGRectMake(10, 75, (mortView.bounds.size.width / 2) - 20, 40))
        mTermLabel.text = "MORTGAGE TERM = "
        mTermLabel.font = UIFont(name: "forza-light", size: 14)
        mTermLabel.textAlignment = NSTextAlignment.Right
        mTermLabel.textColor = UIColor.darkTextColor()
        mortView.addSubview(mTermLabel)

        
        // UITextField
        let mTermAmountPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        mortgageTxtField.frame = (frame: CGRectMake((mortView.bounds.size.width / 2) + 10, 75,(mortView.bounds.size.width / 2) - 20, 40));
        mortgageTxtField.layer.borderColor = model.lightGrayColor.CGColor
        mortgageTxtField.layer.borderWidth = 1.0
        mortgageTxtField.layer.cornerRadius = 2.0
        mortgageTxtField.leftView = mTermAmountPaddingView
        mortgageTxtField.leftViewMode = UITextFieldViewMode.Always
        mortgageTxtField.placeholder = "30 YEARS"
        mortgageTxtField.backgroundColor = UIColor.clearColor()
        mortgageTxtField.delegate = self
        mortgageTxtField.returnKeyType = .Done
        mortgageTxtField.keyboardType = UIKeyboardType.NumberPad
        mortgageTxtField.font = UIFont(name: "forza-light", size: 22)
        mortView.addSubview(mortgageTxtField)
        
        /********************************************************* Interest Rate ********************************************************************/
         // UILabel
        let interestRateLabel = UILabel(frame: CGRectMake(10, 125, (mortView.bounds.size.width / 2) - 20, 40))
        interestRateLabel.text = "INTEREST RATE = "
        interestRateLabel.font = UIFont(name: "forza-light", size: 14)
        interestRateLabel.textAlignment = NSTextAlignment.Right
        interestRateLabel.textColor = UIColor.darkTextColor()
        mortView.addSubview(interestRateLabel)
        
        // UITextField
        let interestAmountPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        interestTxtField.frame = (frame: CGRectMake((mortView.bounds.size.width / 2) + 10, 125,(mortView.bounds.size.width / 2) - 20, 40));
        interestTxtField.layer.borderColor = model.lightGrayColor.CGColor
        interestTxtField.layer.borderWidth = 1.0
        interestTxtField.layer.cornerRadius = 2.0
        interestTxtField.leftView = interestAmountPaddingView
        interestTxtField.leftViewMode = UITextFieldViewMode.Always
        interestTxtField.placeholder = "3.5%"
        interestTxtField.backgroundColor = UIColor.clearColor()
        interestTxtField.delegate = self
        interestTxtField.returnKeyType = .Done
        interestTxtField.keyboardType = UIKeyboardType.DecimalPad
        interestTxtField.font = UIFont(name: "forza-light", size: 22)
        mortView.addSubview(interestTxtField)
        
        /********************************************************* Down Payment ********************************************************************/
         // UILabel
        let downPaymentLabel = UILabel(frame: CGRectMake(10, 175, (mortView.bounds.size.width / 2) - 20, 40))
        downPaymentLabel.text = "DOWNPAYMENT = "
        downPaymentLabel.font = UIFont(name: "forza-light", size: 14)
        downPaymentLabel.textAlignment = NSTextAlignment.Right
        downPaymentLabel.textColor = UIColor.darkTextColor()
        mortView.addSubview(downPaymentLabel)
        
        // UITextField
        let downPaymentPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        downPaymentTxtField.frame = (frame: CGRectMake((mortView.bounds.size.width / 2) + 10, 175,(mortView.bounds.size.width / 2) - 20, 40));
        downPaymentTxtField.layer.borderColor = model.lightGrayColor.CGColor
        downPaymentTxtField.layer.borderWidth = 1.0
        downPaymentTxtField.layer.cornerRadius = 2.0
        downPaymentTxtField.leftView = downPaymentPaddingView
        downPaymentTxtField.leftViewMode = UITextFieldViewMode.Always
        downPaymentTxtField.placeholder = "$5,000"
        downPaymentTxtField.backgroundColor = UIColor.clearColor()
        downPaymentTxtField.delegate = self
        downPaymentTxtField.returnKeyType = .Done
        downPaymentTxtField.keyboardType = UIKeyboardType.NumberPad
        downPaymentTxtField.font = UIFont(name: "forza-light", size: 22)
        mortView.addSubview(downPaymentTxtField)
         
        // UIView
        let calculateView = UIView(frame: CGRectMake(25, 275, calcTray.bounds.size.width - 50, 50))
        let calcGradientLayer = CAGradientLayer()
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        calcTray.addSubview(calculateView)
        
        let calculateArrow = UILabel (frame: CGRectMake(calculateView.bounds.size.width - 50, 5, 40, 45))
        calculateArrow.textAlignment = NSTextAlignment.Right
        calculateArrow.font = UIFont(name: "forza-light", size: 40)
        calculateArrow.text = ">"
        calculateArrow.textColor = UIColor.whiteColor()
        calculateView.addSubview(calculateArrow)
        
        // UIButton
        let calculateButton = UIButton (frame: CGRectMake(25, 0, calculateView.bounds.size.width - 25, 50))
        calculateButton.addTarget(self, action: #selector(IndividualHomeViewController.calculateMortgagePaymentButtonPress(_:)), forControlEvents: .TouchUpInside)
        calculateButton.setTitle("CALCULATE", forState: .Normal)
        calculateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        calculateButton.backgroundColor = UIColor.clearColor()
        calculateButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        calculateButton.contentHorizontalAlignment = .Left
        calculateButton.tag = 0
        calculateView.addSubview(calculateButton)
        
        let btnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let btnView = UIImageView(frame: CGRectMake(0, calculateView.bounds.size.height, calculateView.bounds.size.width, 15))
        btnView.image = btnImg
        calculateView.addSubview(btnView)
        
        // UILabel
        estPaymentLabel.frame = (frame: CGRectMake(25, 335, calcTray.bounds.size.width - 50, 25))
        estPaymentLabel.text = "YOUR ESTIMATED PAYMENT IS:"
        estPaymentLabel.font = UIFont(name: "forza-light", size: 14)
        estPaymentLabel.textAlignment = NSTextAlignment.Left
        calcTray.addSubview(estPaymentLabel)
        
        // UIView
        let paymentView = UIView(frame: CGRectMake(25, 355, calcTray.bounds.size.width - 50, 50))
        let paymentGradientLayer = CAGradientLayer()
        paymentGradientLayer.frame = paymentView.bounds
        paymentGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        paymentView.layer.insertSublayer(paymentGradientLayer, atIndex: 0)
        paymentView.layer.addSublayer(paymentGradientLayer)
        calcTray.addSubview(paymentView)
        
        // UILabel
        paymentLabel.frame = (frame: CGRectMake(0, 0, paymentView.bounds.size.width, 50))
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
        paymentLabel.font = UIFont(name: "forza-light", size: 25)
        paymentLabel.textColor = UIColor.whiteColor()
        paymentLabel.textAlignment = NSTextAlignment.Center
        paymentView.addSubview(paymentLabel)
        
        // UILabel
        let noteLabel = UILabel(frame: CGRectMake(25, 415, paymentView.bounds.size.width - 50, 0))
        noteLabel.text = "Note: The payment calculated is Principal & Interest only. It does not include property taxes, insurance or PMI, if applicable."
        noteLabel.font = UIFont(name: "forza-light", size: 14)
        noteLabel.numberOfLines = 0
        noteLabel.sizeToFit()
        noteLabel.textAlignment = NSTextAlignment.Left
        calcTray.addSubview(noteLabel)
        
    }
    
    func buildSaveDeleteTray() {
        
        saveDeleteTray.frame = (frame: CGRectMake(0, CGFloat(self.yOffset + 60), scrollView.bounds.size.width, 450))
        saveDeleteTray.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(saveDeleteTray)
        
        // UIView
        let deleteView = UIView(frame: CGRectMake(25, 5, calcTray.bounds.size.width - 50, 50))
        let deleteGradientLayer = CAGradientLayer()
        deleteGradientLayer.frame = deleteView.bounds
        deleteGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        deleteView.layer.insertSublayer(deleteGradientLayer, atIndex: 0)
        deleteView.layer.addSublayer(deleteGradientLayer)
        saveDeleteTray.addSubview(deleteView)
        
        // UIButton
        let deleteButton = UIButton (frame: CGRectMake(0, 0, deleteView.bounds.size.width, deleteView.bounds.size.height))
        deleteButton.addTarget(self, action: #selector(IndividualHomeViewController.deleteHome(_:)), forControlEvents: .TouchUpInside)
        deleteButton.setTitle("DELETE HOME", forState: .Normal)
        deleteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        deleteButton.backgroundColor = UIColor.clearColor()
        deleteButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        deleteButton.contentHorizontalAlignment = .Center
        deleteButton.tag = 0
        deleteView.addSubview(deleteButton)
        
        let deleteButtonShadowImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let deleteButtonShadowView = UIImageView(frame: CGRectMake(0, deleteView.bounds.size.height, deleteView.bounds.size.width, 15))
        deleteButtonShadowView.image = deleteButtonShadowImg
        deleteView.addSubview(deleteButtonShadowView)
        
        // UIView
        saveView.frame = (frame: CGRectMake(25, 65, calcTray.bounds.size.width - 50, 50))
        let saveGradientLayer = CAGradientLayer()
        saveGradientLayer.frame = saveView.bounds
        saveGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        saveView.layer.insertSublayer(saveGradientLayer, atIndex: 0)
        saveView.layer.addSublayer(saveGradientLayer)
        saveView.hidden = true
        saveDeleteTray.addSubview(saveView)
        
        // UIButton
        saveButton.frame = (frame: CGRectMake(0, 0, saveView.bounds.size.width, saveView.bounds.size.height))
        saveButton.addTarget(self, action: #selector(IndividualHomeViewController.updateHomeObject), forControlEvents: .TouchUpInside)
        saveButton.setTitle("SAVE HOME", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.backgroundColor = UIColor.clearColor()
        saveButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        saveButton.contentHorizontalAlignment = .Center
        saveButton.tag = 0
        //saveButton.hidden = true
        //saveButton.enabled = false
        saveView.addSubview(saveButton)
        
        let saveButtonShadowImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let saveButtonShadowView = UIImageView(frame: CGRectMake(0, saveView.bounds.size.height, saveView.bounds.size.width, 15))
        saveButtonShadowView.image = saveButtonShadowImg
        saveView.addSubview(saveButtonShadowView)
    }

    func showHideCalcTray(sender: UIButton) {
        if (!isCalcTrayOpen) {
            UIView.animateWithDuration(0.8, animations: {
                self.expandIcon.image = UIImage(named: "expand_white_up")
                self.calcTray.frame = (frame: CGRectMake(0, CGFloat(self.yOffset + 60), self.scrollView.bounds.size.width, 400))
                self.saveDeleteTray.frame = (frame: CGRectMake(0, CGFloat(self.yOffset + 550), self.scrollView.bounds.size.width, 400))
                }, completion: {
                    (value: Bool) in
                    if (self.modelName.rangeOfString("iPad") != nil) {
                        self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 1950)
                    }
                    else {
                        self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 1400)
                    }
                    
                    self.isCalcTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.8, animations: {
                self.expandIcon.image = UIImage(named: "expand_white")
                self.calcTray.frame = (frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 400))
                self.saveDeleteTray.frame = (frame: CGRectMake(0, CGFloat(self.yOffset + 60), self.scrollView.bounds.size.width, 400))
                }, completion: {
                    (value: Bool) in
                    if (self.modelName.rangeOfString("iPad") != nil) {
                        self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: self.yOffset + 750)
                    }
                    else {
                        self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: self.yOffset + 250)
                    }
                    
                    self.isCalcTrayOpen = false
            })
        }
    }
    
    func setDefaultImage() {
        if (homeObject["imageArray"] != nil) {
            
            imageArray = homeObject["imageArray"] as! [PFFile]
            if imageArray.count > 0 {
                let img = imageArray[0] as PFFile
                img.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.defaultImageView.image = image
                            
                            self.imageCountLabel.text = String(format: "1 of %d", self.imageArray.count)
                            
                            let overlayButton = UIButton(frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 250))
                            overlayButton.backgroundColor = UIColor.clearColor()
                            overlayButton.addTarget(self, action: #selector(IndividualHomeViewController.showImageOverlay(_:)), forControlEvents: .TouchUpInside)
                            self.scrollView.addSubview(overlayButton)
                            
                            self.imageOverlay(self.imageArray)
                        }
                    }
                    else {

                        let fillerImage = UIImage(named: "default_home") as UIImage?
                        self.defaultImageView.image = fillerImage
                        
                        self.displayMessage("HomeIn", message: "There was an error downloading your images.")
                        
                        self.homeObject["imageArray"] = []
                        self.homeObject.saveEventually()
                    
                    }
                }
            }
            else {
                let fillerImage = UIImage(named: "default_home") as UIImage?
                defaultImageView.image = fillerImage
            }
        }
    }
    
    func imageOverlay(imageArray: Array<PFFile>) {
        
        imageScollView.contentOffset.x = 0
        //let overlayColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = model.lightGrayColor
        overlayView.hidden = true
        self.view.addSubview(overlayView)
        
        imageScollView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        imageScollView.backgroundColor = UIColor.clearColor()
        imageScollView.delegate = self
        overlayView.addSubview(imageScollView)
        
        var xLocation = 0.0 as CGFloat
        for img: PFFile in imageArray {
            addImageToOverlayAtLocation(img, xLocation: xLocation)
            xLocation += self.scrollView.bounds.size.width
        }
        
        var labelWidth = 100.0 as CGFloat
        if imageArray.count > 9 {
            labelWidth = 125.0
        }
        
        imageIndexLabel.frame = (frame: CGRectMake((self.view.bounds.size.width / 2) - (labelWidth / 2), 25, labelWidth, 50))
        imageIndexLabel.text = String(format: "%d of %d", 1, imageArray.count)
        imageIndexLabel.font = UIFont(name: "forza-light", size: 35)
        imageIndexLabel.textAlignment = NSTextAlignment.Right
        imageIndexLabel.textColor = UIColor.whiteColor()
        overlayView.addSubview(imageIndexLabel)
        
        let closeButton = UIButton(frame: CGRectMake(self.view.bounds.size.width - 50, 25, 50, 50))
        closeButton.addTarget(self, action: #selector(IndividualHomeViewController.hideImageOverlay(_:)), forControlEvents: .TouchUpInside)
        closeButton.setTitle("X", forState: .Normal)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.titleLabel!.font = UIFont(name: "forza-light", size: 32)
        closeButton.tag = 0
        overlayView.addSubview(closeButton)
        
        deleteDefaultButton.frame = (frame: CGRectMake(10, self.view.bounds.size.height - 125, self.view.bounds.size.width - 20, 50))
        deleteDefaultButton.addTarget(self, action: #selector(IndividualHomeViewController.deleteImageFromArray(_:)), forControlEvents: .TouchUpInside)
        deleteDefaultButton.backgroundColor = model.lightRedColor
        deleteDefaultButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        deleteDefaultButton.setTitle("DELETE IMAGE", forState: .Normal)
        deleteDefaultButton.tag = 0
        overlayView.addSubview(deleteDefaultButton)
        
        saveImageDefaultButton.frame = (frame: CGRectMake(10, self.view.bounds.size.height - 65, self.view.bounds.size.width - 20, 50))
        saveImageDefaultButton.addTarget(self, action: #selector(IndividualHomeViewController.setImageAsDefault(_:)), forControlEvents: .TouchUpInside)
        saveImageDefaultButton.backgroundColor = model.lightRedColor
        saveImageDefaultButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        saveImageDefaultButton.setTitle("SET AS DEFAULT", forState: .Normal)
        saveImageDefaultButton.tag = 0
        overlayView.addSubview(saveImageDefaultButton)
        
        imageScollView.contentSize = CGSize(width: CGFloat(Int(scrollView.bounds.size.width) * imageArray.count), height: 250)
    }
    
    func addImageToOverlayAtLocation(img: PFFile, xLocation: CGFloat) {
        img.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    let homeImageView = UIImageView(frame: CGRectMake(CGFloat(xLocation), 0, self.view.bounds.size.width, self.view.bounds.size.height))
                    homeImageView.contentMode = .ScaleAspectFit
                    homeImageView.backgroundColor = UIColor.clearColor()
                    self.imageScollView.addSubview(homeImageView)
                    homeImageView.image = image
                }
            }
        }
    }
    
    // MARK:
    // MARK: UIScrollViewDelegate
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /**
        * Here we target a specific cell index to move towards
        */
        let imageWidth = self.view.bounds.size.width as CGFloat
        if (velocity.x == 0.0)
        {
            // A 0 velocity means the user dragged and stopped (no flick)
            // In this case, tell the scroll view to animate to the closest index
            if (targetContentOffset.memory.x > scrollLocation) {
                if imageIndex < imageArray.count - 1 {
                    imageIndex += 1
                    scrollLocation = imageWidth * CGFloat(imageIndex)
                }
            }
            else {
                if imageIndex > 0 {
                    imageIndex -= 1
                    scrollLocation = imageWidth * CGFloat(imageIndex)
                }
            }
        }
        else if (velocity.x > 0.0)
        {
            // User scrolled right
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            if imageIndex < imageArray.count - 1 {
                imageIndex += 1
                scrollLocation = imageWidth * CGFloat(imageIndex)
            }
        }
        else
        {
            // User scrolled left
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            if imageIndex > 0 {
                imageIndex -= 1
                scrollLocation = imageWidth * CGFloat(imageIndex)
            }
        }
        
        // Return our adjusted target point
        // Adjust stopping point to exact beginning of cell.
        targetContentOffset.memory.x = scrollLocation
        imageIndexLabel.text = String(format: "%d of %d", Int(imageIndex) + 1, imageArray.count)
        saveImageDefaultButton.tag = Int(imageIndex)
        deleteDefaultButton.tag = Int(imageIndex)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.homeNameTxtField {
            self.homePriceTxtField.becomeFirstResponder()
        }
        else if textField == self.homeAddressTxtField {
            self.descTxtView.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        homeNameString = homeNameTxtField.text!
        
        if textField == bedsTxtField {
            if bedsTxtField.text == "" {
                var bed = 0
                if let _ = homeObject["beds"] {
                    bed = (homeObject["beds"] as? Int)!
                    bedsTxtField.text = String(format: "%d", bed)
                }
            }
        }
        else if textField == bathsTxtField {
            if bathsTxtField.text == "" {
                var bath = 0.0
                if let _ = homeObject["baths"] {
                    bath = (homeObject["baths"] as? Double)!
                    bathsTxtField.text = String(format: "%.1f", bath)
                }
            }
        }
        else if textField == sqFeetTxtField {
            if sqFeetTxtField.text == "" {
                var homeSqft = 0
                if let _ = homeObject["footage"] {
                    homeSqft = (homeObject["footage"] as? Int)!
                    sqFeetTxtField.text = String(format: "%d", homeSqft)
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == homeNameTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 200
                }, completion: nil)
        }
        else if textField == homePriceTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 250
                }, completion: nil)
        }
        else if textField == bedsTxtField || textField == bathsTxtField || textField == sqFeetTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 350
                }, completion: nil)

            if textField == bedsTxtField {
                bedsTxtField.text = ""
            }
            else if textField == bathsTxtField {
                bathsTxtField.text = ""
            }
            else if textField == sqFeetTxtField {
                sqFeetTxtField.text = ""
            }
        }
        else if textField == homeAddressTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 425
                }, completion: nil)
        }
        else if textField == loanAmountTxtField {
            userDidEnterEditMode()
            
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 800
                }, completion: nil)
        }
        else if textField == mortgageTxtField {
            userDidEnterEditMode()
            
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 850
                }, completion: nil)
        }
        else if textField == interestTxtField {
            userDidEnterEditMode()
            
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 900
                }, completion: nil)
        }
        else if textField == downPaymentTxtField {
            userDidEnterEditMode()
            
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 950
                }, completion: nil)
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == homePriceTxtField || textField == bathsTxtField || textField == loanAmountTxtField || textField == mortgageTxtField || textField == interestTxtField || textField == downPaymentTxtField {
            // Create an `NSCharacterSet` set which includes everything *but* the digits
            let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
            
            // At every character in this "inverseSet" contained in the string,
            // split the string up into components which exclude the characters
            // in this inverse set
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            
            // Rejoin these components
            let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
            
            // If the original string is equal to the filtered string, i.e. if no
            // inverse characters were present to be eliminated, the input is valid
            // and the statement returns true; else it returns false
            return string == filtered
        }
        else if textField == bedsTxtField || textField == sqFeetTxtField {
            // Create an `NSCharacterSet` set which includes everything *but* the digits
            let inverseSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
            
            // At every character in this "inverseSet" contained in the string,
            // split the string up into components which exclude the characters
            // in this inverse set
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            
            // Rejoin these components
            let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
            
            // If the original string is equal to the filtered string, i.e. if no
            // inverse characters were present to be eliminated, the input is valid
            // and the statement returns true; else it returns false
            return string == filtered

        }
        else {
            return true
        }
    }
    
    // MARK:
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textColor = UIColor.blackColor()
        
        UIView.animateWithDuration(0.4, animations: {
            self.scrollView.contentOffset.y = 500
            }, completion: nil)
        
        if textView.text == "Add notes about this house." {
            textView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add notes about this house."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    // MARK:
    // MARK: Navigation
    func navigateBackHome(sender: UIButton) {
        if didEnterEditMode {
            let alertController = UIAlertController(title: "HomeIn", message: "You entered into edit mode but have not saved your home. If you exit now any changes will not be saved.", preferredStyle: .Alert)
            
            let CancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
                
            }
            
            let OKAction = UIAlertAction(title: "Exit Anyway", style: .Default) { (action) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // MARK:
    // MARK: Action Methods
    func showImageOverlay(sender: UIButton) {
        overlayView.hidden = false
    }
    
    func hideImageOverlay(sender: UIButton) {
        overlayView.hidden = true
        imageIndex = 0
        imageScollView.contentOffset.x = 0
        imageIndexLabel.text = String(format: "%d of %d", Int(imageIndex) + 1, imageArray.count)
    }
    
    func setRating(sender: UIButton) {
        tapGesture()
        
        if (isTextFieldEnabled) {
            
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 300
                }, completion: nil)
            
            userRating = sender.tag
            for i in 0...4 {
                let button = ratingButtonArray[i] as UIButton
                if i < sender.tag {
                    button.setImage(UIImage(named: "star_on_icon"), forState: .Normal)
                }
                else {
                    button.setImage(UIImage(named: "star_off_icon"), forState: .Normal)
                }
            }
        }
    }
    
    func allowEdit(sender: UIButton) {
        didEnterEditMode = true
        saveView.hidden = false
        saveButton.hidden = false
        saveButton.enabled = true
        
        homeNameLabel.text = homeNameTxtField.text
        homeAddressLabel.text = homeAddressTxtField.text

        if (!isTextFieldEnabled) {
            homeNameTxtField.enabled = true
            homePriceTxtField.enabled = true
            homeAddressTxtField.enabled = true
            bedsTxtField.enabled = true
            bathsTxtField.enabled = true
            sqFeetTxtField.enabled = true
            descTxtView.editable = true
            
            homeNameTxtField.hidden = false
            homeNameBorderView.hidden = true
            homeNameLabel.hidden = true
            
            homeAddressTxtField.hidden = false
            homeAddressBorderView.hidden = true
            homeAddressLabel.hidden = true
            
            isTextFieldEnabled = true
            editIcon.image = UIImage(named: "edit_red")
            
            editModeLabel.textColor = model.lightRedColor
            
            homeNameTxtField.becomeFirstResponder()
        }
        else {
            homeNameTxtField.enabled = false
            homePriceTxtField.enabled = false
            homeAddressTxtField.enabled = false
            bedsTxtField.enabled = false
            bathsTxtField.enabled = false
            sqFeetTxtField.enabled = false
            descTxtView.editable = false
            
            homeNameTxtField.hidden = true
            homeNameBorderView.hidden = false
            homeNameLabel.hidden = false
            
            homeAddressTxtField.hidden = true
            homeAddressBorderView.hidden = false
            homeAddressLabel.hidden = false
            
            isTextFieldEnabled = false
            editIcon.image = UIImage(named: "edit_icon")
            
            editModeLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func selectWhereToGetImage(sender: UIButton) {
        
        let photoLibActionHandler = { (action:UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        
        let cameraActionHandler = { (action:UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraCaptureMode = .Photo
            self.picker.modalPresentationStyle = .FullScreen
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        
        let imageAlertController = UIAlertController(title: "Please select what you would like to do.", message: "", preferredStyle: .ActionSheet)
        let photoLibAction = UIAlertAction(title: "Photo Library", style: .Default, handler: photoLibActionHandler)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: cameraActionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        imageAlertController.addAction(photoLibAction)
        imageAlertController.addAction(cameraAction)
        imageAlertController.addAction(cancelAction)
        
        if (modelName.rangeOfString("iPad") != nil) {
            if let popoverController = imageAlertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            self.presentViewController(imageAlertController, animated: true, completion: nil)
        }
        else {
            presentViewController(imageAlertController, animated: true, completion: nil)
        }
    }
    
    func calculateMortgagePaymentButtonPress(sender: UIButton) {
        tapGesture()
        
        var saleAmount = 250000.0
        if loanAmountTxtField.text?.isEmpty != true {
            saleAmount = Double(loanAmountTxtField.text!)!
        }
        
        var mortgage = 30.0
        if mortgageTxtField.text?.isEmpty != true {
            mortgage = Double(mortgageTxtField.text!)!
        }
        
        var interest = 3.5
        if interestTxtField.text?.isEmpty != true {
            if (Double(interestTxtField.text!) == 0.0) {
                interest = 0.01
            }
            else {
                interest = Double(interestTxtField.text!)!
            }
        }
        
        var downPayment = 5000.0
        if downPaymentTxtField.text?.isEmpty != true {
            downPayment = Double(downPaymentTxtField.text!)!
        }
        
        let loan = saleAmount - downPayment
        
        estimatedPaymentDefault = model.calculateMortgagePayment(loan, interest: interest, mortgage: mortgage, taxes: 0.0)
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
    }
    
    func deleteImageFromArray(sender: UIButton) {
        imageArray.removeAtIndex(sender.tag)
        
        removeViews(imageScollView)
        print(sender.tag)
        self.homeObject["imageArray"] = self.imageArray
        setDefaultImage()
        
        updateHomeObject()
        
        saveView.hidden = false
        saveButton.hidden = false
        saveButton.enabled = true
        imageIndex = 0
        overlayView.hidden = true
        imageScollView.contentOffset.x = 0
        print("imageIndex", imageIndex)
        imageCountLabel.text = String(format: "%d of %d", Int(imageIndex), self.imageArray.count)
    }
    
    func setImageAsDefault(sender: UIButton) {
        print(sender.tag)
        let img = imageArray[sender.tag]
        imageArray.removeAtIndex(sender.tag)
        imageArray.insert(img, atIndex: 0)
        
        removeViews(imageScollView)
        self.homeObject["imageArray"] = self.imageArray
        setDefaultImage()
        
        updateHomeObject()
        
        saveView.hidden = false
        saveButton.hidden = false
        saveButton.enabled = true
        
        overlayView.hidden = true
        imageIndex = 0
        imageScollView.contentOffset.x = 0
        imageIndexLabel.text = String(format: "%d of %d", Int(imageIndex) + 1, imageArray.count)
    }
    
    func deleteHome(sender: UIButton) {
        deleteHomeObject()
    }
    
    //MARK:
    //MARK: UIImagePickerController Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                img = pickedImage
                if (picker.sourceType.rawValue == 1) {
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                    print("write to album")
                }
                
                self.newImg = parseObject.scaleImagesForParse(pickedImage)
                self.updateHomeObjectImageArray()
                self.userDidEnterEditMode()
                
            }
            else {
                print(info[UIImagePickerControllerMediaMetadata])
                print(picker.sourceType.rawValue)
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            displayMessage("HomeIn", message: "There is no camera available on this device.")
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateHomeObjectImageArray() {
        removeViews(imageScollView)
        
        saveView.hidden = false
        saveButton.hidden = false
        saveButton.enabled = true
        
        let imageData = UIImagePNGRepresentation(self.newImg)
        if (imageData != nil) {
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            imageArray.append(imageFile!)
            
            self.imageCountLabel.text = String(format: "1 of %d", self.imageArray.count)
            imageOverlay(imageArray)
        }
        
        if self.imageArray.count == 1 {
            defaultImageView.image = newImg
            
            let overlayButton = UIButton(frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 250))
            overlayButton.backgroundColor = UIColor.clearColor()
            overlayButton.addTarget(self, action: #selector(IndividualHomeViewController.showImageOverlay(_:)), forControlEvents: .TouchUpInside)
            self.scrollView.addSubview(overlayButton)
        }
    }
    
    //MARK:
    //MARK: Parse Update Object
    func updateHomeObject() {
        print("updateHomeObject")
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        self.homeObject["name"] = (self.homeNameTxtField.text != "") ? self.homeNameTxtField.text : self.homeObject["name"]
        var price = "0"
        if let _ = self.homePriceTxtField.text {
            price = self.homePriceTxtField.text! as String
        }
        if price.rangeOfString(",") != nil{
            price = price.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        if price.rangeOfString("$") != nil{
            price = price.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        self.homeObject["price"] = (self.homePriceTxtField.text != "") ? Double(price) : self.homeObject["price"]
        self.homeObject["rating"] = self.userRating
        self.homeObject["beds"] = (self.bedsTxtField.text != "") ? Double(self.bedsTxtField.text!) : self.homeObject["beds"]
        self.homeObject["baths"] = (self.bathsTxtField.text != "") ? Double(self.bathsTxtField.text!) : self.homeObject["baths"]
        self.homeObject["footage"] = (self.sqFeetTxtField.text != "") ? Double(self.sqFeetTxtField.text!) : self.homeObject["footage"]
        self.homeObject["address"] = (self.homeAddressTxtField.text != "") ? self.homeAddressTxtField.text : self.homeObject["address"]
        self.homeObject["desc"] = (self.descTxtView.text != "") ? self.descTxtView.text : self.homeObject["desc"]
        self.homeObject["monthlyPayment"] = self.estimatedPaymentDefault
        
        print(self.homeObject["baths"])
        
        
        if self.reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                self.homeObject["imageArray"] = self.imageArray
                self.parseObject.saveHomeWithBlock(self.homeObject)
            }
        }
        else {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                self.parseObject.saveHomeEventually(self.homeObject)
            }
        }
    }
    
    func deleteHomeObject() {
        let alertController = UIAlertController(title: "HomeIn", message: "Are you sure you want to delete this home?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in

        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in            
            self.homeObject.deleteEventually()
            
            let alertController = UIAlertController(title: "HomeIn", message: "The home was deleted", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    //MARK:
    //MARK: UIGesture
    func tapGesture() {
        homeNameTxtField.resignFirstResponder()
        homePriceTxtField.resignFirstResponder()
        homeAddressTxtField.resignFirstResponder()
        bedsTxtField.resignFirstResponder()
        bathsTxtField.resignFirstResponder()
        sqFeetTxtField.resignFirstResponder()
        descTxtView.resignFirstResponder()
        
        loanAmountTxtField.resignFirstResponder()
        mortgageTxtField.resignFirstResponder()
        interestTxtField.resignFirstResponder()
        downPaymentTxtField.resignFirstResponder()
    }
    
    //MARK:
    //MARK: NSNotification
    func keyboardWillAppear(notification: NSNotification){
        if (modelName.rangeOfString("iPad") != nil) {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1950)
        }
        else {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1400)
        }
        
        hideKeyboardButton.enabled = true
        hideKeyboardButton.alpha = 1.0
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        if (modelName.rangeOfString("iPad") != nil) {
            if isCalcTrayOpen {
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1950)
            }
            else {
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: yOffset + 750)
            }
        }
        else {
            if isCalcTrayOpen {
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1400)
            }
            else {
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: yOffset + 250)
            }
        }

        hideKeyboardButton.enabled = false
        hideKeyboardButton.alpha = 0.0
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
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
         dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.myHomesView.removeFromSuperview()
            self.homeTray.removeFromSuperview()
            self.calcTray.removeFromSuperview()
            self.saveDeleteTray.removeFromSuperview()
            self.buildView()
            
            self.activityIndicator.stopAnimating()
            self.loadingOverlay.hidden = true
            
            self.displayMessage("HomeIn", message: "Your home was saved.")
            self.didEnterEditMode = false
        }
    }
    
    func saveFailed(errorMessage: String) {
        loadingOverlay.hidden = true
        activityIndicator.stopAnimating()
        displayMessage("HomeIn", message: String(format: "An error occurred trying to add this home.\n %@", errorMessage))
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
    
    func userDidEnterEditMode() {
        didEnterEditMode = true
        saveView.hidden = false
        saveButton.hidden = false
        saveButton.enabled = true
        
        homeNameTxtField.enabled = true
        homePriceTxtField.enabled = true
        homeAddressTxtField.enabled = true
        bedsTxtField.enabled = true
        bathsTxtField.enabled = true
        sqFeetTxtField.enabled = true
        descTxtView.editable = true
        
        homeNameTxtField.hidden = false
        homeNameBorderView.hidden = true
        homeNameLabel.hidden = true
        
        homeAddressTxtField.hidden = false
        homeAddressBorderView.hidden = true
        homeAddressLabel.hidden = true
        
        isTextFieldEnabled = true
        editIcon.image = UIImage(named: "edit_red")
        
        editModeLabel.textColor = model.lightRedColor
    }
}
