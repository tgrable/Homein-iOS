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
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            let user = PFUser.currentUser()! as PFUser
            if let _ = user["officerNid"] {
                performSegueWithIdentifier("homeViewController", sender: self)
            }
            else {
                performSegueWithIdentifier("profileViewController", sender: self)
            }
            
        }
        else {
            performSegueWithIdentifier("createAccountViewController", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        //PFUser.logOut()
        
        
    }
}