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
    let mortgageView = MortgageCalculatorView()
    let modelName = UIDevice.currentDevice().modelName
    
    // UIView
    let myHomesView = UIView()
    let overlayView = UIView()
    let calcTray = UIView()
    let saveDeleteTray = UIView()
    let loadingOverlay = UIView()
    
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
    let taxesTxtField = UITextField() as UITextField
    
    // UIImagePickerController
    let picker = UIImagePickerController()
    var img = UIImage()
    var newImg = UIImage()
    
    // UILabel
    var paymentLabel = UILabel() as UILabel
    
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
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        
        picker.delegate = self
        buildView()
    }
    
    override func viewDidAppear(animated: Bool) {

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
        
        let backIcn = UIImage(named: "backbutton_icon") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 12.5, 25))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
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
        let homeIcn = UIImage(named: "icn-firstTime") as UIImage?
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
        buildSaveDeleteTray()
        
        var fontSize = 24 as CGFloat
        if modelName.rangeOfString("5") != nil{
            fontSize = 18
        }
        
        let calcBannerView = UIView(frame: CGRectMake(0, 670, scrollView.bounds.size.width, 50))
        let calcBannerGradientLayer = CAGradientLayer()
        calcBannerGradientLayer.frame = calcBannerView.bounds
        calcBannerGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        calcBannerView.layer.insertSublayer(calcBannerGradientLayer, atIndex: 0)
        calcBannerView.layer.addSublayer(calcBannerGradientLayer)
        calcBannerView.hidden = false
        scrollView.addSubview(calcBannerView)
        
        let calcIcn = UIImage(named: "icn-calculator") as UIImage?
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
        
        scrollView.contentSize = CGSize(width: myHomesView.bounds.size.width, height: 900)
    }

    func buildHomeTray() {
        
        let homeTray = UIView(frame: CGRectMake(0, 0, scrollView.bounds.size.width, 670))
        homeTray.backgroundColor = model.lightGrayColor
        scrollView.addSubview(homeTray)
        
        defaultImageView.frame = (frame: CGRectMake(0, 0, scrollView.bounds.size.width, 250))
        homeTray.addSubview(defaultImageView)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        
        let homeName = homeObject["name"] as! NSString
        // UITextField
        homeNameTxtField.frame = (frame: CGRectMake(10, 250, homeTray.bounds.size.width - 20, 40))
        homeNameTxtField.attributedPlaceholder = NSAttributedString(string: homeName as String, attributes:attributes)
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.returnKeyType = .Next
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        homeNameTxtField.font = UIFont(name: "forza-light", size: 22)
        homeNameTxtField.enabled = false
        homeTray.addSubview(homeNameTxtField)
        
        // UILabel
        let price = homeObject["price"] as! Double
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let homePrice = formatter.stringFromNumber(price)! as String
        
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 290, homeTray.bounds.size.width - 90, 40))
        homePriceTxtField.attributedPlaceholder = NSAttributedString(string: homePrice as String, attributes:attributes)
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Next
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        homePriceTxtField.font = UIFont(name: "forza-light", size: 22)
        homePriceTxtField.enabled = false
        homeTray.addSubview(homePriceTxtField)
        
        // UIButton
        let addIcn = UIImage(named: "camera_icon") as UIImage?
        let addIcon = UIImageView(frame: CGRectMake(homeTray.bounds.size.width - 115, 255, 40.5, 35))
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
        editIcon.frame = (frame: CGRectMake(homeTray.bounds.size.width - 55, 255, 41.25, 35))
        editIcon.image = editIcn
        homeTray.addSubview(editIcon)
        
        editButton.frame = (frame: CGRectMake(homeTray.bounds.size.width - 60, 250, 60, 50))
        editButton.addTarget(self, action: "allowEdit:", forControlEvents: .TouchUpInside)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        homeTray.addSubview(editButton)
        
        
        var xOffset = 0
        userRating = homeObject["rating"] as! Int
        
        for i in 1...5 {
            // UIButton
            let ratingButton = UIButton(frame: CGRectMake(CGFloat(10 + xOffset), 330, 35, 35))
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
        
        let dividerView = UIView(frame: CGRectMake(10, 375, homeTray.bounds.size.width - 20, 1))
        dividerView.backgroundColor = UIColor.darkGrayColor()
        dividerView.hidden = false
        homeTray.addSubview(dividerView)
        
        let bed = homeObject["beds"] as? Int
        let attributedHomeBed = NSMutableAttributedString(
            string: String(format: "%d", bed!),
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 12.0)!])

        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(15, 385, (homeTray.bounds.size.width / 3) - 10, 30))
        bedsTxtField.attributedPlaceholder = attributedHomeBed
        bedsTxtField.backgroundColor = UIColor.clearColor()
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Next
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
        bedsTxtField.font = UIFont(name: "Arial", size: 12)
        bedsTxtField.enabled = false
        homeTray.addSubview(bedsTxtField)
        
        let bedsLabel = UILabel(frame: CGRectMake(15, 410, (homeTray.bounds.size.width / 3) - 10, 30))
        bedsLabel.text = "Beds"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bedsLabel.textAlignment = NSTextAlignment.Left
        bedsLabel.numberOfLines = 1
        bedsLabel.font = bedsLabel.font.fontWithSize(12)
        bedsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bedsLabel)
        
        let vertDividerTwoView = UIView(frame: CGRectMake(homeTray.bounds.size.width / 3, 385, 1, 50))
        vertDividerTwoView.backgroundColor = UIColor.darkGrayColor()
        vertDividerTwoView.hidden = false
        homeTray.addSubview(vertDividerTwoView)
        
        let bath = homeObject["baths"] as? Double
        let attributedHomeBath = NSMutableAttributedString(
            string: String(format: "%.1f", bath!),
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 12.0)!])
        
        // UITextField
        bathsTxtField.frame = (frame: CGRectMake((homeTray.bounds.size.width / 3) + 10, 385, (homeTray.bounds.size.width / 3) - 10, 30))
        bathsTxtField.attributedPlaceholder = attributedHomeBath
        bathsTxtField.backgroundColor = UIColor.clearColor()
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Next
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
        bathsTxtField.font = UIFont(name: "Arial", size: 12)
        bathsTxtField.enabled = false
        homeTray.addSubview(bathsTxtField)
        
        let bathsLabel = UILabel(frame: CGRectMake((homeTray.bounds.size.width / 3) + 10, 410, (homeTray.bounds.size.width / 3) - 10, 30))
        bathsLabel.text = "Baths"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bathsLabel.textAlignment = NSTextAlignment.Left
        bathsLabel.numberOfLines = 1
        bathsLabel.font = bathsLabel.font.fontWithSize(12)
        bathsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bathsLabel)
        
        let vertDividerThreeView = UIView(frame: CGRectMake(homeTray.bounds.size.width * 0.66, 385, 1, 50))
        vertDividerThreeView.backgroundColor = UIColor.darkGrayColor()
        vertDividerThreeView.hidden = false
        homeTray.addSubview(vertDividerThreeView)
        
        var attributedHomeSqft = NSMutableAttributedString()
        if let homeSqft = homeObject["footage"] as? Double {
            attributedHomeSqft = NSMutableAttributedString(
                string: String(format: "%.1f", homeSqft),
                attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                    name: "Arial",
                    size: 12.0)!])
        }
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake((homeTray.bounds.size.width * 0.66) + 10, 385, (homeTray.bounds.size.width / 3) - 10, 30))
        sqFeetTxtField.attributedPlaceholder = attributedHomeSqft
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Next
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
        sqFeetTxtField.font = UIFont(name: "Arial", size: 12)
        sqFeetTxtField.enabled = false
        homeTray.addSubview(sqFeetTxtField)
        
        let sqFeetLabel = UILabel(frame: CGRectMake((homeTray.bounds.size.width * 0.66) + 10, 410, (homeTray.bounds.size.width / 3) - 10, 30))
        sqFeetLabel.text = "Sq. Ft."
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sqFeetLabel.textAlignment = NSTextAlignment.Left
        sqFeetLabel.numberOfLines = 1
        sqFeetLabel.font = sqFeetLabel.font.fontWithSize(12)
        sqFeetLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(sqFeetLabel)
        
        let arialAttributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "Arial", size: 18)!
        ]
        
        let homeAddress = homeObject["address"] as! NSString
        //UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, 450, homeTray.bounds.size.width - 20, 40))
        homeAddressTxtField.attributedPlaceholder = NSAttributedString(string: homeAddress as String, attributes:arialAttributes)
        homeAddressTxtField.backgroundColor = UIColor.clearColor()
        homeAddressTxtField.delegate = self
        homeAddressTxtField.returnKeyType = .Next
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        homeAddressTxtField.font = UIFont(name: "forza-light", size: 22)
        homeAddressTxtField.enabled = false
        homeTray.addSubview(homeAddressTxtField)
        
        //Create textview
        descTxtView.frame = (frame : CGRectMake(10, 500, homeTray.bounds.size.width - 20, 150))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.text = homeObject["desc"] as? String
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
        
        let mortView = UIView(frame: CGRectMake(0, 0, calcTray.bounds.size.width, 300))
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
        
        /********************************************************* Property Taxes ********************************************************************/
        // UILabel
        let taxesLabel = UILabel(frame: CGRectMake(10, 225, (mortView.bounds.size.width / 2) - 20, 40))
        taxesLabel.text = "PROPERTY TAXES = "
        taxesLabel.font = UIFont(name: "forza-light", size: 14)
        taxesLabel.textAlignment = NSTextAlignment.Right
        taxesLabel.textColor = UIColor.darkTextColor()
        mortView.addSubview(taxesLabel)
        
        // UITextField
        let taxesPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        taxesTxtField.frame = (frame: CGRectMake((mortView.bounds.size.width / 2) + 10, 225,(mortView.bounds.size.width / 2) - 20, 40));
        taxesTxtField.layer.borderColor = model.lightGrayColor.CGColor
        taxesTxtField.layer.borderWidth = 1.0
        taxesTxtField.layer.cornerRadius = 2.0
        taxesTxtField.placeholder = "3.750%"
        taxesTxtField.leftView = taxesPaddingView
        taxesTxtField.leftViewMode = UITextFieldViewMode.Always
        taxesTxtField.backgroundColor = UIColor.clearColor()
        taxesTxtField.delegate = self
        taxesTxtField.returnKeyType = .Done
        taxesTxtField.keyboardType = UIKeyboardType.DecimalPad
        taxesTxtField.font = UIFont(name: "forza-light", size: 22)
        mortView.addSubview(taxesTxtField)
        
        // UIView
        let calculateView = UIView(frame: CGRectMake(25, 310, calcTray.bounds.size.width - 50, 50))
        let calcGradientLayer = CAGradientLayer()
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        calcTray.addSubview(calculateView)
        
        let calculateArrow = UILabel (frame: CGRectMake(calculateView.bounds.size.width - 50, 0, 40, 50))
        calculateArrow.textAlignment = NSTextAlignment.Right
        calculateArrow.font = UIFont(name: "forza-light", size: 40)
        calculateArrow.text = ">"
        calculateArrow.textColor = UIColor.whiteColor()
        calculateView.addSubview(calculateArrow)
        
        // UIButton
        let calculateButton = UIButton (frame: CGRectMake(25, 0, calculateView.bounds.size.width - 25, 50))
        calculateButton.addTarget(self, action: "calculateRefinanceButtonPress:", forControlEvents: .TouchUpInside)
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
        estPaymentLabel.frame = (frame: CGRectMake(25, 360, calcTray.bounds.size.width - 50, 25))
        estPaymentLabel.text = "YOUR ESTIMATED PAYMENT IS:"
        estPaymentLabel.font = UIFont(name: "forza-light", size: 14)
        estPaymentLabel.textAlignment = NSTextAlignment.Left
        calcTray.addSubview(estPaymentLabel)
        
        // UIView
        let paymentView = UIView(frame: CGRectMake(25, 390, calcTray.bounds.size.width - 50, 50))
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
        
        saveDeleteTray.frame = (frame: CGRectMake(0, 730, scrollView.bounds.size.width, 450))
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
        saveButton.hidden = true
        saveButton.enabled = false
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
                self.calcTray.frame = (frame: CGRectMake(0, 730, self.scrollView.bounds.size.width, 450))
                self.saveDeleteTray.frame = (frame: CGRectMake(0, 1180, self.scrollView.bounds.size.width, 450))
                }, completion: {
                    (value: Bool) in
                    self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 1500)
                    self.isCalcTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.8, animations: {
                self.expandIcon.image = UIImage(named: "expand_white")
                self.calcTray.frame = (frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 450))
                self.saveDeleteTray.frame = (frame: CGRectMake(0, 720, self.scrollView.bounds.size.width, 450))
                }, completion: {
                    (value: Bool) in
                    self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 900)
                    self.isCalcTrayOpen = false
            })
        }
    }
    
    func setDefaultImage() {
        if (homeObject["imageArray"] != nil) {
            
            imageArray = homeObject["imageArray"] as! [PFFile]
            
            let img = imageArray[0] as PFFile
            img.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.defaultImageView.image = image
                        
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
        
        print(imageArray.count)
        
        var xLocation = 0.0 as CGFloat
        for img: PFFile in imageArray {
            addImageToOverlayAtLocation(img, xLocation: xLocation)
            xLocation += self.scrollView.bounds.size.width
        }
        
        var labelWidth = 100.0 as CGFloat
        if imageArray.count > 9 {
            labelWidth = 125.0
        }
        
        saveImageDefaultButton.frame = (frame: CGRectMake(10, 25, 40, 40))
        saveImageDefaultButton.addTarget(self, action: "setImageAsDefault:", forControlEvents: .TouchUpInside)
        saveImageDefaultButton.setBackgroundImage(UIImage(named: "save_icon"), forState: .Normal)
        saveImageDefaultButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveImageDefaultButton.backgroundColor = UIColor.clearColor()
        saveImageDefaultButton.titleLabel!.font = UIFont(name: "forza-light", size: 45)
        saveImageDefaultButton.tag = 0
        overlayView.addSubview(saveImageDefaultButton)
        
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
        closeButton.titleLabel!.font = UIFont(name: "forza-light", size: 45)
        closeButton.tag = 0
        overlayView.addSubview(closeButton)
        
        let setDefaultLabel = UILabel(frame: CGRectMake(0, self.view.bounds.size.height - 65, self.view.bounds.size.width, 65))
        setDefaultLabel.text = "Use the save button to set an image as the new default image for this home."
        setDefaultLabel.font = UIFont(name: "forza-light", size: 18)
        setDefaultLabel.textAlignment = NSTextAlignment.Center
        setDefaultLabel.textColor = UIColor.whiteColor()
        setDefaultLabel.numberOfLines = 3
        setDefaultLabel.backgroundColor = UIColor(red:0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:90.0)
        overlayView.addSubview(setDefaultLabel)
        
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
        else if textField == taxesTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 1000
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
        navigationController?.popViewControllerAnimated(true)
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
            
            isTextFieldEnabled = true
            editIcon.image = UIImage(named: "edit_icon_onstate")
        }
        else {
            homeNameTxtField.enabled = false
            homePriceTxtField.enabled = false
            homeAddressTxtField.enabled = false
            bedsTxtField.enabled = false
            bathsTxtField.enabled = false
            sqFeetTxtField.enabled = false
            descTxtView.editable = false
            
            isTextFieldEnabled = false
            editIcon.image = UIImage(named: "edit_icon")
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

        var taxes = 3.75
        if taxesTxtField.text?.isEmpty != true {
            taxes = Double(taxesTxtField.text!)!
        }
        
        estimatedPaymentDefault = model.calculateMortgagePayment(loan, interest: interest, mortgage: mortgage, taxes: taxes)
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
            //defaultImageView.contentMode = .ScaleAspectFit
            //defaultImageView.image = pickedImage

            if (picker.sourceType.rawValue == 1) {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
            
            /*let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            
            
            if paths.count > 0
            {
                print(paths[0])
            }
            
            loadingOverlay.hidden = false
            activityIndicator.startAnimating()*/

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
            self.homeObject["price"] = (self.homePriceTxtField.text != "") ? Double(self.homePriceTxtField.text!) : self.homeObject["price"]
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
            print(action)
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.homeObject.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("The object was deleted")
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                    
                } else {
                    // There was a problem, check error.description
                    print("error: %@", error)
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
        taxesTxtField.resignFirstResponder()
    }
    
    func keyboardWillAppear(notification: NSNotification){
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1500)
        hideKeyboardButton.enabled = true
        hideKeyboardButton.alpha = 1.0
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        if isCalcTrayOpen {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1500)
        }
        else {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 900)
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