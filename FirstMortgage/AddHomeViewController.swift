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
    
    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    let greenColor = UIColor(red: 185/255, green: 190/255, blue: 71/255, alpha: 1)
    
    let addHomeView = UIView()
    
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
    
    var intComponent = 2.0
    var decComponent = 0.0
    var bathRoomDefault = 0.0
    
    // UIImagePickerController
    let picker = UIImagePickerController()
    
    var imageView = UIImageView()
    var img = UIImage()
    
    var ratingDefault = 0
    
    var logoImageView = UIImageView()
    
    var isSmallerScreen = Bool()
    
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
        
        buildView()
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
        let addButton = UIButton (frame: CGRectMake(whiteBar.bounds.size.width - 75, 0, 75, 45))
        addButton.addTarget(self, action: "addNewHome:", forControlEvents: .TouchUpInside)
        addButton.setTitle("Add", forState: .Normal)
        addButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        addButton.backgroundColor = UIColor.clearColor()
        addButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        addButton.tag = 0
        //whiteBar.addSubview(addButton)
        
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
            NSForegroundColorAttributeName: UIColor.darkTextColor(),
            NSFontAttributeName : UIFont(name: "forza-light", size: 18)!
        ]
        
        // UITextField
        homeNameTxtField.frame = (frame: CGRectMake(10, 210, addHomeView.bounds.size.width - 20, 40))
        homeNameTxtField.attributedPlaceholder = NSAttributedString(string: "NAME YOUR HOME", attributes:attributes)
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.returnKeyType = .Done
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(homeNameTxtField)
        
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 250, addHomeView.bounds.size.width - 20, 40))
        homePriceTxtField.attributedPlaceholder = NSAttributedString(string: "$Price", attributes:attributes)
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Done
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
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
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 14.0)!])
        
        // UITextField
        bedsTxtField.frame = (frame: CGRectMake(15, 345, (scrollView.bounds.size.width / 3) - 10, 30))
        bedsTxtField.attributedPlaceholder = attributedHomeBed
        bedsTxtField.backgroundColor = UIColor.clearColor()
        bedsTxtField.delegate = self
        bedsTxtField.returnKeyType = .Done
        bedsTxtField.keyboardType = UIKeyboardType.NumberPad
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
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 14.0)!])
        
        // UITextField
        bathsTxtField.frame = (frame: CGRectMake((scrollView.bounds.size.width / 3) + 10, 345, (scrollView.bounds.size.width / 3) - 10, 30))
        bathsTxtField.attributedPlaceholder = attributedHomeBath
        bathsTxtField.backgroundColor = UIColor.clearColor()
        bathsTxtField.delegate = self
        bathsTxtField.returnKeyType = .Done
        bathsTxtField.keyboardType = UIKeyboardType.DecimalPad
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
            attributes: [NSForegroundColorAttributeName: UIColor.darkTextColor(),NSFontAttributeName:UIFont(
                name: "Arial",
                size: 14.0)!])
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake((scrollView.bounds.size.width * 0.66) + 10, 345, (scrollView.bounds.size.width / 3) - 10, 30))
        sqFeetTxtField.attributedPlaceholder = attributedHomeSqft
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Done
        sqFeetTxtField.keyboardType = UIKeyboardType.NumberPad
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
        homeAddressTxtField.returnKeyType = .Done
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(homeAddressTxtField)
        
        //Create textview
        descTxtView.frame = (frame : CGRectMake(10, 450, addHomeView.bounds.size.width - 20, 220))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.autocorrectionType = .Yes
        descTxtView.returnKeyType = .Done
        descTxtView.delegate = self
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
        let saveButton = UIButton (frame: CGRectMake(0, 0, saveView.bounds.size.width, saveView.bounds.size.height))
        saveButton.addTarget(self, action: "addNewHome:", forControlEvents: .TouchUpInside)
        saveButton.setTitle("SAVE HOME", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.backgroundColor = UIColor.clearColor()
        saveButton.titleLabel!.font = UIFont(name: "forza-light", size: 25)
        saveButton.contentHorizontalAlignment = .Center
        saveButton.tag = 0
        saveView.addSubview(saveButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        scrollView.addGestureRecognizer(tapGesture)
        
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
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
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
    
    func addNewImage(homeObject: PFObject) {
        let homeImage = PFObject(className: "Images")
        let imageData = UIImagePNGRepresentation(self.img)
        if (imageData != nil) {
            let imageFile = PFFile(name:"image.png", data:imageData!)
            homeImage["image"] = imageFile
        }
        homeImage["home"] = homeObject
        homeImage["default"] = true
        
        homeImage.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("success")
            }
            else {
                print("error")
            }
        }
    }
    
    func addNewHome(sender: UIButton) {
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            var imageArray: [PFFile] = []
            let home = PFObject(className: "Home")
            
            home["user"] = PFUser.currentUser()
            home["name"] = (self.homeNameTxtField.text != "") ? self.homeNameTxtField.text : "Home"
            home["price"] = (self.homePriceTxtField.text != "") ? Double(self.homePriceTxtField.text!) : 250000
            home["address"] = (self.homeAddressTxtField.text != "") ? self.homeAddressTxtField.text : "Address"
            home["beds"] = (self.bedsTxtField.text != "") ? Double(self.bedsTxtField.text!) : 4
            home["baths"] = (self.bathsTxtField.text != "") ? Double(self.bathsTxtField.text!) : 2.5
            home["footage"] = (self.sqFeetTxtField.text != "") ? Double(self.sqFeetTxtField.text!) : 2400
            home["rating"] = self.ratingDefault
            home["desc"] = (self.descTxtView.text != "") ? self.descTxtView.text : "Default home description"
            
            let imageData = UIImagePNGRepresentation(self.img)
            if (imageData != nil) {
                let imageFile = PFFile(name:"image.png", data:imageData!)
                home["image"] = imageFile
                imageArray.append(imageFile!)
                imageArray.append(imageFile!)
                home["imageArray"] = imageArray
            }
            
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
                    
                    self.addNewImage(home)
                }
                else {
                    print("The object was not saved")
                }
            }
        }
    }

    func setRating(sender: UIButton) {
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
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 815)
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
