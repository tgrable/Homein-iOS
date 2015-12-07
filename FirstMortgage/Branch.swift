//
//  Branch.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 11/24/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit
import CoreLocation

class Branch: NSObject {
    var address = String()
    var city = String()
    var state = String()
    var phone = String()
    var lat = Double()
    var long = Double()
    var distanceFromMe = Double()
    
    override init() {        
        super.init()
    }
    
    init(adddress: NSString, city: String, state: String) {
        self.address = adddress as String
        self.city = city as String
        self.state = state as String
        
        super.init()
    }
}
