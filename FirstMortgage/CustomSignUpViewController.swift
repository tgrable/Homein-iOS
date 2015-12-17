//
//  CustomSignUpViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/16/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import ParseUI

class CustomSignUpViewController: PFSignUpViewController, PFSignUpViewControllerDelegate {

    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = model.lightGrayColor
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        self.signUpView?.addSubview(logoView)
        
        let bannerView = UIView(frame: CGRectMake(0, 75, 320, 50))
        let bannerGradientLayer = CAGradientLayer()
        bannerGradientLayer.frame = bannerView.bounds
        bannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        bannerView.layer.insertSublayer(bannerGradientLayer, atIndex: 0)
        bannerView.layer.addSublayer(bannerGradientLayer)
        bannerView.hidden = false
        self.signUpView?.addSubview(bannerView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, bannerView.bounds.size.width, 50))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "CREATE AN ACCOUNT"
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountLabel.numberOfLines = 1
        bannerView.addSubview(createAccountLabel)
        
        self.signUpView!.logo = nil;
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        self.signUpView!.usernameField!.attributedPlaceholder = NSAttributedString(string: "USER NAME", attributes:attributes)
        self.signUpView!.usernameField?.font = UIFont(name: "forza-light", size: 18)
        
        self.signUpView!.passwordField?.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: attributes)
        self.signUpView!.passwordField?.font = UIFont(name: "forza-light", size: 18)
        
        self.signUpView!.emailField!.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes:attributes)
        self.signUpView!.emailField?.font = UIFont(name: "forza-light", size: 18)
        
        self.signUpView!.additionalField?.attributedPlaceholder = NSAttributedString(string: "NAME", attributes: attributes)
        self.signUpView!.additionalField?.font = UIFont(name: "forza-light", size: 18)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
