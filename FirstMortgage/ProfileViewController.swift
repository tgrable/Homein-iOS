//
//  ProfileViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/15/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate {
    // MARK:
    // MARK: Properties
    let model = Model()
    let modelName = UIDevice.currentDevice().modelName
    
    // UIView
    let profileView = UIView() as UIView
    let overlayView = UIView() as UIView
    
    //UIImageView
    let imageView = UIImageView() as UIImageView
    
    //UIScrollView
    let scrollView = UIScrollView() as UIScrollView
    
    //Array
    var loanOfficerArray = Array<Dictionary<String, String>>()
    var tempArray = Array<Dictionary<String, String>>()
    
    // UITextField
    let nameTxtField = UITextField() as UITextField
    let emailTxtField = UITextField() as UITextField
    let searchTxtField = UITextField() as UITextField

    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = model.lightGrayColor
        
        profileView.frame = (frame: CGRectMake(0, 135, self.view.bounds.size.width, self.view.bounds.size.height - 135))
        profileView.backgroundColor = model.lightGrayColor
        profileView.hidden = false
        self.view.addSubview(profileView)
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 0.60
        overlayView.hidden = true
        self.view.addSubview(overlayView)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 22)!
        ]
        
        searchTxtField.frame = (frame: CGRectMake(15, 125, profileView.bounds.size.width - 30, 50))
        searchTxtField.attributedPlaceholder = NSAttributedString(string: "SEARCH LOAN OFFICER", attributes:attributes)
        searchTxtField.backgroundColor = UIColor.whiteColor()
        searchTxtField.delegate = self
        searchTxtField.returnKeyType = .Done
        searchTxtField.keyboardType = UIKeyboardType.Default
        searchTxtField.tag = 999
        overlayView.addSubview(searchTxtField)
        
        scrollView.frame = (frame: CGRectMake(0, 185, profileView.bounds.size.width, profileView.bounds.size.height - 185))
        scrollView.backgroundColor = UIColor.clearColor()
        overlayView.addSubview(scrollView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((profileView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        self.view.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(whiteBar)
        
        let backIcn = UIImage(named: "backbutton_icon") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 12.5, 25))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(50, 0, 75, 45))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitle("HOME", forState: .Normal)
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        // UIButton
        let logOutButton = UIButton (frame: CGRectMake(whiteBar.bounds.size.width - 140, 0, 125, 45))
        logOutButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        logOutButton.setTitle("LOG OUT", forState: .Normal)
        logOutButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        logOutButton.backgroundColor = UIColor.clearColor()
        logOutButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        logOutButton.tag = 1
        whiteBar.addSubview(logOutButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidAppear(animated: Bool) {
        getBranchLoanOfficers()
        
        if let _ = user!["officerNid"] {
            buildProfileView()
        }
        else {
            buildSeachOverlay(loanOfficerArray)
        }
    }
    
    func buildProfileView() {
        let attributes = [
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 22)!
        ]
        
        // UITextField
        nameTxtField.frame = (frame: CGRectMake(25, 10, profileView.bounds.size.width - 50, 30))
        nameTxtField.attributedPlaceholder = NSAttributedString(string: user!["name"] as! String, attributes:attributes)
        nameTxtField.backgroundColor = UIColor.clearColor()
        nameTxtField.delegate = self
        nameTxtField.returnKeyType = .Done
        nameTxtField.keyboardType = UIKeyboardType.Default
        profileView.addSubview(nameTxtField)
        
        // UITextField
        emailTxtField.frame = (frame: CGRectMake(25, 50, profileView.bounds.size.width - 50, 30))
        emailTxtField.attributedPlaceholder = NSAttributedString(string: user!["email"] as! String, attributes:attributes)
        emailTxtField.backgroundColor = UIColor.clearColor()
        emailTxtField.delegate = self
        emailTxtField.returnKeyType = .Done
        emailTxtField.keyboardType = UIKeyboardType.Default
        profileView.addSubview(emailTxtField)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.dictionaryForKey("loanOfficerDict")
        {
            // UIView
            let loView = UIView(frame: CGRectMake(15, 90, profileView.bounds.size.width - 30, 120))
            loView.backgroundColor = UIColor.whiteColor()
            profileView.addSubview(loView)
            
            let nameLabel = UILabel (frame: CGRectMake(15, 10, loView.bounds.size.width - 30, 24))
            nameLabel.textAlignment = NSTextAlignment.Left
            nameLabel.text = name["name"] as? String
            nameLabel.numberOfLines = 1
            nameLabel.font = UIFont.boldSystemFontOfSize(22.0)
            loView.addSubview(nameLabel)
            
            let emailLabel = UILabel (frame: CGRectMake(15, 35, loView.bounds.size.width - 30, 24))
            emailLabel.textAlignment = NSTextAlignment.Left
            emailLabel.text = name["email"] as? String
            emailLabel.numberOfLines = 1
            emailLabel.font = UIFont.boldSystemFontOfSize(18.0)
            loView.addSubview(emailLabel)
            
            let officeLabel = UILabel (frame: CGRectMake(15, 60, loView.bounds.size.width - 30, 24))
            officeLabel.textAlignment = NSTextAlignment.Left
            officeLabel.text = name["office"] as? String
            officeLabel.numberOfLines = 1
            officeLabel.font = UIFont.boldSystemFontOfSize(18.0)
            loView.addSubview(officeLabel)
            
            let mobileLabel = UILabel (frame: CGRectMake(15, 85, loView.bounds.size.width - 30, 24))
            mobileLabel.textAlignment = NSTextAlignment.Left
            mobileLabel.text = name["mobile"] as? String
            mobileLabel.numberOfLines = 1
            mobileLabel.font = UIFont.boldSystemFontOfSize(18.0)
            loView.addSubview(mobileLabel)
            
            print(name)
        }
        
        // UIView
        let calculateView = UIView(frame: CGRectMake(15, 220, profileView.bounds.size.width - 30, 50))
        let calcGradientLayer = CAGradientLayer()
        calcGradientLayer.frame = calculateView.bounds
        calcGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        calculateView.layer.insertSublayer(calcGradientLayer, atIndex: 0)
        calculateView.layer.addSublayer(calcGradientLayer)
        profileView.addSubview(calculateView)
        
        let calculateArrow = UILabel (frame: CGRectMake(calculateView.bounds.size.width - 50, 0, 40, 50))
        calculateArrow.textAlignment = NSTextAlignment.Right
        calculateArrow.font = UIFont(name: "forza-light", size: 40)
        calculateArrow.text = ">"
        calculateArrow.textColor = UIColor.whiteColor()
        calculateView.addSubview(calculateArrow)
        
        // UIButton
        let updateUserButton = UIButton (frame: CGRectMake(25, 0, profileView.bounds.size.width - 25, 50))
        updateUserButton.addTarget(self, action: "calculateMortgagePaymentButtonPress:", forControlEvents: .TouchUpInside)
        updateUserButton.setTitle("UPDATE USER", forState: .Normal)
        updateUserButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updateUserButton.backgroundColor = UIColor.clearColor()
        updateUserButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        updateUserButton.contentHorizontalAlignment = .Left
        updateUserButton.tag = 0
        calculateView.addSubview(updateUserButton)
    }
    
    func buildSeachOverlay(loArray: Array<Dictionary<String, String>>) {
        var yVal = 15.0
        var count = 0
        
        overlayView.hidden = false
        
        for loanOfficer in loArray {
            let nodeDict = loanOfficer as NSDictionary
            buildLoanOfficerCard(nodeDict as! Dictionary<String, String>, yVal: CGFloat(yVal), count: count)
            
            scrollView.contentSize = CGSize(width: profileView.bounds.size.width, height: CGFloat(loArray.count * 135))
            yVal += 130
            count++
        }

    }

    func getBranchLoanOfficers() {
        let endpoint = NSURL(string: "http://www.trekkdev1.com/loan-officers-json")
        let data = NSData(contentsOfURL: endpoint!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            if let nodes = json as? NSArray {
                for node in nodes {
                    if let nodeDict = node as? NSDictionary {
                        loanOfficerArray.append(nodeDict as! Dictionary<String, String>)
                        tempArray.append(nodeDict as! Dictionary<String, String>)
                    }
                }
            }
        }
        catch {
            print("error serializing JSON: \(error)")
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
        nameLabel.font = UIFont.boldSystemFontOfSize(22.0)
        loView.addSubview(nameLabel)
        
        let emailLabel = UILabel (frame: CGRectMake(15, 35, loView.bounds.size.width - 30, 24))
        emailLabel.textAlignment = NSTextAlignment.Left
        emailLabel.text = nodeDict["email"]
        emailLabel.numberOfLines = 1
        emailLabel.font = UIFont.boldSystemFontOfSize(18.0)
        loView.addSubview(emailLabel)
        
        let officeLabel = UILabel (frame: CGRectMake(15, 60, loView.bounds.size.width - 30, 24))
        officeLabel.textAlignment = NSTextAlignment.Left
        officeLabel.text = nodeDict["office"]
        officeLabel.numberOfLines = 1
        officeLabel.font = UIFont.boldSystemFontOfSize(18.0)
        loView.addSubview(officeLabel)
        
        let mobileLabel = UILabel (frame: CGRectMake(15, 85, loView.bounds.size.width - 30, 24))
        mobileLabel.textAlignment = NSTextAlignment.Left
        mobileLabel.text = nodeDict["mobile"]
        mobileLabel.numberOfLines = 1
        mobileLabel.font = UIFont.boldSystemFontOfSize(18.0)
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
        buildSeachOverlay(tempArray)
    }
    
    // MARK:
    // MARK: Navigation
    func navigateBackHome(sender: UIButton) {
        switch sender.tag {
        case 0:
            navigationController?.popViewControllerAnimated(true)
        case 1:
            PFUser.logOut()
            self.navigationController!.popToRootViewControllerAnimated(true)
        default:
            break
        }
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
    func saveLoanOfficerToParse(nid: String, name: String, url: String) {
        
        user!["officerNid"] = Int(nid)
        user!["officerName"] = name
        user!["officerURL"] = url
        
        user!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.removeViews(self.profileView)
                self.overlayView.hidden = true
                self.buildProfileView()
            }
            else {
                print("error")
            }
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
