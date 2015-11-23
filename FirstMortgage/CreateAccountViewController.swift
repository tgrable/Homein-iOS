//
//  CreateAccountViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    // Login View
    let registerView = UIView()
    
    // UITextField
    let userNameRegister = UITextField()
    let firstlastNameRegister = UITextField()
    let passwordRegister = UITextField()
    let emailRegister = UITextField()
    
    // UITextView
    let addressRegister = UITextView()
    
    // Bool
    var optionOne = Bool()
    var optionTwo = Bool()
    var optionThree = Bool()
    
    // ShadowEffet
    var shadow = ShadowEffect()
    
    var imageView = UIImageView() as UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // UIImage
        let fmcLogo = UIImage(named: "fmc_logo") as UIImage?
        
        // UIImageView
        imageView.frame = ( frame: CGRectMake(40, 35, self.view.bounds.size.width - 80, 40) )
        imageView.image = fmcLogo
        self.view.addSubview(imageView)
        
        self.view.backgroundColor = lightGrayColor
        
        optionOne = true
        optionTwo = true
        optionThree = true
        
        buildCreateAccountView()
        buildRegisterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildCreateAccountView() {
        registerView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75))
        registerView.backgroundColor = lightGrayColor
        registerView.hidden = false
        self.view.addSubview(registerView)
        
        let createAccountButton = UIButton (frame: CGRectMake(15, 50, self.view.bounds.size.width - 30, 40))
        createAccountButton.setTitle("Create Account", forState: .Normal)
        createAccountButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        createAccountButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        createAccountButton.backgroundColor = UIColor.clearColor()
        createAccountButton.tag = 0
        registerView.addSubview(createAccountButton)
        
        let descLabel = UILabel (frame: CGRectMake(15, 100, self.view.bounds.size.width - 30, 40))
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.text = "Bacon ipsum dolor amet ribeye ball tip andouille, tail chuck t-bone turducken. Hamburger capicola prosciutto tenderloin."
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        registerView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "blue_check") as UIImage?
        let optionOneButton = UIButton (frame: CGRectMake(30, descLabel.bounds.size.height + 120, 40, 40))
        optionOneButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionOneButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionOneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionOneButton.tag = 1
        registerView.addSubview(optionOneButton)
        
        let optionOneLabel = UILabel (frame: CGRectMake(80, descLabel.bounds.size.height + 120, self.view.bounds.size.width - 100, 40))
        optionOneLabel.textAlignment = NSTextAlignment.Left
        optionOneLabel.text = "Sausage drumstick salami"
        optionOneLabel.numberOfLines = 0
        optionOneLabel.sizeToFit()
        registerView.addSubview(optionOneLabel)

        let optionTwoButton = UIButton (frame: CGRectMake(30, descLabel.bounds.size.height + 180, 40, 40))
        optionTwoButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionTwoButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionTwoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionTwoButton.tag = 2
        registerView.addSubview(optionTwoButton)
        
        let optionTwoLabel = UILabel (frame: CGRectMake(80, descLabel.bounds.size.height + 180, self.view.bounds.size.width - 100, 40))
        optionTwoLabel.textAlignment = NSTextAlignment.Left
        optionTwoLabel.text = "t-bone porchetta fatback jowl"
        optionTwoLabel.numberOfLines = 0
        optionTwoLabel.sizeToFit()
        registerView.addSubview(optionTwoLabel)
        
        let optionThreeButton = UIButton (frame: CGRectMake(30, descLabel.bounds.size.height + 230, 40, 40))
        optionThreeButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionThreeButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionThreeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionThreeButton.tag = 3
        registerView.addSubview(optionThreeButton)
        
        let optionThreeLabel = UILabel (frame: CGRectMake(80, descLabel.bounds.size.height + 230, self.view.bounds.size.width - 100, 40))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.text = "Prosciutto andouille biltong"
        optionThreeLabel.numberOfLines = 0
        optionThreeLabel.sizeToFit()
        registerView.addSubview(optionThreeLabel)
        
        let getStartedButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 290, self.view.bounds.size.width - 30, 40))
        getStartedButton.setTitle("Get Started", forState: .Normal)
        getStartedButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerView.addSubview(getStartedButton)
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 330, self.view.bounds.size.width - 30, 40))
        continueWithoutButton.setTitle("Continue Without", forState: .Normal)
        continueWithoutButton.addTarget(self, action: "continueWithoutLogin:", forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerView.addSubview(continueWithoutButton)
    }
    
    func buildRegisterView() {
        
        let bannerView = UIView(frame: CGRectMake(self.view.bounds.size.width, 15, registerView.bounds.size.width, 50))
        bannerView.backgroundColor = UIColor.orangeColor()
        bannerView.hidden = false
        registerView.addSubview(bannerView)
        
        let registerScrollView = UIScrollView(frame: CGRectMake(self.view.bounds.size.width + 15, 65, self.view.bounds.size.width - 30, registerView.bounds.size.height - 150))
        registerScrollView.backgroundColor = UIColor.whiteColor()
        registerView.addSubview(registerScrollView)
        
        // UIView
        let shadowView = UIView(frame: CGRectMake(self.view.bounds.size.width + 15, (registerView.bounds.size.height - 150) + 65, registerScrollView.bounds.size.width, 2))
        shadowView.backgroundColor = UIColor.clearColor()
        registerView.addSubview(shadowView)
        shadow.applyCurvedShadow(shadowView)

        userNameRegister.frame = (frame: CGRectMake(15, 15, registerScrollView.bounds.size.width - 30, 40))
        userNameRegister.placeholder = "Profile Name"
        userNameRegister.backgroundColor = lightGrayColor
        userNameRegister.tag = 1
        userNameRegister.autocapitalizationType = UITextAutocapitalizationType.None
        userNameRegister.autocorrectionType = UITextAutocorrectionType.No;
        userNameRegister.spellCheckingType = UITextSpellCheckingType.No;
        userNameRegister.keyboardType = UIKeyboardType.Default;
        userNameRegister.delegate = self
        userNameRegister.returnKeyType = .Done
        registerScrollView.addSubview(userNameRegister)
        
        firstlastNameRegister.frame = (frame: CGRectMake(15, 65, registerScrollView.bounds.size.width - 30, 40))
        firstlastNameRegister.placeholder = "Your Name"
        firstlastNameRegister.backgroundColor = lightGrayColor
        firstlastNameRegister.tag = 1
        firstlastNameRegister.autocapitalizationType = UITextAutocapitalizationType.Words
        firstlastNameRegister.autocorrectionType = UITextAutocorrectionType.No;
        firstlastNameRegister.spellCheckingType = UITextSpellCheckingType.No;
        firstlastNameRegister.keyboardType = UIKeyboardType.Default;
        firstlastNameRegister.delegate = self
        firstlastNameRegister.returnKeyType = .Done
        registerScrollView.addSubview(firstlastNameRegister)
        
        emailRegister.frame = (frame: CGRectMake(15, 115, registerScrollView.bounds.size.width - 30, 40))
        emailRegister.placeholder = "Email"
        emailRegister.backgroundColor = lightGrayColor
        emailRegister.tag = 1
        emailRegister.autocapitalizationType = UITextAutocapitalizationType.None
        emailRegister.autocorrectionType = UITextAutocorrectionType.No;
        emailRegister.spellCheckingType = UITextSpellCheckingType.No;
        userNameRegister.keyboardType = UIKeyboardType.EmailAddress;
        userNameRegister.delegate = self
        userNameRegister.returnKeyType = .Done
        registerScrollView.addSubview(emailRegister)
        
        addressRegister.frame = (frame : CGRectMake(15, 165, registerScrollView.bounds.size.width - 30, 140))
        addressRegister.backgroundColor = lightGrayColor
        addressRegister.autocorrectionType = .Yes
        registerScrollView.addSubview(addressRegister)
        
        passwordRegister.frame = (frame: CGRectMake(15, 315, registerScrollView.bounds.size.width - 30, 40))
        passwordRegister.placeholder = "Account Password"
        passwordRegister.backgroundColor = lightGrayColor
        passwordRegister.tag = 1
        passwordRegister.autocapitalizationType = UITextAutocapitalizationType.None
        passwordRegister.autocorrectionType = UITextAutocorrectionType.No;
        passwordRegister.spellCheckingType = UITextSpellCheckingType.No;
        passwordRegister.keyboardType = UIKeyboardType.EmailAddress;
        passwordRegister.returnKeyType = .Done
        passwordRegister.delegate = self
        passwordRegister.secureTextEntry = true
        registerScrollView.addSubview(passwordRegister)
        
        let loanOfficerLabel = UILabel (frame: CGRectMake(15, 365, registerScrollView.bounds.size.width - 30, 40))
        loanOfficerLabel.textAlignment = NSTextAlignment.Left
        loanOfficerLabel.text = "ARE YOU CURRENTLY WORKING WITH A LOAN OFFICER?"
        loanOfficerLabel.numberOfLines = 0
        loanOfficerLabel.sizeToFit()
        registerScrollView.addSubview(loanOfficerLabel)
        
        let loYesButton = UIButton (frame: CGRectMake(15, 415, registerScrollView.bounds.size.width - 30, 30))
        loYesButton.setTitle("YES", forState: .Normal)
        loYesButton.addTarget(self, action: "loYesNo", forControlEvents: .TouchUpInside)
        loYesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        loYesButton.layer.borderWidth = 1
        loYesButton.layer.borderColor = lightGrayColor.CGColor
        loYesButton.tag = 0
        registerScrollView.addSubview(loYesButton)
        
        let loNoButton = UIButton (frame: CGRectMake(15, 445, registerScrollView.bounds.size.width - 30, 30))
        loNoButton.setTitle("NO", forState: .Normal)
        loNoButton.addTarget(self, action: "loYesNo", forControlEvents: .TouchUpInside)
        loNoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        loNoButton.layer.borderWidth = 1
        loNoButton.layer.borderColor = lightGrayColor.CGColor
        loNoButton.tag = 1
        registerScrollView.addSubview(loNoButton)
        
        registerScrollView.contentSize = CGSize(width: self.view.bounds.size.width - 30, height: 775)

        let submitButton = UIButton (frame: CGRectMake(self.view.bounds.size.width + 15, (registerView.bounds.size.height - 150) + 75, self.view.bounds.size.width - 30, 40))
        submitButton.setTitle("SAVE", forState: .Normal)
        submitButton.addTarget(self, action: "registerUser:", forControlEvents: .TouchUpInside)
        submitButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerView.addSubview(submitButton)
        
        let backButton = UIButton (frame: CGRectMake(self.view.bounds.size.width + 15, (registerView.bounds.size.height - 150) + 125, self.view.bounds.size.width - 30, 40))
        backButton.setTitle("Back", forState: .Normal)
        backButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        backButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        backButton.titleLabel?.textAlignment = .Left
        backButton.tag = 1
        registerView.addSubview(backButton)
    }

    func showCreateAccount(sender: UIButton) {
        switch sender.tag {
            case 0:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(self.view.bounds.size.width * -1, 75, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75) )
                    }, completion: { finished in
                })
            case 1:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(0, 75, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75) )
                    }, completion: { finished in
                })
            default:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(0, 75, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75) )
                    }, completion: { finished in
                })
            
        }
    }
    
    func registerUser(sender: UIButton) {
        let user = PFUser()
        user.username = userNameRegister.text
        user["searchableUserName"] = userNameRegister.text!.lowercaseString
        user["name"] = firstlastNameRegister.text
        user.email = emailRegister.text
        user["address"] = addressRegister.text
        user.password = passwordRegister.text
        user["optionOne"] = optionOne
        user["optionTwo"] = optionTwo
        user["optionThree"] = optionThree
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("userLoggedIn", sender: self)
            } else {
                // The login failed. Check error to see why.
                print(error!.userInfo["error"])
            }
        }
    }
    
    func optionChecked(sender: UIButton) {
        let checkMarkCheckedImage = UIImage(named: "blue_check") as UIImage?
        let checkMarkUncheckedImage = UIImage(named: "white_check") as UIImage?
        
        switch sender.tag {
        case 1:
            if optionOne {
                sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
                optionOne = false
            }
            else {
                sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
                optionOne = true
            }
        case 2:
            if optionTwo {
                sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
                optionTwo = false
            }
            else {
                sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
                optionTwo = true
            }
        case 3:
            if optionThree {
                sender.setBackgroundImage(checkMarkUncheckedImage, forState: .Normal)
                optionThree = false
            }
            else {
                sender.setBackgroundImage(checkMarkCheckedImage, forState: .Normal)
                optionThree = true
            }
        default:
            print("")
            
        }
        
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
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
