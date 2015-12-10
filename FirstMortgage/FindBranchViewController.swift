//
//  FindBranchViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBook
import MapKit

class FindBranchViewController: UIViewController, CLLocationManagerDelegate {

    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    let addHomeView = UIView() as UIView
    
    var imageView = UIImageView() as UIImageView
    
    let locationManager = CLLocationManager()
    
    var currentLocation = CLLocation()
    var coords: CLLocationCoordinate2D?
    
    var dictionary = Dictionary<String, String>()
    
    var branchArray = [Branch]()
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        getBranchJson()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildView() {
        addHomeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        addHomeView.backgroundColor = lightGrayColor
        addHomeView.hidden = false
        self.view.addSubview(addHomeView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake((addHomeView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        imageView.image = fmcLogo
        addHomeView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        addHomeView.addSubview(whiteBar)
        
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
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        addHomeView.addSubview(activityIndicator)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
            currentLocation = locationManager.location!
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func getBranchJson() {
        
        let endpoint = NSURL(string: "http://www.trekkdev1.com/branch-json")
        let data = NSData(contentsOfURL: endpoint!)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            if let nodes = json as? NSArray {
                for node in nodes {
                    if let nodeDict = node as? NSDictionary {
                        let branch = Branch()
                        if let streetName = nodeDict["street"] as? String {
                            branch.address = streetName
                        }
                        if let city = nodeDict["city"] as? String {
                            branch.city = city
                        }
                        if let state = nodeDict["state"] as? String {
                            branch.state = state
                        }
                        if let phone = nodeDict["phone"] as? String {
                            branch.phone = cleanPhoneNumnerString(phone)
                        }
                        branchArray.append(branch)
                    }
                }
            }
            calcDistance()
        }
        catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    func calcDistance() {
        var count = 0;
        branchArray.removeAtIndex(0)
        branchArray.removeAtIndex(1)

        for branch in branchArray {
            if (count < 25) {
                let geocoder = CLGeocoder()
                let branchLocation = String(format: "%@, %@, USA", branch.address, branch.state)
                var distance = 0.0
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    geocoder.geocodeAddressString(branchLocation, completionHandler: {(placemarks, error) -> Void in
                        print(branchLocation)
                        if((error) != nil){
                            print("Geocoder Error", error)
                            count++
                        }
                        
                        if let placemark = placemarks?.first {
                            let lat = placemark.location!.coordinate.latitude
                            let long = placemark.location!.coordinate.longitude
                            
                            let clObj = CLLocation(latitude: lat, longitude: long)
                            distance = self.currentLocation.distanceFromLocation(clObj) / 1000
                            branch.distanceFromMe = distance
                            branch.lat = lat
                            branch.long = long
                            count++
                            print(count)
                            
                            if (count == self.branchArray.count) {
                                self.branchArray.sortInPlace({ $0.distanceFromMe < $1.distanceFromMe })
                                self.printLocations()
                            }
                        }
                    })
                }
            }
        }
    }
    
    func printLocations() {
        var yOffset = 15
        var count = 0
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 135.0, addHomeView.bounds.size.width, addHomeView.bounds.size.height - 135.0))
        addHomeView.addSubview(scrollView)
        
        for branch in branchArray {
            
            let branchView = UIView(frame: CGRectMake(15, CGFloat(yOffset), self.view.bounds.size.width - 30, 100))
            branchView.backgroundColor = UIColor.whiteColor()
            scrollView.addSubview(branchView)
            
            let addressLabel = UILabel (frame: CGRectMake(15, 10, branchView.bounds.size.width - 30, 24))
            addressLabel.textAlignment = NSTextAlignment.Left
            addressLabel.text = String(format: "%@", branch.address)
            addressLabel.numberOfLines = 1
            addressLabel.font = UIFont.boldSystemFontOfSize(22.0)
            branchView.addSubview(addressLabel)
            
            let cityStateLabel = UILabel (frame: CGRectMake(15, 35, branchView.bounds.size.width - 30, 24))
            cityStateLabel.textAlignment = NSTextAlignment.Left
            cityStateLabel.text = String(format: "%@, %@", branch.city, branch.state)
            cityStateLabel.numberOfLines = 1
            cityStateLabel.font = cityStateLabel.font.fontWithSize(18.0)
            cityStateLabel.sizeToFit()
            branchView.addSubview(cityStateLabel)
            
            let milesLabel = UILabel (frame: CGRectMake(15, 55, branchView.bounds.size.width - 30, 24))
            milesLabel.textAlignment = NSTextAlignment.Left
            milesLabel.text = String(format: "%.2f Miles", branch.distanceFromMe)
            milesLabel.numberOfLines = 1
            milesLabel.font = cityStateLabel.font.fontWithSize(18.0)
            milesLabel.sizeToFit()
            branchView.addSubview(milesLabel)
            
            let pl = (branch.phone.characters.count > 0) ? formatPhoneString(branch.phone) : ""
            let phoneLabel = UILabel (frame: CGRectMake(15, 75, branchView.bounds.size.width - 30, 24))
            phoneLabel.textAlignment = NSTextAlignment.Left
            phoneLabel.text = String(format: "%@", pl)
            phoneLabel.numberOfLines = 1
            phoneLabel.font = cityStateLabel.font.fontWithSize(18.0)
            phoneLabel.sizeToFit()
            branchView.addSubview(phoneLabel)
            
            let locationButton = UIButton(frame: CGRectMake(0, 0, branchView.bounds.size.width, 75))
            locationButton.addTarget(self, action: "mapButtonPressed:", forControlEvents: .TouchUpInside)
            locationButton.backgroundColor = UIColor.clearColor()
            locationButton.tag = count
            branchView.addSubview(locationButton)
            
            let btnEnabled = (branch.phone.characters.count > 0) ? true : false
            let phoneButton = UIButton(frame: CGRectMake(0, 75, branchView.bounds.size.width, 25))
            phoneButton.addTarget(self, action: "phoneButtonPressed:", forControlEvents: .TouchUpInside)
            phoneButton.backgroundColor = UIColor.clearColor()
            phoneButton.tag = count
            phoneButton.enabled = btnEnabled
            branchView.addSubview(phoneButton)
            
            yOffset += 110
            count++
        }
        
        scrollView.contentSize = CGSize(width: addHomeView.bounds.size.width, height: CGFloat(branchArray.count * 110))
        
        activityIndicator.stopAnimating()
    }
    
    // MARK:
    // MARK: - Utility Methods
    func cleanPhoneNumnerString(phoneNumber: String) -> String {
        let stringArray = phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        return newString
    }
    
    func formatPhoneString(phoneString: String) -> String {
        let areaCode = phoneString.substringWithRange(Range<String.Index>(start: phoneString.startIndex.advancedBy(0), end: phoneString.endIndex.advancedBy(-7)))
        let prefix = phoneString.substringWithRange(Range<String.Index>(start: phoneString.startIndex.advancedBy(3), end: phoneString.endIndex.advancedBy(-4)))
        let number = phoneString.substringWithRange(Range<String.Index>(start: phoneString.startIndex.advancedBy(6), end: phoneString.endIndex.advancedBy(0)))
        
        return String(format: "(%@) %@-%@", areaCode, prefix, number)
    }
    
    // MARK:
    // MARK: - Navigation
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func mapButtonPressed(sender: UIButton) {
        let branch = branchArray[sender.tag]
        openMapForPlace(branch)
    }
    
    func phoneButtonPressed(sender: UIButton) {
        let branch = branchArray[sender.tag]
        openPhoneApp(branch.phone)
    }
    
    func openMapForPlace(branch: Branch) {
        let coords = CLLocationCoordinate2DMake(branch.lat, branch.long)
        
        let address : [String : AnyObject] = [kABPersonAddressStreetKey as String: branch.address, kABPersonAddressCityKey as String: branch.city, kABPersonAddressStateKey as String: branch.state, kABPersonAddressCountryCodeKey as String: "US"]
        
        let place = MKPlacemark(coordinate: coords, addressDictionary: address)
        let mapItem = MKMapItem(placemark: place)
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    func openPhoneApp(phoneNumber: String) {
        print(phoneNumber)
        UIApplication.sharedApplication().openURL(NSURL(string: String(format: "tel://%@", phoneNumber))!)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
