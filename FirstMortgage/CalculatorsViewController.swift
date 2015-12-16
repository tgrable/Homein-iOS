//
//  CalculatorsViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit

class CalculatorsViewController: UIViewController, UITextFieldDelegate {

    // MARK:
    // MARK: Properties
    let model = Model()
    let mortgageView = MortgageCalculatorView()
    let modelName = UIDevice.currentDevice().modelName
    
    // UIView
    let calcView = UIView() as UIView
    let calcWindowView = UIView() as UIView
    
    // UIScrollView
    let scrollView = UIScrollView() as UIScrollView
    
    //UIImageView
    var imageView = UIImageView() as UIImageView
    
    // UITextField
    let loanAmountTxtField = UITextField() as UITextField
    let mortgageTextField = UITextField() as UITextField
    let interestTextField = UITextField() as UITextField
    let taxesTxtField = UITextField() as UITextField
    let currentYearTxtField = UITextField() as UITextField
    let newMortgageTextField = UITextField() as UITextField
    let newInterestTextField = UITextField() as UITextField
   
    // UILabel
    var paymentLabel = UILabel() as UILabel
    var refiPaymentLabel = UILabel() as UILabel
    
    var isMortgageCalc = Bool() as Bool

    var titleLabel = String() as String
    var estimatedPaymentDefault = 1865.78
    var estimatedOriginalPaymentDefault = 2047.96
    var refiPaymentDefault = 1735.52
    
