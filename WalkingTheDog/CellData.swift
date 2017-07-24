//
//  CellData.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/21/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
import SQLite

class CellData{
    var id: Int64
    var name: String
    var image: UIImage
    var walkGoal: Double
    var curWalks: Double
    var distGoal: Double
    var curDist: Double
    var timeGoal: Double
    var curTime: Double
    var streak: Double
    var dogRow: Row?
    var onWalk: Bool
    
    init(inID: Int64, inName: String, inImage: UIImage, inWalkGoal: Double, inCurWalk: Double, inDistGoal: Double, inCurDist: Double, inTimeGoal: Double, inCurTime: Double, inStreak: Double, inRow: Row?, inOnWalk: Bool){
        id = inID
        name = inName
        image = inImage
        walkGoal = inWalkGoal
        curWalks = inCurWalk
        distGoal = inDistGoal
        curDist = inCurDist
        timeGoal = inTimeGoal
        curTime = inCurTime
        streak = inStreak
        dogRow = inRow
        onWalk = inOnWalk
        
    }
    
    func getID() -> Int64 {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getImage() -> UIImage {
        return image
    }
    
    func getWalkGoal() -> Double {
        return walkGoal
    }
    
    func getCurWalks() -> Double {
        return curWalks
    }
    
    func getDistGoal() -> Double {
        return distGoal
    }
    
    func getCurDist() -> Double {
        return curDist
    }
    
    func getTimeGoal() -> Double {
        return timeGoal
    }
    
    func getCurTime() -> Double {
        return curTime
    }
    func getStreak() -> Double {
        return streak
    }
    
}

class achievementsCellData{
    var name: String
    var completed: Double
    var seen: Double
    var threshold: Double
    var progress: Double
    var type: Int64
    
    init(inName: String, inCompleted: Double, inSeen: Double, inThreshold: Double, inProgress: Double, inType: Int64){
        name = inName
        completed = inCompleted
        seen = inSeen
        threshold = inThreshold
        progress = inProgress
        type = inType
    }
    
    func getName() -> String {
        return name
    }
    
    func getCompleted() -> Double{
        return completed
    }
    
    func getSeen() -> Double {
        return seen
    }
    
    func getThreshold() -> Double{
        return threshold
    }
    
    func getProgress() -> Double {
        return progress
    }
    
    func getType() -> Int64 {
        return type
    }
}
