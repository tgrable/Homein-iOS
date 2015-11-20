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
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    let greenColor = UIColor(red: 185/255, green: 190/255, blue: 71/255, alpha: 1)

    @IBOutlet weak var homeTableView: UITableView!
    let basicCellIdentifier = "BasicCell"
    
    let myHomesView = UIView()
    let sortTrayView = UIView()
    
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
        myHomesView.backgroundColor = lightGrayColor
        myHomesView.hidden = false
        self.view.addSubview(myHomesView)
        
        let fmcLogo = UIImage(named: "fmc_logo") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake(40, 35, self.view.bounds.size.width - 80, 40))
        imageView.image = fmcLogo
        myHomesView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        myHomesView.addSubview(whiteBar)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 75, 45))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitle("Back", forState: .Normal)
        homeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        // UIButton
        let addButton = UIButton (frame: CGRectMake(whiteBar.bounds.size.width - 75, 0, 75, 45))
        addButton.addTarget(self, action: "addNewHome:", forControlEvents: .TouchUpInside)
        addButton.setTitle("Add", forState: .Normal)
        addButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addButton.backgroundColor = UIColor.clearColor()
        addButton.tag = 0
        whiteBar.addSubview(addButton)
        
        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, myHomesView.bounds.size.width, 50))
        addHomeBannerView.backgroundColor = UIColor.blueColor()
        addHomeBannerView.hidden = false
        myHomesView.addSubview(addHomeBannerView)
        
        let labelFontSize = isSmallerScreen ? 20.0 : 24.0;
        
        // UIButton
        let sortButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        sortButton.addTarget(self, action: "showHideSortTray:", forControlEvents: .TouchUpInside)
        sortButton.setTitle(":", forState: .Normal)
        sortButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortButton.backgroundColor = UIColor.clearColor()
        sortButton.tag = 0
        addHomeBannerView.addSubview(sortButton)
        
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(65, 10, addHomeBannerView.bounds.size.width - 65, 0))
        bannerLabel.text = "MY HOMES"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bannerLabel.textAlignment = NSTextAlignment.Left
        bannerLabel.numberOfLines = 0
        bannerLabel.font = bannerLabel.font.fontWithSize(CGFloat(labelFontSize))
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.sizeToFit()
        addHomeBannerView.addSubview(bannerLabel)
    }
    
    func showSortTray() {
        sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 195))
        sortTrayView.backgroundColor = greenColor
        sortTrayView.hidden = false
        self.view.addSubview(sortTrayView)
        
        // UILabel
        let sortByLabel = UILabel(frame: CGRectMake(65, 10, sortTrayView.bounds.size.width - 65, 0))
        sortByLabel.text = "SORT BY"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sortByLabel.textAlignment = NSTextAlignment.Left
        sortByLabel.numberOfLines = 0
        sortByLabel.font = sortByLabel.font.fontWithSize(18)
        sortByLabel.textColor = UIColor.whiteColor()
        sortByLabel.sizeToFit()
        sortTrayView.addSubview(sortByLabel)
        
        let dividerView = UIView(frame: CGRectMake(15, 34, self.view.bounds.size.width - 30, 1))
        dividerView.backgroundColor = UIColor.whiteColor()
        dividerView.hidden = false
        sortTrayView.addSubview(dividerView)
        
        // UIButton
        let sortNameButton = UIButton (frame: CGRectMake(0, 40, sortTrayView.bounds.size.width, 40))
        sortNameButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortNameButton.setTitle("NAME", forState: .Normal)
        sortNameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortNameButton.backgroundColor = UIColor.clearColor()
        sortNameButton.titleLabel?.textAlignment = .Left
        sortNameButton.tag = 0
        sortTrayView.addSubview(sortNameButton)
        
        // UIButton
        let sortRatingButton = UIButton (frame: CGRectMake(0, 95, sortTrayView.bounds.size.width, 40))
        sortRatingButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortRatingButton.setTitle("RATING", forState: .Normal)
        sortRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortRatingButton.backgroundColor = UIColor.clearColor()
        sortRatingButton.titleLabel?.textAlignment = .Left
        sortRatingButton.tag = 0
        sortTrayView.addSubview(sortRatingButton)
        
        // UIButton
        let sortPriceButton = UIButton (frame: CGRectMake(0, 145, sortTrayView.bounds.size.width, 40))
        sortPriceButton.addTarget(self, action: "setSortOrder:", forControlEvents: .TouchUpInside)
        sortPriceButton.setTitle("PRICE", forState: .Normal)
        sortPriceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sortPriceButton.backgroundColor = UIColor.clearColor()
        sortPriceButton.titleLabel?.textAlignment = .Left
        sortPriceButton.tag = 0
        sortTrayView.addSubview(sortPriceButton)
    }

    func showHideSortTray(sender: UIButton) {
        if (!isSortTrayOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height - 195, self.view.bounds.size.width, 195))
                }, completion: {
                    (value: Bool) in
                    self.isSortTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.sortTrayView.frame = (frame: CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 195))
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
        cell.priceLabel?.text = String(format:"$%.2f", price) as String
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
