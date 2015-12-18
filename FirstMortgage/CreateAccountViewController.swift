//
//  CreateAccountViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CreateAccountViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate {

    // MARK:
    // MARK: Properties
    let model = Model()
    var parseUser = PFUser()
    
    //UIView
    let overlayView = UIView() as UIView
    
    //UIScrollView
    let scrollView = UIScrollView() as UIScrollView
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    // Login View
    let registerView = UIView()
    
    // UITextField
    let userNameRegister = UITextField()
    let firstlastNameRegister = UITextField()
    let passwordRegister = UITextField()
    let emailRegister = UITextField()
    let searchTxtField = UITextField() as UITextField
    
    // UITextView
    let addressRegister = UITextView()
    
    // Bool
    var optionOne = Bool()
    var optionTwo = Bool()
    var optionThree = Bool()
    
    var imageView = UIImageView() as UIImageView
    
    let locationManager = CLLocationManager()
    
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
        
        self.view.backgroundColor = model.lightGrayColor
        
        optionOne = true
        optionTwo = true
        optionThree = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10;
        locationManager.requestWhenInUseAuthorization()
        
        buildCreateAccountView()
    }

    override func viewDidAppear(animated: Bool) {
        let nodes = model.getBranchLoanOfficers()
        
        loanOfficerArray.removeAll()
        tempArray.removeAll()
        
        for node in nodes {
            if let nodeDict = node as? NSDictionary {
                loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                tempArray.append(nodeDict as! Dictionary<String, String>)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildCreateAccountView() {
        print("Create Account")
        
        registerView.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, self.view.bounds.size.height - 85))
        registerView.backgroundColor = UIColor.whiteColor()
        registerView.hidden = false
        self.view.addSubview(registerView)
        
        let createAccountView = UIView(frame: CGRectMake(15, 50, registerView.bounds.size.width - 30, 40))
        let createAccountGradientLayer = CAGradientLayer()
        createAccountGradientLayer.frame = createAccountView.bounds
        createAccountGradientLayer.colors = [model.darkOrangeColor.CGColor, model.lightOrangeColor.CGColor]
        createAccountView.layer.insertSublayer(createAccountGradientLayer, atIndex: 0)
        createAccountView.layer.addSublayer(createAccountGradientLayer)
        registerView.addSubview(createAccountView)
        
        let createAccountButton = UIButton (frame: CGRectMake(15, 50, registerView.bounds.size.width - 30, 40))
        createAccountButton.setTitle("CREATE AN ACCOUNT", forState: .Normal)
        createAccountButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        createAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        createAccountButton.backgroundColor = UIColor.clearColor()
        createAccountButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        createAccountButton.tag = 0
        registerView.addSubview(createAccountButton)
        
        let descLabel = UILabel (frame: CGRectMake(35, 115, registerView.bounds.size.width - 70, 40))
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
        
        let optionOneLabel = UILabel (frame: CGRectMake(105, descLabel.bounds.size.height + 155, registerView.bounds.size.width - 210, 40))
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
        
        let optionTwoLabel = UILabel (frame: CGRectMake(105, descLabel.bounds.size.height + 195, registerView.bounds.size.width - 210, 40))
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
        
        let optionThreeLabel = UILabel (frame: CGRectMake(105, descLabel.bounds.size.height + 235, registerView.bounds.size.width - 210, 40))
        optionThreeLabel.textAlignment = NSTextAlignment.Left
        optionThreeLabel.font = UIFont(name: "Arial", size: 12)
        optionThreeLabel.text = "Prosciutto andouille biltong"
        optionThreeLabel.numberOfLines = 0
        optionThreeLabel.sizeToFit()
        registerView.addSubview(optionThreeLabel)
        
        let getStartedView = UIView(frame: CGRectMake(35, descLabel.bounds.size.height + 290, registerView.bounds.size.width - 70, 40))
        let getStartedGradientLayer = CAGradientLayer()
        getStartedGradientLayer.frame = getStartedView.bounds
        getStartedGradientLayer.colors = [model.darkBlueColor.CGColor, model.lightBlueColor.CGColor]
        getStartedView.layer.insertSublayer(getStartedGradientLayer, atIndex: 0)
        getStartedView.layer.addSublayer(getStartedGradientLayer)
        registerView.addSubview(getStartedView)
        
        let getStartedArrow = UILabel (frame: CGRectMake(getStartedView.bounds.size.width - 50, 0, 40, 40))
        getStartedArrow.textAlignment = NSTextAlignment.Right
        getStartedArrow.font = UIFont(name: "forza-light", size: 40)
        getStartedArrow.text = ">"
        getStartedArrow.textColor = UIColor.whiteColor()
        getStartedView.addSubview(getStartedArrow)
        
        let getStartedButton = UIButton (frame: CGRectMake(35, descLabel.bounds.size.height + 290, registerView.bounds.size.width - 70, 40))
        getStartedButton.setTitle("GET STARTED", forState: .Normal)
        getStartedButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getStartedButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        registerView.addSubview(getStartedButton)
        
        let continueWithoutButton = UIButton (frame: CGRectMake(15, descLabel.bounds.size.height + 340, registerView.bounds.size.width - 30, 40))
        continueWithoutButton.setTitle("CONTINUE WITHOUT", forState: .Normal)
        continueWithoutButton.addTarget(self, action: "continueWithoutLogin:", forControlEvents: .TouchUpInside)
        continueWithoutButton.setTitleColor(model.darkBlueColor, forState: .Normal)
        continueWithoutButton.titleLabel!.font = UIFont(name: "forza-light", size: 16)
        registerView.addSubview(continueWithoutButton)
    }
    
    func showCreateAccount(sender: UIButton) {
        let signUpController = CustomSignUpViewController()
        signUpController.delegate = self
        signUpController.fields = [.UsernameAndPassword, .Email, .Additional, .SignUpButton, .DismissButton]
        self.presentViewController(signUpController, animated:true, completion: nil)
    }

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        parseUser = user
        buildOverlay()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func searchLoanOfficerArray(searchText: String) {
        removeViews(scrollView)
        tempArray.removeAll()
        for loanOfficer in loanOfficerArray {
            if let lo = loanOfficer["name"] {
                if lo.containsString(searchText) {
                    tempArray.append(loanOfficer)
                }
            }
        }
        buildLoanOfficerSeachOverLay(tempArray)
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 999 {
            searchLoanOfficerArray(searchTxtField.text!)
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }

    func buildOverlay() {

        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 0.90
        self.view.addSubview(overlayView)
        
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 75, overlayView.bounds.size.width - 30, 0))
        overLayTextLabel.text = "Are you currently working with a loan officer?"
        overLayTextLabel.textAlignment = NSTextAlignment.Left
        overLayTextLabel.textColor = UIColor.whiteColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 32)
        overLayTextLabel.numberOfLines = 0
        overLayTextLabel.sizeToFit()
        overlayView.addSubview(overLayTextLabel)
        
        
        // UIView
        let noView = UIView(frame: CGRectMake(15, 200, overlayView.bounds.size.width - 30, 50))
        let noGradientLayer = CAGradientLayer()
        noGradientLayer.frame = noView.bounds
        noGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        noView.alpha = 1.0
        noView.layer.insertSublayer(noGradientLayer, atIndex: 0)
        noView.layer.addSublayer(noGradientLayer)
        overlayView.addSubview(noView)
        
        // UIButton
        let noButton = UIButton (frame: CGRectMake(0, 0, noView.bounds.size.width, 50))
        noButton.addTarget(self, action: "workingWithALoanOfficer:", forControlEvents: .TouchUpInside)
        noButton.setTitle("NO", forState: .Normal)
        noButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        noButton.backgroundColor = UIColor.clearColor()
        noButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        noButton.contentHorizontalAlignment = .Center
        noButton.tag = 0
        noView.addSubview(noButton)
        
        // UIView
        let yesView = UIView(frame: CGRectMake(15, 300, overlayView.bounds.size.width - 30, 50))
        let yesGradientLayer = CAGradientLayer()
        yesGradientLayer.frame = yesView.bounds
        yesGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        yesView.alpha = 1.0
        yesView.layer.insertSublayer(yesGradientLayer, atIndex: 0)
        yesView.layer.addSublayer(yesGradientLayer)
        overlayView.addSubview(yesView)
        
        // UIButton
        let yesButton = UIButton (frame: CGRectMake(0, 0, yesView.bounds.size.width, 50))
        yesButton.addTarget(self, action: "workingWithALoanOfficer:", forControlEvents: .TouchUpInside)
        yesButton.setTitle("YES", forState: .Normal)
        yesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        yesButton.backgroundColor = UIColor.clearColor()
        yesButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        yesButton.contentHorizontalAlignment = .Center
        yesButton.tag = 1
        yesView.addSubview(yesButton)
        
    }
    
    func buildLoanOfficerSeachOverLay(loArray: Array<Dictionary<String, String>>) {
        
        removeViews(overlayView)
        
        var yVal = 15.0
        var count = 0
        
        // UILabel
        let overLayTextLabel = UILabel(frame: CGRectMake(15, 25, overlayView.bounds.size.width - 30, 0))
        overLayTextLabel.text = "You currently not assigned to a loan officer. Please select one from the list below."
        overLayTextLabel.textAlignment = NSTextAlignment.Left
        overLayTextLabel.textColor = UIColor.whiteColor()
        overLayTextLabel.font = UIFont(name: "forza-light", size: 18)
        overLayTextLabel.numberOfLines = 0
        overLayTextLabel.sizeToFit()
        overlayView.addSubview(overLayTextLabel)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 22)!
        ]
        
        let searchTxtPaddingView = UIView(frame: CGRectMake(0, 0, 15, 40))
        searchTxtField.frame = (frame: CGRectMake(15, 85, overlayView.bounds.size.width - 30, 50))
        searchTxtField.attributedPlaceholder = NSAttributedString(string: "SEARCH LOAN OFFICER", attributes:attributes)
        searchTxtField.backgroundColor = UIColor.whiteColor()
        searchTxtField.delegate = self
        searchTxtField.leftView = searchTxtPaddingView
        searchTxtField.leftViewMode = UITextFieldViewMode.Always
        searchTxtField.returnKeyType = .Done
        searchTxtField.keyboardType = UIKeyboardType.Default
        searchTxtField.tag = 999
        searchTxtField.font = UIFont(name: "forza-light", size: 22)
        overlayView.addSubview(searchTxtField)
        
        scrollView.frame = (frame: CGRectMake(0, 135, overlayView.bounds.size.width, overlayView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        overlayView.addSubview(scrollView)
        
        for loanOfficer in loArray {
            let nodeDict = loanOfficer as NSDictionary
            buildLoanOfficerCard(nodeDict as! Dictionary<String, String>, yVal: CGFloat(yVal), count: count)
            
            scrollView.contentSize = CGSize(width: overlayView.bounds.size.width, height: CGFloat(loArray.count * 135))
            yVal += 130
            count++
        }
    }
    
    func buildLoanOfficerCard(nodeDict: Dictionary<String, String>, yVal: CGFloat, count: Int) -> UIView {
        // UIView
        let loView = UIView(frame: CGRectMake(15, yVal, scrollView.bounds.size.width - 30, 120))
        loView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(loView)
        
        let nameLabel = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 24))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.text = nodeDict["name"]
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "forza-light", size: 24)
        loView.addSubview(nameLabel)
        
        let emailLabel = UILabel (frame: CGRectMake(15, 35, loView.bounds.size.width - 30, 24))
        emailLabel.textAlignment = NSTextAlignment.Left
        emailLabel.text = nodeDict["email"]
        emailLabel.numberOfLines = 1
        emailLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(emailLabel)
        
        let officeLabel = UILabel (frame: CGRectMake(15, 60, loView.bounds.size.width - 30, 24))
        officeLabel.textAlignment = NSTextAlignment.Left
        officeLabel.text = nodeDict["office"]
        officeLabel.numberOfLines = 1
        officeLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(officeLabel)
        
        let mobileLabel = UILabel (frame: CGRectMake(15, 85, loView.bounds.size.width - 30, 24))
        mobileLabel.textAlignment = NSTextAlignment.Left
        mobileLabel.text = nodeDict["mobile"]
        mobileLabel.numberOfLines = 1
        mobileLabel.font = UIFont(name: "forza-light", size: 18)
        loView.addSubview(mobileLabel)
        
        // UIButton
        let selectButton = UIButton (frame: CGRectMake(0, 0, loView.bounds.size.width, loView.bounds.size.height))
        selectButton.addTarget(self, action: "setLoanOfficer:", forControlEvents: .TouchUpInside)
        selectButton.backgroundColor = UIColor.clearColor()
        selectButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        selectButton.contentHorizontalAlignment = .Right
        selectButton.tag = count
        loView.addSubview(selectButton)
        
        return loView
    }
    
    func setLoanOfficer(sender: UIButton) {
        let dict = tempArray[sender.tag]
        
        let nid = dict["nid"]! as String
        let name = dict["name"]! as String
        let officerURL = dict["url"]! as String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("loanOfficerDict")
        defaults.setObject(dict, forKey: "loanOfficerDict")
        
        print(dict)
        
        saveLoanOfficerToParse(nid, name: name, url: officerURL)
    }
    
    // MARK:
    // MARK: Parse
    func saveLoanOfficerToParse(nid: String, name: String, url: String) {
        
        parseUser["officerNid"] = Int(nid)
        parseUser["officerName"] = name
        parseUser["officerURL"] = url
        parseUser["optionOne"] = optionOne
        parseUser["optionTwo"] = optionTwo
        parseUser["optionThree"] = optionThree
        
        parseUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("succcess")
                self.performSegueWithIdentifier("userLoggedIn", sender: self)
            }
            else {
                print("error")
            }
        }
    }
    
    func saveUserOptionToParse() {
        parseUser["optionOne"] = optionOne
        parseUser["optionTwo"] = optionTwo
        parseUser["optionThree"] = optionThree
        
        parseUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("succcess")
                self.performSegueWithIdentifier("userLoggedIn", sender: self)
            }
            else {
                print("error")
            }
        }
    }
    
    func workingWithALoanOfficer(sender: UIButton) {
        switch sender.tag {
        case 0:
            saveUserOptionToParse()
        case 1:
            buildLoanOfficerSeachOverLay(loanOfficerArray)
        default:
            print("Default")
        }
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
