//
//  IndividualHomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 11/18/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class IndividualHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK:
    // MARK: Properties
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    // UIView
    let myHomesView = UIView()
    
    // UIScrollView
    let scrollView = UIScrollView()
    
    // UITextField
    let homeNameTxtField = UITextField()
    let homePriceTxtField = UITextField()
    let homeAddressTxtField = UITextField()
    let bedsTxtField = UITextField()
    let bathsTxtField = UITextField()
    let sqFeetTxtField = UITextField()
    
    // UIImagePickerController
    let picker = UIImagePickerController()
    var img = UIImage()
    
    var homeObject: PFObject!
    
    var imageView = UIImageView()
    
    var isSmallerScreen = Bool()
    var isTextFieldEnabled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildView() {
        myHomesView.frame = (frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
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
        
        let addHomeBannerView = UIView(frame: CGRectMake(0, 135, myHomesView.bounds.size.width, 50))
        addHomeBannerView.backgroundColor = UIColor.blueColor()
        addHomeBannerView.hidden = false
        myHomesView.addSubview(addHomeBannerView)
        
        let labelFontSize = isSmallerScreen ? 20.0 : 24.0;
        
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
        
        scrollView.frame = (frame: CGRectMake(0, 185, myHomesView.bounds.size.width, myHomesView.bounds.size.height - 185))
        scrollView.backgroundColor = UIColor.clearColor()
        myHomesView.addSubview(scrollView)
        
        let imageScollView = UIScrollView(frame: CGRectMake(0, 0, scrollView.bounds.size.width, 250))
        imageScollView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(imageScollView)
        
        if (homeObject["imageArray"] != nil) {
            var imageArray: [PFFile] = []
            imageArray = homeObject["imageArray"] as! [PFFile]
            var xLocation = 0.0
            
            for img: PFFile in imageArray {
                img.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        let homeImageView = UIImageView(frame: CGRectMake(CGFloat(xLocation), 0, self.scrollView.bounds.size.width, 250))
                        homeImageView.backgroundColor = UIColor.clearColor()
                        imageScollView.addSubview(homeImageView)
                        
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            homeImageView.image = image
                        }
                        
                        xLocation += Double(self.scrollView.bounds.size.width)
                    }
                }
            }
            imageScollView.contentSize = CGSize(width: CGFloat(Int(scrollView.bounds.size.width) * imageArray.count), height: 250)
        }
        else {
            let defaultImageView = UIImageView(frame: CGRectMake(0, 0, scrollView.bounds.size.width, 250))
            imageScollView.addSubview(defaultImageView)
            let fillerImage = UIImage(named: "homebackground") as UIImage?
            defaultImageView.image = fillerImage
        }
        
        let homeName = homeObject["name"] as! NSString
        var attributedHomeName = NSMutableAttributedString()
        attributedHomeName = NSMutableAttributedString(
            string: homeName as String,
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor()])
        
        // UITextField
        homeNameTxtField.frame = (frame: CGRectMake(10, 250, scrollView.bounds.size.width - 20, 30))
        homeNameTxtField.attributedPlaceholder = attributedHomeName
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.enabled = false
        homeNameTxtField.returnKeyType = .Done
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(homeNameTxtField)
        
        // UILabel
        let price = homeObject["price"] as! Double
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        let homePrice = formatter.stringFromNumber(price)! as String

        var attributedHomePrice = NSMutableAttributedString()
        attributedHomePrice = NSMutableAttributedString(
            string: homePrice as String,
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor()])
        
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 275, scrollView.bounds.size.width - 90, 30))
        homePriceTxtField.attributedPlaceholder = attributedHomePrice
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.enabled = false
        homePriceTxtField.returnKeyType = .Done
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        scrollView.addSubview(homePriceTxtField)

        // UIButton
        let addImagesButton = UIButton (frame: CGRectMake(scrollView.bounds.size.width - 120, 250, 80, 30))
        addImagesButton.addTarget(self, action: "arraytest:", forControlEvents: .TouchUpInside)
        addImagesButton.setTitle("Add Images", forState: .Normal)
        addImagesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addImagesButton.backgroundColor = UIColor.clearColor()
        addImagesButton.tag = 0
        scrollView.addSubview(addImagesButton)
        
        // UIButton
        let editButton = UIButton (frame: CGRectMake(scrollView.bounds.size.width - 50, 250, 40, 40))
        editButton.addTarget(self, action: "allowEdit:", forControlEvents: .TouchUpInside)
        editButton.setTitle("Edit", forState: .Normal)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.tag = 0
        scrollView.addSubview(editButton)
        
        let bed = homeObject["beds"] as? Int
        let attributedHomeBed = NSMutableAttributedString(
            string: String(format: "%d", bed!),
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 12.0)!])
        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(scrollView.bounds.size.width - 150, 300, 40, 30))
        bedsTxtField.attributedPlaceholder = attributedHomeBed
        bedsTxtField.backgroundColor = UIColor.clearColor()
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Done
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
        scrollView.addSubview(bedsTxtField)
        
        let bedsLabel = UILabel(frame: CGRectMake(scrollView.bounds.size.width - 150, 320, 40, 30))
        bedsLabel.text = "Beds"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bedsLabel.textAlignment = NSTextAlignment.Left
        bedsLabel.numberOfLines = 1
        bedsLabel.font = bedsLabel.font.fontWithSize(12)
        bedsLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(bedsLabel)
        
        let vertDividerTwoView = UIView(frame: CGRectMake(scrollView.bounds.size.width - 109, 300, 1, 50))
        vertDividerTwoView.backgroundColor = UIColor.darkGrayColor()
        vertDividerTwoView.hidden = false
        scrollView.addSubview(vertDividerTwoView)
        
        let bath = homeObject["baths"] as? Double
        let attributedHomeBath = NSMutableAttributedString(
            string: String(format: "%.1f", bath!),
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 12.0)!])
        
        // UITextField
        bathsTxtField.frame = (frame: CGRectMake(scrollView.bounds.size.width - 100, 300, 40, 30))
        bathsTxtField.attributedPlaceholder = attributedHomeBath
        bathsTxtField.backgroundColor = UIColor.clearColor()
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Done
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
        scrollView.addSubview(bathsTxtField)
        
        let bathsLabel = UILabel(frame: CGRectMake(scrollView.bounds.size.width - 100, 320, 40, 30))
        bathsLabel.text = "Baths"
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        bathsLabel.textAlignment = NSTextAlignment.Left
        bathsLabel.numberOfLines = 1
        bathsLabel.font = bathsLabel.font.fontWithSize(12)
        bathsLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(bathsLabel)
        
        let vertDividerThreeView = UIView(frame: CGRectMake(scrollView.bounds.size.width - 59, 300, 1, 50))
        vertDividerThreeView.backgroundColor = UIColor.darkGrayColor()
        vertDividerThreeView.hidden = false
        scrollView.addSubview(vertDividerThreeView)
        
        var attributedHomeSqft = NSMutableAttributedString()
        if let homeSqft = homeObject["footage"] as? Double {
            attributedHomeSqft = NSMutableAttributedString(
                string: String(format: "%.1f", homeSqft),
                attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                    name: "Arial",
                    size: 12.0)!])
        }
        
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake(scrollView.bounds.size.width - 50, 300, 40, 30))
        sqFeetTxtField.attributedPlaceholder = attributedHomeSqft
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Done
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
        scrollView.addSubview(sqFeetTxtField)
        
        let sqFeetLabel = UILabel(frame: CGRectMake(scrollView.bounds.size.width - 50, 320, 40, 30))
        sqFeetLabel.text = "Sq. Ft."
        //myHomesLabel.font = UIFont(name: listItem.titleLabel.font.fontName, size: 24)
        sqFeetLabel.textAlignment = NSTextAlignment.Left
        sqFeetLabel.numberOfLines = 1
        sqFeetLabel.font = sqFeetLabel.font.fontWithSize(12)
        sqFeetLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(sqFeetLabel)
        
        var xOffset = 0
        for i in 1...4 {
            // UIButton
            let ratingButtonPhotoButton = UIButton (frame: CGRectMake(CGFloat(10 + xOffset), 315, 30, 30))
            ratingButtonPhotoButton.addTarget(self, action: "setRating:", forControlEvents: .TouchUpInside)
            ratingButtonPhotoButton.backgroundColor = UIColor.blueColor()
            ratingButtonPhotoButton.layer.borderWidth = 1.0
            ratingButtonPhotoButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            ratingButtonPhotoButton.tag = i
            scrollView.addSubview(ratingButtonPhotoButton)
            
            xOffset += 35
        }
        
        let dividerView = UIView(frame: CGRectMake(10, 359, scrollView.bounds.size.width - 20, 1))
        dividerView.backgroundColor = UIColor.darkGrayColor()
        dividerView.hidden = false
        scrollView.addSubview(dividerView)
        
        let homeAddress = homeObject["address"] as! NSString
        let attributedHomeAddress = NSMutableAttributedString(
            string: homeAddress as String,
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor()])
        
        // UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, 370, scrollView.bounds.size.width - 20, 30))
        homeAddressTxtField.attributedPlaceholder = attributedHomeAddress
        homeAddressTxtField.backgroundColor = UIColor.clearColor()
        homeAddressTxtField.delegate = self
        homeAddressTxtField.enabled = false
        homeAddressTxtField.returnKeyType = .Done
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(homeAddressTxtField)
        
        //Create textview
        let descTxtView = UITextView(frame : CGRectMake(10, CGFloat(370 + homeNameTxtField.frame.height + 10), scrollView.bounds.size.width - 20, 250))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.text = homeObject["desc"] as? String
        descTxtView.autocorrectionType = .Yes
        descTxtView.editable = false
        scrollView.addSubview(descTxtView)
        
        scrollView.contentSize = CGSize(width: myHomesView.bounds.size.width, height: 775)
    }
    
    // MARK:
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    // MARK:
    // MARK: Navigation
    func navigateBackHome(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func allowEdit(sender: UIButton) {
        print("press")
        if (!isTextFieldEnabled) {
            homeNameTxtField.enabled = true
            homePriceTxtField.enabled = true
            homeAddressTxtField.enabled = true
            bedsTxtField.enabled = true
            bathsTxtField.enabled = true
            sqFeetTxtField.enabled = true
            
            isTextFieldEnabled = true
        }
        else {
            homeNameTxtField.enabled = false
            homePriceTxtField.enabled = false
            homeAddressTxtField.enabled = false
            bedsTxtField.enabled = false
            bathsTxtField.enabled = false
            sqFeetTxtField.enabled = false
            
            isTextFieldEnabled = false
        }
    }
    
    //MARK:
    //MARK: UIImagePickerController Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            img = pickedImage
            if (picker.sourceType.rawValue == 1) {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
        }
        else {
            print(info)
            print(picker.sourceType.rawValue)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectWhereToGetImage(sender: UIButton) {
        
        let photoLibActionHandler = { (action:UIAlertAction!) -> Void in
            self.picker.allowsEditing = true
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
        }
        
        let cameraActionHandler = { (action:UIAlertAction!) -> Void in
            self.picker.allowsEditing = true
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
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}