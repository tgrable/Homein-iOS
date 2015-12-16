//
//  IndividualHomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 11/18/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class IndividualHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK:
    // MARK: Properties
    let model = Model()
    let mortgageView = MortgageCalculatorView()
    
    // UIView
    let myHomesView = UIView()
    let overlayView = UIView()
    let calcTray = UIView()
    
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
    
    // UIImagePickerController
    let picker = UIImagePickerController()
    var img = UIImage()
    
    // UILabel
    var paymentLabel = UILabel() as UILabel
    
    var estimatedPaymentDefault = 1835.26
    
    var homeObject: PFObject!
    var imageArray: [PFFile] = []
    
    var imageView = UIImageView()
    let defaultImageView = UIImageView()
    
    var isSmallerScreen = Bool()
    var isTextFieldEnabled = Bool()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var isCalcTrayOpen = Bool()
    
    let estPaymentLabel = UILabel()
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        buildView()
        // Do any additional setup after loading the view.
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
        calcBannerLabel.font = UIFont(name: "forza-light", size: 25)
        calcBannerLabel.textAlignment = NSTextAlignment.Left
        calcBannerLabel.textColor = UIColor.whiteColor()
        calcBannerView.addSubview(calcBannerLabel)
        
        let calcBannerButton = UIButton(frame: CGRectMake(0, 0, calcBannerView.bounds.size.width, calcBannerView.bounds.size.height))
        calcBannerButton.addTarget(self, action: "showHideCalcTray:", forControlEvents: .TouchUpInside)
        calcBannerButton.backgroundColor = UIColor.clearColor()
        calcBannerView.addSubview(calcBannerButton)
        
        scrollView.contentSize = CGSize(width: myHomesView.bounds.size.width, height: 750)
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
        homeNameTxtField.frame = (frame: CGRectMake(10, 250, homeTray.bounds.size.width - 20, 30))
        homeNameTxtField.attributedPlaceholder = NSAttributedString(string: homeName as String, attributes:attributes)
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.returnKeyType = .Done
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        homeNameTxtField.enabled = false
        homeTray.addSubview(homeNameTxtField)
        
        // UILabel
        let price = homeObject["price"] as! Double
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let homePrice = formatter.stringFromNumber(price)! as String
        
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 275, homeTray.bounds.size.width - 90, 30))
        homePriceTxtField.attributedPlaceholder = NSAttributedString(string: homePrice as String, attributes:attributes)
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Done
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        homePriceTxtField.enabled = false
        homeTray.addSubview(homePriceTxtField)
        
        // UIButton
        let addIcn = UIImage(named: "camera_icon") as UIImage?
        let addImagesButton = UIButton (frame: CGRectMake(homeTray.bounds.size.width - 120, 260, 50, 35))
        addImagesButton.addTarget(self, action: "selectWhereToGetImage:", forControlEvents: .TouchUpInside)
        addImagesButton.setBackgroundImage(addIcn, forState: .Normal)
        addImagesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addImagesButton.backgroundColor = UIColor.clearColor()
        addImagesButton.tag = 0
        homeTray.addSubview(addImagesButton)
        
        // UIButton
        let editIcn = UIImage(named: "edit_icon") as UIImage?
        let editButton = UIButton (frame: CGRectMake(homeTray.bounds.size.width - 50, 260, 35, 35))
        editButton.addTarget(self, action: "allowEdit:", forControlEvents: .TouchUpInside)
        editButton.setBackgroundImage(editIcn, forState: .Normal)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        homeTray.addSubview(editButton)
        
        let bed = homeObject["beds"] as? Int
        let attributedHomeBed = NSMutableAttributedString(
            string: String(format: "%d", bed!),
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 12.0)!])
        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(homeTray.bounds.size.width - 150, 300, 40, 30))
        bedsTxtField.attributedPlaceholder = attributedHomeBed
        bedsTxtField.backgroundColor = UIColor.clearColor()
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Done
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
        bedsTxtField.enabled = false
        homeTray.addSubview(bedsTxtField)
        
        let bedsLabel = UILabel(frame: CGRectMake(homeTray.bounds.size.width - 150, 320, 40, 30))
        bedsLabel.text = "Beds"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bedsLabel.textAlignment = NSTextAlignment.Left
        bedsLabel.numberOfLines = 1
        bedsLabel.font = bedsLabel.font.fontWithSize(12)
        bedsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bedsLabel)
        
        let vertDividerTwoView = UIView(frame: CGRectMake(homeTray.bounds.size.width - 109, 300, 1, 50))
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
        bathsTxtField.frame = (frame: CGRectMake(homeTray.bounds.size.width - 100, 300, 40, 30))
        bathsTxtField.attributedPlaceholder = attributedHomeBath
        bathsTxtField.backgroundColor = UIColor.clearColor()
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Done
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
        bathsTxtField.enabled = false
        homeTray.addSubview(bathsTxtField)
        
        let bathsLabel = UILabel(frame: CGRectMake(homeTray.bounds.size.width - 100, 320, 40, 30))
        bathsLabel.text = "Baths"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bathsLabel.textAlignment = NSTextAlignment.Left
        bathsLabel.numberOfLines = 1
        bathsLabel.font = bathsLabel.font.fontWithSize(12)
        bathsLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(bathsLabel)
        
        let vertDividerThreeView = UIView(frame: CGRectMake(homeTray.bounds.size.width - 59, 300, 1, 50))
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
        sqFeetTxtField.frame = (frame: CGRectMake(homeTray.bounds.size.width - 50, 300, 40, 30))
        sqFeetTxtField.attributedPlaceholder = attributedHomeSqft
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Done
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
        sqFeetTxtField.enabled = false
        homeTray.addSubview(sqFeetTxtField)
        
        let sqFeetLabel = UILabel(frame: CGRectMake(homeTray.bounds.size.width - 50, 320, 40, 30))
        sqFeetLabel.text = "Sq. Ft."
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sqFeetLabel.textAlignment = NSTextAlignment.Left
        sqFeetLabel.numberOfLines = 1
        sqFeetLabel.font = sqFeetLabel.font.fontWithSize(12)
        sqFeetLabel.textColor = UIColor.darkTextColor()
        homeTray.addSubview(sqFeetLabel)
        
        let starImage = UIImage(named: "Star_empty-01") as UIImage?
        var xOffset = 0
        for i in 1...4 {
            // UIButton
            let ratingButtonPhotoButton = UIButton (frame: CGRectMake(CGFloat(10 + xOffset), 315, 30, 30))
            ratingButtonPhotoButton.addTarget(self, action: "setRating:", forControlEvents: .TouchUpInside)
            ratingButtonPhotoButton.backgroundColor = model.darkBlueColor
            ratingButtonPhotoButton.setImage(starImage, forState: .Normal)
            ratingButtonPhotoButton.tag = i
            scrollView.addSubview(ratingButtonPhotoButton)
            
            xOffset += 35
        }
        
        let dividerView = UIView(frame: CGRectMake(10, 359, homeTray.bounds.size.width - 20, 1))
        dividerView.backgroundColor = UIColor.darkGrayColor()
        dividerView.hidden = false
        homeTray.addSubview(dividerView)
        
        let arialAttributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "Arial", size: 18)!
        ]
        
        let homeAddress = homeObject["address"] as! NSString
        //UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, 370, homeTray.bounds.size.width - 20, 30))
        homeAddressTxtField.attributedPlaceholder = NSAttributedString(string: homeAddress as String, attributes:arialAttributes)
        homeAddressTxtField.backgroundColor = UIColor.clearColor()
        homeAddressTxtField.delegate = self
        homeAddressTxtField.returnKeyType = .Done
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        homeAddressTxtField.enabled = false
        homeTray.addSubview(homeAddressTxtField)
        
        //Create textview
        let descTxtView = UITextView(frame : CGRectMake(10, CGFloat(370 + homeNameTxtField.frame.height + 10), homeTray.bounds.size.width - 20, 250))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.text = homeObject["desc"] as? String
        descTxtView.autocorrectionType = .Yes
        descTxtView.editable = false
        homeTray.addSubview(descTxtView)
        
        setDefaultImage()
    }
    
    func buildCalcTray() {
        calcTray.frame = (frame: CGRectMake(0, 0, scrollView.bounds.size.width, 650))
        calcTray.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(calcTray)
        
        let mortView = UIView(frame: CGRectMake(0, 0, scrollView.bounds.size.width, 300))
        mortView.backgroundColor = model.lightGrayColor
        calcTray.addSubview(mortView)
        
        mortgageView.buildMortgageCalcView(mortView)
        
        // UIView
        let calculateView = UIView(frame: CGRectMake(25, 310, calcTray.bounds.size.width - 50, 50))
        let calcGradientLayer = CAGradientLayer()
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        calcTray.addSubview(calculateView)
        
        // UIButton
        let calculateButton = UIButton (frame: CGRectMake(25, 0, calculateView.bounds.size.width - 25, calculateView.bounds.size.height))
        calculateButton.addTarget(self, action: "calculateMortgagePaymentButtonPress:", forControlEvents: .TouchUpInside)
        calculateButton.setTitle("CALCULATE", forState: .Normal)
        calculateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        calculateButton.backgroundColor = UIColor.clearColor()
        calculateButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        calculateButton.contentHorizontalAlignment = .Left
        calculateButton.tag = 0
        calculateView.addSubview(calculateButton)
        
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
        
        // UIView
        let saveView = UIView(frame: CGRectMake(25, 450, calcTray.bounds.size.width - 50, 50))
        let saveGradientLayer = CAGradientLayer()
        saveGradientLayer.frame = saveView.bounds
        saveGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        saveView.layer.insertSublayer(saveGradientLayer, atIndex: 0)
        saveView.layer.addSublayer(saveGradientLayer)
        calcTray.addSubview(saveView)
        
        // UIButton
        let saveButton = UIButton (frame: CGRectMake(0, 0, saveView.bounds.size.width, saveView.bounds.size.height))
        saveButton.addTarget(self, action: "calculateMortgagePaymentButtonPress:", forControlEvents: .TouchUpInside)
        saveButton.setTitle("SAVE HOME", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.backgroundColor = UIColor.clearColor()
        saveButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        saveButton.contentHorizontalAlignment = .Center
        saveButton.tag = 0
        saveView.addSubview(saveButton)
        
        // UIView
        let deleteView = UIView(frame: CGRectMake(25, 510, calcTray.bounds.size.width - 50, 50))
        let deleteGradientLayer = CAGradientLayer()
        deleteGradientLayer.frame = saveView.bounds
        deleteGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        deleteView.layer.insertSublayer(deleteGradientLayer, atIndex: 0)
        deleteView.layer.addSublayer(deleteGradientLayer)
        calcTray.addSubview(deleteView)
        
        // UIButton
        let deleteButton = UIButton (frame: CGRectMake(0, 0, saveView.bounds.size.width, saveView.bounds.size.height))
        deleteButton.addTarget(self, action: "deleteHome:", forControlEvents: .TouchUpInside)
        deleteButton.setTitle("DELETE HOME", forState: .Normal)
        deleteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        deleteButton.backgroundColor = UIColor.clearColor()
        deleteButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        deleteButton.contentHorizontalAlignment = .Center
        deleteButton.tag = 0
        deleteView.addSubview(deleteButton)
    }

    func showHideCalcTray(sender: UIButton) {
        if (!isCalcTrayOpen) {
            UIView.animateWithDuration(0.8, animations: {
                self.calcTray.frame = (frame: CGRectMake(0, 730, self.scrollView.bounds.size.width, 650))
                }, completion: {
                    (value: Bool) in
                    self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 1300)
                    self.isCalcTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.8, animations: {
                self.calcTray.frame = (frame: CGRectMake(0, 0, self.scrollView.bounds.size.width, 650))
                }, completion: {
                    (value: Bool) in
                    self.scrollView.contentSize = CGSize(width: self.myHomesView.bounds.size.width, height: 750)
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
            let fillerImage = UIImage(named: "homebackground") as UIImage?
            defaultImageView.image = fillerImage
        }
    }
    
    func imageOverlay(imageArray: Array<PFFile>) {
        
        let overlayColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = overlayColor
        overlayView.hidden = true
        self.view.addSubview(overlayView)
        
        imageScollView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        imageScollView.backgroundColor = UIColor.clearColor()
        overlayView.addSubview(imageScollView)
        var xLocation = 0.0
        
        for img: PFFile in imageArray {
            img.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        print(image)
                        let homeImageView = UIImageView(frame: CGRectMake(CGFloat(xLocation), 0, self.view.bounds.size.width, self.view.bounds.size.height))
                        homeImageView.contentMode = .ScaleAspectFit
                        homeImageView.backgroundColor = UIColor.clearColor()
                        self.imageScollView.addSubview(homeImageView)
                        homeImageView.image = image
                    }
                    
                    xLocation += Double(self.scrollView.bounds.size.width)
                }
            }
        }
        
        let closeButton = UIButton(frame: CGRectMake(self.view.bounds.size.width - 50, 25, 50, 50))
        closeButton.addTarget(self, action: "hideImageOverlay:", forControlEvents: .TouchUpInside)
        closeButton.setTitle("X", forState: .Normal)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.titleLabel!.font = UIFont(name: "forza-light", size: 45)
        closeButton.tag = 0
        overlayView.addSubview(closeButton)
        
        imageScollView.contentSize = CGSize(width: CGFloat(Int(scrollView.bounds.size.width) * imageArray.count), height: 250)
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
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
    }
    
    func allowEdit(sender: UIButton) {
        if (!isTextFieldEnabled) {
            homeNameTxtField.enabled = true
            homePriceTxtField.enabled = true
            homeAddressTxtField.enabled = true
            bedsTxtField.enabled = true
            bathsTxtField.enabled = true
            sqFeetTxtField.enabled = true
            
            isTextFieldEnabled = true
        }
        else {
            homeNameTxtField.enabled = false
            homePriceTxtField.enabled = false
            homeAddressTxtField.enabled = false
            bedsTxtField.enabled = false
            bathsTxtField.enabled = false
            sqFeetTxtField.enabled = false
            
            isTextFieldEnabled = false
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
        //estimatedPaymentDefault =  model.calculateMortgagePayment(mortgageView.loanAmountTxtField, interest: mortgageView.interestDefault, mortgage: mortgageView.mortgageDefault)
        //paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
        //updateHomeObjectWithMortgagePayment()
    }
    
    func deleteHome(sender: UIButton) {
        deleteHomeObject()
    }
    
    //MARK:
    //MARK: UIImagePickerController Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            defaultImageView.contentMode = .ScaleAspectFit
            defaultImageView.image = pickedImage
            img = pickedImage
            if (picker.sourceType.rawValue == 1) {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
            
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            scrollView.addSubview(activityIndicator)
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                
                self.img = self.scaleImagesForParse(self.img)
                self.updateHomeObjectImageArray()
            }

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
    
    //MARK:
    //MARK: Parse Update Object
    func updateHomeObjectImageArray() {
        var imgArray = homeObject["imageArray"] as! Array<PFFile>
        let imageData = UIImagePNGRepresentation(self.img)
        
        if (imageData != nil) {
            let imageFile = PFFile(name:"image.png", data:imageData!)
            imgArray.append(imageFile!)
            homeObject["imageArray"] = imgArray
        }
        homeObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.imageScollView.removeFromSuperview()
                self.imageOverlay(imgArray)
                
                // TODO: This update method is really slow
                print("The object was saved")
            }
            else {
                print("The object was not saved")
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateHomeObjectWithMortgagePayment() {
        homeObject["monthlyPayment"] = estimatedPaymentDefault
        homeObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("The object was saved")
            }
            else {
                print("The object was not saved")
            }
        }
    }
    
    func deleteHomeObject() {
       
        homeObject.deleteInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("The object was deleted")
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                
            } else {
                // There was a problem, check error.description
                print("error: %@", error)
            }
        }
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}