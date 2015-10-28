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
    
    let homeView = UIView() as UIView
    
    var imageView = UIImageView() as UIImageView

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
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
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
        
        let myHomesButton = UIButton (frame: CGRectMake(0, CGFloat(offset), self.view.bounds.size.width / 2, (self.view.bounds.size.width / 2) * 0.75))
        myHomesButton.setTitle("MY HOMES", forState: .Normal)
        myHomesButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        myHomesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myHomesButton.backgroundColor = UIColor.blueColor()
        myHomesButton.layer.borderWidth = 2
        myHomesButton.layer.borderColor = UIColor.whiteColor().CGColor
        myHomesButton.tag = 0
        scrollView.addSubview(myHomesButton)
        
        let addAHomeButton = UIButton (frame: CGRectMake(self.view.bounds.size.width / 2, CGFloat(offset), self.view.bounds.size.width / 2, (self.view.bounds.size.width / 2) * 0.75))
        addAHomeButton.setTitle("ADD A\nHOME", forState: .Normal)
        addAHomeButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        addAHomeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addAHomeButton.backgroundColor = UIColor.blueColor()
        addAHomeButton.layer.borderWidth = 2
        addAHomeButton.layer.borderColor = UIColor.whiteColor().CGColor
        addAHomeButton.tag = 0
        scrollView.addSubview(addAHomeButton)
        
        offset = ((width / 2) * 0.75) + 15
        
        let mortgageCalculatorButton = UIButton (frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        mortgageCalculatorButton.setTitle("MORTGAGE\nCALCULATOR", forState: .Normal)
        mortgageCalculatorButton.addTarget(self, action: "navigateToOtherViews:", forControlEvents: .TouchUpInside)
        mortgageCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mortgageCalculatorButton.backgroundColor = UIColor.blueColor()
        mortgageCalculatorButton.layer.borderWidth = 2
        mortgageCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        mortgageCalculatorButton.tag = 0
        scrollView.addSubview(mortgageCalculatorButton)
        
        let refiCalculatorButton = UIButton (frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        refiCalculatorButton.setTitle("REFINANCING\nCALCULATOR", forState: .Normal)
        refiCalculatorButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        refiCalculatorButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refiCalculatorButton.backgroundColor = UIColor.blueColor()
        refiCalculatorButton.layer.borderWidth = 2
        refiCalculatorButton.layer.borderColor = UIColor.whiteColor().CGColor
        refiCalculatorButton.tag = 0
        scrollView.addSubview(refiCalculatorButton)
        
        offset = (((width / 2) * 0.75) + (width / 2)) + 15
        
        let findBranchButton = UIButton (frame: CGRectMake(10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        findBranchButton.setTitle("FIND THE\nCLOSEST\nBRANCH", forState: .Normal)
        findBranchButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        findBranchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        findBranchButton.backgroundColor = UIColor.blueColor()
        findBranchButton.layer.borderWidth = 2
        findBranchButton.layer.borderColor = UIColor.whiteColor().CGColor
        findBranchButton.tag = 0
        scrollView.addSubview(findBranchButton)
        
        let preQualifiedButton = UIButton (frame: CGRectMake((self.view.bounds.size.width / 2) + 10, CGFloat(offset), (self.view.bounds.size.width / 2) - 20, (self.view.bounds.size.width / 2) - 20))
        preQualifiedButton.setTitle("GET\nPREQUALIFIED", forState: .Normal)
        preQualifiedButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
        preQualifiedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        preQualifiedButton.backgroundColor = UIColor.blueColor()
        preQualifiedButton.layer.borderWidth = 2
        preQualifiedButton.layer.borderColor = UIColor.whiteColor().CGColor
        preQualifiedButton.tag = 0
        scrollView.addSubview(preQualifiedButton)
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: ((self.view.bounds.size.width / 2) * 2) + (135 + 15))
        
        if ((PFUser.currentUser()) == nil) {
            let loginButton = UIButton (frame: CGRectMake(self.view.bounds.size.width - 100, 0, 100, 50))
            loginButton.setTitle("Login", forState: .Normal)
            loginButton.addTarget(self, action: "showCreateAccount:", forControlEvents: .TouchUpInside)
            loginButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            loginButton.backgroundColor = UIColor.clearColor()
            loginButton.tag = 0
            whiteBar.addSubview(loginButton)
        }
    }
    
    func navigateToOtherViews(sender: UIButton) {
        switch sender.tag {
        case 0:
            let cvc = self.storyboard!.instantiateViewControllerWithIdentifier("CalculatorsViewController") as! CalculatorsViewController
            self.navigationController!.pushViewController(cvc, animated: true)
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
