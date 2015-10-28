//
//  CreateAccountViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController, UIScrollViewDelegate {

    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    // Login View
    let registerView = UIView() as UIView
    let userNameRegister = UITextField() as UITextField
    let passwordRegister = UITextField() as UITextField
    let emailRegister = UITextField() as UITextField
    
    var imageView = UIImageView() as UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buildCreateAccountView()
        buildRegisterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildCreateAccountView() {
        registerView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height))
        registerView.backgroundColor = lightGrayColor
        registerView.hidden = false
        self.view.addSubview(registerView)
        
        let fmcLogo = UIImage(named: "fmc_logo") as UIImage?
        // UIImageView
        imageView.frame = ( frame: CGRectMake(40, 35, self.view.bounds.size.width - 80, 40) )
        imageView.image = fmcLogo
        registerView.addSubview(imageView)
        
        let createAccountButton = UIButton (frame: CGRectMake(15, 100, self.view.bounds.size.width - 30, 40))
        createAccountButton.setTitle("Create Account", forState: .Normal)
        createAccountButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        createAccountButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        createAccountButton.backgroundColor = UIColor.clearColor()
        createAccountButton.tag = 0
        registerView.addSubview(createAccountButton)
        
        let descLabel = UILabel (frame: CGRectMake(15, 150, self.view.bounds.size.width - 30, 40))
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.text = "Bacon ipsum dolor amet ribeye ball tip andouille, tail chuck t-bone turducken. Hamburger capicola prosciutto tenderloin."
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        registerView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "blue_check") as UIImage?
        let optionOneButton = UIButton (frame: CGRectMake(30, descLabel.bounds.size.height + 170, 40, 40))
        optionOneButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionOneButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionOneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionOneButton.tag = 0
        registerView.addSubview(optionOneButton)
        
        let optionOneLabel = UILabel (frame: CGRectMake(80, descLabel.bounds.size.height + 170, self.view.bounds.size.width - 100, 40))
        optionOneLabel.textAlignment = NSTextAlignment.Left
        optionOneLabel.text = "Sausage drumstick salami"
        optionOneLabel.numberOfLines = 0
        optionOneLabel.sizeToFit()
        registerView.addSubview(optionOneLabel)

        let optionTwoButton = UIButton (frame: CGRectMake(30, descLabel.bounds.size.height + 220, 40, 40))
        optionTwoButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionTwoButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionTwoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionTwoButton.tag = 0
        registerView.addSubview(optionTwoButton)
        
        let optionTwoLabel = UILabel (frame: CGRectMake(80, descLabel.bounds.size.height + 220, self.view.bounds.size.width - 100, 40))
        optionTwoLabel.textAlignment = NSTextAlignment.Left
        optionTwoLabel.text = "t-bone porchetta fatback jowl"
        optionTwoLabel.numberOfLines = 0
        optionTwoLabel.sizeToFit()
        registerView.addSubview(optionTwoLabel)
        
        let optionThreeButton = UIButton (frame: CGRectMake(30, descLabel.bounds.size.height + 270, 40, 40))
        optionThreeButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionThreeButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionThreeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionThreeButton.tag = 0
        registerView.addSubview(optionThreeButton)
        
        let optionThreeLabel = UILabel (frame: CGRectMake(80, descLabel.bounds.size.height + 270, self.view.bounds.size.width - 100, 40))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.text = "Prosciutto andouille biltong"
        optionThreeLabel.numberOfLines = 0
        optionThreeLabel.sizeToFit()
        registerView.addSubview(optionThreeLabel)
        
        let getStartedButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 320, self.view.bounds.size.width - 30, 40))
        getStartedButton.setTitle("Get Started", forState: .Normal)
        getStartedButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerView.addSubview(getStartedButton)
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 370, self.view.bounds.size.width - 30, 40))
        continueWithoutButton.setTitle("Continue Without", forState: .Normal)
        continueWithoutButton.addTarget(self, action: "continueWithoutLogin:", forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerView.addSubview(continueWithoutButton)
    }
    
    func buildRegisterView() {
        let backButton = UIButton (frame: CGRectMake(self.view.bounds.size.width + 15, 50, self.view.bounds.size.width - 30, 40))
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        backButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        backButton.titleLabel?.textAlignment = .Left
        backButton.tag = 1
        registerView.addSubview(backButton)
        
        userNameRegister.frame = (frame: CGRectMake(self.view.bounds.size.width + 15, 100, self.view.bounds.size.width - 30, 40))
        userNameRegister.placeholder = "User Name"
        userNameRegister.borderStyle = UITextBorderStyle.RoundedRect
        userNameRegister.layer.borderColor = UIColor.lightGrayColor().CGColor
        userNameRegister.tag = 1
        userNameRegister.autocapitalizationType = UITextAutocapitalizationType.None
        userNameRegister.autocorrectionType = UITextAutocorrectionType.No;
        userNameRegister.spellCheckingType = UITextSpellCheckingType.No;
        userNameRegister.keyboardType = UIKeyboardType.Default;
        registerView.addSubview(userNameRegister)
        
        passwordRegister.frame = (frame: CGRectMake(self.view.bounds.size.width + 15, 150, self.view.bounds.size.width - 30, 40))
        passwordRegister.placeholder = "Password"
        passwordRegister.borderStyle = UITextBorderStyle.RoundedRect
        passwordRegister.layer.borderColor = UIColor.lightGrayColor().CGColor
        passwordRegister.tag = 1
        passwordRegister.secureTextEntry = true
        registerView.addSubview(passwordRegister)
        
        emailRegister.frame = (frame: CGRectMake(self.view.bounds.size.width + 15, 200, self.view.bounds.size.width - 30, 40))
        emailRegister.placeholder = "Email"
        emailRegister.borderStyle = UITextBorderStyle.RoundedRect
        emailRegister.layer.borderColor = UIColor.lightGrayColor().CGColor
        emailRegister.tag = 1
        emailRegister.autocapitalizationType = UITextAutocapitalizationType.None
        emailRegister.autocorrectionType = UITextAutocorrectionType.No;
        emailRegister.spellCheckingType = UITextSpellCheckingType.No;
        userNameRegister.keyboardType = UIKeyboardType.EmailAddress;
        registerView.addSubview(emailRegister)
        
        let submitButton = UIButton (frame: CGRectMake(self.view.bounds.size.width + 15, 250, self.view.bounds.size.width - 30, 40))
        submitButton.setTitle("Register", forState: .Normal)
        submitButton.addTarget(self, action: "registerUser", forControlEvents: .TouchUpInside)
        submitButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerView.addSubview(submitButton)
    }

    func showCreateAccount(sender: UIButton) {
        switch sender.tag {
            case 0:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(self.view.bounds.size.width * -1, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height) )
                    }, completion: { finished in
                })
            case 1:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height) )
                    }, completion: { finished in
                })
                registerView.frame = ( frame: CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height) )
            default:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height) )
                    }, completion: { finished in
                })
            
        }
    }
    
    func registerUser() {
        let user = PFUser()
        user.username = userNameRegister.text
        user.password = passwordRegister.text
        user.email = emailRegister.text
        user["searchableUserName"] = userNameRegister.text!.lowercaseString
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                _ = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                //NSNotificationCenter.defaultCenter().postNotificationName("loginRegisterWasSuccessful", object: nil)
                print("Hooray")
            }
        }
    }
    
    func optionChecked(sender: UIButton) {
        let checkMarkCheckedImage = UIImage(named: "blue_check") as UIImage?
        let checkMarkUncheckedImage = UIImage(named: "white_check") as UIImage?
        if (sender.tag == 0) {
            sender.tag = 1
            sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
        }
        else {
            sender.tag = 0
            sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
        }
    }

    func continueWithoutLogin(sender: UIButton) {
        performSegueWithIdentifier("userLoggedIn", sender: self)
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
