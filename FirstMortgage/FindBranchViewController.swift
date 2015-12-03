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
        
        //creatStateDictionary()
        buildView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getBranchJson()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildView() {
        addHomeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width * 2, self.view.bounds.size.height))
        addHomeView.backgroundColor = lightGrayColor
        addHomeView.hidden = false
        self.view.addSubview(addHomeView)
        
        let fmcLogo = UIImage(named: "fmc_logo") as UIImage?
        // UIImageView
        imageView.frame = (frame: CGRectMake(40, 35, self.view.bounds.size.width - 80, 40))
        imageView.image = fmcLogo
        addHomeView.addSubview(imageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        addHomeView.addSubview(whiteBar)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 75, 45))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitle("Home", forState: .Normal)
        homeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
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
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized) {                currentLocation = locationManager.location!
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func getBranchJson() {
        
        let endpoint = NSURL(string: "http://fmc.dev.192.168.100.186.xip.io/branch-json")
        //let endpoint = NSURL(string: "http://www.trekkdev1.com/branch-json")
        let jsondata = NSData(contentsOfURL: endpoint!)
        
        //let jsondata = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(jsondata!, options: .AllowFragments)
            if let nodes = json as? NSDictionary {
                if let nodeArray = nodes["nodes"] as? NSArray {
                    for node in nodeArray {
                        if let nd = node as? NSDictionary {
                            if let n = nd["node"] as? NSDictionary {
                                if let checkState = n["State"] as? String {
                                    if (!checkState.isEmpty) {
                                        let branch = Branch()
                                        if let streetName = n["Street"] as? String {
                                            branch.address = streetName
                                        }
                                        if let city = n["City"] as? String {
                                            branch.city = city
                                        }
                                        if let state = n["State"] as? String {
                                            branch.state = state
                                        }
                                        branchArray.append(branch)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            print(branchArray.count)
            calcDistance()
        }
        catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    func calcDistance() {
        var count = 1;
        for branch in branchArray {
            let geocoder = CLGeocoder()
            let branchLocation = String(format: "%@, %@, USA", branch.address, branch.state)
            var distance = 0.0
            
            geocoder.geocodeAddressString(branchLocation, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
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
                    
                    if (count == self.branchArray.count) {
                        self.branchArray.sortInPlace({ $0.distanceFromMe < $1.distanceFromMe })
                        self.printLocations()
                    }
                }
            })
        }
    }
    
    func printLocations() {
        var yOffset = 15
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 135.0, addHomeView.bounds.size.width, addHomeView.bounds.size.height - 135.0))
        addHomeView.addSubview(scrollView)
        
        //for branch in branchArray {
        for i in 0...4 {
            let branch = branchArray[i]
            
            let addressLabel = UILabel (frame: CGRectMake(15, CGFloat(yOffset), self.view.bounds.size.width - 30, 24))
            addressLabel.textAlignment = NSTextAlignment.Left
            addressLabel.text = String(format: "%@", branch.address)
            addressLabel.numberOfLines = 1
            addressLabel.font = UIFont.boldSystemFontOfSize(24.0)
            addressLabel.sizeToFit()
            scrollView.addSubview(addressLabel)
            
            let cityStateLabel = UILabel (frame: CGRectMake(15, CGFloat(yOffset + 34), self.view.bounds.size.width - 30, 24))
            cityStateLabel.textAlignment = NSTextAlignment.Left
            cityStateLabel.text = String(format: "%@, %@", branch.city, branch.state)
            cityStateLabel.numberOfLines = 1
            cityStateLabel.font = cityStateLabel.font.fontWithSize(18.0)
            cityStateLabel.sizeToFit()
            scrollView.addSubview(cityStateLabel)
            
            let milesLabel = UILabel (frame: CGRectMake(15, CGFloat(yOffset + 58), self.view.bounds.size.width - 30, 24))
            milesLabel.textAlignment = NSTextAlignment.Left
            milesLabel.text = String(format: "%.2f Miles", branch.distanceFromMe)
            milesLabel.numberOfLines = 1
            milesLabel.font = cityStateLabel.font.fontWithSize(18.0)
            milesLabel.sizeToFit()
            scrollView.addSubview(milesLabel)
            
            let locationButton = UIButton(frame: CGRectMake(15, CGFloat(yOffset), self.view.bounds.size.width - 30, 100))
            locationButton.addTarget(self, action: "mapButtonPressed:", forControlEvents: .TouchUpInside)
            locationButton.backgroundColor = UIColor.clearColor()
            locationButton.tag = i
            scrollView.addSubview(locationButton)
            
            yOffset += 110
        }
        
        scrollView.contentSize = CGSize(width: addHomeView.bounds.size.width, height: 675)
        activityIndicator.stopAnimating()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func mapButtonPressed(sender: UIButton) {
        let branch = branchArray[sender.tag]
        openMapForPlace(branch)
    }
    
    func openMapForPlace(branch: Branch) {
        let coords = CLLocationCoordinate2DMake(branch.lat, branch.long)
        
        let address : [String : AnyObject] = [kABPersonAddressStreetKey as String: branch.address, kABPersonAddressCityKey as String: branch.city, kABPersonAddressStateKey as String: branch.state, kABPersonAddressCountryCodeKey as String: "US"]
        
        let place = MKPlacemark(coordinate: coords, addressDictionary: address)
        let mapItem = MKMapItem(placemark: place)
        mapItem.openInMapsWithLaunchOptions(nil)
    }
}
