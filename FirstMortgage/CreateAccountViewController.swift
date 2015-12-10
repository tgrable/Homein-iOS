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
    
    let lightBlueColor = UIColor(red: 83/255, green: 135/255, blue: 186/255, alpha: 1)
    let darkBlueColor = UIColor(red: 53/255, green: 103/255, blue: 160/255, alpha: 1)
    
    let lightOrangeColor = UIColor(red: 238/255, green: 155/255, blue: 78/255, alpha: 1)
    let darkOrangeColor = UIColor(red: 222/255, green: 123/255, blue: 37/255, alpha: 1)
    
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
        
        print("Create Account")
        // Do any additional setup after loading the view.
        
        // UIImage
        let fmcLogo = UIImage(named: "home_in") as UIImage?

        // UIImageView
        imageView.frame = (frame: CGRectMake((self.view.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
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
        print("Create Account")
        
        registerView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75))
        registerView.backgroundColor = UIColor.whiteColor()
        registerView.hidden = false
        self.view.addSubview(registerView)
        
        let createAccountView = UIView(frame: CGRectMake(15, 50, (registerView.bounds.size.width / 2) - 30, 40))
        let createAccountGradientLayer = CAGradientLayer()
        createAccountGradientLayer.frame = createAccountView.bounds
        createAccountGradientLayer.colors = [darkOrangeColor.CGColor, lightOrangeColor.CGColor]
        createAccountView.layer.insertSublayer(createAccountGradientLayer, atIndex: 0)
        createAccountView.layer.addSublayer(createAccountGradientLayer)
        registerView.addSubview(createAccountView)
        
        let createAccountButton = UIButton (frame: CGRectMake(15, 50, (registerView.bounds.size.width / 2) - 30, 40))
        createAccountButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        createAccountButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        createAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        createAccountButton.backgroundColor = UIColor.clearColor()
        createAccountButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        createAccountButton.tag = 0
        registerView.addSubview(createAccountButton)
        
        let descLabel = UILabel (frame: CGRectMake(35, 115, (registerView.bounds.size.width / 2) - 70, 40))
        descLabel.textAlignment = NSTextAlignment.Left
        descLabel.font = UIFont(name: "Arial", size: 12)
        descLabel.text = "Bacon ipsum dolor amet ribeye ball tip andouille, tail chuck t-bone turducken. Hamburger capicola prosciutto tenderloin."
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        registerView.addSubview(descLabel)
        
        let checkMarkImage = UIImage(named: "blue_check") as UIImage?
        let optionOneButton = UIButton (frame: CGRectMake(70, descLabel.bounds.size.height + 150, 25, 25))
        optionOneButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionOneButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionOneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionOneButton.tag = 1
        registerView.addSubview(optionOneButton)
        
        let optionOneLabel = UILabel (frame: CGRectMake(105, descLabel.bounds.size.height + 155, (registerView.bounds.size.width / 2) - 210, 40))
        optionOneLabel.textAlignment = NSTextAlignment.Left
        optionOneLabel.font = UIFont(name: "Arial", size: 12)
        optionOneLabel.text = "Sausage drumstick salami"
        optionOneLabel.numberOfLines = 0
        optionOneLabel.sizeToFit()
        registerView.addSubview(optionOneLabel)

        let optionTwoButton = UIButton (frame: CGRectMake(70, descLabel.bounds.size.height + 190, 25, 25))
        optionTwoButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionTwoButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionTwoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionTwoButton.tag = 2
        registerView.addSubview(optionTwoButton)
        
        let optionTwoLabel = UILabel (frame: CGRectMake(105, descLabel.bounds.size.height + 195, (registerView.bounds.size.width / 2) - 210, 40))
        optionTwoLabel.textAlignment = NSTextAlignment.Left
        optionTwoLabel.font = UIFont(name: "Arial", size: 12)
        optionTwoLabel.text = "t-bone porchetta fatback jowl"
        optionTwoLabel.numberOfLines = 0
        optionTwoLabel.sizeToFit()
        registerView.addSubview(optionTwoLabel)
        
        let optionThreeButton = UIButton (frame: CGRectMake(70, descLabel.bounds.size.height + 230, 25, 25))
        optionThreeButton.setBackgroundImage(checkMarkImage, forState: .Normal)
        optionThreeButton.addTarget(self, action: "optionChecked:", forControlEvents: .TouchUpInside)
        optionThreeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        optionThreeButton.tag = 3
        registerView.addSubview(optionThreeButton)
        
        let optionThreeLabel = UILabel (frame: CGRectMake(105, descLabel.bounds.size.height + 235, (registerView.bounds.size.width / 2) - 210, 40))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.font = UIFont(name: "Arial", size: 12)
        optionThreeLabel.text = "Prosciutto andouille biltong"
        optionThreeLabel.numberOfLines = 0
        optionThreeLabel.sizeToFit()
        registerView.addSubview(optionThreeLabel)
        
        let getStartedView = UIView(frame: CGRectMake(35, descLabel.bounds.size.height + 290, (registerView.bounds.size.width / 2) - 70, 40))
        let getStartedGradientLayer = CAGradientLayer()
        getStartedGradientLayer.frame = getStartedView.bounds
        getStartedGradientLayer.colors = [darkBlueColor.CGColor, lightBlueColor.CGColor]
        getStartedView.layer.insertSublayer(getStartedGradientLayer, atIndex: 0)
        getStartedView.layer.addSublayer(getStartedGradientLayer)
        registerView.addSubview(getStartedView)
        
        let getStartedArrow = UILabel (frame: CGRectMake(getStartedView.bounds.size.width - 50, 0, 40, 40))
        getStartedArrow.textAlignment = NSTextAlignment.Right
        getStartedArrow.font = UIFont(name: "forza-light", size: 40)
        getStartedArrow.text = ">"
        getStartedArrow.textColor = UIColor.whiteColor()
        getStartedView.addSubview(getStartedArrow)
        
        let getStartedButton = UIButton (frame: CGRectMake(35, descLabel.bounds.size.height + 290, (registerView.bounds.size.width / 2) - 70, 40))
        getStartedButton.setTitle("GET STARTED", forState: .Normal)
        getStartedButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        registerView.addSubview(getStartedButton)
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 340, (registerView.bounds.size.width / 2) - 30, 40))
        continueWithoutButton.setTitle("CONTINUE WITHOUT", forState: .Normal)
        continueWithoutButton.addTarget(self, action: "continueWithoutLogin:", forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(darkBlueColor, forState: .Normal)
        continueWithoutButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        registerView.addSubview(continueWithoutButton)
    }
    
    func buildRegisterView() {
        print("Create Account")
        
        let bannerView = UIView(frame: CGRectMake((registerView.bounds.size.width / 2), 0, registerView.bounds.size.width / 2, 50))
        let bannerGradientLayer = CAGradientLayer()
        bannerGradientLayer.frame = bannerView.bounds
        bannerGradientLayer.colors = [lightOrangeColor.CGColor, darkOrangeColor.CGColor]
        bannerView.layer.insertSublayer(bannerGradientLayer, atIndex: 0)
        bannerView.layer.addSublayer(bannerGradientLayer)
        bannerView.hidden = false
        registerView.addSubview(bannerView)
        
        let createAccountLabel = UILabel (frame: CGRectMake(0, 0, bannerView.bounds.size.width, 50))
        createAccountLabel.textAlignment = NSTextAlignment.Center
        createAccountLabel.font = UIFont(name: "forza-light", size: 25)
        createAccountLabel.text = "CREATE AN ACCOUNT"
        createAccountLabel.textColor = UIColor.whiteColor()
        createAccountLabel.numberOfLines = 1
        bannerView.addSubview(createAccountLabel)
        
        let registerScrollView = UIScrollView(frame: CGRectMake(self.view.bounds.size.width + 15, 65, self.view.bounds.size.width - 30, registerView.bounds.size.height - 150))
        registerScrollView.backgroundColor = UIColor.whiteColor()
        registerView.addSubview(registerScrollView)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 25)! // Note the !
        ]
        
        let userNamePaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        userNameRegister.frame = (frame: CGRectMake(15, 15, registerScrollView.bounds.size.width - 30, 40))
        userNameRegister.attributedPlaceholder = NSAttributedString(string: "PROFILE NAME", attributes:attributes)
        userNameRegister.leftView = userNamePaddingView
        userNameRegister.leftViewMode = UITextFieldViewMode.Always
        userNameRegister.backgroundColor = lightGrayColor
        userNameRegister.tag = 1
        userNameRegister.autocapitalizationType = UITextAutocapitalizationType.None
        userNameRegister.autocorrectionType = UITextAutocorrectionType.No;
        userNameRegister.spellCheckingType = UITextSpellCheckingType.No;
        userNameRegister.keyboardType = UIKeyboardType.Default;
        userNameRegister.delegate = self
        userNameRegister.returnKeyType = .Done
        registerScrollView.addSubview(userNameRegister)
        
        let firstlastPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        firstlastNameRegister.frame = (frame: CGRectMake(15, 65, registerScrollView.bounds.size.width - 30, 40))
        firstlastNameRegister.attributedPlaceholder = NSAttributedString(string: "YOUR NAME", attributes:attributes)
        firstlastNameRegister.leftView = firstlastPaddingView
        firstlastNameRegister.leftViewMode = UITextFieldViewMode.Always
        firstlastNameRegister.backgroundColor = lightGrayColor
        firstlastNameRegister.tag = 1
        firstlastNameRegister.autocapitalizationType = UITextAutocapitalizationType.Words
        firstlastNameRegister.autocorrectionType = UITextAutocorrectionType.No;
        firstlastNameRegister.spellCheckingType = UITextSpellCheckingType.No;
        firstlastNameRegister.keyboardType = UIKeyboardType.Default;
        firstlastNameRegister.delegate = self
        firstlastNameRegister.returnKeyType = .Done
        registerScrollView.addSubview(firstlastNameRegister)
        
        let emailPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        emailRegister.frame = (frame: CGRectMake(15, 115, registerScrollView.bounds.size.width - 30, 40))
        emailRegister.attributedPlaceholder = NSAttributedString(string: "EMAIL ADDRESS", attributes:attributes)
        emailRegister.leftView = emailPaddingView
        emailRegister.leftViewMode = UITextFieldViewMode.Always
        emailRegister.backgroundColor = lightGrayColor
        emailRegister.tag = 1
        emailRegister.autocapitalizationType = UITextAutocapitalizationType.None
        emailRegister.autocorrectionType = UITextAutocorrectionType.No;
        emailRegister.spellCheckingType = UITextSpellCheckingType.No;
        emailRegister.keyboardType = UIKeyboardType.EmailAddress;
        emailRegister.delegate = self
        emailRegister.returnKeyType = .Done
        registerScrollView.addSubview(emailRegister)
        
        addressRegister.frame = (frame : CGRectMake(15, 165, registerScrollView.bounds.size.width - 30, 140))
        addressRegister.backgroundColor = lightGrayColor
        addressRegister.autocorrectionType = .Yes
        registerScrollView.addSubview(addressRegister)
        
        let passwordPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        passwordRegister.frame = (frame: CGRectMake(15, 315, registerScrollView.bounds.size.width - 30, 40))
        passwordRegister.attributedPlaceholder = NSAttributedString(string: "ACCOUNT PASSWORD", attributes:attributes)
        passwordRegister.leftView = passwordPaddingView
        passwordRegister.leftViewMode = UITextFieldViewMode.Always
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

        let saveView = UIView(frame: CGRectMake((registerView.bounds.size.width / 2) + 75, (registerView.bounds.size.height - 150) + 75, (registerView.bounds.size.width / 2) - 150, 40))
        let saveGradientLayer = CAGradientLayer()
        saveGradientLayer.frame = saveView.bounds
        saveGradientLayer.colors = [lightBlueColor.CGColor, darkBlueColor.CGColor]
        bannerView.layer.insertSublayer(saveGradientLayer, atIndex: 0)
        saveView.layer.addSublayer(saveGradientLayer)
        saveView.hidden = false
        registerView.addSubview(saveView)
        
        let submitButton = UIButton (frame: CGRectMake((registerView.bounds.size.width / 2) + 75, (registerView.bounds.size.height - 150) + 75, (registerView.bounds.size.width / 2) - 150, 40))
        submitButton.setTitle("SAVE", forState: .Normal)
        submitButton.addTarget(self, action: "registerUser:", forControlEvents: .TouchUpInside)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        registerView.addSubview(submitButton)
    }

    func showCreateAccount(sender: UIButton) {
        switch sender.tag {
            case 0:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(self.view.bounds.size.width * -1, 85, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75) )
                    }, completion: { finished in
                })
            case 1:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(0, 85, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75) )
                    }, completion: { finished in
                })
            default:
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                    self.registerView.frame = ( frame: CGRectMake(0, 85, self.view.bounds.size.width * 2, self.view.bounds.size.height - 75) )
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
