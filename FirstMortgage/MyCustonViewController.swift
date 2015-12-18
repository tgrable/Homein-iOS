//
//  MyCustonViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/11/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import ParseUI

class MyCustonViewController: PFLogInViewController {

    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = model.lightGrayColor
        
        print(self.logInView!.bounds.size.width)
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        self.logInView?.addSubview(logoView)
        
        self.logInView!.logo = nil;
        
        let bannerView = UIView(frame: CGRectMake(0, 85, model.deviceWidth(), 50))
        let bannerGradientLayer = CAGradientLayer()
        bannerGradientLayer.frame = bannerView.bounds
        bannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        bannerView.layer.insertSublayer(bannerGradientLayer, atIndex: 0)
        bannerView.layer.addSublayer(bannerGradientLayer)
        bannerView.hidden = false
        self.logInView?.addSubview(bannerView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, bannerView.bounds.size.width, 50))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "LOG INTO YOUR ACCOUNT"
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountLabel.numberOfLines = 1
        bannerView.addSubview(createAccountLabel)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        
        self.logInView!.usernameField!.attributedPlaceholder = NSAttributedString(string: "USER NAME", attributes: attributes)
        self.logInView!.passwordField!.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: attributes)
        self.logInView!.logInButton?.setTitle("LOG IN", forState: .Normal)
        self.logInView!.logInButton?.titleLabel?.font = UIFont(name: "forza-light", size: 24)
        
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
