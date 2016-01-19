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
    let modelName = UIDevice.currentDevice().modelName

    //Reachability
    let reachability = Reachability()
    
    @IBOutlet weak var homeTableView: UITableView!
    let basicCellIdentifier = "BasicCell"
    
    let myHomesView = UIView()
    let sortTrayView = UIView()
    let dismissView = UIView()
    let sortTrayGradientLayer = CAGradientLayer()
    
    var imageView = UIImageView()
    var sortDirIcon = UIImageView()
    
    var isSmallerScreen = Bool()
    var isSortTrayOpen = Bool()
    var sortAscending = Bool()
    
    var sortNameAscending = Bool()
    var sortRatingAscending = Bool()
    var sortPriceAscending = Bool()
    
    var sortNameDirection = UIImageView()
    var sortRatingDirection = UIImageView()
    var sortPriceDirection = UIImageView()
    
    let sortDirectionButton = UIButton()
    let sortNameButton = UIButton ()
    let sortPriceButton = UIButton ()
    let sortRatingButton = UIButton ()
    
    let swipeRec = UISwipeGestureRecognizer()
    
    var sortCriteria = String()
    
    var alreadyDisplayedAlert = Bool()
    
    // Parse
    var userHomes = [PFObject]()
    var home: PFObject!
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        sortAscending = false
        sortNameAscending = false
        sortRatingAscending = false
        sortPriceAscending = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        sortCriteria = "createdAt"
        getAllHomesForUser(sortCriteria, sortDirection: sortAscending)
        buildView()
        
        showSortTray()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        homeTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit being called in MyHomesViewController")
        removeViews(self.view)
    }
    
    // MARK:
    // MARK: Build Views
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
        
        let backIcn = UIImage(named: "back_grey") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 30, 30))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)

        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        let addIcn = UIImage(named: "add_grey") as UIImage?
        let addIcon = UIImageView(frame: CGRectMake(whiteBar.bounds.size.width - 50, 12.5, 25, 25))
        addIcon.image = addIcn
        whiteBar.addSubview(addIcon)
        
        // UIButton
        let addButton = UIButton (frame: CGRectMake(whiteBar.bounds.size.width - 50, 0, 50, 50))
        addButton.addTarget(self, action: "addNewHome:", forControlEvents: .TouchUpInside)
        addButton.backgroundColor = UIColor.clearColor()
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

        let sortIcn = UIImage(named: "sort_icon") as UIImage?
        let sortIconView = UIImageView(frame: CGRectMake(10, 12.5, 25, 25))
        sortIconView.image = sortIcn
        addHomeBannerView.addSubview(sortIconView)
        
        // UIButton
        let sortButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        sortButton.addTarget(self, action: "showHideSortTray", forControlEvents: .TouchUpInside)
        sortButton.backgroundColor = UIColor.clearColor()
        sortButton.tag = 0
        addHomeBannerView.addSubview(sortButton)
        
        //UIImageView
        let homeIcn = UIImage(named: "home_icon") as UIImage?
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
        dismissView.frame = (frame: CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.height))
        dismissView.backgroundColor = model.lightGrayColor
        dismissView.alpha = 0.0
        dismissView.hidden = true
        self.view.addSubview(dismissView)
        
        sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200))
        sortTrayGradientLayer.frame = sortTrayView.bounds
        sortTrayGradientLayer.colors = [model.lightGreenColor.CGColor, model.darkGreenColor.CGColor]
        sortTrayView.layer.insertSublayer(sortTrayGradientLayer, atIndex: 0)
        sortTrayView.layer.addSublayer(sortTrayGradientLayer)
        sortTrayView.hidden = false
        self.view.addSubview(sortTrayView)
        
        // UILabel
        let sortByLabel = UILabel(frame: CGRectMake(15, 5, sortTrayView.bounds.size.width - 65, 0))
        sortByLabel.text = "SORT BY"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sortByLabel.textAlignment = NSTextAlignment.Left
        sortByLabel.numberOfLines = 0
        sortByLabel.font = UIFont(name: "forza-light", size: 25)
        sortByLabel.textColor = UIColor.whiteColor()
        sortByLabel.sizeToFit()
        sortTrayView.addSubview(sortByLabel)
        
        let dividerView = UIView(frame: CGRectMake(15, 37, self.view.bounds.size.width - 30, 1))
        dividerView.backgroundColor = UIColor.whiteColor()
        dividerView.hidden = false
        sortTrayView.addSubview(dividerView)
        
        let nameImage = UIImage(named: "home_icon") as UIImage?
        // UIImageView
        let nameImageView = UIImageView(frame: CGRectMake(15, 50, 30, 30))
        nameImageView.image = nameImage
        sortTrayView.addSubview(nameImageView)
        
        // UIButton
        sortNameButton.frame = (frame: CGRectMake(50, 45, sortTrayView.bounds.size.width - 50, 40))
        sortNameButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortNameButton.setTitle("NAME", forState: .Normal)
        sortNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortNameButton.backgroundColor = UIColor.clearColor()
        sortNameButton.contentHorizontalAlignment = .Left
        sortNameButton.tag = 0
        sortNameButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        sortTrayView.addSubview(sortNameButton)
        
        // UIImageView
        sortNameDirection.frame = (frame: CGRectMake(sortTrayView.bounds.size.width - 75, 40, 45, 45))
        sortNameDirection.image = UIImage(named: "expand_white") as UIImage?
        sortTrayView.addSubview(sortNameDirection)
        
        let starImage = UIImage(named: "Star_empty-01") as UIImage?
        // UIImageView
        let ratingImageView = UIImageView(frame: CGRectMake(15, 95, 30, 30))
        ratingImageView.image = starImage
        sortTrayView.addSubview(ratingImageView)
        
        // UIButton
        sortRatingButton.frame = (frame: CGRectMake(50, 90, sortTrayView.bounds.size.width - 50, 40))
        sortRatingButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortRatingButton.setTitle("RATING", forState: .Normal)
        sortRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortRatingButton.backgroundColor = UIColor.clearColor()
        sortRatingButton.contentHorizontalAlignment = .Left
        sortRatingButton.tag = 0
        sortRatingButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        sortTrayView.addSubview(sortRatingButton)
        
        // UIImageView
        sortRatingDirection.frame = (frame: CGRectMake(sortTrayView.bounds.size.width - 75, 85, 45, 45))
        sortRatingDirection.image = UIImage(named: "expand_white") as UIImage?
        sortTrayView.addSubview(sortRatingDirection)
        
        let priceImage = UIImage(named: "Money_icon-04") as UIImage?
        // UIImageView
        let priceImageView = UIImageView(frame: CGRectMake(15, 140, 30, 30))
        priceImageView.image = priceImage
        sortTrayView.addSubview(priceImageView)
        
        // UIButton
        sortPriceButton.frame = (frame: CGRectMake(50, 135, sortTrayView.bounds.size.width, 40))
        sortPriceButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortPriceButton.setTitle("PRICE", forState: .Normal)
        sortPriceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortPriceButton.backgroundColor = UIColor.clearColor()
        sortPriceButton.contentHorizontalAlignment = .Left
        sortPriceButton.tag = 0
        sortPriceButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        sortTrayView.addSubview(sortPriceButton)
        
        // UIImageView
        sortPriceDirection.frame = (frame: CGRectMake(sortTrayView.bounds.size.width - 75, 130, 45, 45))
        sortPriceDirection.image = UIImage(named: "expand_white") as UIImage?
        sortTrayView.addSubview(sortPriceDirection)
        
        let dismissSwipe = UISwipeGestureRecognizer()
        dismissSwipe.direction = UISwipeGestureRecognizerDirection.Down
        dismissSwipe.addTarget(self, action: "showHideSortTray")
        dismissView.userInteractionEnabled = true
        dismissView.addGestureRecognizer(dismissSwipe)
        
        swipeRec.direction = UISwipeGestureRecognizerDirection.Down
        swipeRec.addTarget(self, action: "showHideSortTray")
        sortTrayView.userInteractionEnabled = true
        sortTrayView.addGestureRecognizer(swipeRec)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "showHideSortTray")
        dismissView.addGestureRecognizer(tapGesture)
    }

    func showHideSortTray() {
        if (!isSortTrayOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.dismissView.hidden = false
                self.sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height - 175, self.view.bounds.size.width, 175))
                self.sortTrayGradientLayer.frame = self.sortTrayGradientLayer.bounds
                self.dismissView.alpha = 0.25
                }, completion: {
                    (value: Bool) in
                    self.isSortTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 175))
                self.sortTrayGradientLayer.frame = self.sortTrayGradientLayer.bounds
                self.dismissView.alpha = 0.0
                }, completion: {
                    (value: Bool) in
                    self.isSortTrayOpen = false
                    self.dismissView.hidden = true
            })
        }
    }
    
    func setSortOrder(sender: UIButton) {
        sortCriteria = (sender.titleLabel?.text)! as String
        
        switch sortCriteria {
        case "NAME":
            sortNameButton.setTitleColor(model.darkGrayColor, forState: .Normal)
            sortPriceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sortRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            if (sortNameAscending) {
                sortNameDirection.image = UIImage(named: "expand_white_up") as UIImage?
                getAllHomesForUser(sortCriteria.lowercaseString, sortDirection: sortNameAscending)
                sortNameAscending = false
            }
            else {
                sortNameDirection.image = UIImage(named: "expand_white") as UIImage?
                getAllHomesForUser(sortCriteria.lowercaseString, sortDirection: sortNameAscending)
                sortNameAscending = true
            }
            
        case "PRICE":
            sortNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sortPriceButton.setTitleColor(model.darkGrayColor, forState: .Normal)
            sortRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            if (sortPriceAscending) {
                sortPriceDirection.image = UIImage(named: "expand_white_up") as UIImage?
                getAllHomesForUser(sortCriteria.lowercaseString, sortDirection: sortPriceAscending)
                sortPriceAscending = false
            }
            else {
                sortPriceDirection.image = UIImage(named: "expand_white") as UIImage?
                getAllHomesForUser(sortCriteria.lowercaseString, sortDirection: sortPriceAscending)
                sortPriceAscending = true
            }
        case "RATING":
            sortNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sortPriceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sortRatingButton.setTitleColor(model.darkGrayColor, forState: .Normal)
            if (sortRatingAscending) {
                sortRatingDirection.image = UIImage(named: "expand_white_up") as UIImage?
                getAllHomesForUser(sortCriteria.lowercaseString, sortDirection: sortRatingAscending)
                sortRatingAscending = false
            }
            else {
                sortRatingDirection.image = UIImage(named: "expand_white") as UIImage?
                getAllHomesForUser(sortCriteria.lowercaseString, sortDirection: sortRatingAscending)
                sortRatingAscending = true
            }
        default:
            sortNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sortPriceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sortRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    }
    
    // MARK:
    // MARK: Parse Method
    func getAllHomesForUser(sortOrder: String, sortDirection: Bool) {
        sortAscending = sortDirection
        let query = PFQuery(className:"Home")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        if sortAscending {
            query.orderByAscending(sortOrder)
        }
        else {
            query.orderByDescending(sortOrder)
        }
        if self.reachability.isConnectedToNetwork() == false {
            query.fromLocalDatastore()
        }
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
                
                PFObject.pinAllInBackground(objects)
                
            } else {
                // Log details of the failure
                let alertController = UIAlertController(title: "HomeIn", message: String(format: "%@", error!.userInfo), preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
    
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
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
        setSqfeetForCell(cell, indexPath: indexPath)
        
        setRatingImage(cell, indexPath: indexPath)
        
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
                            cell.backgroundImage.contentMode = .ScaleAspectFill
                            cell.backgroundImage.clipsToBounds = true
                        }
                    }
                    else {
                        if self.alreadyDisplayedAlert != true {
                            let alertController = UIAlertController(title: "HomeIn", message: "There was an error downloading some of your images.", preferredStyle: .Alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                // ...
                            }
                            alertController.addAction(OKAction)
                            
                            self.presentViewController(alertController, animated: true) {
                                // ...
                            }
                            
                            self.alreadyDisplayedAlert = true
                        }
                        
                        item["imageArray"] = []
                        item.saveEventually()
                        
                        let fillerImage = UIImage(named: "default_home") as UIImage?
                        cell.backgroundImage?.image = fillerImage
                        cell.backgroundImage.contentMode = .ScaleAspectFill
                        cell.backgroundImage.clipsToBounds = true
                    }
                }
            }
            else {
                let fillerImage = UIImage(named: "default_home") as UIImage?
                cell.backgroundImage?.image = fillerImage
                cell.backgroundImage.contentMode = .ScaleAspectFill
                cell.backgroundImage.clipsToBounds = true
            }
        }
        else {
            let fillerImage = UIImage(named: "default_home") as UIImage?
            cell.backgroundImage?.image = fillerImage
            cell.backgroundImage.contentMode = .ScaleAspectFill
            cell.backgroundImage.clipsToBounds = true
        }
    }
    
    func setTitleForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        if let _ = item["name"] {
            cell.titleLabel?.text = item["name"] as? String
        }
        else {
            cell.titleLabel?.text = ""
        }
    }
    
    func setPriceForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        if let _ = item["price"] {
            let price = item["price"] as! Double
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            cell.priceLabel?.text = formatter.stringFromNumber(price)
        }
        else {
            cell.priceLabel?.text = "$0.00"
        }
    }
    
    func setAddressForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        if let _ = item["address"] {
            cell.addressLabel?.text = item["address"] as? String
        }
        else {
            cell.addressLabel?.text = ""
        }
    }
    
    func setBedsForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        if let _ = item["beds"] {
            let beds = item["beds"] as! Int
            cell.bedsLabel?.text = String(format:"%d", beds) as String
        }
        else {
            cell.bedsLabel?.text = String(format:"%d", 0) as String
        }
    }
    
    func setBathsForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        if let _ = item["baths"] {
            let baths = item["baths"] as! Double
            cell.bathsLabel?.text = String(format: "%.1f", baths) as String
        }
        else {
            cell.bathsLabel?.text = String(format: "%.1f", 0.0) as String
        }
        
    }
    
    func setSqfeetForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        if let _ = item["footage"] {
            let sqft = item["footage"] as! Int
            cell.sqfeetLabel?.text = String(format:"%d", sqft) as String
        }
        else {
            cell.sqfeetLabel?.text = String(format:"%d", 0) as String
        }
    }
    
    func setRatingImage(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let item = self.userHomes[row] as PFObject
        
        var rating = 0
        if let _ = item["rating"] {
            rating = item["rating"] as! Int
        }
        
        switch rating {
        case 0:
            cell.ratingView?.image = UIImage(named: "star-0")
        case 1:
            cell.ratingView?.image = UIImage(named: "star-1")
        case 2:
            cell.ratingView?.image = UIImage(named: "star-2")
        case 3:
            cell.ratingView?.image = UIImage(named: "star-3")
        case 4:
            cell.ratingView?.image = UIImage(named: "star-4")
        case 5:
            cell.ratingView?.image = UIImage(named: "star-5")
        default:
            cell.ratingView?.image = UIImage(named: "star-0")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //if (modelName.rangeOfString("iPad") != nil) {
        if (self.view.bounds.size.width >= 768) {
            return 450.0
        }
        else {
            return 225.0
        }
        
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
        homeObject.deleteEventually()
        
        let alertController = UIAlertController(title: "HomeIn", message: "The home was deleted", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    // MARK:
    // MARK: Navigation
    func navigateBackHome(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func addNewHome(sender: UIButton) {        
        let ahvc = self.storyboard!.instantiateViewControllerWithIdentifier("addHomeViewController") as! AddHomeViewController
        self.navigationController!.pushViewController(ahvc, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "individualHomeSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! IndividualHomeViewController
            // your new view controller should have property that will store passed value
            viewController.homeObject = home
        }
    }
    
    // MARK:
    // MARK: Memory Management
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }
}
