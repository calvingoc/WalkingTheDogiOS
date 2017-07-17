//
//  UserWalkingTheDogSettings.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/17/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation

public class UserWalkingTheDogSettings: NSObject, NSCoding{
    let defaultDog: Int64
    let dogsOnWalk: String
    
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(defaultDog, forKey: "deftDog")
        aCoder.encode(dogsOnWalk, forKey: "dogsOnWlk")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.defaultDog = aDecoder.decodeObject(forKey: "deftDog") as! Int64
        self.dogsOnWalk = aDecoder.decodeObject(forKey: "dogsOnWlk") as? String ?? ""
    }
    
    
}
