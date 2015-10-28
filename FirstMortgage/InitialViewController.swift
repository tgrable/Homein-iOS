//
//  InitialViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import Parse

class InitialViewController: UIViewController {
    
    // MARK:
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        //PFUser.logOut()
        
        if (PFUser.currentUser() != nil) {
            performSegueWithIdentifier("homeViewController", sender: self)
        }
        else {
            performSegueWithIdentifier("createAccountViewController", sender: self)
        }
    }
}