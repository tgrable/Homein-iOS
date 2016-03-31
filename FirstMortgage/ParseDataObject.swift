//
//  ParseDataObject.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 2/12/16.
//  Copyright © 2016 Trekk Design. All rights reserved.
//

import UIKit
import Parse

@objc protocol ParseDataDelegate: class {

    optional func loginSucceeded()
    optional func loginFailed(errorMessage: String)
    
    optional func signupSucceeded()
    optional func signupFailed(errorMessage: String)
    
    optional func querySecceededWithObjects(objects: [PFObject])
    optional func queryFailed(errorMessage: String)
    
    optional func saveSucceeded()
    optional func saveFailed(errorMessage: String)
}

class ParseDataObject: NSObject {
    
    weak var delegate: ParseDataDelegate?
    
    // MARK:
    // MARK: Parse Login/Signup Methods
    func loginPFUser(userName: String, password: String) {
        PFUser.logInWithUsernameInBackground(userName, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.delegate?.loginSucceeded!()
            }
            else {
                let errorString = error!.userInfo["error"] as? String
                self.delegate?.loginFailed!(errorString!)
            }
        }
    }
    
    func signUpPFUser(user: PFUser) {
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                self.delegate?.signupSucceeded!()
            }
            else {
                let errorString = error!.userInfo["error"] as? String
                self.delegate?.signupFailed!(errorString!)
            }
        }
    }
    
    // MARK:
    // MARK: Parse Fetch Methods
    func getAllHomesForUser(sortOrder: String, sortDirection: Bool, fromLocalDataStore: Bool) {
        let sortAscending = sortDirection
        let query = PFQuery(className:"Home")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        if sortAscending {
            query.orderByAscending(sortOrder)
        }
        else {
            query.orderByDescending(sortOrder)
        }
        if fromLocalDataStore == true {
            query.fromLocalDatastore()
        }
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                PFObject.pinAllInBackground(objects)
                self.delegate?.querySecceededWithObjects!(objects!)
                
            } else {
                let errorString = error!.userInfo["error"] as? String
                self.delegate?.queryFailed!(errorString!)
            }
        }
    }
    
    // MARK:
    // MARK: Parse Save Methods
    func saveHomeWithBlock(home: PFObject) {
        home.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                home.pinInBackground()
                self.delegate?.saveSucceeded!()
            }
            else {
                let errorString = error!.userInfo["error"] as? String
                self.delegate?.saveFailed!(errorString!)
            }
        }
    }
    
    func saveHomeEventually(home: PFObject) {
        home.saveEventually()
        delegate?.saveSucceeded!()
    }
    
    func saveUser(user: PFUser, officerEmail: String) {
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                if (officerEmail.characters.count > 0) {
                    //TODO: COMMENT THIS OUT BEFORE WORKING - THIS WILL SPAM LOAN OFFICERS OTHERWISE 
//                    self.emailLoanOfficer(user["name"] as! String, email: user["email"] as! String, loanOfficer: officerEmail)
                }
                self.delegate?.saveSucceeded!()
            }
            else {
                let errorString = error!.userInfo["error"] as? String
                self.delegate?.saveFailed!(errorString!)
            }
        }
    }
    
    func saveUserEventually(user: PFUser, officerEmail: String) {
        user.saveEventually()
        delegate?.saveSucceeded!()
    }
    
    func emailLoanOfficer(name: String, email: String, loanOfficer: String) {

        PFCloud.callFunctionInBackground("loanOfficer", withParameters: ["name" : name, "email": email, "officer" : loanOfficer]) { (result: AnyObject?, error: NSError?) in
            print("----- Email LO -----")
        }
    }
    
    // MARK:
    // MARK: Utility Methods
    func scaleImagesForParse(img: UIImage) -> UIImage {
        var height = 0.0
        var width = 0.0
        
        if img.size.height > img.size.width {
            height = 736 / Double(img.size.height)
            width = 414 / Double(img.size.width)
        }
        else {
            height = 414 / Double(img.size.height)
            width = 736 / Double(img.size.width)
        }
        
        let size = CGSizeApplyAffineTransform(img.size, CGAffineTransformMakeScale(CGFloat(width), CGFloat(height)))
        let hasAlpha = false
        let scale: CGFloat = 1.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        img.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
