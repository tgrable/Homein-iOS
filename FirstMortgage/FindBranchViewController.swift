//
//  FindBranchViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import CoreLocation

class FindBranchViewController: UIViewController, CLLocationManagerDelegate {

    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    let addHomeView = UIView() as UIView
    
    var imageView = UIImageView() as UIImageView
    
    let locationManager = CLLocationManager()
    
    let currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
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
    }
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        locationManager.stopUpdatingLocation()
        
        /*//My location
        let myLocation = CLLocation(latitude: 59.244696, longitude: 17.813868)
        
        //My buddy's location
        let myBuddysLocation = CLLocation(latitude: 59.326354, longitude: 18.072310)
        
        //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distanceFromLocation(myBuddysLocation) / 1000
        
        //Display the result in km
        print(String(format: "The distance to my buddy is %.01fkm", distance))*/
 
        
        let address = "3322 Carolina Ave, IL, USA"
        let geocoder = CLGeocoder()
        
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let lat = placemark.location!.coordinate.latitude
                let long = placemark.location!.coordinate.longitude
                
                let clObj = CLLocation(latitude: lat, longitude: long)
                
                print(clObj)
            }
        })
        
        /*CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })*/
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        //print(placemark)
        
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
        print(placemark.location!.coordinate.longitude.description)
        print(placemark.location!.coordinate.latitude.description)
        
        /*print(placemark.locality ? placemark.locality : "")
        print(placemark.postalCode ? placemark.postalCode : "")
        print(placemark.administrativeArea ? placemark.administrativeArea : "")
        print(placemark.country ? placemark.country : "")*/
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
