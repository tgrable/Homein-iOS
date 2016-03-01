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
import Contacts
import Answers
import Crashlytics

class FindBranchViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK:
    // MARK: Properties    
    let model = Model()
    let modelName = UIDevice.currentDevice().modelName
    
    let addHomeView = UIView() as UIView
    let pickerView = UIView()
    
    let homeButton = UIButton ()
    
    var imageView = UIImageView() as UIImageView
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var coords: CLLocationCoordinate2D?

    var branchArray = Array<Dictionary<String, String>>()
    var filteredArray = Array<Dictionary<String, String>>()
    
    var stateArray = [String]()
    var stateDictionary = Dictionary<String, String>()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var isPickerTrayOpen = Bool() as Bool
    var stateToCheck = String() as String
    
    var stateLocatorTimer: NSTimer!
    var locationServicesIsAllowed = Bool()
    var timerHasFired = false
    var geoLocatorHasFired = false
    var didFireRunLocationSearch = false
    
    // UIPickerView
    let statesPicker = UIPickerView() as UIPickerView
    
    let reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"checkIfLocationServicesEnabled", name:UIApplicationWillEnterForegroundNotification, object:nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.objectForKey("branchOfficeArray") {
            stateArray = defaults.objectForKey("branchOfficeArray") as! Array<String>
        }
        
        print(stateArray)

        createStateDictionary()
        buildView()
        
        statesPicker.delegate = self
        statesPicker.dataSource = self
        
        checkIfLocationServicesEnabled()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationServicesIsAllowed == false {
            let alertController = UIAlertController(title: "HomeIn", message: "You must enable location services to use the feature of the app.", preferredStyle: .Alert)
            
            let SettingsAction = UIAlertAction(title: "Settings", style: .Default) { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            
            alertController.addAction(SettingsAction)
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit being called in FindBranchViewController")
        branchArray.removeAll()
        filteredArray.removeAll()
        stateArray.removeAll()
        stateDictionary.removeAll()
        removeViews(self.view)
        
        locationManager.stopUpdatingLocation()
    }
    
    func checkIfLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                locationServicesIsAllowed = true
            default:
                locationServicesIsAllowed = false
            }
        }
        
        if locationServicesIsAllowed {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10;
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            if didFireRunLocationSearch == false {
                runLocationSearch()
            }
        }
    }
    
    func runLocationSearch() {
        
        didFireRunLocationSearch = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = view.center
        addHomeView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        buildPickerViewTray()
        
        if reachability.isConnectedToNetwork() {
            stateLocatorTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "runTimedCode", userInfo: nil, repeats: false)
            
            getBranchJson()
        }
        else {
            let defaults = NSUserDefaults.standardUserDefaults()
            stateArray = defaults.objectForKey("branchOfficeArray") as! Array<String>
            branchArray = defaults.objectForKey("branchOfficeArrayDict") as! Array<Dictionary<String, String>>
            
            runTimedCode()
        }
    }
    
    func buildView() {
        addHomeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        addHomeView.backgroundColor = model.lightGrayColor
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
        
        let backIcn = UIImage(named: "back_grey") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 30, 30))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
        // UIButton
        homeButton.frame = (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)

        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, addHomeView.bounds.size.width, 50))
        let addHomeBannerGradientLayer = CAGradientLayer()
        addHomeBannerGradientLayer.frame = addHomeBannerView.bounds
        addHomeBannerGradientLayer.colors = [model.lightRedColor.CGColor, model.darkRedColor.CGColor]
        addHomeBannerView.layer.insertSublayer(addHomeBannerGradientLayer, atIndex: 0)
        addHomeBannerView.layer.addSublayer(addHomeBannerGradientLayer)
        addHomeBannerView.hidden = false
        addHomeView.addSubview(addHomeBannerView)
        
        //UIImageView
        let homeIcn = UIImage(named: "bank_icon") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((addHomeBannerView.bounds.size.width / 2) - (12.5 + 125), 12.5, 25, 25))
        homeIcon.image = homeIcn
        addHomeBannerView.addSubview(homeIcon)
        
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(15, 0, addHomeBannerView.bounds.size.width, 50))
        bannerLabel.text = "FIND A BRANCH"
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.font = UIFont(name: "forza-light", size: 25)
        addHomeBannerView.addSubview(bannerLabel)
    }
    
    func buildPickerViewTray() {
        pickerView.frame = (frame: CGRectMake(0, addHomeView.bounds.size.height, addHomeView.bounds.size.width, 450))
        pickerView.backgroundColor = UIColor.clearColor()
        addHomeView.addSubview(pickerView)
        
        var textLocation = 75 as CGFloat
        if modelName.rangeOfString("4s") != nil {
            textLocation = 160
        }
        
        // UILabel
        let messageLabel = UILabel(frame: CGRectMake(25, textLocation, addHomeView.bounds.size.width - 50, 0))
        messageLabel.text = "Please select a state from the list below to find a branch near you."
        messageLabel.font = UIFont(name: "forza-light", size: 25)
        messageLabel.textAlignment = NSTextAlignment.Left
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        pickerView.addSubview(messageLabel)
        
        // UIButton
        let selectButton = UIButton (frame: CGRectMake(addHomeView.bounds.size.width - 125, 250, 100, 50))
        selectButton.addTarget(self, action: "searchNewState:", forControlEvents: .TouchUpInside)
        selectButton.setTitle("SELECT", forState: .Normal)
        selectButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        selectButton.backgroundColor = UIColor.clearColor()
        selectButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        selectButton.contentHorizontalAlignment = .Right
        selectButton.tag = 0
        pickerView.addSubview(selectButton)
        
        // UIPickerView
        statesPicker.frame = (frame: CGRectMake(0, 300, pickerView.bounds.size.width, 150))
        statesPicker.backgroundColor = UIColor.whiteColor()
        statesPicker.tag = 0
        pickerView.addSubview(statesPicker)
    }
    
    func showHideSortTray() {
        if (!isPickerTrayOpen) {
            UIView.animateWithDuration(0.4, animations: {
                self.pickerView.frame = (frame: CGRectMake(0, self.addHomeView.bounds.size.height - 450, self.addHomeView.bounds.size.width, 450))
                }, completion: {
                    (value: Bool) in
                    self.isPickerTrayOpen = true
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.pickerView.frame = (frame: CGRectMake(0, self.addHomeView.bounds.size.height, self.addHomeView.bounds.size.width, 450))
                }, completion: {
                    (value: Bool) in
                    self.isPickerTrayOpen = false
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
            if let _ = locationManager.location {
                currentLocation = locationManager.location!
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }

    func getBranchJson() {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            var states = [String]()
            let endpoint = NSURL(string: "https://www.firstmortgageco.com/branch-json")
            let data = NSData(contentsOfURL: endpoint!)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if let nodes = json as? NSArray {
                    for node in nodes {
                        if let nodeDict = node as? NSDictionary {
                            var branch: [String:String] = [:]
                            
                            if let streetName = nodeDict["street"] as? String {
                                //branch!.address = streetName
                                branch["address"] = streetName
                            }
                            if let city = nodeDict["city"] as? String {
                                //branch!.city = city
                                branch["city"] = city
                            }
                            if let state = nodeDict["state"] as? String {
                                //branch!.state = state
                                branch["state"] = state
                            }
                            if let phone = nodeDict["phone"] as? String {
                                //branch!.phone = self.cleanPhoneNumnerString(phone)
                                branch["phone"] = self.cleanPhoneNumnerString(phone)
                            }
                            
                            if let nmls = nodeDict["nmls"] as? String {
                                branch["nmls"] = nmls
                            }
                            
                            branch["distanceFromMe"] = ""
                            branch["lat"] = ""
                            branch["long"] = ""
                            
                            self.branchArray.append(branch)
                            states.append(branch["state"]!)
                        }
                    }
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(self.branchArray, forKey: "branchOfficeArrayDict")
                }

                self.stateArray = self.removeDuplicates(states)
                self.getUsersAdministrativeArea()
            }
            catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                if value.characters.count == 2{
                    // Add value to the set.
                    encountered.insert(value)
                    // ... Append the value.
                    result.append(value)
                }
            }
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("branchOfficeArray")
        defaults.setObject(result, forKey: "branchOfficeArray")

        statesPicker.reloadAllComponents()
        
        return result
    }

    
    func getUsersAdministrativeArea() {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, e) -> Void in
            self.geoLocatorHasFired = true
            if self.timerHasFired == false {
                if let _ = placemarks?.last {
                    let placemark = placemarks!.last! as CLPlacemark
                    
                    if let _ = placemark.administrativeArea {
                        let state = placemark.administrativeArea

                        if (CLLocationManager.authorizationStatus() == .AuthorizedAlways || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
                            self.findBranchesInMyState(state!)
                        }
                        else {
                            self.geoLocatorHasFired = false
                        }
                    }
                    else {
                        self.geoLocatorHasFired = false
                    }
                }
                else {
                    self.geoLocatorHasFired = false
                }
            }
        })
    }

    func runTimedCode() {
        if stateArray.count > 0 {
            timerHasFired = true
            if geoLocatorHasFired == false {
                statesPicker.reloadAllComponents()
                activityIndicator.stopAnimating()
                showHideSortTray()
            }
        }
    }
    
    func findBranchesInMyState(state: String) {
        var filterStateArray = Array<Dictionary<String, String>>()
        for branch in branchArray {
            if  branch["state"] == state {
                filterStateArray.append(branch)
            }
        }
        
        if reachability.isConnectedToNetwork() {
            if (filterStateArray.count > 0) {
                calcDistance(filterStateArray)
            }
            else {
                activityIndicator.stopAnimating()

                statesPicker.reloadAllComponents()
                showHideSortTray()
            }
        }
        else {
            activityIndicator.stopAnimating()
            
            statesPicker.reloadAllComponents()
            showHideSortTray()
            printLocations(filterStateArray)
        }
    }
    
    func calcDistance(filteredBranchArray: Array<Dictionary<String, String>>) {
        var count = 0;
        
        var newBranchArray = Array<Dictionary<String, String>>()
        for var branch in filteredBranchArray {
            if (count < 25) {
                let geocoder = CLGeocoder()
                let branchLocation = String(format: "%@, %@, USA", branch["address"]!, branch["state"]!)
                var distance = 0.0
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    geocoder.geocodeAddressString(branchLocation, completionHandler: {(placemarks, error) -> Void in
                        if((error) != nil){
                            print("Geocoder Error", error)
                            count++
                        }
                        
                        if let placemark = placemarks?.first {
                            let lat = placemark.location!.coordinate.latitude
                            let long = placemark.location!.coordinate.longitude

                            let clObj = CLLocation(latitude: lat, longitude: long)
                            distance = self.currentLocation.distanceFromLocation(clObj) * 0.000621371;
                            
                            branch["distanceFromMe"] = String(format:"%f", distance)
                            branch["lat"] = String(format:"%f", lat)
                            branch["long"] = String(format:"%f", long)
                            count++
                            
                            newBranchArray.append(branch)
                            
                            if (count == filteredBranchArray.count) {
       
                                newBranchArray.sortInPlace({ Double($0["distanceFromMe"]!)! < Double($1["distanceFromMe"]!) })
                                
                                self.printLocations(newBranchArray)

                            }
                        }
                    })
                }
            }
        }
    }
    
    func printLocations(filteredBranchArray: Array<Dictionary<String, String>>) {
        filteredArray.removeAll()
        filteredArray = filteredBranchArray
        
        var yOffset = 15.0 as CGFloat
        var count = 0
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 185.0, addHomeView.bounds.size.width, addHomeView.bounds.size.height - 185.0))
        addHomeView.addSubview(scrollView)
        
        for branch in filteredBranchArray {
            var offset = 0.0 as CGFloat
            
            let branchView = UIView(frame: CGRectMake(15, yOffset, self.view.bounds.size.width - 30, 0))
            branchView.backgroundColor = UIColor.whiteColor()
            scrollView.addSubview(branchView)
            
            var address = ""
            if let _ = branch["address"] {
                address = branch["address"]!
            }
            let addressLabel = UILabel (frame: CGRectMake(15, 10, branchView.bounds.size.width - 30, 0))
            addressLabel.font = UIFont(name: "forza-light", size: 24)
            addressLabel.textAlignment = NSTextAlignment.Left
            addressLabel.text = String(format: "%@", address)
            addressLabel.numberOfLines = 0
            addressLabel.sizeToFit()
            branchView.addSubview(addressLabel)
            offset = addressLabel.bounds.size.height
            
            var city = ""
            if let _ = branch["city"] {
                city = branch["city"]!
            }
            var state = ""
            if let _ = branch["state"] {
                state = branch["state"]!
            }
            let cityStateLabel = UILabel (frame: CGRectMake(15, offset + 10, branchView.bounds.size.width - 30, 0))
            cityStateLabel.font = UIFont(name: "forza-light", size: 18)
            cityStateLabel.textAlignment = NSTextAlignment.Left
            cityStateLabel.text = String(format: "%@, %@", city, state)
            cityStateLabel.numberOfLines = 0
            cityStateLabel.sizeToFit()
            branchView.addSubview(cityStateLabel)
            offset += cityStateLabel.bounds.size.height
            
            if let _ = branch["distanceFromMe"] {
                let dist = branch["distanceFromMe"]! as String
                if dist.characters.count > 0 {
                    let milesLabel = UILabel (frame: CGRectMake(15, offset + 10, branchView.bounds.size.width - 30, 0))
                    milesLabel.font = UIFont(name: "forza-light", size: 18)
                    milesLabel.textAlignment = NSTextAlignment.Left
                    milesLabel.text = String(format: "%.01f Miles", Double(branch["distanceFromMe"]!)!)
                    milesLabel.numberOfLines = 0
                    milesLabel.sizeToFit()
                    branchView.addSubview(milesLabel)
                    offset += milesLabel.bounds.size.height
                    
                    let locationButton = UIButton(frame: CGRectMake(0, 0, branchView.bounds.size.width, offset))
                    locationButton.addTarget(self, action: "mapButtonPressed:", forControlEvents: .TouchUpInside)
                    locationButton.backgroundColor = UIColor.clearColor()
                    locationButton.tag = count
                    branchView.addSubview(locationButton)
                }
            }
            
            var pl = ""
            if let _ = branch["phone"] {
                if (branch["phone"]!.characters.count > 0) {
                    pl = formatPhoneString(branch["phone"]!)
                }
            }
            let phoneLabel = UILabel (frame: CGRectMake(15, offset + 10, branchView.bounds.size.width - 30, 0))
            phoneLabel.font = UIFont(name: "forza-light", size: 18)
            phoneLabel.textAlignment = NSTextAlignment.Left
            phoneLabel.text = String(format: "%@", pl)
            phoneLabel.numberOfLines = 0
            phoneLabel.sizeToFit()
            phoneLabel.textColor = model.darkBlueColor
            branchView.addSubview(phoneLabel)
            offset += phoneLabel.bounds.size.height
            
            var nmls = ""
            if let _ = branch["nmls"] {
                if (branch["nmls"]!.characters.count > 0) {
                    nmls = branch["nmls"]!
                }
            }
            let nmlsLabel = UILabel (frame: CGRectMake(15, offset + 10, branchView.bounds.size.width - 30, 0))
            nmlsLabel.font = UIFont(name: "forza-light", size: 18)
            nmlsLabel.textAlignment = NSTextAlignment.Left
            nmlsLabel.text = String(format: "%@", nmls)
            nmlsLabel.numberOfLines = 0
            nmlsLabel.sizeToFit()
            branchView.addSubview(nmlsLabel)
            offset += nmlsLabel.bounds.size.height
            
            branchView.frame = CGRectMake(15, yOffset, self.view.bounds.size.width - 30, offset + 20)
            
            let shadowImg = UIImage(named: "Long_shadow") as UIImage?
            // UIImageView
            let shadowView = UIImageView(frame: CGRectMake(15, yOffset + offset + 20, branchView.bounds.size.width, 15))
            shadowView.image = shadowImg
            scrollView.addSubview(shadowView)
            
            var btnEnabled = false
            if let _ = branch["phone"] {
                if (branch["phone"]!.characters.count > 0) {
                    btnEnabled = true
                }
            }
            let phoneButton = UIButton(frame: CGRectMake(12, offset - 27, branchView.bounds.size.width / 2, 20))
            phoneButton.addTarget(self, action: "phoneButtonPressed:", forControlEvents: .TouchUpInside)
            phoneButton.backgroundColor = UIColor.clearColor()
            phoneButton.tag = count
            phoneButton.enabled = btnEnabled
            branchView.addSubview(phoneButton)
            
            yOffset += offset + 30
            count++
        }

        scrollView.contentSize = CGSize(width: addHomeView.bounds.size.width, height: CGFloat(filteredBranchArray.count * 135))
        
        activityIndicator.stopAnimating()
    }
    
    // MARK:
    // MARK: - Action Methods
    func searchNewState(sender: UIButton) {
        
        /*************************** Fabric Analytics *********************************************/
                Answers.logCustomEventWithName("User_Search_State_Manually", customAttributes: ["Category":"User_Action"])
                print("User_Search_State_Manually")
        /************************* End Fabric Analytics *******************************************/
        
        findBranchesInMyState(stateToCheck)
        
        statesPicker.reloadAllComponents()
        showHideSortTray()
    }
    
    // MARK:
    // MARK: - Navigation
    func navigateBackHome(sender: UIButton) {
        homeButton.enabled = false
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func mapButtonPressed(sender: UIButton) {
        let branch = filteredArray[sender.tag]
        openMapForPlace(branch)
    }
    
    func phoneButtonPressed(sender: UIButton) {
        let branch = self.filteredArray[sender.tag]
        
        let alertController = UIAlertController(title: "HomeIn", message: String(format: "Call %@", formatPhoneString(branch["phone"]!)), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.openPhoneApp(branch["phone"]!)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func openMapForPlace(branch: [String:String]) {
        let coords = CLLocationCoordinate2DMake(Double(branch["lat"]!)!, Double(branch["long"]!)!)
        
        let address : [String : AnyObject] = [CNPostalAddressStreetKey as String: branch["address"]!, CNPostalAddressCityKey as String: branch["city"]!, CNPostalAddressStateKey as String: branch["state"]!, CNPostalAddressCountryKey as String: "US"]
        
        let place = MKPlacemark(coordinate: coords, addressDictionary: address)
        let mapItem = MKMapItem(placemark: place)
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    func openPhoneApp(phoneNumber: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: String(format: "tel://%", phoneNumber))!)
    }
    
    // MARK:
    // MARK: UIPickerView Delegate and Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if stateArray.count > 0 {
            return stateArray.count
        }
        else {
            let defaults = NSUserDefaults.standardUserDefaults()
            var defaultsStateArray = [String]()
            if let _ = defaults.objectForKey("branchOfficeArray") {
                defaultsStateArray = defaults.objectForKey("branchOfficeArray") as! Array<String>
            }
            return defaultsStateArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if stateArray.count > 0 {
            let stateFullName = stateDictionary[stateArray[row]]
            return stateFullName
        }
        else {

            let defaults = NSUserDefaults.standardUserDefaults()
            var defaultsStateArray = [String]()
            defaultsStateArray = defaults.objectForKey("branchOfficeArray") as! Array<String>
            let stateFullName = stateDictionary[defaultsStateArray[row]]
            return stateFullName
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if stateArray.count > 0 {
            stateToCheck = stateArray[row]
        }
    }
    
    // MARK:
    // MARK: - Utility Methods
    func cleanPhoneNumnerString(phoneNumber: String) -> String {
        let stringArray = phoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        return newString
    }
    
    func formatPhoneString(phoneString: String) -> String {
        let stringArray = phoneString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        let finalString = cleanPhoneNumnerString(newString)
        
        let areaCode = finalString.substringWithRange(Range<String.Index>(start: finalString.startIndex.advancedBy(0), end: finalString.endIndex.advancedBy(-7)))
        let prefix = finalString.substringWithRange(Range<String.Index>(start: finalString.startIndex.advancedBy(3), end: finalString.endIndex.advancedBy(-4)))
        let number = finalString.substringWithRange(Range<String.Index>(start: finalString.startIndex.advancedBy(6), end: finalString.endIndex.advancedBy(0)))
        
        return String(format: "(%@) %@-%@", areaCode, prefix, number)
    }
    
    func createStateDictionary() {
        stateDictionary = [
            "AL":"Alabama",
            "AK":"Alaska",
            "AZ":"Arizona",
            "AR":"Arkansas",
            "CA":"California",
            "CO":"Colorado",
            "CT":"Connecticut",
            "DE":"Delaware",
            "DC":"District of Columbia",
            "FL":"Florida",
            "GA":"Georgia",
            "HI":"Hawaii",
            "ID":"Idaho",
            "IL":"Illinois",
            "IN":"Indiana",
            "IA":"Iowa",
            "KS":"Kansas",
            "KY":"Kentucky",
            "LA":"Louisiana",
            "ME":"Maine",
            "MD":"Maryland",
            "MA":"Massachusetts",
            "MI":"Michigan",
            "MN":"Minnesota",
            "MS":"Mississippi",
            "MO":"Missouri",
            "MT":"Montana",
            "NE":"Nebraska",
            "NV":"Nevada",
            "NH":"New Hampshire",
            "NJ":"New Jersey",
            "NM":"New Mexico",
            "NY":"New York",
            "NC":"North Carolina",
            "ND":"Dorth Dakota",
            "OH":"Ohio",
            "OK":"Oklahoma",
            "OR":"Oregon",
            "PA":"Pennsylvania",
            "RI":"Rhode Island",
            "SC":"South Carolina",
            "SD":"South Dakota",
            "TN":"Tennessee",
            "TX":"Texas",
            "UT":"Utah",
            "VT":"Vermont",
            "VA":"Virginia",
            "WA":"Washington",
            "WV":"West Virginia",
            "WI":"Wisconsin",
            "WY":"Wyoming",
        ]
        stateToCheck = "AZ"
    }

    // MARK:
    // MARK: Memory Management
    func removeViews(views: UIView) {
        for view in views.subviews {
            view.removeFromSuperview()
        }
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
