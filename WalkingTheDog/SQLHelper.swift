//
//  SQLHelper.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/17/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
import SQLite
import Firebase

public class SQLHelper {
    
    let id = Expression<Int64>("id")
    let dogName = Expression<String>("dogName")
    let timeGoal = Expression<Double>("timeGoal")
    let walksGoal = Expression<Double>("walksGoal")
    let distGoal = Expression<Double>("distGoal")
    let curTime = Expression<Double>("curTime")
    let curWalks = Expression<Double>("curWalks")
    let curDist = Expression<Double>("curDist")
    let streak = Expression<Double>("streak")
    let totWalks = Expression<Double>("totWalks")
    let totTime = Expression<Double>("totTime")
    let totDist = Expression<Double>("totDist")
    let totDays = Expression<Double>("totDays")
    let bestTime = Expression<Double>("bestTime")
    let bestDist = Expression<Double>("bestDist")
    let bestTimeDay = Expression<Double>("bestTimeDay")
    let bestDistDay = Expression<Double>("bestDistDay")
    let bestWalks = Expression<Double>("bestWalks")
    let bestStreak = Expression<Double>("bestStreak")
    let lastDaySync = Expression<Double>("lastDaySync")
    let picPath = Expression<String?>("picPath")
    let onlineID = Expression<String?>("onlineID")
    
    let achievement = Expression<String>("achievement")
    let completed = Expression<Double>("completed")
    let date = Expression<Double>("date")
    let seen = Expression<Double>("seen")
    let threshold = Expression<Double>("threshold")
    let progress = Expression<Double>("progress")
    let type = Expression<Int64>("type")
    let updateTracker = Expression<Double>("updateTracker")
    