    // MARK:
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        buildView()
        
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
        calcView.backgroundColor = model.lightGrayColor
        calcView.hidden = false
        self.view.addSubview(calcView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((calcView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        calcView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        calcView.addSubview(whiteBar)
        
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
        
        let calcBannerView = UIView(frame: CGRectMake(0, 135, calcView.bounds.size.width, 50))
        let calcBannerGradientLayer = CAGradientLayer()
        calcBannerGradientLayer.frame = calcBannerView.bounds
        calcBannerGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        calcBannerView.layer.insertSublayer(calcBannerGradientLayer, atIndex: 0)
        calcBannerView.layer.addSublayer(calcBannerGradientLayer)
        calcBannerView.hidden = false
        calcView.addSubview(calcBannerView)
        
        let calcIcn = UIImage(named: "icn-calculator") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake(15, 12.5, 25, 25))
        calcIcon.image = calcIcn
        calcBannerView.addSubview(calcIcon)
        
        if (isMortgageCalc) {
            titleLabel = "MORTGAGE CALCULATOR"
        }
        else {
            titleLabel = "REFINANCE CALCULATOR"
        }
        
        var fontSize = 25
        if modelName.rangeOfString("5") != nil{
            fontSize = 20
        }
        
        // UILabel font =
        let bannerLabel = UILabel(frame: CGRectMake(50, 0, calcBannerView.bounds.size.width - 50, 50))
        bannerLabel.text = titleLabel
        bannerLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        bannerLabel.textAlignment = NSTextAlignment.Left
        bannerLabel.textColor = UIColor.whiteColor()
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

        let mortView = UIView(frame: CGRectMake(0, 0, calcWindowView.bounds.size.width, 300))
        mortView.backgroundColor = model.lightGrayColor
        calcWindowView.addSubview(mortView)
        
        let shadowImg = UIImage(named: "long_shadow") as UIImage?
        // UIImageView
        let shadowView = UIImageView(frame: CGRectMake(0, 300, mortView.bounds.size.width, 15))
        shadowView.image = shadowImg
        mortView.addSubview(shadowView)
        
        mortgageView.buildMortgageCalcView(mortView)
        
        // UIView
        let calculateView = UIView(frame: CGRectMake(25, 325, scrollView.bounds.size.width - 50, 50))
        let calcGradientLayer = CAGradientLayer()
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        scrollView.addSubview(calculateView)
        
        let calculateArrow = UILabel (frame: CGRectMake(calculateView.bounds.size.width - 50, 0, 40, 50))
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
        let btnView = UIImageView(frame: CGRectMake(25, 375, calculateView.bounds.size.width - 50, 15))
        btnView.image = btnImg
        scrollView.addSubview(btnView)
        
        // UILabel
        let estPaymentLabel = UILabel(frame: CGRectMake(25, 375, calcView.bounds.size.width - 50, 40))
        estPaymentLabel.text = "YOUR ESTIMATED PAYMENT IS:"
        estPaymentLabel.font = UIFont(name: "forza-light", size: 14)
        estPaymentLabel.textAlignment = NSTextAlignment.Left
        scrollView.addSubview(estPaymentLabel)
        
        // UIView
        let paymentView = UIView(frame: CGRectMake(25, 410, calcView.bounds.size.width - 50, 50))
        paymentView.backgroundColor = model.lightGreenColor
        scrollView.addSubview(paymentView)
        
        // UILabel
        paymentLabel.frame = (frame: CGRectMake(0, 0, paymentView.bounds.size.width, 50))
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedPaymentDefault)
        paymentLabel.font = UIFont(name: "forza-light", size: 24)
        paymentLabel.textColor = UIColor.whiteColor()
        paymentLabel.textAlignment = NSTextAlignment.Center
        paymentView.addSubview(paymentLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        mortView.addGestureRecognizer(tapGesture)
        
        scrollView.contentSize = CGSize(width: calcView.bounds.size.width, height: 575)
    }
    
    func buildRefiCalcView() {
        
        calcWindowView.frame = (frame: CGRectMake(10, 0, calcView.bounds.size.width - 20, 387))
        let fontSize = 14
        
        let refiCalcView = UIView(frame: CGRectMake(0, 0, calcWindowView.bounds.size.width, calcWindowView.bounds.size.height))
        refiCalcView.backgroundColor = UIColor.clearColor()
        refiCalcView.hidden = false
        calcWindowView.addSubview(refiCalcView)
        
        let shadowImg = UIImage(named: "long_shadow") as UIImage?
        // UIImageView
        let shadowView = UIImageView(frame: CGRectMake(0, 387, refiCalcView.bounds.size.width, 15))
        shadowView.image = shadowImg
        refiCalcView.addSubview(shadowView)
        
        /********************************************************* Current Loan Amount ********************************************************************/
         // UILabel
        let currentLoanAmountLabel = UILabel(frame: CGRectMake(10, 25, (refiCalcView.bounds.size.width / 2) - 25, 40))
        currentLoanAmountLabel.text = "CURRENT\nLOAN AMOUNT"
        currentLoanAmountLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        currentLoanAmountLabel.textAlignment = NSTextAlignment.Right
        currentLoanAmountLabel.textColor = UIColor.darkTextColor()
        currentLoanAmountLabel.numberOfLines = 2
        refiCalcView.addSubview(currentLoanAmountLabel)
        
        // UILabel
        let equalOneLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 25, 20, 40))
        equalOneLabel.text = " = "
        equalOneLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalOneLabel.textAlignment = NSTextAlignment.Right
        equalOneLabel.textColor = UIColor.darkTextColor()
        refiCalcView.addSubview(equalOneLabel)
        
