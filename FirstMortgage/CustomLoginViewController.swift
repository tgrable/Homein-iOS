//
//  CustomLoginViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/22/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class CustomLoginViewController: UIViewController, UITextFieldDelegate {
    let model = Model()
    let username = UITextField()
    let password = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = model.lightGrayColor
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        self.view.addSubview(logoView)
        
        let dismissButton = UIButton (frame: CGRectMake(0, 25, 50, 50))
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: "dismissViewController", forControlEvents: .TouchUpInside)
        dismissButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "forza-light", size: 42)
        self.view.addSubview(dismissButton)
       
        let bannerView = UIView(frame: CGRectMake(0, 85, model.deviceWidth(), 50))
        let bannerGradientLayer = CAGradientLayer()
        bannerGradientLayer.frame = bannerView.bounds
        bannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        bannerView.layer.insertSublayer(bannerGradientLayer, atIndex: 0)
        bannerView.layer.addSublayer(bannerGradientLayer)
        bannerView.hidden = false
        self.view.addSubview(bannerView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, bannerView.bounds.size.width, 50))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "LOG INTO YOUR ACCOUNT"
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountLabel.numberOfLines = 1
        bannerView.addSubview(createAccountLabel)

        // UITextField
        let unPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        username.frame = (frame: CGRectMake(0, 155, self.view.bounds.size.width, 50));
        username.layer.borderColor = model.lightGrayColor.CGColor
        username.layer.borderWidth = 1.0
        username.leftView = unPaddingView
        username.leftViewMode = UITextFieldViewMode.Always
        username.placeholder = "USER NAME"
        username.backgroundColor = UIColor.whiteColor()
        username.delegate = self
        username.returnKeyType = .Done
        username.keyboardType = UIKeyboardType.Default
        username.font = UIFont(name: "forza-username", size: 45)
        self.view.addSubview(username)
        
        // UITextField
        let pwPaddingView = UIView(frame: CGRectMake(0, 0, 15, 50))
        password.frame = (frame: CGRectMake(0, 205, self.view.bounds.size.width, 50));
        password.layer.borderColor = model.lightGrayColor.CGColor
        password.layer.borderWidth = 1.0
        password.leftView = pwPaddingView
        password.leftViewMode = UITextFieldViewMode.Always
        password.placeholder = "PASSWORD"
        password.backgroundColor = UIColor.whiteColor()
        password.delegate = self
        password.returnKeyType = .Done
        password.keyboardType = UIKeyboardType.Default
        password.secureTextEntry = true
        password.font = UIFont(name: "forza-username", size: 45)
        self.view.addSubview(password)
        
        let loginButton = UIButton (frame: CGRectMake(0, 275, 320, 50))
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: "loginUser:", forControlEvents: .TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = model.darkBlueColor
        loginButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        self.view.addSubview(loginButton)
        
        let getStartedButton = UIButton (frame: CGRectMake(0, 350, 320, 50))
        getStartedButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        getStartedButton.addTarget(self, action: "createAccountForUser:", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.backgroundColor = model.lightRedColor
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        self.view.addSubview(getStartedButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginUser(sender: UIButton) {
        if (username.text!.isEmpty != true && password.text!.isEmpty != true) {
            PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    self.performSegueWithIdentifier("homeViewController", sender: self)
                } else {
                    // The login failed. Check error to see why.
                }
            }
        }
    }
    
    func createAccountForUser(sender: UIButton) {
        
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
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