    let dogs = Table("dogs")
    let achievements = Table("achievements")
    var db: Connection?
    static var sharedInstance = SQLHelper()
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    
    init() {
        do{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/WalkingTheDog.sqlite3")
            print("SQLPATH \(path)")
            try db!.run(dogs.create(temporary: false, ifNotExists: true, block:{ t in
                t.column(id, primaryKey: true)
                t.column(dogName)
                t.column(timeGoal)
                t.column(walksGoal)
                t.column(distGoal)
                t.column(curTime)
                t.column(curWalks)
                t.column(curDist)
                t.column(streak)
                t.column(totWalks)
                t.column(totTime)
                t.column(totDist)
                t.column(totDays)
                t.column(bestTime)
                t.column(bestDist)
                t.column(bestTimeDay)
                t.column(bestDistDay)
                t.column(bestWalks)
                t.column(bestStreak)
                t.column(lastDaySync)
                t.column(picPath)
                t.column(onlineID)}))
            
            try db!.run(achievements.create(temporary: false, ifNotExists:true, block: { t in
                t.column(id, primaryKey: true)
                t.column(achievement)
                t.column(completed)
                t.column(seen)
                t.column(date)
                t.column(threshold)
                t.column(progress)
                t.column(type)
                t.column(updateTracker)}))
        } catch {
            print("connection failed")
        }
    }
    
    
    func setUpTables(){
        do {
            if try db!.scalar(achievements.count) == 0 {
            let rowID = try db!.run(achievements.insert(achievement <- "Potted a Puppy;Make your first dog.", completed <- 0, date <- 0, seen <- 1, threshold <- 1, progress <- 0, type <- 0, updateTracker <- 0))
            print("inserted id: \(rowID)")
            try db!.run(achievements.insert(achievement <- "Windowsill Lab Garden;Make five dogs.", completed <- 0, date <- 0, seen <- 1, threshold <- 5, progress <- 0, type <- 0, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Backyard Pug Plot;Make ten dogs.", completed <- 0, date <- 0, seen <- 1, threshold <- 10, progress <- 0, type <- 0, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Corgi Farmer; Make 100 dogs.", completed <- 0, date <- 0, seen <- 1, threshold <- 100, progress <- 0, type <- 0, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Walking the Dog;Take your first walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 1, progress <- 0, type <- 1, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Stretching Your Legs; Take ten walks.", completed <- 0, date <- 0, seen <- 1, threshold <- 10, progress <- 0, type <- 1, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Professional Dog Walker; Take one hundred walks.", completed <- 0, date <- 0, seen <- 1, threshold <- 100, progress <- 0, type <- 1, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Dog Walking Mastery;Take one thousand walks.", completed <- 0, date <- 0, seen <- 1, threshold <- 1000, progress <- 0, type <- 1, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "You Could Have Watched an Episode of Criminal Minds;One hour of walk time.", completed <- 0, date <- 0, seen <- 1, threshold <- 60, progress <- 0, type <- 2, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "You Could Have Watched 2/3s of the Lord Of The Rings Extended Edition;Ten hours of walk time.", completed <- 0, date <- 0, seen <- 1, threshold <- 600, progress <- 0, type <- 2, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Ain't Got Time to Sleep;24 hours of walk time.", completed <- 0, date <- 0, seen <- 1, threshold <- 1440, progress <- 0, type <- 2, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "You're All Out of Bubble Gum;100 hours of walk time.", completed <- 0, date <- 0, seen <- 1, threshold <- 6000, progress <- 0, type <- 2, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Still Have Time Before the First Line in 2001: A Space Odyssey;A week of walk time.", completed <- 0, date <- 0, seen <- 1, threshold <- 10080, progress <- 0, type <- 2, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Game Over Man, Game Over;1000 hours of walk time.", completed <- 0, date <- 0, seen <- 1, threshold <- 60000, progress <- 0, type <- 2, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Can I Have My Shoes Back?;Walk a mile.", completed <- 0, date <- 0, seen <- 1, threshold <- 1, progress <- 0, type <- 3, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Hot to Trot;Walk ten miles.", completed <- 0, date <- 0, seen <- 1, threshold <- 10, progress <- 0, type <- 3, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Made It to Athens (Please Don't Die Now);Walk a marathon.", completed <- 0, date <- 0, seen <- 1, threshold <- 26.2, progress <- 0, type <- 3, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "How Do I Get Home?;Walk 100 miles.", completed <- 0, date <- 0, seen <- 1, threshold <- 100, progress <- 0, type <- 3, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "The Iditarod? Show Off;Walk 1000 miles.", completed <- 0, date <- 0, seen <- 1, threshold <- 1000, progress <- 0, type <- 3, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Warming Up;Half an hour in one walk", completed <- 0, date <- 0, seen <- 1, threshold <- 30, progress <- 0, type <- 4, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Was It a Good Podcase?;Hour in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 60, progress <- 0, type <- 4, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Hope You Brought Water; Hour and a half in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 90, progress <- 0, type <- 4, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Up Next, Nap Time;2 hours in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 120, progress <- 0, type <- 4, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "You Got Lost;5 hours in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 300, progress <- 0, type <- 4, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "A Smile a Mile;Mile in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 1, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Gotta Hit That Distance Goal;2 miles in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 2, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "It Was For Charity;5k in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 3, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "I Hope You Don't Have a Dachsund;5 miles in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 5, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Dog Athlete;10k in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 6, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "WHY WON'T YOU POO?;10 miles in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 10, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Do You Bring Up Your Rescue Dog Or Your Marathon First?;26.2 miles in one walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 26.2, progress <- 0, type <- 5, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Power Walker; 3 miles an hour in a walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 3, progress <- 0, type <- 6, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Don't Forget To Pee;5 miles an hour in a walk.", completed <- 0, date <- 0, seen <- 1, threshold <- 5, progress <- 0, type <- 6, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "I Like Stars;Hit your goals.", completed <- 0, date <- 0, seen <- 1, threshold <- 1, progress <- 0, type <- 11, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Star Gazing;5 day streak.", completed <- 0, date <- 0, seen <- 1, threshold <- 5, progress <- 0, type <- 7, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "The Perfect Week;7 day streak.", completed <- 0, date <- 0, seen <- 1, threshold <- 7, progress <- 0, type <- 7, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "In the Habit;10 day streak.", completed <- 0, date <- 0, seen <- 1, threshold <- 10, progress <- 0, type <- 7, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Streaking;30 day streak.", completed <- 0, date <- 0, seen <- 1, threshold <- 30, progress <- 0, type <- 7, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Luckiest Dog in the World;365 day streak.", completed <- 0, date <- 0, seen <- 1, threshold <- 365, progress <- 0, type <- 7, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Getting Your Daily Dose of Vitamin D;Walk an hour in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 60, progress <- 0, type <- 8, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Gameification, Heard of It?;Walk 1.5 hours in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 90, progress <- 0, type <- 8, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "The Kids Put On The Teletubbies Movies Again?;2 hours in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 120, progress <- 0, type <- 8, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "How's Retirement?;5 hours in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 300, progress <- 0, type <- 8, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Bring Your Dog To Work Day;8 hours in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 480, progress <- 0, type <- 8, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Round the Block;Mile in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 1, progress <- 0, type <- 9, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "There and Back Again;2 miles in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 2, progress <- 0, type <- 9, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Summer Has Finally Come;5 miles in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 5, progress <- 0, type <- 9, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Day at the Dog Park;10 miles in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 10, progress <- 0, type <- 9, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "Took You All Day?;26.2 miles in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 26.2, progress <- 0, type <- 9, updateTracker <- 0))
            try db!.run(achievements.insert(achievement <- "I'm Sorry Your Dog Has IBS;Five walks in a day.", completed <- 0, date <- 0, seen <- 1, threshold <- 5, progress <- 0, type <- 10, updateTracker <- 0))
            }
        } catch {
            print("insertion failed: \(error)")
        }
    
    }
    
    func updateAchievements(updateType: Int64, value: Double){
        let query = achievements.select(progress, threshold, updateTracker, completed, date, seen, id).filter(updateType == type)
        do {
            for results in try db!.prepare(query){
                var prog = results[progress] + value
                if (updateType == 7){
                    prog = value
                }
                let update = achievements.filter(id == results[id])
                try db!.run(update.update(progress <- prog))
                if (prog >= results[threshold] && results[updateTracker] == 0){
                    try db!.run(update.update(completed <- results[completed] + 1))
                    try db!.run(update.update(updateTracker <- 1))
                    let time = Double(NSDate().timeIntervalSince1970) * 1000
                    try db!.run(update.update(date <- time))
                    try db!.run(update.update(seen <- 0))
                    }
                
            }
        } catch {
            print("update failed \(error)")
        }
        
        
    }
    
    func resetAchievements(updateType: Int64){
        let query = achievements.select(updateTracker, progress, id).filter(updateType == type)
        do {
            for results in try db!.prepare(query){
                let update = achievements.filter(id == results[id])
                try db!.run(update.update(updateTracker <- 0))
                try db!.run(update.update(progress <- 0))
            }
        } catch{
            print("reset failed \(error)")
        }
    }
    
    func markAsSeen(){
        do{
            try db!.run(achievements.update(seen <- 1))
        } catch{
            print("mark ans seen failed \(error)")
        }
        
    }
    
    public func findDogName(dogID: Int64) -> String? {
        let query = dogs.select(dogName).filter(id == dogID)
        do {
            for results in try db!.prepare(query){
                return results[dogName]
            }
        } catch{
            print("find dog name failed \(error)")
        }
        return nil
    }
    
    public func findDogByOnlineID(ID: String) -> Row? {
        do {
            let query = dogs.filter(onlineID == ID)
            let data = try db!.pluck(query)
            return data
        } catch {
            print("find dog by online ID failed \(error)")
            return nil
        }
    }
    
    public func findDog(dogID: Int64) -> Row? {
        do {
            let query = dogs.filter(id == dogID)
            let data = try db!.pluck(query)
            return data
        } catch{
            print("find dog failed \(error)")
            return nil
        }
    }
    
    public func addDog(newDogName: String, nWalksGoal: Double, nTimeGoal: Double, distanceGoal: Double, picturePath: String, shareID: String) -> Int64? {
        do{
            return try db!.run(dogs.insert(dogName <- newDogName, walksGoal <- nWalksGoal, timeGoal <- nTimeGoal, distGoal <- distanceGoal, curTime <- 0, curWalks <- 0, curDist <- 0, streak <- 0, totWalks <- 0, totTime <- 0, totDist <- 0, totDays <- 0, bestTime <- 0, bestDist <- 0, bestTimeDay <- 0, bestDistDay <- 0, bestWalks <- 0, bestStreak <- 0, lastDaySync <- 0, picPath <- picturePath, onlineID <- shareID))
        } catch{
            print("add dog failed \(error)")
            return nil
        }
    }
    
    public func importDog(newDogName: String, onlId: String, newWalksGoal: Double, newTimeGoal: Double, newDistGoal: Double, newcurTime: Double, newCurWalks: Double, newCurDist: Double, newStreak: Double, newTotWalks: Double, newTotTime: Double, newTotDist: Double, newTotDays: Double, newBestTime: Double, newBestDist: Double, newBestTimeDay: Double, newBestDistDay: Double, newBestWAlks: Double, newBestStreaks: Double, newLastDaySynced: Double) -> Int64? {
        do{
            let newDogID = try db!.run(dogs.insert(dogName <- newDogName, walksGoal <- newWalksGoal, timeGoal <- newTimeGoal, distGoal <- newDistGoal, curTime <- newcurTime, curWalks <- newCurWalks, curDist <- newCurDist, streak <- newStreak, totWalks <- newTotWalks, totTime <- newTotTime, totDist <- newTotDist, totDays <- newTotDays, bestTime <- newBestTime, bestDist <- newBestDist, bestTimeDay <- newBestTimeDay, bestDistDay <- newBestDistDay, bestWalks <- newBestWAlks, bestStreak <- newBestStreaks, lastDaySync <- newLastDaySynced, picPath <- "default", onlineID <- onlId))
            print("new dog imported \(newDogID)")
            return newDogID
        } catch{
            print("add dog failed \(error)")
            return nil
        }
    }
    
    public func updateDog(newDogName: String, nWalksGoal: Double, nTimeGoal: Double, distanceGoal: Double, picturePath: String, shareID: String, dogID: Int64){
        let dogToUpdate = dogs.filter(id == dogID)
        do {
            try db!.run(dogToUpdate.update(dogName <- newDogName))
            try db!.run(dogToUpdate.update(walksGoal <- nWalksGoal))
            try db!.run(dogToUpdate.update(timeGoal <- nTimeGoal))
            try db!.run(dogToUpdate.update(distGoal <- distanceGoal))
            try db!.run(dogToUpdate.update(onlineID <- shareID))
            try db!.run(dogToUpdate.update(picPath <- picturePath))
        } catch {
            print("update dog failed \(error)")
        }
    }
    
    public func onlineUpdate(newDogName: String, onlId: String, newWalksGoal: Double, newTimeGoal: Double, newDistGoal: Double, newcurTime: Double, newCurWalks: Double, newCurDist: Double, newStreak: Double, newTotWalks: Double, newTotTime: Double, newTotDist: Double, newTotDays: Double, newBestTime: Double, newBestDist: Double, newBestTimeDay: Double, newBestDistDay: Double, newBestWAlks: Double, newBestStreaks: Double, newLastDaySynced: Double) {
        do{
            let dogToUpdate = dogs.filter(onlineID == onlId)
            try db!.run(dogToUpdate.update(dogName <- newDogName))
            try db!.run(dogToUpdate.update(walksGoal <- newWalksGoal))
            try db!.run(dogToUpdate.update(timeGoal <- newTimeGoal))
            try db!.run(dogToUpdate.update(distGoal <- newDistGoal))
            try db!.run(dogToUpdate.update(curTime <- newcurTime))
            try db!.run(dogToUpdate.update(curWalks <- newCurWalks))
            try db!.run(dogToUpdate.update(curDist <- newCurDist))
            try db!.run(dogToUpdate.update(streak <- newStreak))
            try db!.run(dogToUpdate.update(totWalks <- newTotWalks))
            try db!.run(dogToUpdate.update(totTime <- newTotTime))
            try db!.run(dogToUpdate.update(totDist <- newTotDist))
            try db!.run(dogToUpdate.update(totDays <- newTotDays))
            try db!.run(dogToUpdate.update(bestTime <- newBestTime))
            try db!.run(dogToUpdate.update(bestDist <- newBestDist))
            try db!.run(dogToUpdate.update(bestTimeDay <- newBestTimeDay))
            try db!.run(dogToUpdate.update(bestDistDay <- newBestDistDay))
            try db!.run(dogToUpdate.update(bestWalks <- newBestWAlks))
            try db!.run(dogToUpdate.update(bestStreak <- newBestStreaks))
            try db!.run(dogToUpdate.update(lastDaySync <- newLastDaySynced))
        } catch{
            print("add dog failed \(error)")
        }
    }
    
    public func setListeners(ref: DatabaseReference){
        do{
            let query = dogs.filter(onlineID != nil && onlineID != "")
            for dogs in try db!.prepare(query){
                let onlID = dogs[onlineID]
                ref.child(onlID!).observe(DataEventType.value, with: { (snapshot) in
                    let dog = snapshot.value as? NSDictionary
                    SQLHelper.sharedInstance.onlineUpdate(newDogName: dog?["name"] as? String ?? "", onlId: onlID!, newWalksGoal: dog?["numWalksGoals"] as? Double ?? 0, newTimeGoal: dog?["timeGoals"] as? Double ?? 0, newDistGoal: dog?["distanceGoal"] as? Double ?? 0, newcurTime: dog?["walkTime"] as? Double ?? 0, newCurWalks: dog?["numWalks"] as? Double ?? 0, newCurDist: dog?["curentDistance"] as? Double ?? 0, newStreak: dog?["streak"] as? Double ?? 0, newTotWalks: dog?["totalWalks"] as? Double ?? 0, newTotTime: dog?["totalTime"] as? Double ?? 0, newTotDist: dog?["totalDist"] as? Double ?? 0, newTotDays: dog?["totalDays"] as? Double ?? 0, newBestTime: dog?["bestTimeWalk"] as? Double ?? 0, newBestDist: dog?["BestDistWalk"] as? Double ?? 0, newBestTimeDay: dog?["bestTimeDay"] as? Double ?? 0, newBestDistDay: dog?["bestDistDay"] as? Double ?? 0, newBestWAlks: dog?["bestWalks"] as? Double ?? 0, newBestStreaks: dog?["bestStreak"] as? Double ?? 0, newLastDaySynced: dog?["lastDaySynced"] as? Double ?? 0)
                })
                { (error) in print(error.localizedDescription)}
            }
        } catch{
            print("listeners failed \(error)")
        }
    }
    
    public func deleteDog( dogID: Int64) -> Int64?{
        do {
            let delete = dogs.filter(id == dogID)
            try db!.run(delete.delete())
            for var dog in try db!.prepare(dogs){
                return dog.get(id)
            }
            return -1
        } catch {
            print("delete dog failed \(error)")
            return -1
        }
        
    }
    
    public func numberOfDogs() -> Int {
        do {
            return try db!.scalar(dogs.count)
        } catch{
            print("dog count failed \(error)")
            return 0
        }
    }
    
    func allDogs() -> [CellData]{
        do{
            var dogsArray = [Int64]()
            let mUserSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings
            let dogsString = mUserSettings?.dogsOnWalk.components(separatedBy: ",")
            for pups in dogsString! {
                if pups != "" {
                    dogsArray.append(Int64(pups)!)
                }
            }
            var allData = [CellData]()
            for dog in try db!.prepare(dogs){
                var image: UIImage
                if dog[picPath] != "default"{
                    image = ImageStore().loadImage(key: "WalkingTheDog\(String(dog[id]))")
                } else {
                    image = UIImage(named: "stockdog")!
                }
                let dogCell = CellData(inID: dog[id], inName: dog[dogName], inImage: image, inWalkGoal: dog[walksGoal], inCurWalk: dog[curWalks], inDistGoal: dog[distGoal], inCurDist: dog[curDist], inTimeGoal: dog[timeGoal], inCurTime: dog[curTime], inStreak: dog[streak], inRow: dog, inOnWalk: dogsArray.contains(dog[id]))
                allData.append(dogCell)
            }
            return allData
        } catch {
            print("making dog cells failed \(error)")
            let dogCell = CellData(inID: -1, inName: "No Dogs Found", inImage: UIImage(named: "stockdog")!, inWalkGoal: 0, inCurWalk: 0, inDistGoal: 0, inCurDist: 0, inTimeGoal: 0, inCurTime: 0, inStreak: 0, inRow: nil, inOnWalk: false)
            return [dogCell]
        }
        
    }
    
    func allAchievements() -> [achievementsCellData]{
        do {
            var allData = [achievementsCellData]()
            for ach in try db!.prepare(achievements){
                let cell = achievementsCellData(inName: ach[achievement], inCompleted: ach[completed], inSeen: ach[seen], inThreshold: ach[threshold], inProgress: ach[progress], inType: ach[type])
                allData.append(cell)
            }
            return allData
        } catch {
            print("making achievement cells failed \(error)")
            let cell = achievementsCellData(inName: "failed to load achievements;sorry", inCompleted: 1, inSeen: 1, inThreshold: 1, inProgress: 1, inType: 1)
            return[cell]
        }
        
    }
    
    func newAchievements() -> [achievementsCellData]{
        do {
            var allData = [achievementsCellData]()
            let query = achievements.filter(SQLHelper.sharedInstance.seen == 0)
            for ach in try db!.prepare(query){
                let cell = achievementsCellData(inName: ach[achievement], inCompleted: ach[completed], inSeen: ach[seen], inThreshold: ach[threshold], inProgress: ach[progress], inType: ach[type])
                allData.append(cell)
            }
            return allData
        } catch {
            print("making achievement cells failed \(error)")
            let cell = achievementsCellData(inName: "failed to load achievements;sorry", inCompleted: 1, inSeen: 1, inThreshold: 1, inProgress: 1, inType: 1)
            return[cell]
        }
        
    }
    
    func allDogsOnWalk() -> [CellData]{
        do{
            var dogsArray = [Int64]()
            let mUserSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings
            let dogsString = mUserSettings?.dogsOnWalk.components(separatedBy: ",")
            for pups in dogsString! {
                if pups != "" && pups != nil{
                    dogsArray.append(Int64(pups)!)
                }
            }
            var allData = [CellData]()
            for dog in try db!.prepare(dogs.filter(dogsArray.contains(id))){
                var image: UIImage
                if dog[picPath] != "default"{
                    image = ImageStore().loadImage(key: "WalkingTheDog\(String(dog[id]))")
                } else {
                    image = UIImage(named: "stockdog")!
                }
                let dogCell = CellData(inID: dog[id], inName: dog[dogName], inImage: image, inWalkGoal: dog[walksGoal], inCurWalk: dog[curWalks], inDistGoal: dog[distGoal], inCurDist: dog[curDist], inTimeGoal: dog[timeGoal], inCurTime: dog[curTime], inStreak: dog[streak], inRow: dog, inOnWalk: true)
                allData.append(dogCell)
            }
            return allData
        } catch {
            print("making dog cells failed \(error)")
            let dogCell = CellData(inID: -1, inName: "No Dogs Found", inImage: UIImage(named: "stockdog")!, inWalkGoal: 0, inCurWalk: 0, inDistGoal: 0, inCurDist: 0, inTimeGoal: 0, inCurTime: 0, inStreak: 0, inRow: nil, inOnWalk: true)
            return [dogCell]
        }
        
    }
    
    func endWalkUpdate(updateId: Int64, time: Double, distance: Double, walks: Double, newStreak: Double, newBestDist: Double, newBestTime: Double) {
        do{
            let dogToUpdate = dogs.filter(id == updateId)
            try db!.run(dogToUpdate.update(curTime <- time))
            try db!.run(dogToUpdate.update(curWalks <- walks))
            try db!.run(dogToUpdate.update(curDist <- distance))
            try db!.run(dogToUpdate.update(streak <- newStreak))
            try db!.run(dogToUpdate.update(bestTime <- newBestTime))
            try db!.run(dogToUpdate.update(bestDist <- newBestDist))
        } catch {
            print("updating walk failed \(error)")
        }
    }
    
    func resetDogs(ref: DatabaseReference) {
        do {
            let now = Date()
            var maxStreak = 0
            for dog in try db!.prepare(dogs){
                let sync = Date(timeIntervalSince1970: dog.get(lastDaySync))
                if Calendar(identifier: Calendar.Identifier.gregorian).startOfDay(for: now) != Calendar(identifier: Calendar.Identifier.gregorian).startOfDay(for: sync){
                    let dogToUpdate = dogs.filter(id == dog.get(id))
                    let dogOnlineID = dog.get(onlineID)
                    let totalDays = dog.get(totDays) + 1
                    let totalWalks = dog.get(totWalks) + dog.get(curWalks)
                    let totalTimes = dog.get(totTime) + dog.get(curTime)
                    let totalDist = dog.get(totDist) + dog.get(curDist)
                    if (dog.get(streak) > dog.get(bestStreak)){
                        if dogOnlineID != "" || dogOnlineID != nil {
                            ref.child(dogOnlineID!).child("bestStreak").setValue(dog.get(streak))
                        } else {
                            try db!.run(dogToUpdate.update(bestStreak <- dog.get(streak)))
                        }
                    }
                    if (dog.get(bestDistDay) < dog.get(curDist)){
                        if dogOnlineID != "" || dogOnlineID != nil {
                            ref.child(dogOnlineID!).child("bestDistDay").setValue(dog.get(curDist))
                        }
                        else {
                            try db!.run(dogToUpdate.update(bestDistDay <- dog.get(curDist)))
                        }
                    }
                    if (dog.get(bestTimeDay) < dog.get(curTime)) {
                        if dogOnlineID != "" || dogOnlineID != nil {
                            ref.child(dogOnlineID!).child("bestTimeDay").setValue(dog.get(curTime))
                        } else {
                            try db!.run(dogToUpdate.update(bestTimeDay <- dog.get(curTime)))
                        }
                    }
                    if (dog.get(bestWalks) < dog.get(curWalks)) {
                        if dogOnlineID != "" || dogOnlineID != nil {
                            ref.child(dogOnlineID!).child("bestWalks").setValue(dog.get(self.curWalks))
                        } else {
                            try db!.run(dogToUpdate.update(bestWalks <- dog.get(curWalks)))
                        }
                    }
                    var curStreak = dog.get(streak)
                    if (dog.get(timeGoal) > dog.get(curTime) || dog.get(distGoal) > dog.get(curDist) || dog.get(walksGoal) > dog.get(curWalks)){
                        curStreak = 0
                        if dogOnlineID != "" || dogOnlineID != nil {
                            ref.child(dogOnlineID!).child("streak").setValue(0)
                        } else {
                            try db!.run(dogToUpdate.update(streak <- 0))
                        }
                    }
                    maxStreak = max(maxStreak, Int(curStreak))
                    if dogOnlineID != "" || dogOnlineID != nil {
                        ref.child(dogOnlineID!).child("totalDays").setValue(totalDays)
                        ref.child(dogOnlineID!).child("totalWalks").setValue(totalWalks)
                        ref.child(dogOnlineID!).child("totalTime").setValue(totalTimes)
                        ref.child(dogOnlineID!).child("totalDist").setValue(totalDist)
                        ref.child(dogOnlineID!).child("lastDaySynced").setValue(now.timeIntervalSince1970.roundTo(places: 0))
                        ref.child(dogOnlineID!).child("numWalks").setValue(0)
                        ref.child(dogOnlineID!).child("curentDistance").setValue(0)
                        ref.child(dogOnlineID!).child("walkTime").setValue(0)
                    }
                    else {
                        try db!.run(dogToUpdate.update(totDays <- totalDays))
                        try db!.run(dogToUpdate.update(totWalks <- totalWalks))
                        try db!.run(dogToUpdate.update(totTime <- totalTimes))
                        try db!.run(dogToUpdate.update(totDist <- totalDist))
                        try db!.run(dogToUpdate.update(lastDaySync <- now.timeIntervalSince1970.roundTo(places: 0)))
                        try db!.run(dogToUpdate.update(curWalks <- 0))
                        try db!.run(dogToUpdate.update(curDist <- 0))
                        try db!.run(dogToUpdate.update(curTime <- 0))
                        
                    }
                    
                }
            }
            SQLHelper.sharedInstance.resetAchievements(updateType: 8)
            SQLHelper.sharedInstance.resetAchievements(updateType: 9)
            SQLHelper.sharedInstance.resetAchievements(updateType: 10)
            SQLHelper.sharedInstance.resetAchievements(updateType: 11)
            if (maxStreak == 0){
                SQLHelper.sharedInstance.resetAchievements(updateType: 7)
            } else {
                SQLHelper.sharedInstance.updateAchievements(updateType: 7, value: Double(maxStreak))
            }
        } catch {
            print("dog reset failed \(error)")
        }
    }
}