        // UITextField
        let loanPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        loanAmountTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 25,(refiCalcView.bounds.size.width / 2) - 20, 40));
        loanAmountTxtField.layer.borderColor = model.lightGrayColor.CGColor
        loanAmountTxtField.layer.borderWidth = 1.0
        loanAmountTxtField.layer.cornerRadius = 2.0
        loanAmountTxtField.leftView = loanPaddingView
        loanAmountTxtField.leftViewMode = UITextFieldViewMode.Always
        loanAmountTxtField.placeholder = "$250,000"
        loanAmountTxtField.backgroundColor = UIColor.clearColor()
        loanAmountTxtField.delegate = self
        loanAmountTxtField.returnKeyType = .Done
        loanAmountTxtField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(loanAmountTxtField)
        
        /********************************************************* Current Mortgage Term ********************************************************************/
         // UILabel
        let mTermLabel = UILabel(frame: CGRectMake(10, 75, (refiCalcView.bounds.size.width / 2) - 25, 40))
        mTermLabel.text = "CURRENT\nMORTGAGE TERM"
        mTermLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        mTermLabel.textAlignment = NSTextAlignment.Right
        mTermLabel.textColor = UIColor.darkTextColor()
        mTermLabel.numberOfLines = 2
        refiCalcView.addSubview(mTermLabel)
        
        // UILabel
        let equalTwoLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 75, 20, 40))
        equalTwoLabel.text = " = "
        equalTwoLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalTwoLabel.textAlignment = NSTextAlignment.Right
        equalTwoLabel.numberOfLines = 2
        refiCalcView.addSubview(equalTwoLabel)
        
        // UITextField
        let mortgagePaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        mortgageTextField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 75,(refiCalcView.bounds.size.width / 2) - 20, 40));
        mortgageTextField.layer.borderColor = model.lightGrayColor.CGColor
        mortgageTextField.layer.borderWidth = 1.0
        mortgageTextField.layer.cornerRadius = 2.0
        mortgageTextField.leftView = mortgagePaddingView
        mortgageTextField.leftViewMode = UITextFieldViewMode.Always
        mortgageTextField.placeholder = "30 YEARS"
        mortgageTextField.backgroundColor = UIColor.clearColor()
        mortgageTextField.delegate = self
        mortgageTextField.returnKeyType = .Done
        mortgageTextField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(mortgageTextField)
        
        /********************************************************* Current Interest Rate ********************************************************************/
         // UILabel
        let interestRateLabel = UILabel(frame: CGRectMake(10, 125, (refiCalcView.bounds.size.width / 2) - 25, 40))
        interestRateLabel.text = "CURRENT\nINTEREST RATE"
        interestRateLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        interestRateLabel.textAlignment = NSTextAlignment.Right
        interestRateLabel.textColor = UIColor.darkTextColor()
        interestRateLabel.numberOfLines = 2
        refiCalcView.addSubview(interestRateLabel)
        
        // UILabel
        let equalThreeLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 125, 20, 40))
        equalThreeLabel.text = " = "
        equalThreeLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalThreeLabel.textAlignment = NSTextAlignment.Right
        equalThreeLabel.numberOfLines = 2
        refiCalcView.addSubview(equalThreeLabel)
        
        // UITextField
        let interestPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        interestTextField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 125,(refiCalcView.bounds.size.width / 2) - 20, 40));
        interestTextField.layer.borderColor = model.lightGrayColor.CGColor
        interestTextField.layer.borderWidth = 1.0
        interestTextField.layer.cornerRadius = 2.0
        interestTextField.leftView = interestPaddingView
        interestTextField.leftViewMode = UITextFieldViewMode.Always
        interestTextField.placeholder = "4.5%"
        interestTextField.backgroundColor = UIColor.clearColor()
        interestTextField.delegate = self
        interestTextField.returnKeyType = .Done
        interestTextField.keyboardType = UIKeyboardType.DecimalPad
        refiCalcView.addSubview(interestTextField)

        
        /********************************************************* Current Origination Year ********************************************************************/
         // UILabel
        let currentOriginationYearLabel = UILabel(frame: CGRectMake(10, 175, (refiCalcView.bounds.size.width / 2) - 25, 40))
        currentOriginationYearLabel.text = "ORIGINATING\nLOAN YEAR"
        currentOriginationYearLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        currentOriginationYearLabel.textAlignment = NSTextAlignment.Right
        currentOriginationYearLabel.textColor = UIColor.darkTextColor()
        currentOriginationYearLabel.numberOfLines = 2
        refiCalcView.addSubview(currentOriginationYearLabel)
        
        // UILabel
        let equalFourLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 175, 20, 40))
        equalFourLabel.text = " = "
        equalFourLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalFourLabel.textAlignment = NSTextAlignment.Right
        equalFourLabel.numberOfLines = 2
        refiCalcView.addSubview(equalFourLabel)
        
        // UITextField
        let yearPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        currentYearTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 175,(refiCalcView.bounds.size.width / 2) - 20, 40));
        currentYearTxtField.layer.borderColor = model.lightGrayColor.CGColor
        currentYearTxtField.layer.borderWidth = 1.0
        currentYearTxtField.layer.cornerRadius = 2.0
        currentYearTxtField.leftView = yearPaddingView
        currentYearTxtField.leftViewMode = UITextFieldViewMode.Always
        currentYearTxtField.placeholder = "2010"
        currentYearTxtField.backgroundColor = UIColor.clearColor()
        currentYearTxtField.delegate = self
        currentYearTxtField.returnKeyType = .Done
        currentYearTxtField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(currentYearTxtField)

        /********************************************************* Refinance Fees ********************************************************************/
         // UILabel
        let taxesLabel = UILabel(frame: CGRectMake(10, 225, (refiCalcView.bounds.size.width / 2) - 25, 40))
        taxesLabel.text = "PROPERTY TAXES"
        taxesLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        taxesLabel.textAlignment = NSTextAlignment.Right
        taxesLabel.textColor = UIColor.darkTextColor()
        taxesLabel.numberOfLines = 2
        refiCalcView.addSubview(taxesLabel)
        
        // UILabel
        let equalSixLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 225, 20, 40))
        equalSixLabel.text = " = "
        equalSixLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalSixLabel.textAlignment = NSTextAlignment.Right
        equalSixLabel.numberOfLines = 2
        refiCalcView.addSubview(equalSixLabel)
        
        // UITextField
        let feePaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        taxesTxtField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 225,(refiCalcView.bounds.size.width / 2) - 20, 40));
        taxesTxtField.layer.borderColor = model.lightGrayColor.CGColor
        taxesTxtField.layer.borderWidth = 1.0
        taxesTxtField.layer.cornerRadius = 2.0
        taxesTxtField.leftView = feePaddingView
        taxesTxtField.leftViewMode = UITextFieldViewMode.Always
        taxesTxtField.placeholder = "3.75%"
        taxesTxtField.backgroundColor = UIColor.clearColor()
        taxesTxtField.delegate = self
        taxesTxtField.returnKeyType = .Done
        taxesTxtField.keyboardType = UIKeyboardType.DecimalPad
        refiCalcView.addSubview(taxesTxtField)

        let refiDividerView = UIView(frame: CGRectMake(10, 275, calcWindowView.bounds.size.width - 20, 2))
        refiDividerView.backgroundColor = model.lightGrayColor
        refiDividerView.hidden = false
        calcWindowView.addSubview(refiDividerView)
        
        /********************************************************* New Mortgage Term ********************************************************************/
         // UILabel
        let newTermLabel = UILabel(frame: CGRectMake(10, 287, (refiCalcView.bounds.size.width / 2) - 25, 40))
        newTermLabel.text = "NEW MORTGAGE TERM"
        newTermLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        newTermLabel.textAlignment = NSTextAlignment.Right
        newTermLabel.textColor = UIColor.darkTextColor()
        newTermLabel.numberOfLines = 2
        refiCalcView.addSubview(newTermLabel)
        
        // UILabel
        let equalSevenLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 287, 20, 40))
        equalSevenLabel.text = " = "
        equalSevenLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalSevenLabel.textAlignment = NSTextAlignment.Right
        equalSevenLabel.numberOfLines = 2
        refiCalcView.addSubview(equalSevenLabel)
        
        // UITextField
        let newMortgagePaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        newMortgageTextField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 287,(refiCalcView.bounds.size.width / 2) - 20, 40));
        newMortgageTextField.layer.borderColor = model.lightGrayColor.CGColor
        newMortgageTextField.layer.borderWidth = 1.0
        newMortgageTextField.layer.cornerRadius = 2.0
        newMortgageTextField.leftView = newMortgagePaddingView
        newMortgageTextField.leftViewMode = UITextFieldViewMode.Always
        newMortgageTextField.placeholder = "30 YEARS"
        newMortgageTextField.backgroundColor = UIColor.clearColor()
        newMortgageTextField.delegate = self
        newMortgageTextField.returnKeyType = .Done
        newMortgageTextField.keyboardType = UIKeyboardType.NumberPad
        refiCalcView.addSubview(newMortgageTextField)
        
        /********************************************************* Current Interest Rate ********************************************************************/
         // UILabel
        let newInterestRateLabel = UILabel(frame: CGRectMake(10, 337, (refiCalcView.bounds.size.width / 2) - 25, 40))
        newInterestRateLabel.text = "NEW INTEREST RATE"
        newInterestRateLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        newInterestRateLabel.textAlignment = NSTextAlignment.Right
        newInterestRateLabel.textColor = UIColor.darkTextColor()
        newInterestRateLabel.numberOfLines = 2
        refiCalcView.addSubview(newInterestRateLabel)
        
        // UILabel
        let equalEightLabel = UILabel(frame: CGRectMake((refiCalcView.bounds.size.width / 2) - 20, 337, 20, 40))
        equalEightLabel.text = " = "
        equalEightLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        equalEightLabel.textAlignment = NSTextAlignment.Right
        equalEightLabel.numberOfLines = 2
        refiCalcView.addSubview(equalEightLabel)
        
        // UITextField
        let newInterestPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        newInterestTextField.frame = (frame: CGRectMake((refiCalcView.bounds.size.width / 2) + 10, 337,(refiCalcView.bounds.size.width / 2) - 20, 40));
        newInterestTextField.layer.borderColor = model.lightGrayColor.CGColor
        newInterestTextField.layer.borderWidth = 1.0
        newInterestTextField.layer.cornerRadius = 2.0
        newInterestTextField.leftView = newInterestPaddingView
        newInterestTextField.leftViewMode = UITextFieldViewMode.Always
        newInterestTextField.placeholder = "3.5 %"
        newInterestTextField.backgroundColor = UIColor.clearColor()
        newInterestTextField.delegate = self
        newInterestTextField.returnKeyType = .Done
        newInterestTextField.keyboardType = UIKeyboardType.DecimalPad
        refiCalcView.addSubview(newInterestTextField)
        
        // UIView
        let calculateView = UIView(frame: CGRectMake(25, 412, scrollView.bounds.size.width - 50, 50))
        let calcGradientLayer = CAGradientLayer()
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        scrollView.addSubview(calculateView)
        
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
        let btnView = UIImageView(frame: CGRectMake(15, 462, calculateView.bounds.size.width, 15))
        btnView.image = btnImg
        refiCalcView.addSubview(btnView)
        
        // UILabel
        let estPaymentLabel = UILabel(frame: CGRectMake(25, 477, calcView.bounds.size.width - 50, 40))
        estPaymentLabel.text = "UNDER ORIGINAL TERMS YOU PAY:"
        estPaymentLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        estPaymentLabel.textAlignment = NSTextAlignment.Left
        scrollView.addSubview(estPaymentLabel)
        
        // UIView
        let paymentView = UIView(frame: CGRectMake(25, 512, calcView.bounds.size.width - 50, 50))
        paymentView.backgroundColor = model.lightOrangeColor
        scrollView.addSubview(paymentView)
        
        // UILabel
        paymentLabel.frame = (frame: CGRectMake(0, 0, paymentView.bounds.size.width, 50))
        paymentLabel.text = String(format:"$%.2f / MONTH", estimatedOriginalPaymentDefault)
        paymentLabel.font = UIFont(name: "forza-light", size: 24)
        paymentLabel.textColor = UIColor.whiteColor()
        paymentLabel.textAlignment = NSTextAlignment.Center
        paymentView.addSubview(paymentLabel)
        
        // UILabel
        let estRefiPaymentLabel = UILabel(frame: CGRectMake(25, 562, calcView.bounds.size.width - 50, 40))
        estRefiPaymentLabel.text = "AFTER REFINANCING YOU PAY:"
        estRefiPaymentLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        estRefiPaymentLabel.textAlignment = NSTextAlignment.Left
        scrollView.addSubview(estRefiPaymentLabel)
        
        // UIView
        let refiPaymentView = UIView(frame: CGRectMake(25, 597, calcView.bounds.size.width - 50, 50))
        refiPaymentView.backgroundColor = model.lightGreenColor
        scrollView.addSubview(refiPaymentView)
        
        // UILabel
        refiPaymentLabel.frame = (frame: CGRectMake(0, 0, paymentView.bounds.size.width, 50))
        refiPaymentLabel.text = String(format:"$%.2f / MONTH", refiPaymentDefault)
        refiPaymentLabel.font = UIFont(name: "forza-light", size: 24)
        refiPaymentLabel.textColor = UIColor.whiteColor()
        refiPaymentLabel.textAlignment = NSTextAlignment.Center
        refiPaymentView.addSubview(refiPaymentLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        refiCalcView.addGestureRecognizer(tapGesture)
        
        scrollView.contentSize = CGSize(width: calcView.bounds.size.width, height: 775)
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
        mortgageTextField.resignFirstResponder()
        interestTextField.resignFirstResponder()
        currentYearTxtField.resignFirstResponder()
        taxesTxtField.resignFirstResponder()
        newMortgageTextField.resignFirstResponder()
        newInterestTextField.resignFirstResponder()
    }
    
    // MARK:
    // MARK: Action Methods
    func calculateMortgagePaymentButtonPress(sender: UIButton) {
        
        var saleAmount = 250000.0
        if mortgageView.loanAmountTxtField.text?.isEmpty != true {
            saleAmount = Double(mortgageView.loanAmountTxtField.text!)!
        }
        
        var downPayment = 5000.0
        if mortgageView.downPaymentTxtField.text?.isEmpty != true {
            downPayment = Double(mortgageView.downPaymentTxtField.text!)!
        }
        
        let loan = saleAmount - downPayment
        
        var mortgage = 30.0
        if mortgageView.mortgageTxtField.text?.isEmpty != true {
            mortgage = Double(mortgageView.mortgageTxtField.text!)!
        }
        
        var interest = 3.5
        if mortgageView.interestTxtField.text?.isEmpty != true {
            interest = Double(mortgageView.interestTxtField.text!)!
        }
        
        var taxes = 3.75
        if mortgageView.taxesTxtField.text?.isEmpty != true {
            taxes = Double(mortgageView.taxesTxtField.text!)!
        }
        
        paymentLabel.text = String(format:"$%.2f / MONTH", model.calculateMortgagePayment(loan, interest: interest, mortgage: mortgage, taxes: taxes))
    }
    
    func calculateRefinanceButtonPress(sender: UIButton) {
        
        var loan = 250000.0
        if loanAmountTxtField.text?.isEmpty != true {
            loan = Double(loanAmountTxtField.text!)!
        }
        
        var mortgage = 30.0
        if mortgageTextField.text?.isEmpty != true {
            mortgage = Double(mortgageTextField.text!)!
        }

        var interest = 4.5
        if interestTextField.text?.isEmpty != true {
            interest = Double(interestTextField.text!)!
        }
        
        var year = 2010.0
        if currentYearTxtField.text?.isEmpty != true {
            year = Double(currentYearTxtField.text!)!
        }
        
        var taxes = 3.75
        if taxesTxtField.text?.isEmpty != true {
            taxes = Double(taxesTxtField.text!)!
        }
        
        paymentLabel.text = String(format:"$%.2f / MONTH", model.calculateMortgagePayment(loan, interest: interest, mortgage: mortgage, taxes: taxes))
        
        let newloanamount = loan - model.calculateBalancePaid(loan, intRate: interest, mortgage: mortgage, year: year)
        print(newloanamount)
        
        var newInterest = 3.5
        if newInterestTextField.text?.isEmpty != true {
            newInterest = Double(newInterestTextField.text!)!
        }

        var newMortgage = 30.0
        if newMortgageTextField.text?.isEmpty != true {
            newMortgage = Double(newMortgageTextField.text!)!
        }

        refiPaymentLabel.text = String(format:"$%.2f / MONTH", model.calculateMortgagePayment(newloanamount, interest: newInterest, mortgage: newMortgage, taxes: taxes))
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
