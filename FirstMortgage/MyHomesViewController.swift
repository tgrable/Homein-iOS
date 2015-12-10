//
//  MyHomesViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class MyHomesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK:
    // MARK: Properties
    
    let model = Model()

    @IBOutlet weak var homeTableView: UITableView!
    let basicCellIdentifier = "BasicCell"
    
    let myHomesView = UIView()
    let sortTrayView = UIView()
    let sortTrayGradientLayer = CAGradientLayer()
    
    var imageView = UIImageView()
    
    var isSmallerScreen = Bool()
    var isSortTrayOpen = Bool()
    
    // Parse
    var userHomes = [PFObject]()
    var home: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        getAllHomesForUser("createdAt")
        buildView()
        
        showSortTray()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildView() {
        myHomesView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, 185))
        myHomesView.backgroundColor = model.lightGrayColor
        myHomesView.hidden = false
        self.view.addSubview(myHomesView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((myHomesView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        myHomesView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        myHomesView.addSubview(whiteBar)
        
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
        let addButton = UIButton (frame: CGRectMake(whiteBar.bounds.size.width - 75, 0, 75, 45))
        addButton.addTarget(self, action: "addNewHome:", forControlEvents: .TouchUpInside)
        addButton.setTitle("Add", forState: .Normal)
        addButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        addButton.backgroundColor = UIColor.clearColor()
        addButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        addButton.tag = 0
        whiteBar.addSubview(addButton)
        
        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, myHomesView.bounds.size.width, 50))
        let addHomeBannerGradientLayer = CAGradientLayer()
        addHomeBannerGradientLayer.frame = addHomeBannerView.bounds
        addHomeBannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        addHomeBannerView.layer.insertSublayer(addHomeBannerGradientLayer, atIndex: 0)
        addHomeBannerView.layer.addSublayer(addHomeBannerGradientLayer)
        addHomeBannerView.hidden = false
        myHomesView.addSubview(addHomeBannerView)
        
        let labelFontSize = isSmallerScreen ? 20.0 : 24.0;

        let sortIcn = UIImage(named: "sortby_icon") as UIImage?
        let sortIconView = UIImageView(frame: CGRectMake(20, 12.5, 5.25, 25))
        sortIconView.image = sortIcn
        addHomeBannerView.addSubview(sortIconView)
        
        // UIButton
        let sortButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        sortButton.addTarget(self, action: "showHideSortTray:", forControlEvents: .TouchUpInside)
        sortButton.backgroundColor = UIColor.clearColor()
        sortButton.tag = 0
        addHomeBannerView.addSubview(sortButton)
        
        //UIImageView
        let homeIcn = UIImage(named: "icn-firstTime") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((addHomeBannerView.bounds.size.width / 2) - (12.5 + 100), 12.5, 25, 25))
        homeIcon.image = homeIcn
        addHomeBannerView.addSubview(homeIcon)
        
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(0, 0, addHomeBannerView.bounds.size.width, 50))
        bannerLabel.text = "MY HOMES"
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.font = bannerLabel.font.fontWithSize(CGFloat(labelFontSize))
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.font = UIFont(name: "forza-light", size: 25)
        addHomeBannerView.addSubview(bannerLabel)
    }
    
    func showSortTray() {
        sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 175))
        sortTrayGradientLayer.frame = sortTrayView.bounds
        sortTrayGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        sortTrayView.layer.insertSublayer(sortTrayGradientLayer, atIndex: 0)
        sortTrayView.layer.addSublayer(sortTrayGradientLayer)
        sortTrayView.hidden = false
        self.view.addSubview(sortTrayView)
        
        // UILabel
        let sortByLabel = UILabel(frame: CGRectMake(15, 10, sortTrayView.bounds.size.width - 65, 0))
        sortByLabel.text = "SORT BY"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sortByLabel.textAlignment = NSTextAlignment.Left
        sortByLabel.numberOfLines = 0
        sortByLabel.font = UIFont(name: "forza-light", size: 25)
        sortByLabel.textColor = UIColor.whiteColor()
        sortByLabel.sizeToFit()
        sortTrayView.addSubview(sortByLabel)
        
        let dividerView = UIView(frame: CGRectMake(15, 34, self.view.bounds.size.width - 30, 1))
        dividerView.backgroundColor = UIColor.whiteColor()
        dividerView.hidden = false
        sortTrayView.addSubview(dividerView)
        
        let nameImage = UIImage(named: "Star_empty-01") as UIImage?
        // UIImageView
        let nameImageView = UIImageView(frame: CGRectMake(15, 45, 30, 30))
        nameImageView.image = nameImage
        sortTrayView.addSubview(nameImageView)
        
        // UIButton
        let sortNameButton = UIButton (frame: CGRectMake(50, 40, sortTrayView.bounds.size.width - 50, 40))
        sortNameButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortNameButton.setTitle("NAME", forState: .Normal)
        sortNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortNameButton.backgroundColor = UIColor.clearColor()
        sortNameButton.contentHorizontalAlignment = .Left
        sortNameButton.tag = 0
        sortNameButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        sortTrayView.addSubview(sortNameButton)
        
        let starImage = UIImage(named: "Star_empty-01") as UIImage?
        // UIImageView
        let ratingImageView = UIImageView(frame: CGRectMake(15, 90, 30, 30))
        ratingImageView.image = starImage
        sortTrayView.addSubview(ratingImageView)
        
        // UIButton
        let sortRatingButton = UIButton (frame: CGRectMake(50, 85, sortTrayView.bounds.size.width - 50, 40))
        sortRatingButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortRatingButton.setTitle("RATING", forState: .Normal)
        sortRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortRatingButton.backgroundColor = UIColor.clearColor()
        sortRatingButton.contentHorizontalAlignment = .Left
        sortRatingButton.tag = 0
        sortRatingButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        sortTrayView.addSubview(sortRatingButton)
        
        
        let priceImage = UIImage(named: "Star_empty-01") as UIImage?
        // UIImageView
        let priceImageView = UIImageView(frame: CGRectMake(15, 135, 30, 30))
        priceImageView.image = priceImage
        sortTrayView.addSubview(priceImageView)
        
        // UIButton
        let sortPriceButton = UIButton (frame: CGRectMake(50, 130, sortTrayView.bounds.size.width, 40))
        sortPriceButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortPriceButton.setTitle("PRICE", forState: .Normal)
        sortPriceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortPriceButton.backgroundColor = UIColor.clearColor()
        sortPriceButton.contentHorizontalAlignment = .Left
        sortPriceButton.tag = 0
        sortPriceButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        sortTrayView.addSubview(sortPriceButton)
    }

    func showHideSortTray(sender: UIButton) {
        if (!isSortTrayOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height - 175, self.view.bounds.size.width, 175))
                self.sortTrayGradientLayer.frame = self.sortTrayGradientLayer.bounds
                }, completion: {
                    (value: Bool) in
                    self.isSortTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 175))
                self.sortTrayGradientLayer.frame = self.sortTrayGradientLayer.bounds
                }, completion: {
                    (value: Bool) in
                    self.isSortTrayOpen = false
            })
        }
    }
    
    func setSortOrder(sender: UIButton) {
        let sortorder = sender.titleLabel?.text
        getAllHomesForUser(sortorder!.lowercaseString)
    }
    
    // MARK:
    // MARK: Parse Method
    func getAllHomesForUser(sortOrder: String) {
        let query = PFQuery(className:"Home")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.orderByDescending(sortOrder)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                self.userHomes.removeAll()
                for object in objects! {
                    self.userHomes.append(object)
                }
                self.homeTableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // MARK:
    // MARK: UITableViewDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userHomes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> BasicCell {
        let cell = homeTableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! BasicCell
        setBackgroungImageForCell(cell, indexPath: indexPath)
        setTitleForCell(cell, indexPath: indexPath)
        setPriceForCell(cell, indexPath: indexPath)
        setAddressForCell(cell, indexPath: indexPath)
        setBedsForCell(cell, indexPath: indexPath)
        setBathsForCell(cell, indexPath: indexPath)
        return cell
    }
    func setBackgroungImageForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        var defaultImage: [PFFile] = []
        
        if (item["imageArray"] != nil) {
            defaultImage = item["imageArray"] as! [PFFile]
            if (defaultImage.count > 0 ) {
                let userImageFile = defaultImage[0]
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            cell.backgroundImage?.image = image
                        }
                    }
                }
            }
        }
        else {
            let fillerImage = UIImage(named: "homebackground") as UIImage?
            cell.backgroundImage?.image = fillerImage
        }
    }
    func setTitleForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        cell.titleLabel?.text = item["name"] as? String
    }
    func setPriceForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        let price = item["price"] as! Double
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        cell.priceLabel?.text = formatter.stringFromNumber(price)
        
        //cell.priceLabel?.text = String(format:"$%.0f", price) as String
    }
    func setAddressForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        cell.addressLabel?.text = item["address"] as? String
    }
    func setBedsForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        let beds = item["beds"] as! Int
        cell.bedsLabel?.text = String(format:"%d", beds) as String
    }
    func setBathsForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        let baths = item["baths"] as! Double
        cell.bathsLabel?.text = String(format: "%.1f", baths) as String
    }
    func setSqfeetForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        cell.addressLabel?.text = item["sqfeet"] as? String
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 225.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        home = item
        performSegueWithIdentifier("individualHomeSegue", sender: self)
    }
    
    // called when a row deletion action is confirmed
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let homeObj = self.userHomes[indexPath.row] as PFObject
            deleteHomeObject(homeObj)
            
            self.userHomes.removeAtIndex(indexPath.row)
            homeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func deleteHomeObject(homeObject: PFObject) {
        
        homeObject.deleteInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("The object was deleted")
                
            } else {
                // There was a problem, check error.description
                print("error: %@", error)
            }
        }
    }
    
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        }
        
        delete.backgroundColor = model.darkOrangeColor
        return [delete]
    }*/
    
    // MARK:
    // MARK: Navigation
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "individualHomeSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! IndividualHomeViewController
            // your new view controller should have property that will store passed value
            viewController.homeObject = home
        }
    }
}
