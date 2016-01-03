//
//  AddHomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class AddHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    // MARK:
    // MARK: Properties
    
    let model = Model()
    let addHomeView = UIView()
    let overlayView = UIView()
    
    // UIScrollView
    let scrollView = UIScrollView()
    
    // UITextField
    let homeNameTxtField = UITextField()
    let homePriceTxtField = UITextField()
    let homeAddressTxtField = UITextField()
    let bedsTxtField = UITextField()
    let bathsTxtField = UITextField()
    let sqFeetTxtField = UITextField()
    var userRating = Int()
    
    // UITextField
    let descTxtView = UITextView()
    
    let hideKeyboardButton = UIButton()
    let saveButton = UIButton ()
    
    var intComponent = 2.0
    var decComponent = 0.0
    var bathRoomDefault = 0.0
    
    // UIImagePickerController
    let picker = UIImagePickerController()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var imageView = UIImageView()
    var img = UIImage()
    
    var ratingDefault = 0
    
    var logoImageView = UIImageView()
    
    var isSmallerScreen = Bool()
    var cameFromHomeScreen = Bool()
    
    var imageArray: [PFFile] = []
    var ratingButtonArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        
        picker.delegate = self
        
        bathRoomDefault = intComponent + decComponent
        
        isSmallerScreen = false
        if (self.view.bounds.size.width == 320) {
            isSmallerScreen = true
        }
        print("AddHomeViewController cameFromHomeScreen: ", cameFromHomeScreen)
        
        buildView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildView() {
        addHomeView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        addHomeView.backgroundColor = model.lightGrayColor
        addHomeView.hidden = false
        self.view.addSubview(addHomeView)
        
        let fmcLogo = UIImage(named: "home_in") as UIImage?
        // UIImageView
        let logoImageView = UIImageView(frame: CGRectMake((addHomeView.bounds.size.width / 2) - 79.5, 25, 159, 47.5))
        logoImageView.image = fmcLogo
        addHomeView.addSubview(logoImageView)
        
        let whiteBar = UIView(frame: CGRectMake(0, 85, self.view.bounds.size.width, 50))
        whiteBar.backgroundColor = UIColor.whiteColor()
        addHomeView.addSubview(whiteBar)

        let backIcn = UIImage(named: "backbutton_icon") as UIImage?
        let backIcon = UIImageView(frame: CGRectMake(20, 10, 12.5, 25))
        backIcon.image = backIcn
        whiteBar.addSubview(backIcon)
        
        // UIButton
        let homeButton = UIButton (frame: CGRectMake(0, 0, 50, 50))
        homeButton.addTarget(self, action: "navigateBackHome:", forControlEvents: .TouchUpInside)
        homeButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.tag = 0
        whiteBar.addSubview(homeButton)
        
        // UIButton
        hideKeyboardButton.frame = (frame: CGRectMake(whiteBar.bounds.size.width - 50, 5, 40, 40))
        hideKeyboardButton.addTarget(self, action: "tapGesture", forControlEvents: .TouchUpInside)
        hideKeyboardButton.setImage(UIImage(named: "hide_keyboard"), forState: .Normal)
        hideKeyboardButton.backgroundColor = UIColor.clearColor()
        hideKeyboardButton.tag = 0
        hideKeyboardButton.enabled = false
        hideKeyboardButton.alpha = 0
        whiteBar.addSubview(hideKeyboardButton)
        
        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, addHomeView.bounds.size.width, 50))
        let addHomeBannerGradientLayer = CAGradientLayer()
        addHomeBannerGradientLayer.frame = addHomeBannerView.bounds
        addHomeBannerGradientLayer.colors = [model.lightBlueColor.CGColor, model.darkBlueColor.CGColor]
        addHomeBannerView.layer.insertSublayer(addHomeBannerGradientLayer, atIndex: 0)
        addHomeBannerView.layer.addSublayer(addHomeBannerGradientLayer)
        addHomeBannerView.hidden = false
        addHomeView.addSubview(addHomeBannerView)
        
        let labelFontSize = isSmallerScreen ? 20.0 : 24.0;
        
        //UIImageView
        let homeIcn = UIImage(named: "icn-firstTime") as UIImage?
        let homeIcon = UIImageView(frame: CGRectMake((addHomeBannerView.bounds.size.width / 2) - (12.5 + 100), 12.5, 25, 25))
        homeIcon.image = homeIcn
        addHomeBannerView.addSubview(homeIcon)
        
        // UILabel
        let bannerLabel = UILabel(frame: CGRectMake(0, 0, addHomeBannerView.bounds.size.width, 50))
        bannerLabel.text = "ADD A HOME"
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.font = bannerLabel.font.fontWithSize(CGFloat(labelFontSize))
        bannerLabel.textColor = UIColor.whiteColor()
        bannerLabel.font = UIFont(name: "forza-light", size: 25)
        addHomeBannerView.addSubview(bannerLabel)
        
        scrollView.frame = (frame: CGRectMake(0, 185, addHomeView.bounds.size.width, addHomeView.bounds.size.height - 135))
        scrollView.backgroundColor = UIColor.clearColor()
        addHomeView.addSubview(scrollView)
        
        let cameraImage = UIImage(named: "camera_icon") as UIImage?
        // UIImageView
        imageView.frame = ( frame: CGRectMake((scrollView.bounds.size.width / 2) - 62.5, 59, 135, 118))
        imageView.image = cameraImage
        scrollView.addSubview(imageView)
        
        // UIButton
        let addHomePhotoButton = UIButton (frame: CGRectMake((scrollView.bounds.size.width / 2) - 125, 25, 250, 175))
        addHomePhotoButton.addTarget(self, action: "selectWhereToGetImage:", forControlEvents: .TouchUpInside)
        addHomePhotoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addHomePhotoButton.backgroundColor = UIColor.clearColor()
        addHomePhotoButton.layer.borderWidth = 1.0
        addHomePhotoButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        addHomePhotoButton.tag = 0
        scrollView.addSubview(addHomePhotoButton)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        
        // UITextField
        homeNameTxtField.frame = (frame: CGRectMake(10, 210, addHomeView.bounds.size.width - 20, 40))
        homeNameTxtField.attributedPlaceholder = NSAttributedString(string: "NAME YOUR HOME", attributes:attributes)
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.returnKeyType = .Next
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        homeNameTxtField.font = UIFont(name: "forza-light", size: 22)
        scrollView.addSubview(homeNameTxtField)
        
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 250, addHomeView.bounds.size.width - 20, 40))
        homePriceTxtField.attributedPlaceholder = NSAttributedString(string: "$Price", attributes:attributes)
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Next
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        homePriceTxtField.font = UIFont(name: "forza-light", size: 22)
        scrollView.addSubview(homePriceTxtField)
        
        let starImage = UIImage(named: "star_off_icon") as UIImage?
        var xOffset = 0
        for i in 1...5 {
            // UIButton
            let ratingButton = UIButton (frame: CGRectMake(CGFloat(10 + xOffset), 290, 35, 35))
            ratingButton.addTarget(self, action: "setRating:", forControlEvents: .TouchUpInside)
            ratingButton.backgroundColor = model.darkBlueColor
            ratingButton.setImage(starImage, forState: .Normal)
            ratingButton.tag = i
            scrollView.addSubview(ratingButton)
            
            ratingButtonArray.append(ratingButton)
            
            xOffset += 40
        }
        
        let dividerView = UIView(frame: CGRectMake(10, 335, addHomeView.bounds.size.width - 20, 1))
        dividerView.backgroundColor = UIColor.darkGrayColor()
        dividerView.hidden = false
        scrollView.addSubview(dividerView)
        
        let bed = "4"
        let attributedHomeBed = NSMutableAttributedString(
            string: bed,
            attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 14.0)!])
        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(15, 345, (scrollView.bounds.size.width / 3) - 10, 30))
        bedsTxtField.attributedPlaceholder = attributedHomeBed
        bedsTxtField.backgroundColor = UIColor.clearColor()
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Next
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
        bedsTxtField.font = UIFont(name: "Arial", size: 12)
        scrollView.addSubview(bedsTxtField)
        
        let bedsLabel = UILabel(frame: CGRectMake(15, 370, (scrollView.bounds.size.width / 3) - 10, 30))
        bedsLabel.text = "Beds"
        bedsLabel.textAlignment = NSTextAlignment.Left
        bedsLabel.numberOfLines = 1
        bedsLabel.font = UIFont(name: "Arial", size: 14)
        bedsLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(bedsLabel)
        
        let vertDividerTwoView = UIView(frame: CGRectMake(scrollView.bounds.size.width / 3, 345, 1, 50))
        vertDividerTwoView.backgroundColor = UIColor.darkGrayColor()
        vertDividerTwoView.hidden = false
        scrollView.addSubview(vertDividerTwoView)
        
        let bath = "2.5"
        let attributedHomeBath = NSMutableAttributedString(
            string: bath,
            attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 14.0)!])
        
        // UITextField
        bathsTxtField.frame = (frame: CGRectMake((scrollView.bounds.size.width / 3) + 10, 345, (scrollView.bounds.size.width / 3) - 10, 30))
        bathsTxtField.attributedPlaceholder = attributedHomeBath
        bathsTxtField.backgroundColor = UIColor.clearColor()
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Next
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
        bathsTxtField.font = UIFont(name: "Arial", size: 12)
        scrollView.addSubview(bathsTxtField)
        
        let bathsLabel = UILabel(frame: CGRectMake((scrollView.bounds.size.width / 3) + 10, 370, (scrollView.bounds.size.width / 3) - 10, 30))
        bathsLabel.text = "Baths"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bathsLabel.textAlignment = NSTextAlignment.Left
        bathsLabel.numberOfLines = 1
        bathsLabel.font = UIFont(name: "Arial", size: 14)
        bathsLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(bathsLabel)
        
        let vertDividerThreeView = UIView(frame: CGRectMake(scrollView.bounds.size.width * 0.66, 345, 1, 50))
        vertDividerThreeView.backgroundColor = UIColor.darkGrayColor()
        vertDividerThreeView.hidden = false
        scrollView.addSubview(vertDividerThreeView)
        
        let sqft = "2400"
        let attributedHomeSqft = NSMutableAttributedString(
            string: sqft,
            attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 14.0)!])
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake((scrollView.bounds.size.width * 0.66) + 10, 345, (scrollView.bounds.size.width / 3) - 10, 30))
        sqFeetTxtField.attributedPlaceholder = attributedHomeSqft
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Next
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
        sqFeetTxtField.font = UIFont(name: "Arial", size: 12)
        scrollView.addSubview(sqFeetTxtField)
        
        let sqFeetLabel = UILabel(frame: CGRectMake((scrollView.bounds.size.width * 0.66) + 10, 370, (scrollView.bounds.size.width / 3) - 10, 30))
        sqFeetLabel.text = "Sq. Ft."
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sqFeetLabel.textAlignment = NSTextAlignment.Left
        sqFeetLabel.numberOfLines = 1
        sqFeetLabel.font = UIFont(name: "Arial", size: 14)
        sqFeetLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(sqFeetLabel)

        //UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, 410, addHomeView.bounds.size.width - 20, 40))
        homeAddressTxtField.attributedPlaceholder = NSAttributedString(string: "ADDRESS", attributes:attributes)
        homeAddressTxtField.backgroundColor = UIColor.clearColor()
        homeAddressTxtField.delegate = self
        homeAddressTxtField.returnKeyType = .Next
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        homeAddressTxtField.font = UIFont(name: "forza-light", size: 22)
        scrollView.addSubview(homeAddressTxtField)
        
        //Create textview
        descTxtView.frame = (frame : CGRectMake(10, 450, addHomeView.bounds.size.width - 20, 220))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.autocorrectionType = .Yes
        descTxtView.returnKeyType = .Done
        descTxtView.textColor = UIColor.lightGrayColor()
        descTxtView.text = "Add notes about this house."
        descTxtView.delegate = self
        descTxtView.font = UIFont(name: "forza-light", size: 22)
        scrollView.addSubview(descTxtView)
        
        // UIView
        let saveView = UIView(frame: CGRectMake(15, 695, scrollView.bounds.size.width - 30, 50))
        let saveGradientLayer = CAGradientLayer()
        saveGradientLayer.frame = saveView.bounds
        saveGradientLayer.colors = [model.lightOrangeColor.CGColor, model.darkOrangeColor.CGColor]
        saveView.layer.insertSublayer(saveGradientLayer, atIndex: 0)
        saveView.layer.addSublayer(saveGradientLayer)
        scrollView.addSubview(saveView)
        
        // UIButton
        saveButton.frame = (frame: CGRectMake(0, 0, saveView.bounds.size.width, saveView.bounds.size.height))
        saveButton.addTarget(self, action: "addNewHome:", forControlEvents: .TouchUpInside)
        saveButton.setTitle("SAVE HOME", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.backgroundColor = UIColor.clearColor()
        saveButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        saveButton.contentHorizontalAlignment = .Center
        saveButton.tag = 0
        saveView.addSubview(saveButton)
        
        let btnImg = UIImage(named: "right_shadow") as UIImage?
        // UIImageView
        let btnView = UIImageView(frame: CGRectMake(0, saveView.bounds.size.height, saveView.bounds.size.width, 15))
        btnView.image = btnImg
        saveView.addSubview(btnView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        scrollView.addGestureRecognizer(tapGesture)
        
        overlayView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        overlayView.backgroundColor = UIColor.darkGrayColor()
        overlayView.alpha = 0.85
        overlayView.hidden = true
        self.view.addSubview(overlayView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = view.center
        overlayView.addSubview(activityIndicator)
        
        scrollView.contentSize = CGSize(width: addHomeView.bounds.size.width, height: 815)
    }
    
    func tapGesture() {
        homeNameTxtField.resignFirstResponder()
        homePriceTxtField.resignFirstResponder()
        homeAddressTxtField.resignFirstResponder()
        bedsTxtField.resignFirstResponder()
        bathsTxtField.resignFirstResponder()
        sqFeetTxtField.resignFirstResponder()
        descTxtView.resignFirstResponder()
    }
    
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.homeNameTxtField {
            self.homePriceTxtField.becomeFirstResponder()
        }
        else if textField == self.homeAddressTxtField {
            self.descTxtView.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == homeNameTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 165
                }, completion: nil)
        }
        else if textField == homePriceTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 215
                }, completion: nil)
        }
        else if textField == bedsTxtField || textField == bathsTxtField || textField == sqFeetTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 315
                }, completion: nil)
        }
        else if textField == homeAddressTxtField {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.y = 365
                }, completion: nil)
        }
        
        return true
    }
    
    // MARK:
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.4, animations: {
            self.scrollView.contentOffset.y = 415
            }, completion: nil)
        
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add notes about this house."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    //MARK:
    //MARK: UIImagePickerController Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            imageView.frame = (frame: CGRectMake((scrollView.bounds.size.width / 2) - 125, 25, 250, 175))
            img = pickedImage
            //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                self.img = self.scaleImagesForParse(self.img)
                let imageData = UIImagePNGRepresentation(self.img)
                if (imageData != nil) {
                    let imageFile = PFFile(name:"image.png", data:imageData!)
                    self.imageArray.append(imageFile!)
                }
            //}

            if (picker.sourceType.rawValue == 1) {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
        }
        else {
            print(info)
            print(picker.sourceType.rawValue)
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        var msg = String()
        if (self.imageArray.count > 1) {
            msg = String(format: "You now have %d images associated with this house.", self.imageArray.count)
        }
        else {
            msg = String(format: "You now have %d image associated with this house.", self.imageArray.count)
        }
        
        let alertController = UIAlertController(title: "HomeIn", message: msg, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scaleImagesForParse(img: UIImage) -> UIImage {
        let size = CGSizeApplyAffineTransform(img.size, CGAffineTransformMakeScale(0.33, 0.33))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        img.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    func selectWhereToGetImage(sender: UIButton) {
        tapGesture()
        
        let photoLibActionHandler = { (action:UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        
        let cameraActionHandler = { (action:UIAlertAction!) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraCaptureMode = .Photo
            self.picker.modalPresentationStyle = .FullScreen
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        
        let imageAlertController = UIAlertController(title: "Please select what you would like to do.", message: "", preferredStyle: .ActionSheet)
        let photoLibAction = UIAlertAction(title: "Photo Library", style: .Default, handler: photoLibActionHandler)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: cameraActionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        imageAlertController.addAction(photoLibAction)
        imageAlertController.addAction(cameraAction)
        imageAlertController.addAction(cancelAction)
        presentViewController(imageAlertController, animated: true, completion: nil)
    }
    
    func addNewHome(sender: UIButton) {
        if (self.homeNameTxtField.text != "") {
            saveButton.enabled = false
            overlayView.hidden = false
            activityIndicator.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let home = PFObject(className: "Home")
                
                home["user"] = PFUser.currentUser()
                home["name"] = (self.homeNameTxtField.text != "") ? self.homeNameTxtField.text : "Home"
                home["price"] = (self.homePriceTxtField.text != "") ? Double(self.homePriceTxtField.text!) : 0
                home["address"] = (self.homeAddressTxtField.text != "") ? self.homeAddressTxtField.text : ""
                home["beds"] = (self.bedsTxtField.text != "") ? Double(self.bedsTxtField.text!) : 0
                home["baths"] = (self.bathsTxtField.text != "") ? Double(self.bathsTxtField.text!) : 0
                home["footage"] = (self.sqFeetTxtField.text != "") ? Double(self.sqFeetTxtField.text!) : 0
                home["rating"] = self.ratingDefault
                home["desc"] = (self.descTxtView.text != "") ? self.descTxtView.text : "Default home description"
                home["imageArray"] = self.imageArray
                
                home.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        print("The object was saved")
                        self.homeNameTxtField.text = ""
                        self.homePriceTxtField.text = ""
                        self.homeAddressTxtField.text = ""
                        self.sqFeetTxtField.text = ""
                        self.descTxtView.text = ""
                        self.imageView.image = nil
                        
                        for i in 0...4 {
                            let button = self.ratingButtonArray[i] as UIButton
                            button.setImage(UIImage(named: "star_off_icon"), forState: .Normal)
                        }
                        
                        self.activityIndicator.stopAnimating()
                        
                        let alertController = UIAlertController(title: "HomeIn", message: "This house has been added.", preferredStyle: .Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            self.overlayView.hidden = true
                            if (self.cameFromHomeScreen) {
                                self.navigationController?.popViewControllerAnimated(true)
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                            else {
                                self.performSegueWithIdentifier("addHomeToTableView", sender: nil)
                            }
                        }
                        alertController.addAction(OKAction)
                        
                        self.presentViewController(alertController, animated: true) {
                            // ...
                        }
                        
                    }
                    else {
                        print("The object was not saved")
                    }
                }
            }
        }
        else {
            let alertController = UIAlertController(title: "HomeIn", message: "Please enter a name for this home.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
    }

    func setRating(sender: UIButton) {
        tapGesture()
        
        UIView.animateWithDuration(0.4, animations: {
            self.scrollView.contentOffset.y = 265
            }, completion: nil)
        
        ratingDefault = sender.tag
        for i in 0...4 {
            let button = ratingButtonArray[i] as UIButton
            if i < sender.tag {
                button.setImage(UIImage(named: "star_on_icon"), forState: .Normal)
            }
            else {
                button.setImage(UIImage(named: "star_off_icon"), forState: .Normal)
            }
        }
    }
    
    func keyboardWillAppear(notification: NSNotification){
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 1050)
        hideKeyboardButton.enabled = true
        hideKeyboardButton.alpha = 1.0
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 815)
        hideKeyboardButton.enabled = false
        hideKeyboardButton.alpha = 0.0
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addHomeToTableView" {
            let destViewController: MyHomesViewController = segue.destinationViewController as! MyHomesViewController
            destViewController.cameFromHomeScreen = cameFromHomeScreen
        }
    }
}
