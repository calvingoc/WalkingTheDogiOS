//
//  UserWalkingTheDogSettings.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/17/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation

public class UserWalkingTheDogSettings: NSObject, NSCoding{
    
    struct Keys {
        static let defaultDog = "deftDog"
        static let currentDog = "currentDog"
        static let dogsOnWalk = "dogsOnWalk"
        static let defDogsOnWalk = "defDogsOnWalk"
    }
    private var _defaultDog: Int64?
    private var _currentDog: Int64?
    private var _dogsOnWalk: String?
    private var _defDogsOnWalk: String?
    
    override public init() {}
    
    init(defaultDog: Int64, currentDog: Int64, dogsOnWalk: String, defDogsOnWalk: String){
        self._defaultDog = defaultDog
        self._currentDog = currentDog
        self._dogsOnWalk = dogsOnWalk
        self._defDogsOnWalk = defDogsOnWalk
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        if let deftDogObject = aDecoder.decodeObject(forKey: Keys.defaultDog) as? Int64{
            _defaultDog = deftDogObject
        }
        if let currentDogObject = aDecoder.decodeObject(forKey: Keys.currentDog) as? Int64 {
            _currentDog = currentDogObject
        }
        if let dogsOnWalkObject = aDecoder.decodeObject(forKey: Keys.dogsOnWalk) as? String {
            _dogsOnWalk = dogsOnWalkObject
        }
        if let defDogsOnWalkObject = aDecoder.decodeObject(forKey: Keys.defDogsOnWalk) as? String {
            _defDogsOnWalk = defDogsOnWalkObject
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_defaultDog, forKey: Keys.defaultDog)
        aCoder.encode(_currentDog, forKey: Keys.currentDog)
        aCoder.encode(_dogsOnWalk, forKey: Keys.dogsOnWalk)
        aCoder.encode(_defDogsOnWalk, forKey: Keys.defDogsOnWalk)
    }
    
    var defaultDog: Int64{
        get {
            return _defaultDog!
        }
        set {
            _defaultDog = newValue
        }
    }
    
    var currentDog: Int64{
        get {
            return _currentDog!
        }
        set {
            _currentDog = newValue
        }
    }
    
    var dogsOnWalk: String {
        get {
            return _dogsOnWalk!
        }
        set {
            _dogsOnWalk = newValue
        }
    }
    
    var defDogsOnWalk: String {
        get {
            return _defDogsOnWalk!
        }
        set {
            _defDogsOnWalk = newValue
        }
    }
    
    
}
