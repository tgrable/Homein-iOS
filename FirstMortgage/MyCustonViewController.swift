//
//  MyCustonViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 12/11/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import ParseUI

class MyCustonViewController: PFLogInViewController, PFSignUpViewControllerDelegate {

    // Custom Color
    let lightGrayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lightGrayColor
        
        print(self.logInView!.bounds.size.width)
        
        let logoView = UIImageView(image: UIImage(named:"home_in"))
        logoView.frame = (frame: CGRectMake(100, 25, 159, 47.5))
        self.logInView?.addSubview(logoView)
        
        self.logInView!.logo = nil;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
