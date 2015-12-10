//
//  AddHomeViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class AddHomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

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
    let sqFeetTxtField = UITextField()
    
    // UITextField
    let descTxtView = UITextView()
    
    // UIPickerView
    let bedRoomPicker = UIPickerView() as UIPickerView
    let bedRoomPickerData = ["1","2","3","4","5","6","7","8","9"]
    var bedRoomDefault = 4.0
    
    let bathRoomPicker = UIPickerView() as UIPickerView
    let bathRoomPickerData = [
        ["1","2","3","4","5","6","7","8","9"],
        ["0.0","0.5"]
    ]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bedRoomPicker.delegate = self
        bedRoomPicker.dataSource = self
        bedRoomPicker.selectRow(3, inComponent: 0, animated: true)
        
        bathRoomPicker.delegate = self
        bathRoomPicker.dataSource = self
        bathRoomPicker.selectRow(1, inComponent: 0, animated: true)
        
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
        homeNameTxtField.frame = (frame: CGRectMake(10, 200, addHomeView.bounds.size.width - 20, 30))
        homeNameTxtField.attributedPlaceholder = NSAttributedString(string: "NAME YOUR HOME", attributes:attributes)
        homeNameTxtField.backgroundColor = UIColor.clearColor()
        homeNameTxtField.delegate = self
        homeNameTxtField.returnKeyType = .Done
        homeNameTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(homeNameTxtField)
        
        // UITextField
        homePriceTxtField.frame = (frame: CGRectMake(10, 230, addHomeView.bounds.size.width - 20, 30))
        homePriceTxtField.attributedPlaceholder = NSAttributedString(string: "$Price", attributes:attributes)
        homePriceTxtField.backgroundColor = UIColor.clearColor()
        homePriceTxtField.delegate = self
        homePriceTxtField.returnKeyType = .Done
        homePriceTxtField.keyboardType = UIKeyboardType.NumberPad
        scrollView.addSubview(homePriceTxtField)
        
        let starImage = UIImage(named: "Star_empty-01") as UIImage?
        var xOffset = 0
        for i in 1...4 {
            // UIButton
            let ratingButtonPhotoButton = UIButton (frame: CGRectMake(CGFloat(10 + xOffset), 263, 30, 30))
            ratingButtonPhotoButton.addTarget(self, action: "setRating:", forControlEvents: .TouchUpInside)
            ratingButtonPhotoButton.backgroundColor = model.darkBlueColor
            ratingButtonPhotoButton.setImage(starImage, forState: .Normal)
            ratingButtonPhotoButton.tag = i
            scrollView.addSubview(ratingButtonPhotoButton)
            
            xOffset += 35
        }
        
        // UIPickerView
        bedRoomPicker.frame = (frame: CGRectMake(addHomeView.bounds.size.width / 2, 255, 30, 40))
        bedRoomPicker.backgroundColor = UIColor.clearColor()
        bedRoomPicker.layer.borderColor = lightGrayColor.CGColor
        bedRoomPicker.tag = 0
        scrollView.addSubview(bedRoomPicker)
        
        // UILabel
        let bedLabel = UILabel(frame: CGRectMake((addHomeView.bounds.size.width / 2), 290, 40, 10))
        bedLabel.text = "Beds"
        bedLabel.font = UIFont(name: "Arial", size: 8)
        bedLabel.textAlignment = NSTextAlignment.Left
        bedLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(bedLabel)
        
        // UIPickerView
        bathRoomPicker.frame = (frame: CGRectMake((addHomeView.bounds.size.width / 2) + 30, 255, 55, 40))
        bathRoomPicker.backgroundColor = UIColor.clearColor()
        bathRoomPicker.layer.borderColor = lightGrayColor.CGColor
        bathRoomPicker.tag = 1
        scrollView.addSubview(bathRoomPicker)
        
        // UILabel
        let bathLabel = UILabel(frame: CGRectMake((addHomeView.bounds.size.width / 2) + 60, 290, 100, 10))
        bathLabel.text = "Baths"
        bathLabel.font = UIFont(name: "Arial", size: 8)
        bathLabel.textAlignment = NSTextAlignment.Left
        bathLabel.numberOfLines = 0
        bathLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(bathLabel)
        
        // UITextField
        sqFeetTxtField.frame = (frame: CGRectMake((addHomeView.bounds.size.width / 2) + 100, 255, 100, 40))
        sqFeetTxtField.placeholder = "2,400"
        sqFeetTxtField.backgroundColor = UIColor.clearColor()
        sqFeetTxtField.delegate = self
        sqFeetTxtField.returnKeyType = .Done
        sqFeetTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(sqFeetTxtField)
        
        // UILabel
        let sqFeetLabel = UILabel(frame: CGRectMake((addHomeView.bounds.size.width / 2) + 100, 290, 100, 10))
        sqFeetLabel.text = "Sq. Ft."
        sqFeetLabel.font = UIFont(name: "Arial", size: 8)
        sqFeetLabel.textAlignment = NSTextAlignment.Left
        sqFeetLabel.textColor = UIColor.darkTextColor()
        scrollView.addSubview(sqFeetLabel)
        
        let dividerView = UIView(frame: CGRectMake(10, 305, addHomeView.bounds.size.width - 20, 1))
        dividerView.backgroundColor = UIColor.darkGrayColor()
        dividerView.hidden = false
        scrollView.addSubview(dividerView)
        
        //UITextField
        homeAddressTxtField.frame = (frame: CGRectMake(10, 305, addHomeView.bounds.size.width - 20, 40))
        homeAddressTxtField.attributedPlaceholder = NSAttributedString(string: "ADDRESS", attributes:attributes)
        homeAddressTxtField.backgroundColor = UIColor.clearColor()
        homeAddressTxtField.delegate = self
        homeAddressTxtField.returnKeyType = .Done
        homeAddressTxtField.keyboardType = UIKeyboardType.Default
        scrollView.addSubview(homeAddressTxtField)
        
        //Create textview
        descTxtView.frame = (frame : CGRectMake(10, 350, addHomeView.bounds.size.width - 20, 250))
        descTxtView.backgroundColor = UIColor.whiteColor()
        descTxtView.autocorrectionType = .Yes
        scrollView.addSubview(descTxtView)
        
        scrollView.contentSize = CGSize(width: addHomeView.bounds.size.width, height: 650)
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
    
    // MARK:
    // MARK: UIPickerView Delegate and Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView.tag == 0) {
            return 1
        }
        else if (pickerView.tag == 1) {
            return bathRoomPickerData.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return bedRoomPickerData.count
        }
        else if (pickerView.tag == 1) {
            return bathRoomPickerData[component].count
        }
        else {
            return 0
        }
        
    }
    
    /*func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return bedRoomPickerData[row]
        }
        else if (pickerView.tag == 1) {
            return bathRoomPickerData[component][row]
        }
        else {
            return nil
        }
    }*/
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.lightGrayColor()
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 12.0) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        if (pickerView.tag == 0) {
            pickerLabel.text = bedRoomPickerData[row]
        }
        else if (pickerView.tag == 1) {
            pickerLabel.text = bathRoomPickerData[component][row]
        }
        else {
            
        }
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            bedRoomDefault = Double(bedRoomPickerData[row])!
        }
        else if (pickerView.tag == 1) {
            //bathRoomDefault = Double(bathRoomPickerData[component][row])!
            if component == 0{
                intComponent = Double(bathRoomPickerData[component][row])!
            }
            else if (component == 1) {
                decComponent = Double(bathRoomPickerData[component][row])!
            }
            else {
                print("Empty")
            }
            
            bathRoomDefault = intComponent + decComponent
        }
        else {
            print("Empty")
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
            home["name"] = self.homeNameTxtField.text
            home["price"] = Double(self.homePriceTxtField.text!)
            home["address"] = self.homeAddressTxtField.text
            home["beds"] = self.bedRoomDefault
            home["baths"] = self.bathRoomDefault
            home["footage"] = self.sqFeetTxtField
            home["rating"] = self.ratingDefault
            home["desc"] = self.descTxtView.text
            
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
