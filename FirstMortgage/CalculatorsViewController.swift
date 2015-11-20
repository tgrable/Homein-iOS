//
//  CalculatorsViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit

class CalculatorsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    let greenColor = UIColor(red: 185/255, green: 190/255, blue: 71/255, alpha: 1)
    
    // UIView
    let calcView = UIView() as UIView
    let calcWindowView = UIView() as UIView
    
    // UIScrollView
    let scrollView = UIScrollView() as UIScrollView
    
    //UIImageView
    var imageView = UIImageView() as UIImageView
    
    // UITextField
    let loanAmountTxtField = UITextField() as UITextField
    let downPaymentTxtField = UITextField() as UITextField
    let taxesTxtField = UITextField() as UITextField
    
    let currentYearTxtField = UITextField() as UITextField
    let newLoanAmountTxtField = UITextField() as UITextField
    let newYearTxtField = UITextField() as UITextField
    
    // UIPickerView
    let mortgageTermPicker = UIPickerView() as UIPickerView
    let mortgagePickerData = ["15 Years","30 Years"]
    var mortgageDefault = 30.0
    
    let interestRatePicker = UIPickerView() as UIPickerView
    let interestPickerData = ["3.0%","3.5%","4.0%","4.5%","5.0%","5.5%"]
    var interestDefault = 3.0
    
    let newMortgageTermPicker = UIPickerView() as UIPickerView
    let newMortgagePickerData = ["15 Years","30 Years"]
    var newMortgageDefault = 30.0
    
    let newInterestRatePicker = UIPickerView() as UIPickerView
    let newInterestPickerData = ["3.0%","3.5%","4.0%","4.5%","5.0%","5.5%"]
    var newInterestDefault = 3.0
    
    // UILabel
    var paymentLabel = UILabel() as UILabel
    
    // ShadowEffet
    var shadow = ShadowEffect()
    
    var isMortgageCalc = Bool() as Bool
    var isSmallerScreen = Bool() as Bool
    var titleLabel = String() as String
    var estimatedPaymentDefault = 1835.26
    
    // MARK:
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isSmallerScreen = false
        if (self.view.bounds.size.width == 320) {
            isSmallerScreen = true
        }
        
        buildView()

        mortgageTermPicker.delegate = self
        mortgageTermPicker.dataSource = self
        
        interestRatePicker.delegate = self
        interestRatePicker.dataSource = self
        
        newMortgageTermPicker.delegate = self
        newMortgageTermPicker.dataSource = self
        
        newInterestRatePicker.delegate = self
        newInterestRatePicker.dataSource = self
        
        if (isMortgageCalc) {
            buildMortgageCalcView()
        }
        else {
            buildRefiCalcView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:
    // MARK: Build View
    
    func buildView() {
        calcView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        calcView.backgroundColor = lightGrayColor
        calcView.hidden = false
        self.view.addSubview(calcView)
        
        let fmcLogo = UIImage(named: "fmc_logo") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake(40, 35, self.view.bounds.size.width - 80, 40))
        imageView.image = fmcLogo
        calcView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        calcView.addSubview(whiteBar)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 75, 45))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitle("Home", forState: .Normal)
        homeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        let calcBannerView = UIView(frame: CGRectMake(0, 135, calcView.bounds.size.width, 50))
        calcBannerView.backgroundColor = greenColor
        calcBannerView.hidden = false
        calcView.addSubview(calcBannerView)
        
        if (isMortgageCalc) {
            titleLabel = "MORTGAGE CALCULATOR"
        }
        else {
            titleLabel = "REFINANCE CALCULATOR"
        }
        
        let labelFontSize = isSmallerScreen ? 20.0 : 24.0;
        print(isSmallerScreen)
        print(CGFloat(labelFontSize))
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(65, 10, calcBannerView.bounds.size.width - 65, 0))
        bannerLabel.text = titleLabel
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bannerLabel.textAlignment = NSTextAlignment.Left
        bannerLabel.numberOfLines = 0
        bannerLabel.font = paymentLabel.font.fontWithSize(CGFloat(labelFontSize))
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.sizeToFit()
        calcBannerView.addSubview(bannerLabel)
        
        scrollView.frame = (frame: CGRectMake(0, 185, calcView.bounds.size.width, calcView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        calcView.addSubview(scrollView)
        
        calcWindowView.backgroundColor = UIColor.whiteColor()
        calcWindowView.hidden = false
        scrollView.addSubview(calcWindowView)
    }
    
    func buildMortgageCalcView() {
        
        calcWindowView.frame = (frame: CGRectMake(10, 0, calcView.bounds.size.width - 20, 300))
        let fontSize = 14
        
        // UIView
        let shadowView = UIView(frame: CGRectMake(10, 300, calcView.bounds.size.width - 20, 2))
        shadowView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(shadowView)
        shadow.applyCurvedShadow(shadowView)
        
        let mortgageCalcView = UIView(frame: CGRectMake(0, 0, calcWindowView.bounds.size.width, calcWindowView.bounds.size.height))
        mortgageCalcView.backgroundColor = UIColor.clearColor()
        mortgageCalcView.hidden = false
        calcWindowView.addSubview(mortgageCalcView)
        
        /********************************************************* Loan Amount ********************************************************************/
        // UILabel
        let loanAmountLabel = UILabel(frame: CGRectMake(10, 35, (mortgageCalcView.bounds.size.width / 2) - 20, 0))
        loanAmountLabel.text = "LOAN AMOUNT"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        loanAmountLabel.textAlignment = NSTextAlignment.Left
        loanAmountLabel.numberOfLines = 0
        loanAmountLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        loanAmountLabel.sizeToFit()
        mortgageCalcView.addSubview(loanAmountLabel)
        
        // UILabel
        let equalOneLabel = UILabel(frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) - 20, 35, 20, 0))
        equalOneLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalOneLabel.textAlignment = NSTextAlignment.Right
        equalOneLabel.numberOfLines = 0
        equalOneLabel.sizeToFit()
        mortgageCalcView.addSubview(equalOneLabel)
        
        // UITextField
        loanAmountTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 25,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
        loanAmountTxtField.borderStyle = UITextBorderStyle.Line
        loanAmountTxtField.layer.borderColor = lightGrayColor.CGColor
        loanAmountTxtField.placeholder = "$250,000"
        loanAmountTxtField.backgroundColor = UIColor.clearColor()
        loanAmountTxtField.delegate = self
        loanAmountTxtField.returnKeyType = .Done
        loanAmountTxtField.keyboardType = UIKeyboardType.NumberPad
        mortgageCalcView.addSubview(loanAmountTxtField)
        
        /********************************************************* Mortgage Term ********************************************************************/
        // UILabel
        let mTermLabel = UILabel(frame: CGRectMake(10, 85, (mortgageCalcView.bounds.size.width / 2) - 20, 0))
        mTermLabel.text = "MORTGAGE TERM"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        mTermLabel.textAlignment = NSTextAlignment.Left
        mTermLabel.numberOfLines = 0
        mTermLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        mTermLabel.sizeToFit()
        mortgageCalcView.addSubview(mTermLabel)
        
        // UILabel
        let equalTwoLabel = UILabel(frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) - 20, 85, 20, 0))
        equalTwoLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalTwoLabel.textAlignment = NSTextAlignment.Right
        equalTwoLabel.numberOfLines = 0
        equalTwoLabel.sizeToFit()
        mortgageCalcView.addSubview(equalTwoLabel)
        
        // UITextField
        mortgageTermPicker.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 75,(mortgageCalcView.bounds.size.width / 2) - 20, 50));
        mortgageTermPicker.backgroundColor = UIColor.clearColor()
        mortgageTermPicker.layer.borderColor = lightGrayColor.CGColor
        mortgageTermPicker.tag = 0
        mortgageCalcView.addSubview(mortgageTermPicker)
        
        /********************************************************* Interest Rate ********************************************************************/
        // UILabel
        let interestRateLabel = UILabel(frame: CGRectMake(10, 135, (mortgageCalcView.bounds.size.width / 2) - 20, 0))
        interestRateLabel.text = "INTEREST RATE"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        interestRateLabel.textAlignment = NSTextAlignment.Left
        interestRateLabel.numberOfLines = 0
        interestRateLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        interestRateLabel.sizeToFit()
        mortgageCalcView.addSubview(interestRateLabel)
        
        // UILabel
        let equalThreeLabel = UILabel(frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) - 20, 135, 20, 0))
        equalThreeLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalThreeLabel.textAlignment = NSTextAlignment.Right
        equalThreeLabel.numberOfLines = 0
        equalThreeLabel.sizeToFit()
        mortgageCalcView.addSubview(equalThreeLabel)
        
        // UITextField
        interestRatePicker.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 125,(mortgageCalcView.bounds.size.width / 2) - 20, 50));
        interestRatePicker.backgroundColor = UIColor.clearColor()
        interestRatePicker.layer.borderColor = lightGrayColor.CGColor
        interestRatePicker.tag = 1
        mortgageCalcView.addSubview(interestRatePicker)
        
        /********************************************************* Down Payment ********************************************************************/
        // UILabel
        let downPaymentLabel = UILabel(frame: CGRectMake(10, 185, (mortgageCalcView.bounds.size.width / 2) - 20, 0))
        downPaymentLabel.text = "DOWNPAYMENT"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        downPaymentLabel.textAlignment = NSTextAlignment.Left
        downPaymentLabel.numberOfLines = 0
        downPaymentLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        downPaymentLabel.sizeToFit()
        mortgageCalcView.addSubview(downPaymentLabel)
        
        // UILabel
        let equalFourLabel = UILabel(frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) - 20, 185, 20, 0))
        equalFourLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalFourLabel.textAlignment = NSTextAlignment.Right
        equalFourLabel.numberOfLines = 0
        equalFourLabel.sizeToFit()
        mortgageCalcView.addSubview(equalFourLabel)
        
        // UITextField
        downPaymentTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 175,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
        downPaymentTxtField.borderStyle = UITextBorderStyle.Line
        downPaymentTxtField.layer.borderColor = lightGrayColor.CGColor
        downPaymentTxtField.placeholder = "$5,000"
        downPaymentTxtField.backgroundColor = UIColor.clearColor()
        downPaymentTxtField.delegate = self
        downPaymentTxtField.returnKeyType = .Done
        downPaymentTxtField.keyboardType = UIKeyboardType.NumberPad
        mortgageCalcView.addSubview(downPaymentTxtField)
        
        /********************************************************* Property Taxes ********************************************************************/
        // UILabel
        let taxesLabel = UILabel(frame: CGRectMake(10, 235, (mortgageCalcView.bounds.size.width / 2) - 20, 0))
        taxesLabel.text = "PROPERTY TAXES"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        taxesLabel.textAlignment = NSTextAlignment.Left
        taxesLabel.numberOfLines = 0
        taxesLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        taxesLabel.sizeToFit()
        mortgageCalcView.addSubview(taxesLabel)
        
        // UILabel
        let equalFiveLabel = UILabel(frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) - 20, 235, 20, 0))
        equalFiveLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalFiveLabel.textAlignment = NSTextAlignment.Right
        equalFiveLabel.numberOfLines = 0
        equalFiveLabel.sizeToFit()
        mortgageCalcView.addSubview(equalFiveLabel)
        
        // UITextField
        taxesTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 225,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
        taxesTxtField.borderStyle = UITextBorderStyle.Line
        taxesTxtField.layer.borderColor = lightGrayColor.CGColor
        taxesTxtField.placeholder = "3.750%"
        taxesTxtField.backgroundColor = UIColor.clearColor()
        taxesTxtField.delegate = self
        taxesTxtField.returnKeyType = .Done
        taxesTxtField.keyboardType = UIKeyboardType.DecimalPad
        mortgageCalcView.addSubview(taxesTxtField)
        
        let calculateImage = UIImage(named: "btn-calculate")
        
        // UIButton
        let calculateButton = UIButton (frame: CGRectMake(25, 325, 178, 56))
        calculateButton.addTarget(self, action: "calculateMortgagePayment:", forControlEvents: .TouchUpInside)
        calculateButton.setBackgroundImage(calculateImage, forState: .Normal)
        calculateButton.backgroundColor = UIColor.clearColor()
        calculateButton.tag = 0
        scrollView.addSubview(calculateButton)
        
        // UILabel
        let estPaymentLabel = UILabel(frame: CGRectMake(25, 400, calcView.bounds.size.width - 50, 0))
        estPaymentLabel.text = "YOUR ESTIMATED PAYMENT IS:"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        estPaymentLabel.textAlignment = NSTextAlignment.Left
        estPaymentLabel.numberOfLines = 0
        estPaymentLabel.sizeToFit()
        scrollView.addSubview(estPaymentLabel)
        
        // UIView
        let paymentView = UIView(frame: CGRectMake(25, 425, calcView.bounds.size.width - 50, 50))
        paymentView.backgroundColor = greenColor
        scrollView.addSubview(paymentView)
        
        // UILabel
        paymentLabel.frame = (frame: CGRectMake(25, 10, paymentView.bounds.size.width, 0))
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        paymentLabel.font = paymentLabel.font.fontWithSize(24)
        paymentLabel.textColor = UIColor.whiteColor()
        paymentLabel.textAlignment = NSTextAlignment.Center
        paymentLabel.numberOfLines = 0
        paymentLabel.sizeToFit()
        paymentView.addSubview(paymentLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        mortgageCalcView.addGestureRecognizer(tapGesture)
        
        scrollView.contentSize = CGSize(width: calcView.bounds.size.width, height: 575)
    }
    
    func buildRefiCalcView() {
        
        calcWindowView.frame = (frame: CGRectMake(10, 0, calcView.bounds.size.width - 20, 525))
        let fontSize = 14
        
        let refiCalcView = UIView(frame: CGRectMake(0, 0, calcWindowView.bounds.size.width, calcWindowView.bounds.size.height))
        refiCalcView.backgroundColor = UIColor.clearColor()
        refiCalcView.hidden = false
        calcWindowView.addSubview(refiCalcView)
        
        /********************************************************* Current Loan Amount ********************************************************************/
         // UILabel
        let currentLoanAmountLabel = UILabel(frame: CGRectMake(10, 25, (refiCalcView.bounds.size.width / 2) - 20, 0))
        currentLoanAmountLabel.text = "CURRENT LOAN AMOUNT"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        currentLoanAmountLabel.textAlignment = NSTextAlignment.Left
        currentLoanAmountLabel.numberOfLines = 0
        currentLoanAmountLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        currentLoanAmountLabel.sizeToFit()
        refiCalcView.addSubview(currentLoanAmountLabel)
        
        // UILabel
        let equalOneLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 35, 20, 0))
        equalOneLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalOneLabel.textAlignment = NSTextAlignment.Right
        equalOneLabel.numberOfLines = 0
        equalOneLabel.sizeToFit()
        refiCalcView.addSubview(equalOneLabel)
        
        // UITextField
        loanAmountTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 25,(refiCalcView.bounds.size.width / 2) - 20, 40));
        loanAmountTxtField.borderStyle = UITextBorderStyle.Line
        loanAmountTxtField.layer.borderColor = lightGrayColor.CGColor
        loanAmountTxtField.placeholder = "$250,000"
        loanAmountTxtField.backgroundColor = UIColor.clearColor()
        loanAmountTxtField.delegate = self
        loanAmountTxtField.returnKeyType = .Done
        loanAmountTxtField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(loanAmountTxtField)
        
        /********************************************************* Current Mortgage Term ********************************************************************/
         // UILabel
        let mTermLabel = UILabel(frame: CGRectMake(10, 85, (refiCalcView.bounds.size.width / 2) - 20, 0))
        mTermLabel.text = "CURRENT MORTGAGE TERM"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        mTermLabel.textAlignment = NSTextAlignment.Left
        mTermLabel.numberOfLines = 0
        mTermLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        mTermLabel.sizeToFit()
        refiCalcView.addSubview(mTermLabel)
        
        // UILabel
        let equalTwoLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 85, 20, 0))
        equalTwoLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalTwoLabel.textAlignment = NSTextAlignment.Right
        equalTwoLabel.numberOfLines = 0
        equalTwoLabel.sizeToFit()
        refiCalcView.addSubview(equalTwoLabel)
        
        // UIPickerView
        mortgageTermPicker.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 75,(refiCalcView.bounds.size.width / 2) - 20, 50));
        mortgageTermPicker.backgroundColor = UIColor.clearColor()
        mortgageTermPicker.layer.borderColor = lightGrayColor.CGColor
        mortgageTermPicker.tag = 0
        refiCalcView.addSubview(mortgageTermPicker)
        
        /********************************************************* Current Interest Rate ********************************************************************/
         // UILabel
        let interestRateLabel = UILabel(frame: CGRectMake(10, 135, (refiCalcView.bounds.size.width / 2) - 20, 0))
        interestRateLabel.text = "CURRENT INTEREST RATE"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        interestRateLabel.textAlignment = NSTextAlignment.Left
        interestRateLabel.numberOfLines = 0
        interestRateLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        interestRateLabel.sizeToFit()
        refiCalcView.addSubview(interestRateLabel)
        
        // UILabel
        let equalThreeLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 135, 20, 0))
        equalThreeLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalThreeLabel.textAlignment = NSTextAlignment.Right
        equalThreeLabel.numberOfLines = 0
        equalThreeLabel.sizeToFit()
        refiCalcView.addSubview(equalThreeLabel)
        
        // UIPickerView
        interestRatePicker.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 125,(refiCalcView.bounds.size.width / 2) - 20, 50));
        interestRatePicker.backgroundColor = UIColor.clearColor()
        interestRatePicker.layer.borderColor = lightGrayColor.CGColor
        interestRatePicker.tag = 1
        refiCalcView.addSubview(interestRatePicker)
        
        /********************************************************* Current Origination Year ********************************************************************/
         // UILabel
        let currentOriginationYearLabel = UILabel(frame: CGRectMake(10, 185, (refiCalcView.bounds.size.width / 2) - 20, 0))
        currentOriginationYearLabel.text = "CURRENT ORIGINATION YEAR"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        currentOriginationYearLabel.textAlignment = NSTextAlignment.Left
        currentOriginationYearLabel.numberOfLines = 0
        currentOriginationYearLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        currentOriginationYearLabel.sizeToFit()
        refiCalcView.addSubview(currentOriginationYearLabel)
        
        // UILabel
        let equalFourLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 185, 20, 0))
        equalFourLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalFourLabel.textAlignment = NSTextAlignment.Right
        equalFourLabel.numberOfLines = 0
        equalFourLabel.sizeToFit()
        refiCalcView.addSubview(equalFourLabel)
        
        // UITextField
        currentYearTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 175,(refiCalcView.bounds.size.width / 2) - 20, 40));
        currentYearTxtField.borderStyle = UITextBorderStyle.Line
        currentYearTxtField.layer.borderColor = lightGrayColor.CGColor
        currentYearTxtField.placeholder = "2010"
        currentYearTxtField.backgroundColor = UIColor.clearColor()
        currentYearTxtField.delegate = self
        currentYearTxtField.returnKeyType = .Done
        currentYearTxtField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(currentYearTxtField)
        
        let refiDividerView = UIView(frame: CGRectMake(10, 250, calcWindowView.bounds.size.width - 20, 2))
        refiDividerView.backgroundColor = lightGrayColor
        refiDividerView.hidden = false
        calcWindowView.addSubview(refiDividerView)
        
        /********************************************************* New Loan Amount ********************************************************************/
         // UILabel
        let newLoanAmountLabel = UILabel(frame: CGRectMake(10, 275, (refiCalcView.bounds.size.width / 2) - 20, 0))
        newLoanAmountLabel.text = "NEW LOAN AMOUNT"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        newLoanAmountLabel.textAlignment = NSTextAlignment.Left
        newLoanAmountLabel.numberOfLines = 0
        newLoanAmountLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        newLoanAmountLabel.sizeToFit()
        refiCalcView.addSubview(newLoanAmountLabel)
        
        // UILabel
        let equalFiveLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 285, 20, 0))
        equalFiveLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalFiveLabel.textAlignment = NSTextAlignment.Right
        equalFiveLabel.numberOfLines = 0
        equalFiveLabel.sizeToFit()
        refiCalcView.addSubview(equalFiveLabel)
        
        // UITextField
        newLoanAmountTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 275,(refiCalcView.bounds.size.width / 2) - 20, 40));
        newLoanAmountTxtField.borderStyle = UITextBorderStyle.Line
        newLoanAmountTxtField.layer.borderColor = lightGrayColor.CGColor
        newLoanAmountTxtField.placeholder = "$225,000"
        newLoanAmountTxtField.backgroundColor = UIColor.clearColor()
        newLoanAmountTxtField.delegate = self
        newLoanAmountTxtField.returnKeyType = .Done
        newLoanAmountTxtField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(newLoanAmountTxtField)
        
        /********************************************************* New Mortgage Term ********************************************************************/
         // UILabel
        let newTermLabel = UILabel(frame: CGRectMake(10, 335, (refiCalcView.bounds.size.width / 2) - 20, 0))
        newTermLabel.text = "NEW MORTGAGE TERM"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        newTermLabel.textAlignment = NSTextAlignment.Left
        newTermLabel.numberOfLines = 0
        newTermLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        newTermLabel.sizeToFit()
        refiCalcView.addSubview(newTermLabel)
        
        // UILabel
        let equalSixLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 345, 20, 0))
        equalSixLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalSixLabel.textAlignment = NSTextAlignment.Right
        equalSixLabel.numberOfLines = 0
        equalSixLabel.sizeToFit()
        refiCalcView.addSubview(equalSixLabel)
        
        // UIPickerView
        newMortgageTermPicker.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 335,(refiCalcView.bounds.size.width / 2) - 20, 50));
        newMortgageTermPicker.backgroundColor = UIColor.clearColor()
        newMortgageTermPicker.layer.borderColor = lightGrayColor.CGColor
        newMortgageTermPicker.tag = 2
        refiCalcView.addSubview(newMortgageTermPicker)
        
        /********************************************************* Current Interest Rate ********************************************************************/
         // UILabel
        let newInterestRateLabel = UILabel(frame: CGRectMake(10, 395, (refiCalcView.bounds.size.width / 2) - 20, 0))
        newInterestRateLabel.text = "NEW INTEREST RATE"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        newInterestRateLabel.textAlignment = NSTextAlignment.Left
        newInterestRateLabel.numberOfLines = 0
        newInterestRateLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        newInterestRateLabel.sizeToFit()
        refiCalcView.addSubview(newInterestRateLabel)
        
        // UILabel
        let equalSevenLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 405, 20, 0))
        equalSevenLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalSevenLabel.textAlignment = NSTextAlignment.Right
        equalSevenLabel.numberOfLines = 0
        equalSevenLabel.sizeToFit()
        refiCalcView.addSubview(equalSevenLabel)
        
        // UIPickerView
        newInterestRatePicker.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 395,(refiCalcView.bounds.size.width / 2) - 20, 50));
        newInterestRatePicker.backgroundColor = UIColor.clearColor()
        newInterestRatePicker.layer.borderColor = lightGrayColor.CGColor
        newInterestRatePicker.tag = 3
        refiCalcView.addSubview(newInterestRatePicker)
        
        /********************************************************* Current Origination Year ********************************************************************/
         // UILabel
        let newOriginationYearLabel = UILabel(frame: CGRectMake(10, 455, (refiCalcView.bounds.size.width / 2) - 20, 0))
        newOriginationYearLabel.text = "NEW ORIGINATION YEAR"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        newOriginationYearLabel.textAlignment = NSTextAlignment.Left
        newOriginationYearLabel.numberOfLines = 0
        newOriginationYearLabel.font = paymentLabel.font.fontWithSize(CGFloat(fontSize))
        newOriginationYearLabel.sizeToFit()
        refiCalcView.addSubview(newOriginationYearLabel)
        
        // UILabel
        let equalEightLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 465, 20, 0))
        equalEightLabel.text = " = "
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        equalEightLabel.textAlignment = NSTextAlignment.Right
        equalEightLabel.numberOfLines = 0
        equalEightLabel.sizeToFit()
        refiCalcView.addSubview(equalEightLabel)
        
        // UITextField
        newYearTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 455,(refiCalcView.bounds.size.width / 2) - 20, 40));
        newYearTxtField.borderStyle = UITextBorderStyle.Line
        newYearTxtField.layer.borderColor = lightGrayColor.CGColor
        newYearTxtField.placeholder = "2010"
        newYearTxtField.backgroundColor = UIColor.clearColor()
        newYearTxtField.delegate = self
        newYearTxtField.returnKeyType = .Done
        newYearTxtField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(newYearTxtField)
        
        let calculateImage = UIImage(named: "btn-calculate")
        
        // UIButton
        let calculateButton = UIButton (frame: CGRectMake(25, 550, 178, 56))
        calculateButton.addTarget(self, action: "calculateMortgagePayment:", forControlEvents: .TouchUpInside)
        calculateButton.setBackgroundImage(calculateImage, forState: .Normal)
        calculateButton.backgroundColor = UIColor.clearColor()
        calculateButton.tag = 0
        scrollView.addSubview(calculateButton)
        
        // UILabel
        let estPaymentLabel = UILabel(frame: CGRectMake(25, 615, calcView.bounds.size.width - 50, 0))
        estPaymentLabel.text = "YOUR ESTIMATED PAYMENT IS:"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        estPaymentLabel.textAlignment = NSTextAlignment.Left
        estPaymentLabel.numberOfLines = 0
        estPaymentLabel.sizeToFit()
        scrollView.addSubview(estPaymentLabel)
        
        // UIView
        let paymentView = UIView(frame: CGRectMake(25, 650, calcView.bounds.size.width - 50, 50))
        paymentView.backgroundColor = greenColor
        scrollView.addSubview(paymentView)
        
        // UILabel
        paymentLabel.frame = (frame: CGRectMake(25, 10, paymentView.bounds.size.width, 0))
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        paymentLabel.font = paymentLabel.font.fontWithSize(24)
        paymentLabel.textColor = UIColor.whiteColor()
        paymentLabel.textAlignment = NSTextAlignment.Center
        paymentLabel.numberOfLines = 0
        paymentLabel.sizeToFit()
        paymentView.addSubview(paymentLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        refiCalcView.addGestureRecognizer(tapGesture)
        
        scrollView.contentSize = CGSize(width: calcView.bounds.size.width, height: 775)
    }
    
    // MARK:
    // MARK: UIPickerView Delegate and Data Source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //print("pickerView.tag == %f", pickerView.tag)
        
        if (pickerView.tag == 0) {
            return mortgagePickerData.count
        }
        else if (pickerView.tag == 1) {
            return interestPickerData.count
        }
        else if (pickerView.tag == 2) {
            return newMortgagePickerData.count
        }
        else if (pickerView.tag == 3) {
            return newInterestPickerData.count
        }
        else {
            return 0
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return mortgagePickerData[row]
        }
        else if (pickerView.tag == 1) {
            return interestPickerData[row]
        }
        else if (pickerView.tag == 2) {
            return newMortgagePickerData[row]
        }
        else if (pickerView.tag == 3) {
            return newInterestPickerData[row]
        }
        else {
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            let index1 = mortgagePickerData[row].startIndex.advancedBy(2)
            let substring1 = mortgagePickerData[row].substringToIndex(index1)
            
            mortgageDefault = Double(substring1)!
        }
        else if (pickerView.tag == 1) {
            let index2 = interestPickerData[row].startIndex.advancedBy(3)
            let substring2 = interestPickerData[row].substringToIndex(index2)
            
            interestDefault = Double(substring2)!
        }
        else {
            print("empty")
        }
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
    // MARK: UITapGesture
    
    func tapGesture() {
        loanAmountTxtField.resignFirstResponder()
        downPaymentTxtField.resignFirstResponder()
        taxesTxtField.resignFirstResponder()
        
        currentYearTxtField.resignFirstResponder()
        newLoanAmountTxtField.resignFirstResponder()
        newYearTxtField.resignFirstResponder()
    }
    
    // MARK:
    // MARK: Action Methods

    func calculateMortgagePayment(sender: UIButton) {
        let loanAmount = Double(loanAmountTxtField.text!)!
        let intRate = interestDefault
        let term  = mortgageDefault
        
        let r = intRate / 1200
        let n = term * 12
        let rPower = pow(1+r, n)
        
        let monthlyPayment = loanAmount * r * rPower / (rPower - 1)
        estimatedPaymentDefault = monthlyPayment + (((Double(taxesTxtField.text!)! / 100) * Double(loanAmountTxtField.text!)!) / 12)
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
    }
    
    // MARK:
    // MARK: Navigation
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
