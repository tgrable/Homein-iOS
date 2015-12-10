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
    
    let lightBlueColor = UIColor(red: 83/255, green: 135/255, blue: 186/255, alpha: 1)
    let darkBlueColor = UIColor(red: 53/255, green: 103/255, blue: 160/255, alpha: 1)
    
    let lightOrangeColor = UIColor(red: 238/255, green: 155/255, blue: 78/255, alpha: 1)
    let darkOrangeColor = UIColor(red: 222/255, green: 123/255, blue: 37/255, alpha: 1)
    
    let lightGreenColor = UIColor(red: 184.0/255.0, green: 189.0/255.0, blue: 70.0/255.0, alpha: 1)
    let darkGreenColor = UIColor(red: 154.0/255.0, green: 166.0/255.0, blue: 65.0/255.0, alpha: 1)
    
    let lightRedColor = UIColor(red: 204.0/255.0, green: 69.0/255.0, blue: 67.0/255.0, alpha: 1)
    let darkRedColor = UIColor(red: 174.0/255.0, green: 58.0/255.0, blue: 55.0/255.0, alpha: 1)
    
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
        homeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        homeView.backgroundColor = lightGrayColor
        homeView.hidden = false
        self.view.addSubview(homeView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((homeView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
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
        let myHomesGradientLayer = CAGradientLayer()
        myHomesGradientLayer.frame = myHomesView.bounds
        myHomesGradientLayer.colors = [lightBlueColor.CGColor, darkBlueColor.CGColor]
        myHomesView.layer.insertSublayer(myHomesGradientLayer, atIndex: 0)
        myHomesView.layer.addSublayer(myHomesGradientLayer)
        scrollView.addSubview(myHomesView)
        
        let homeIcn = UIImage(named: "icn-firstTime") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((myHomesView.bounds.size.width / 2) - 18, 25, 36, 36))
        homeIcon.image = homeIcn
        myHomesView.addSubview(homeIcon)
        
        // UILabel
        let myHomesLabel = UILabel(frame: CGRectMake(0, 75, myHomesView.bounds.size.width, 24))
        myHomesLabel.text = "MY HOMES"
        myHomesLabel.font = UIFont(name: "forza-light", size: 18)
        myHomesLabel.textAlignment = NSTextAlignment.Center
        myHomesLabel.textColor = UIColor.whiteColor()
        myHomesLabel.numberOfLines = 1
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
        let addHomesGradientLayer = CAGradientLayer()
        addHomesGradientLayer.frame = addHomesView.bounds
        addHomesGradientLayer.colors = [lightBlueColor.CGColor, darkBlueColor.CGColor]
        addHomesView.layer.insertSublayer(addHomesGradientLayer, atIndex: 0)
        addHomesView.layer.addSublayer(addHomesGradientLayer)
        scrollView.addSubview(addHomesView)
 
        let addIcn = UIImage(named: "add_icon") as UIImage?
        let addHomeIcon = UIImageView(frame: CGRectMake((myHomesView.bounds.size.width / 2) - 18, 25, 26, 26))
        addHomeIcon.image = addIcn
        addHomesView.addSubview(addHomeIcon)
        
        // UILabel
        let addHomesLabel = UILabel(frame: CGRectMake(0, 65, myHomesView.bounds.size.width, 48))
        addHomesLabel.text = "ADD A\nHOME"
        addHomesLabel.font = UIFont(name: "forza-light", size: 18)
        addHomesLabel.textAlignment = NSTextAlignment.Center
        addHomesLabel.textColor = UIColor.whiteColor()
        addHomesLabel.numberOfLines = 2
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
        let mortgageCalculatorGradientLayer = CAGradientLayer()
        mortgageCalculatorGradientLayer.frame = mortgageCalculatorView.bounds
        mortgageCalculatorGradientLayer.colors = [lightGreenColor.CGColor, darkGreenColor.CGColor]
        mortgageCalculatorView.layer.insertSublayer(mortgageCalculatorGradientLayer, atIndex: 0)
        mortgageCalculatorView.layer.addSublayer(mortgageCalculatorGradientLayer)
        scrollView.addSubview(mortgageCalculatorView)
        
        let calcIcn = UIImage(named: "icn-calculator") as UIImage?
        let calcIcon = UIImageView(frame: CGRectMake((mortgageCalculatorView.bounds.size.width / 2) - 18, 25, 36, 36))
        calcIcon.image = calcIcn
        mortgageCalculatorView.addSubview(calcIcon)
        
        // UILabel
        let mortgageCalculatorLabel = UILabel(frame: CGRectMake(0, 75, mortgageCalculatorView.bounds.size.width, 48))
        mortgageCalculatorLabel.text = "MORTGAGE\nCALCULATOR"
        mortgageCalculatorLabel.font = UIFont(name: "forza-light", size: 18)
        mortgageCalculatorLabel.textAlignment = NSTextAlignment.Center
        mortgageCalculatorLabel.numberOfLines = 2
        mortgageCalculatorLabel.textColor = UIColor.whiteColor()
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
        let refiCalculatorGradientLayer = CAGradientLayer()
        refiCalculatorGradientLayer.frame = refiCalculatorView.bounds
        refiCalculatorGradientLayer.colors = [lightOrangeColor.CGColor, darkOrangeColor.CGColor]
        refiCalculatorView.layer.insertSublayer(refiCalculatorGradientLayer, atIndex: 0)
        refiCalculatorView.layer.addSublayer(refiCalculatorGradientLayer)
        scrollView.addSubview(refiCalculatorView)
        
        let calcIconTwo = UIImageView(frame: CGRectMake((refiCalculatorView.bounds.size.width / 2) - 18, 25, 36, 36))
        calcIconTwo.image = calcIcn
        refiCalculatorView.addSubview(calcIconTwo)
        
        // UILabel
        let refiCalculatorLabel = UILabel(frame: CGRectMake(0, 75, refiCalculatorView.bounds.size.width, 48))
        refiCalculatorLabel.text = "REFINANCING\nCALCULATOR"
        refiCalculatorLabel.font = UIFont(name: "forza-light", size: 18)
        refiCalculatorLabel.textAlignment = NSTextAlignment.Center
        refiCalculatorLabel.numberOfLines = 2
        refiCalculatorLabel.textColor = UIColor.whiteColor()
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
        let findBranchGradientLayer = CAGradientLayer()
        findBranchGradientLayer.frame = findBranchView.bounds
        findBranchGradientLayer.colors = [lightRedColor.CGColor, darkRedColor.CGColor]
        findBranchView.layer.insertSublayer(findBranchGradientLayer, atIndex: 0)
        findBranchView.layer.addSublayer(findBranchGradientLayer)
        scrollView.addSubview(findBranchView)
        
        let brnchIcn = UIImage(named: "branch_icon") as UIImage?
        let branchIcon = UIImageView(frame: CGRectMake((findBranchView.bounds.size.width / 2) - 18, 25, 36, 36))
        branchIcon.image = brnchIcn
        findBranchView.addSubview(branchIcon)
        
        // UILabel
        let findBranchLabel = UILabel(frame: CGRectMake(0, 75, findBranchView.bounds.size.width, 72))
        findBranchLabel.text = "FIND THE\nCLOSEST\nBRANCH"
        findBranchLabel.font = UIFont(name: "forza-light", size: 18)
        findBranchLabel.textAlignment = NSTextAlignment.Center
        findBranchLabel.numberOfLines = 3
        findBranchLabel.textColor = UIColor.whiteColor()
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
        let preQualifiedGradientLayer = CAGradientLayer()
        preQualifiedGradientLayer.frame = preQualifiedView.bounds
        preQualifiedGradientLayer.colors = [lightBlueColor.CGColor, darkBlueColor.CGColor]
        preQualifiedView.layer.insertSublayer(preQualifiedGradientLayer, atIndex: 0)
        preQualifiedView.layer.addSublayer(preQualifiedGradientLayer)
        scrollView.addSubview(preQualifiedView)
        
        let checkIcn = UIImage(named: "icn-applyOnline") as UIImage?
        let checkIcon = UIImageView(frame: CGRectMake((preQualifiedView.bounds.size.width / 2) - 18, 25, 36, 36))
        checkIcon.image = checkIcn
        preQualifiedView.addSubview(checkIcon)
        
        // UILabel
        let preQualifiedLabel = UILabel(frame: CGRectMake(0, 75, preQualifiedView.bounds.size.width, 48))
        preQualifiedLabel.text = "GET\nPREQUALIFIED"
        preQualifiedLabel.font = UIFont(name: "forza-light", size: 18)
        preQualifiedLabel.textAlignment = NSTextAlignment.Center
        preQualifiedLabel.numberOfLines = 2
        preQualifiedLabel.textColor = UIColor.whiteColor()
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
        
        userButton.frame = (frame: CGRectMake(5, 0, whiteBar.bounds.size.width - 35, 50))
        userButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        userButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        userButton.backgroundColor = UIColor.clearColor()
        userButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        userButton.contentHorizontalAlignment = .Right
        whiteBar.addSubview(userButton)
        
        let fwdIcn = UIImage(named: "forwardbutton_icon") as UIImage?
        let fwdIcon = UIImageView(frame: CGRectMake(whiteBar.bounds.size.width - 20, 10, 12.5, 25))
        fwdIcon.image = fwdIcn
        whiteBar.addSubview(fwdIcon)
        
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
            if let firstName = user!["name"] {
                userButton.setTitle(String(format: "%@'S PROFILE", firstName.uppercaseString), forState: .Normal)
            }
            else {
                userButton.setTitle("PROFILE", forState: .Normal)
            }
            
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
            print("press")
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
