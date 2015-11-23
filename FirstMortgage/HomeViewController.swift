//
//  HomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    let homeView = UIView()
    
    var imageView = UIImageView()

    var isMortgageCalc = Bool()
    let whiteBar = UIView()
    
    // UIButton
    let myHomesButton = UIButton()
    let addAHomeButton = UIButton()
    let mortgageCalculatorButton = UIButton()
    let refiCalculatorButton = UIButton()
    let findBranchButton = UIButton()
    let preQualifiedButton = UIButton()
    let userButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildHomeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildHomeView() {
        homeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height))
        homeView.backgroundColor = lightGrayColor
        homeView.hidden = false
        self.view.addSubview(homeView)
        
        let fmcLogo = UIImage(named: "fmc_logo") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake(40, 35, self.view.bounds.size.width - 80, 40))
        imageView.image = fmcLogo
        homeView.addSubview(imageView)
        
        whiteBar.frame = (frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        homeView.addSubview(whiteBar)
        
        let backgroundImage = UIImage(named: "homebackground") as UIImage?
        // UIImageView
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 135, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        backgroundImageView.image = backgroundImage
        homeView.addSubview(backgroundImageView)
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 135, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        homeView.addSubview(scrollView)
        
        var offset = 0.0
        let width = Double(self.view.bounds.size.width)
        
        /********************************************************* My Homes Button ********************************************************************/
        // UIView
        let myHomesView = UIView(frame: CGRectMake(0, CGFloat(offset), self.view.bounds.size.width / 2, (self.view.bounds.size.width / 2) * 0.75))
        myHomesView.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(myHomesView)
        
        // UILabel
        let myHomesLabel = UILabel(frame: CGRectMake(15, 15, myHomesView.bounds.size.width, 0))
        myHomesLabel.text = "MY HOMES"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        myHomesLabel.textAlignment = NSTextAlignment.Center
        myHomesLabel.numberOfLines = 0
        myHomesLabel.sizeToFit()
        myHomesView.addSubview(myHomesLabel)
        
        // UIButton
        myHomesButton.frame = (frame: CGRectMake(0, 0, myHomesView.bounds.size.width, myHomesView.bounds.size.height))
        myHomesButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        myHomesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myHomesButton.backgroundColor = UIColor.clearColor()
        myHomesButton.layer.borderWidth = 2
        myHomesButton.layer.borderColor = UIColor.whiteColor().CGColor
        myHomesButton.tag = 0
        myHomesView.addSubview(myHomesButton)
        
        /********************************************************* Add Homes Button ********************************************************************/
        // UIView
        let addHomesView = UIView(frame: CGRectMake(self.view.bounds.size.width / 2, CGFloat(offset), self.view.bounds.size.width / 2, (self.view.bounds.size.width / 2) * 0.75))
        addHomesView.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(addHomesView)
        
        // UILabel
        let addHomesLabel = UILabel(frame: CGRectMake(15, 15, myHomesView.bounds.size.width, 0))
        addHomesLabel.text = "Add A\nHOME"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        addHomesLabel.textAlignment = NSTextAlignment.Center
        addHomesLabel.numberOfLines = 0
        addHomesLabel.sizeToFit()
        addHomesView.addSubview(addHomesLabel)
        
        addAHomeButton.frame = (frame: CGRectMake(0, 0, myHomesView.bounds.size.width, myHomesView.bounds.size.height))
        addAHomeButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        addAHomeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addAHomeButton.backgroundColor = UIColor.clearColor()
        addAHomeButton.layer.borderWidth = 2
        addAHomeButton.layer.borderColor = UIColor.whiteColor().CGColor
        addAHomeButton.tag = 1
        addHomesView.addSubview(addAHomeButton)
        
        offset = ((width / 2) * 0.75) + 15
        
        /********************************************************* Mortgage Calculator Button ********************************************************************/
        // UIView
        let mortgageCalculatorView = UIView(frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        mortgageCalculatorView.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(mortgageCalculatorView)
        
        // UILabel
        let mortgageCalculatorLabel = UILabel(frame: CGRectMake(15, 15, mortgageCalculatorView.bounds.size.width, 0))
        mortgageCalculatorLabel.text = "MORTGAGE\nCALCULATOR"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        mortgageCalculatorLabel.textAlignment = NSTextAlignment.Center
        mortgageCalculatorLabel.numberOfLines = 0
        mortgageCalculatorLabel.sizeToFit()
        mortgageCalculatorView.addSubview(mortgageCalculatorLabel)
        
        // UIButton
        mortgageCalculatorButton.frame = (frame: CGRectMake(0, 0, mortgageCalculatorView.bounds.size.width, mortgageCalculatorView.bounds.size.height))
        mortgageCalculatorButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        mortgageCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mortgageCalculatorButton.backgroundColor = UIColor.clearColor()
        mortgageCalculatorButton.layer.borderWidth = 2
        mortgageCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        mortgageCalculatorButton.tag = 2
        mortgageCalculatorView.addSubview(mortgageCalculatorButton)
        
        /********************************************************* Refinance Calculator Button ********************************************************************/
        // UIView
        let refiCalculatorView = UIView(frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        refiCalculatorView.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(refiCalculatorView)
        
        // UILabel
        let refiCalculatorLabel = UILabel(frame: CGRectMake(15, 15, refiCalculatorView.bounds.size.width, 0))
        refiCalculatorLabel.text = "REFINANCING\nCALCULATOR"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        refiCalculatorLabel.textAlignment = NSTextAlignment.Center
        refiCalculatorLabel.numberOfLines = 0
        refiCalculatorLabel.sizeToFit()
        refiCalculatorView.addSubview(refiCalculatorLabel)
        
        refiCalculatorButton.frame = (frame: CGRectMake(0, 0, refiCalculatorView.bounds.size.width, refiCalculatorView.bounds.size.height))
        refiCalculatorButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        refiCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refiCalculatorButton.backgroundColor = UIColor.clearColor()
        refiCalculatorButton.layer.borderWidth = 2
        refiCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        refiCalculatorButton.tag = 3
        refiCalculatorView.addSubview(refiCalculatorButton)
        
        offset = (((width / 2) * 0.75) + (width / 2)) + 15
        
        /********************************************************* Find Branch Button ********************************************************************/
        // UIView
        let findBranchView = UIView(frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        findBranchView.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(findBranchView)
        
        // UILabel
        let findBranchLabel = UILabel(frame: CGRectMake(15, 15, findBranchView.bounds.size.width, 0))
        findBranchLabel.text = "FIND THE\nCLOSEST\nBRANCH"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        findBranchLabel.textAlignment = NSTextAlignment.Center
        findBranchLabel.numberOfLines = 0
        findBranchLabel.sizeToFit()
        findBranchView.addSubview(findBranchLabel)
        
        findBranchButton.frame = (frame: CGRectMake(0, 0, findBranchView.bounds.size.width, findBranchView.bounds.size.height))
        findBranchButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        findBranchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        findBranchButton.backgroundColor = UIColor.clearColor()
        findBranchButton.layer.borderWidth = 2
        findBranchButton.layer.borderColor = UIColor.whiteColor().CGColor
        findBranchButton.tag = 4
        findBranchView.addSubview(findBranchButton)
        
        /********************************************************* Get Prequalified Button ********************************************************************/
         // UIView
        let preQualifiedView = UIView(frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        preQualifiedView.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(preQualifiedView)
        
        // UILabel
        let preQualifiedLabel = UILabel(frame: CGRectMake(15, 15, preQualifiedView.bounds.size.width, 0))
        preQualifiedLabel.text = "GET\nPREQUALIFIED"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        preQualifiedLabel.textAlignment = NSTextAlignment.Center
        preQualifiedLabel.numberOfLines = 0
        preQualifiedLabel.sizeToFit()
        preQualifiedView.addSubview(preQualifiedLabel)
        
        preQualifiedButton.frame = (frame: CGRectMake(0, 0, preQualifiedView.bounds.size.width, preQualifiedView.bounds.size.height))
        preQualifiedButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        preQualifiedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        preQualifiedButton.backgroundColor = UIColor.clearColor()
        preQualifiedButton.layer.borderWidth = 2
        preQualifiedButton.layer.borderColor = UIColor.whiteColor().CGColor
        preQualifiedButton.tag = 5
        preQualifiedView.addSubview(preQualifiedButton)
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: ((self.view.bounds.size.width / 2) * 2) + (135 + 15))
        
        userButton.frame = (frame: CGRectMake(10, 0, self.view.bounds.size.width - 20, 50))
        userButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        userButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        userButton.backgroundColor = UIColor.clearColor()
        userButton.contentHorizontalAlignment = .Right
        whiteBar.addSubview(userButton)
        
        checkIfLoggedIn()
    }
    
    func buildLoginView() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "First Mortgage", message: "Login", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "User Name"
        })
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) -> Void in
            let unTextField = alert.textFields![0] as UITextField
            print("User Name Text field: \(unTextField.text)")
            
            let pwTextField = alert.textFields![1] as UITextField
            print("Password Text field: \(pwTextField.text)")
            
            PFUser.logInWithUsernameInBackground(unTextField.text!, password:pwTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    self.checkIfLoggedIn()
                } else {
                    // The login failed. Check error to see why.
                    print(error)
                }
            }
        }))
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkIfLoggedIn() {
        if ((PFUser.currentUser()) == nil) {
            userButton.setTitle("Login", forState: .Normal)
            userButton.tag = 6
            
            myHomesButton.enabled = false
            addAHomeButton.enabled = false
            preQualifiedButton.enabled = false
        }
        else {
            let user = PFUser.currentUser()
            let firstName = user!["name"] as! String
            userButton.setTitle(String(format: "%@'S PROFILE >", firstName.uppercaseString), forState: .Normal)
            userButton.tag = 7
            
            myHomesButton.enabled = true
            addAHomeButton.enabled = true
            preQualifiedButton.enabled = true
        }
    }
    
    // MARK:
    // MARK: Actions
    func navigateToOtherViews(sender: UIButton) {
        switch sender.tag {
        case 0:
            let mhvc = self.storyboard!.instantiateViewControllerWithIdentifier("myHomesViewController") as! MyHomesViewController
            self.navigationController!.pushViewController(mhvc, animated: true)
        case 1:
            let ahvc = self.storyboard!.instantiateViewControllerWithIdentifier("addHomeViewController") as! AddHomeViewController
            self.navigationController!.pushViewController(ahvc, animated: true)
        case 2:
            isMortgageCalc = true
            performSegueWithIdentifier("calculatorsViewController", sender: nil)
        case 3:
            isMortgageCalc = false
            performSegueWithIdentifier("calculatorsViewController", sender: nil)
        case 4:
            let cvc = self.storyboard!.instantiateViewControllerWithIdentifier("findBranchViewController") as! FindBranchViewController
            self.navigationController!.pushViewController(cvc, animated: true)
        case 5:
            let cvc = self.storyboard!.instantiateViewControllerWithIdentifier("webViewController") as! WebViewController
            self.navigationController!.pushViewController(cvc, animated: true)
        case 6:
            print("Login Pressed")
            buildLoginView()
        case 7:
            print("View Profile")
        default:
            print("Default")
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destViewController: CalculatorsViewController = segue.destinationViewController as! CalculatorsViewController
        destViewController.isMortgageCalc = isMortgageCalc
    }
}
