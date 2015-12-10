//
//  MortgageCalculatorView.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/9/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit

class MortgageCalculatorView: UIView, UITextFieldDelegate {

    // MARK:
    // MARK: Properties
    let model = Model()
    
    // UIView
    let calcView = UIView() as UIView
    
    // UITextField
    let loanAmountTxtField = UITextField() as UITextField
    let mortgageTxtField = UITextField() as UITextField
    let interestTxtField = UITextField() as UITextField
    let downPaymentTxtField = UITextField() as UITextField
    let taxesTxtField = UITextField() as UITextField
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func buildMortgageCalcView(view: UIView) {
        
        calcView.frame = (frame: CGRectMake(10, 0, view.bounds.size.width - 20, 300))
        calcView.backgroundColor = UIColor.whiteColor()
        calcView.hidden = false
        view.addSubview(calcView)

        let fontSize = 14
        
        let mortgageCalcView = UIView(frame: CGRectMake(0, 0, calcView.bounds.size.width, calcView.bounds.size.height))
        mortgageCalcView.backgroundColor = UIColor.clearColor()
        mortgageCalcView.hidden = false
        calcView.addSubview(mortgageCalcView)
        
        /********************************************************* Loan Amount ********************************************************************/
         // UILabel
        let loanAmountLabel = UILabel(frame: CGRectMake(10, 25, (mortgageCalcView.bounds.size.width / 2) - 20, 40))
        loanAmountLabel.text = "SALE PRICE = "
        loanAmountLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        loanAmountLabel.textAlignment = NSTextAlignment.Right
        loanAmountLabel.textColor = UIColor.darkTextColor()
        mortgageCalcView.addSubview(loanAmountLabel)
        
        // UITextField
        let loanAmountPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        loanAmountTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 25,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
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
        mortgageCalcView.addSubview(loanAmountTxtField)
        
        /********************************************************* Mortgage Term ********************************************************************/
         // UILabel
        let mTermLabel = UILabel(frame: CGRectMake(10, 75, (mortgageCalcView.bounds.size.width / 2) - 20, 40))
        mTermLabel.text = "MORTGAGE TERM = "
        mTermLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        mTermLabel.textAlignment = NSTextAlignment.Right
        mTermLabel.textColor = UIColor.darkTextColor()
        mortgageCalcView.addSubview(mTermLabel)
        
        // UITextField
        let mTermAmountPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        mortgageTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 75,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
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
        mortgageCalcView.addSubview(mortgageTxtField)
        
        /********************************************************* Interest Rate ********************************************************************/
         // UILabel
        let interestRateLabel = UILabel(frame: CGRectMake(10, 125, (mortgageCalcView.bounds.size.width / 2) - 20, 40))
        interestRateLabel.text = "INTEREST RATE = "
        interestRateLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        interestRateLabel.textAlignment = NSTextAlignment.Right
        interestRateLabel.textColor = UIColor.darkTextColor()
        mortgageCalcView.addSubview(interestRateLabel)
        
        // UITextField
        let interestAmountPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        interestTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 125,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
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
        mortgageCalcView.addSubview(interestTxtField)
        
        /********************************************************* Down Payment ********************************************************************/
         // UILabel
        let downPaymentLabel = UILabel(frame: CGRectMake(10, 175, (mortgageCalcView.bounds.size.width / 2) - 20, 40))
        downPaymentLabel.text = "DOWNPAYMENT = "
        downPaymentLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        downPaymentLabel.textAlignment = NSTextAlignment.Right
        downPaymentLabel.textColor = UIColor.darkTextColor()
        mortgageCalcView.addSubview(downPaymentLabel)
        
        // UITextField
        let downPaymentPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        downPaymentTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 175,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
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
        mortgageCalcView.addSubview(downPaymentTxtField)
        
        /********************************************************* Property Taxes ********************************************************************/
         // UILabel
        let taxesLabel = UILabel(frame: CGRectMake(10, 225, (mortgageCalcView.bounds.size.width / 2) - 20, 40))
        taxesLabel.text = "PROPERTY TAXES = "
        taxesLabel.font = UIFont(name: "forza-light", size: CGFloat(fontSize))
        taxesLabel.textAlignment = NSTextAlignment.Right
        taxesLabel.textColor = UIColor.darkTextColor()
        mortgageCalcView.addSubview(taxesLabel)
        
        // UITextField
        let taxesPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        taxesTxtField.frame = (frame: CGRectMake((mortgageCalcView.bounds.size.width / 2) + 10, 225,(mortgageCalcView.bounds.size.width / 2) - 20, 40));
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
        mortgageCalcView.addSubview(taxesTxtField)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        mortgageCalcView.addGestureRecognizer(tapGesture)
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
    }    
}
