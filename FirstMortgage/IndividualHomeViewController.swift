//
//  IndividualHomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 11/18/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class IndividualHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    // MARK:
    // MARK: Properties
    let model = Model()
    let modelName = UIDevice.currentDevice().modelName
    
    // UIView
    let myHomesView = UIView()
    let overlayView = UIView()
    let calcTray = UIView()
    let saveDeleteTray = UIView()
    let loadingOverlay = UIView()
    let homeAddressBorderView = UIView()
    
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
    
    let estPaymentLabel = UILabel()
    let imageIndexLabel = UILabel()
    
    let saveView = UIView()
    let saveButton = UIButton ()
    let editButton = UIButton ()
    let editIcon = UIImageView()
    let saveImageDefaultButton = UIButton()
    
    let hideKeyboardButton = UIButton()
    
    var contentOffSet = 0.0 as CGFloat
    var imageIndex = 0
    var scrollLocation = 0.0 as CGFloat
    
    var yOffset = 0.0 as CGFloat
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        
        picker.delegate = self
        buildView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        
        // TODO: I'd like this here and build the image portion in viewDidLoad
        //buildView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true);
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        hideKeyboardButton.addTarget(self, action: "tapGesture", forControlEvents: .TouchUpInside)
        hideKeyboardButton.setImage(UIImage(named: "hide_keyboard"), forState: .Normal)
        hideKeyboardButton.backgroundColor = UIColor.clearColor()
        hideKeyboardButton.tag = 0
        hideKeyboardButton.enabled = false
        hideKeyboardButton.alpha = 0
        whiteBar.addSubview(hideKeyboardButton)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
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
        
        let calcBannerView = UIView(frame: CGRectMake(0, yOffset, scrollView.bounds.size.width, 50))
        let calcBannerGradientLayer = CAGradientLayer()
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
        calcBannerButton.addTarget(self, action: "showHideCalcTray:", forControlEvents: .TouchUpInside)
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
        let homeTray = UIView(frame: CGRectMake(0, 0, scrollView.bounds.size.width, 670))
        homeTray.backgroundColor = model.lightGrayColor
        scrollView.addSubview(homeTray)
        
        defaultImageView.frame = (frame: CGRectMake(0, 0, scrollView.bounds.size.width, 250))
        defaultImageView.contentMode = .ScaleAspectFill
        defaultImageView.clipsToBounds = true
        homeTray.addSubview(defaultImageView)
        
        let homeNameborder = CALayer()
        let width = CGFloat(1.0)
        
        var homeName = ""
        if let _ = homeObject["name"] {
            homeName = homeObject["name"] as! String
        }
        // UITextField
        homeNameTxtField.frame = (frame: CGRectMake(10, 250, homeTray.bounds.size.width - 125, 40))
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
        homeTray.addSubview(homeNameTxtField)
        
        var price = 0.0
        if let _ = homeObject["price"] {
            price = homeObject["price"] as! Double
        }
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let homePrice = formatter.stringFromNumber(price)! as String
        
        let homePriceborder = CALayer()
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 290, homeTray.bounds.size.width - 20, 40))
        homePriceborder.borderColor = UIColor.lightGrayColor().CGColor
        homePriceborder.frame = CGRect(x: 0, y: homePriceTxtField.frame.size.height - width, width:  homePriceTxtField.frame.size.width, height: homePriceTxtField.frame.size.height)
        homePriceborder.borderWidth = width
        homePriceTxtField.layer.addSublayer(homePriceborder)
        homePriceTxtField.layer.masksToBounds = true
        homePriceTxtField.text = homePrice as String
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Next
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        homePriceTxtField.font = UIFont(name: "forza-light", size: 22)
        homePriceTxtField.enabled = false
        homeTray.addSubview(homePriceTxtField)
        
        let attributes = [
            //NSForegroundColorAttributeName: UIColor.redColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        
        var homeAddress = ""
        if let _ = homeObject["address"] {
            homeAddress = homeObject["address"] as! String
        }
        
        let homeAddressborder = CALayer()
        //UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, 330, homeTray.bounds.size.width - 20, 40))
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
        homeAddressLabel.frame = (frame: CGRectMake(10, 337, homeTray.bounds.size.width - 20, 0))
        if (homeAddress.characters.count > 0) {
            homeAddressLabel.text = homeAddress as String
            homeAddressLabel.textColor = UIColor.darkTextColor()
        }
        else {
            homeAddressLabel.text = "ADDRESS"
            homeAddressLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 202/255, alpha: 1)
        }
        homeAddressLabel.textAlignment = NSTextAlignment.Left
        homeAddressLabel.font = UIFont(name: "forza-light", size: 22)
        homeAddressLabel.hidden = false
        homeAddressLabel.numberOfLines = 0
        homeAddressLabel.sizeToFit()
        homeTray.addSubview(homeAddressLabel)
        
        yOffset = 337 + homeAddressLabel.bounds.size.height
        
        homeAddressBorderView.frame = (frame: CGRectMake(10, yOffset + 5, homeTray.bounds.size.width - 20, 1))
        homeAddressBorderView.backgroundColor = UIColor.lightGrayColor()
        homeAddressBorderView.hidden = false
        homeTray.addSubview(homeAddressBorderView)
        
        // UIButton
        let addIcn = UIImage(named: "camera_icon") as UIImage?
        let addIcon = UIImageView(frame: CGRectMake(homeTray.bounds.size.width - 105, 255, 34.29, 30))
        addIcon.image = addIcn
        homeTray.addSubview(addIcon)
        
        let addImagesButton = UIButton (frame: CGRectMake(homeTray.bounds.size.width - 120, 250, 60, 50))
        addImagesButton.addTarget(self, action: "selectWhereToGetImage:", forControlEvents: .TouchUpInside)
        addImagesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addImagesButton.backgroundColor = UIColor.clearColor()
        addImagesButton.tag = 0
        homeTray.addSubview(addImagesButton)
        
        // UIButton
        let editIcn = UIImage(named: "edit_icon") as UIImage?
        editIcon.frame = (frame: CGRectMake(homeTray.bounds.size.width - 55, 255, 34.27, 30))
        editIcon.image = editIcn
        homeTray.addSubview(editIcon)
        
        editButton.frame = (frame: CGRectMake(homeTray.bounds.size.width - 60, 250, 60, 50))
        editButton.addTarget(self, action: "allowEdit:", forControlEvents: .TouchUpInside)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        homeTray.addSubview(editButton)
        
        yOffset += 15
        var xOffset = 0
        userRating = homeObject["rating"] as! Int
        
        for i in 1...5 {
            // UIButton
            let ratingButton = UIButton(frame: CGRectMake(CGFloat(10 + xOffset), yOffset, 35, 35))
            ratingButton.addTarget(self, action: "setRating:", forControlEvents: .TouchUpInside)
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

        yOffset += 45
        var bed = 0
        if let _ = homeObject["beds"] {
            bed = (homeObject["beds"] as? Int)!
        }
        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(15, yOffset, (homeTray.bounds.size.width / 3) - 20, 30))
        let bedPaddingView = UIView(frame: CGRectMake(0, 0, (bedsTxtField.bounds.size.width / 2) - 5, 50))
        bedsTxtField.leftView = bedPaddingView
        bedsTxtField.leftViewMode = UITextFieldViewMode.Always
        bedsTxtField.text = String(format: "%d", bed)
        bedsTxtField.backgroundColor = UIColor.clearColor()
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Next
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
        bedsTxtField.font = UIFont(name: "Arial", size: 14)
        bedsTxtField.enabled = false
        homeTray.addSubview(bedsTxtField)
        
        let bedsLabel = UILabel(frame: CGRectMake(15, yOffset + 20, (homeTray.bounds.size.width / 3) - 20, 30))
        bedsLabel.text = "Beds"
        bedsLabel.textAlignment = NSTextAlignment.Center
        bedsLabel.numberOfLines = 1
        bedsLabel.font = bedsLabel.font.fontWithSize(14)
        bedsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bedsLabel)
        
        let vertDividerTwoView = UIView(frame: CGRectMake(homeTray.bounds.size.width / 3, yOffset, 1, 50))
        vertDividerTwoView.backgroundColor = UIColor.lightGrayColor()
        vertDividerTwoView.hidden = false
        homeTray.addSubview(vertDividerTwoView)
        
        var bath = 0.0
        if let _ = homeObject["baths"] {
            bath = (homeObject["baths"] as? Double)!
        }

        // UITextField
        bathsTxtField.frame = (frame: CGRectMake((homeTray.bounds.size.width / 3) + 5, yOffset, (homeTray.bounds.size.width / 3) - 20, 30))
        let bathPaddingView = UIView(frame: CGRectMake(0, 0, (bedsTxtField.bounds.size.width / 2) - 5, 50))
        bathsTxtField.leftView = bathPaddingView
        bathsTxtField.leftViewMode = UITextFieldViewMode.Always
        bathsTxtField.text = String(format: "%.1f", bath)
        bathsTxtField.backgroundColor = UIColor.clearColor()
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Next
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
        bathsTxtField.font = UIFont(name: "Arial", size: 14)
        bathsTxtField.enabled = false
        homeTray.addSubview(bathsTxtField)
        
        let bathsLabel = UILabel(frame: CGRectMake((homeTray.bounds.size.width / 3) + 10, yOffset + 20, (homeTray.bounds.size.width / 3) - 20, 30))
        bathsLabel.text = "Baths"
        bathsLabel.textAlignment = NSTextAlignment.Center
        bathsLabel.numberOfLines = 1
        bathsLabel.font = bathsLabel.font.fontWithSize(14)
        bathsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bathsLabel)
        
        let vertDividerThreeView = UIView(frame: CGRectMake(homeTray.bounds.size.width * 0.66, yOffset, 1, 50))
        vertDividerThreeView.backgroundColor = UIColor.lightGrayColor()
        vertDividerThreeView.hidden = false
        homeTray.addSubview(vertDividerThreeView)

        var homeSqft = 0
        if let _ = homeObject["footage"] {
            homeSqft = (homeObject["footage"] as? Int)!
        }
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake((homeTray.bounds.size.width * 0.66) + 10, yOffset, (homeTray.bounds.size.width / 3) - 20, 30))
        let sqFeetPaddingView = UIView(frame: CGRectMake(0, 0, (bedsTxtField.bounds.size.width / 2) - 15, 50))
        sqFeetTxtField.leftView = sqFeetPaddingView
        sqFeetTxtField.leftViewMode = UITextFieldViewMode.Always
        sqFeetTxtField.text = String(format: "%d", homeSqft)
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Next
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
        sqFeetTxtField.font = UIFont(name: "Arial", size: 14)
        sqFeetTxtField.enabled = false
        homeTray.addSubview(sqFeetTxtField)
        
        let sqFeetLabel = UILabel(frame: CGRectMake((homeTray.bounds.size.width * 0.66) + 10, yOffset + 20, (homeTray.bounds.size.width / 3) - 20, 30))
        sqFeetLabel.text = "Sq. Ft."
        sqFeetLabel.textAlignment = NSTextAlignment.Center
        sqFeetLabel.numberOfLines = 1
        sqFeetLabel.font = sqFeetLabel.font.fontWithSize(14)
        sqFeetLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(sqFeetLabel)
        
        yOffset += 65
        
        var desc = "Add notes about this house."
        if let _ = homeObject["desc"] {
            desc =  homeObject["desc"] as! String
        }
        //Create textview
        descTxtView.frame = (frame : CGRectMake(10, yOffset, homeTray.bounds.size.width - 20, 150))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.text = desc
        descTxtView.autocorrectionType = .Yes
        descTxtView.editable = false
        descTxtView.font = UIFont(name: "forza-light", size: 22)
        homeTray.addSubview(descTxtView)
        
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
        calculateButton.addTarget(self, action: "calculateMortgagePaymentButtonPress:", forControlEvents: .TouchUpInside)
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
        deleteButton.addTarget(self, action: "deleteHome:", forControlEvents: .TouchUpInside)
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
        saveButton.addTarget(self, action: "updateHomeObject:", forControlEvents: .TouchUpInside)
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
        print(self.yOffset)
        
        if (!isCalcTrayOpen) {
            UIView.animateWithDuration(0.8, animations: {
                self.expandIcon.image = UIImage(named: "expand_white_up")
                self.calcTray.frame = (frame: CGRectMake(0, CGFloat(self.yOffset + 60), self.scrollView.bounds.size.width, 400))
                self.saveDeleteTray.frame = (frame: CGRectMake(0, CGFloat(self.yOffset + 480), self.scrollView.bounds.size.width, 400))
                }, completion: {
                    (value: Bool) in
                    self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 1400)
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
                    self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: self.yOffset + 250)
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
                            
                            let imageCountView = UIView(frame: CGRectMake(self.defaultImageView.bounds.size.width - 85, 10, 75, 25))
                            imageCountView.backgroundColor = UIColor.darkGrayColor()
                            imageCountView.alpha = 0.85
                            self.defaultImageView.addSubview(imageCountView)
                            
                            // UILabel
                            let imageCountLabel = UILabel(frame: CGRectMake(0, 0, imageCountView.bounds.size.width, 25))
                            imageCountLabel.text = String(format: "1 of %d", self.imageArray.count)
                            imageCountLabel.font = UIFont(name: "Arial", size: 15)
                            imageCountLabel.textAlignment = NSTextAlignment.Center
                            imageCountLabel.textColor = UIColor.whiteColor()
                            imageCountView.addSubview(imageCountLabel)
                            
                            let overlayButton = UIButton(frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 250))
                            overlayButton.backgroundColor = UIColor.clearColor()
                            overlayButton.addTarget(self, action: "showImageOverlay:", forControlEvents: .TouchUpInside)
                            self.scrollView.addSubview(overlayButton)
                            
                            self.imageOverlay(self.imageArray)
                        }
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
        let overlayColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = overlayColor
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
        closeButton.addTarget(self, action: "hideImageOverlay:", forControlEvents: .TouchUpInside)
        closeButton.setTitle("X", forState: .Normal)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.titleLabel!.font = UIFont(name: "forza-light", size: 32)
        closeButton.tag = 0
        overlayView.addSubview(closeButton)
        
        saveImageDefaultButton.frame = (frame: CGRectMake(10, self.view.bounds.size.height - 65, self.view.bounds.size.width - 20, 50))
        saveImageDefaultButton.addTarget(self, action: "setImageAsDefault:", forControlEvents: .TouchUpInside)
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
                    imageIndex++
                    scrollLocation = imageWidth * CGFloat(imageIndex)
                }
            }
            else {
                if imageIndex > 0 {
                    imageIndex--
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
                imageIndex++
                scrollLocation = imageWidth * CGFloat(imageIndex)
            }
        }
        else
        {
            // User scrolled left
            // Evaluate to the nearest index
            // Err towards closer a index by forcing a slightly closer target offset
            if imageIndex > 0 {
                imageIndex--
                scrollLocation = imageWidth * CGFloat(imageIndex)
            }
        }
        
        // Return our adjusted target point
        // Adjust stopping point to exact beginning of cell.
        targetContentOffset.memory.x = scrollLocation
        imageIndexLabel.text = String(format: "%d of %d", Int(imageIndex) + 1, imageArray.count)
        saveImageDefaultButton.tag = Int(imageIndex)
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
            // TODO: Maybe reset these if nothing changes
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
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 800
                }, completion: nil)
        }
        else if textField == mortgageTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 850
                }, completion: nil)
        }
        else if textField == interestTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 900
                }, completion: nil)
        }
        else if textField == downPaymentTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 950
                }, completion: nil)
        }
        
        return true
    }
    
    // MARK:
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.4, animations: {
            self.scrollView.contentOffset.y = 500
            }, completion: nil)
        
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
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

        if (!isTextFieldEnabled) {
            homeNameTxtField.enabled = true
            homePriceTxtField.enabled = true
            homeAddressTxtField.enabled = true
            bedsTxtField.enabled = true
            bathsTxtField.enabled = true
            sqFeetTxtField.enabled = true
            descTxtView.editable = true
            
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
        presentViewController(imageAlertController, animated: true, completion: nil)
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
    
    func setImageAsDefault(sender: UIButton) {
        let img = imageArray[sender.tag]
        imageArray.removeAtIndex(sender.tag)
        imageArray.insert(img, atIndex: 0)
        
        removeViews(imageScollView)
        self.homeObject["imageArray"] = self.imageArray
        setDefaultImage()
        
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
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            if (picker.sourceType.rawValue == 1) {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }

            self.newImg = self.scaleImagesForParse(pickedImage)
            self.updateHomeObjectImageArray()

        }
        else {
            print(info[UIImagePickerControllerMediaMetadata])
            print(picker.sourceType.rawValue)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:
    //MARK: Utility Methods
    func scaleImagesForParse(img: UIImage) -> UIImage {
        let size = CGSizeApplyAffineTransform(img.size, CGAffineTransformMakeScale(0.33, 0.33))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        img.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func updateHomeObjectImageArray() {
        removeViews(imageScollView)
        
        saveView.hidden = false
        saveButton.hidden = false
        saveButton.enabled = true
        
        let imageData = UIImagePNGRepresentation(self.newImg)
        if (imageData != nil) {
            let imageFile = PFFile(name:"image.png", data:imageData!)
            imageArray.append(imageFile!)
            
            imageOverlay(imageArray)
        }
        
        if self.imageArray.count == 1 {
            defaultImageView.image = newImg
            
            let overlayButton = UIButton(frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 250))
            overlayButton.backgroundColor = UIColor.clearColor()
            overlayButton.addTarget(self, action: "showImageOverlay:", forControlEvents: .TouchUpInside)
            self.scrollView.addSubview(overlayButton)
        }
    }
    
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }
    
    //MARK:
    //MARK: Parse Update Object
    func updateHomeObject(sender: UIButton) {
        loadingOverlay.hidden = false
        activityIndicator.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            self.homeObject["name"] = (self.homeNameTxtField.text != "") ? self.homeNameTxtField.text : self.homeObject["name"]
            var price = self.homePriceTxtField.text! as String
            if price.rangeOfString(",") != nil{
                price = price.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            if price.rangeOfString("$") != nil{
                price = price.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            else {
                print("does not have $")
            }
            self.homeObject["price"] = (self.homePriceTxtField.text != "") ? Double(price) : self.homeObject["price"]
            self.homeObject["rating"] = self.userRating
            self.homeObject["beds"] = (self.bedsTxtField.text != "") ? Double(self.bedsTxtField.text!) : self.homeObject["beds"]
            self.homeObject["baths"] = (self.bathsTxtField.text != "") ? Double(self.bathsTxtField.text!) : self.homeObject["baths"]
            self.homeObject["footage"] = (self.sqFeetTxtField.text != "") ? Double(self.sqFeetTxtField.text!) : self.homeObject["footage"]
            self.homeObject["address"] = (self.homeAddressTxtField.text != "") ? self.homeAddressTxtField.text : self.homeObject["address"]
            self.homeObject["desc"] = (self.descTxtView.text != "") ? self.descTxtView.text : self.homeObject["desc"]
            self.homeObject["imageArray"] = self.imageArray
            self.homeObject["monthlyPayment"] = self.estimatedPaymentDefault
            
            self.homeObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                self.activityIndicator.stopAnimating()
                self.loadingOverlay.hidden = true
                
                if (success) {
                    let alertController = UIAlertController(title: "HomeIn", message: "Your home was saved.", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        self.didEnterEditMode = false
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
                else {
                    let errorString = error!.userInfo["error"] as? String
                    
                    let alertController = UIAlertController(title: "HomeIn", message: errorString, preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                }
            }
        }
    }
    
    func deleteHomeObject() {
        let alertController = UIAlertController(title: "HomeIn", message: "Are you sure you want to delete this home?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in

        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.homeObject.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    //let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    //self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                    self.navigationController!.popToRootViewControllerAnimated(true)
                    
                } else {
                    let alertController = UIAlertController(title: "HomeIn", message: String(format: "error: %@", error!), preferredStyle: .Alert)
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
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1400)
        hideKeyboardButton.enabled = true
        hideKeyboardButton.alpha = 1.0
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        if isCalcTrayOpen {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1400)
        }
        else {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: yOffset + 250)
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
    
}