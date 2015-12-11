//
//  model.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/1/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    // MARK:
    // MARK: Properties
  
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    let lightBlueColor = UIColor(red: 83/255, green: 135/255, blue: 186/255, alpha: 1)
    let darkBlueColor = UIColor(red: 53/255, green: 103/255, blue: 160/255, alpha: 1)
    
    let lightOrangeColor = UIColor(red: 238/255, green: 155/255, blue: 78/255, alpha: 1)
    let darkOrangeColor = UIColor(red: 222/255, green: 123/255, blue: 37/255, alpha: 1)
    
    let lightGreenColor = UIColor(red: 184.0/255.0, green: 189.0/255.0, blue: 70.0/255.0, alpha: 1)
    let darkGreenColor = UIColor(red: 154.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1)
    
    let lightRedColor = UIColor(red: 204.0/255.0, green: 69.0/255.0, blue: 67.0/255.0, alpha: 1)
    let darkRedColor = UIColor(red: 174.0/255.0, green: 58.0/255.0, blue: 55.0/255.0, alpha: 1)
    
    // MARK:
    // MARK: Calculations
    func calculateMortgagePayment(loanAmount: Double, interest: Double, mortgage: Double, taxes: Double) -> Double {
        var estimatedPaymentDefault = 0.0

        let r = Double(interest) / 1200
        let n = Double(mortgage) * 12
        let rPower = pow(1 + r, n)
        
        let monthlyPayment = loanAmount * r * rPower / (rPower - 1)
        estimatedPaymentDefault = monthlyPayment + (((taxes / 100) * loanAmount) / 12)
        
        return estimatedPaymentDefault
    }
  
    func calculateBalancePaid(loanAmount: Double, intRate: Double, mortgage: Double, year: Double) -> Double {
        
        let currentMonthlyPayment = calculateMortgagePayment(loanAmount, interest: intRate, mortgage: mortgage, taxes: 0.0)
        let r = Double(intRate) / 100
        let monthsPaid = (getCurrentYear() - year) * 12
        let rPower = pow(1 + r / 12.0, monthsPaid)
        let balPaid = ((12 * currentMonthlyPayment / r - loanAmount) * (rPower - 1))
        
        print(balPaid)
        
        return balPaid
    }
    
    func getCurrentYear() -> Double {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
        return Double(defaultTimeZoneStr)!
    }
}
