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
        static let lastWalkTime = "lastWalkTime"
        static let lastWalkDist = "lastWalkDist"
        static let lastTimeSynced = "lastTimeSynced"
    }
    private var _defaultDog: Int64?
    private var _currentDog: Int64?
    private var _dogsOnWalk: String?
    private var _defDogsOnWalk: String?
    public var _lastWalkTime: Double?
    public var _lastWalkDist: Double?
    public var _lastTimeSynced: Date?
    
    override public init() {}
    
    init(defaultDog: Int64, currentDog: Int64, dogsOnWalk: String, defDogsOnWalk: String){
        self._defaultDog = defaultDog
        self._currentDog = currentDog
        self._dogsOnWalk = dogsOnWalk
        self._defDogsOnWalk = defDogsOnWalk
        self._lastTimeSynced = Date()
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
        
        if let lastWalkTimeObject = aDecoder.decodeObject(forKey: Keys.lastWalkTime) as? Double {
            _lastWalkTime = lastWalkTimeObject
        }
        
        if let lastWalkDistObject = aDecoder.decodeObject(forKey: Keys.lastWalkDist) as? Double {
            _lastWalkDist = lastWalkDistObject
        }
        
        if let lastTimeSyncedObject = aDecoder.decodeObject(forKey: Keys.lastTimeSynced) as? Date {
            _lastTimeSynced = lastTimeSyncedObject
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(_defaultDog, forKey: Keys.defaultDog)
        aCoder.encode(_currentDog, forKey: Keys.currentDog)
        aCoder.encode(_dogsOnWalk, forKey: Keys.dogsOnWalk)
        aCoder.encode(_defDogsOnWalk, forKey: Keys.defDogsOnWalk)
        aCoder.encode(_lastWalkTime, forKey: Keys.lastWalkTime)
        aCoder.encode(_lastWalkDist, forKey: Keys.lastWalkDist)
        aCoder.encode(_lastTimeSynced, forKey: Keys.lastTimeSynced)
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
    
    var lastWalkTime: Double {
        get {
            return _lastWalkTime!
        }
        set {
            _lastWalkTime = newValue
        }
    }
    
    var lastWalkDist: Double {
        get {
            return _lastWalkDist!
        }
        set {
            _lastWalkDist = newValue
        }
    }
    var lastTimeSynced: Date {
        get {
            return _lastTimeSynced!
        }
        set {
            _lastTimeSynced = newValue
        }
    }
    
    
    
}
