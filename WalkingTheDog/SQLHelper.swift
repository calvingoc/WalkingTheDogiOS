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
    let achievements = Table("self.achievements")
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
            self.db = try Connection("\(path)/WalkingTheDog.sqlite3")
            print("SQLPATH \(path)")
            try self.db!.run(self.dogs.create(temporary: false, ifNotExists: true, block:{ t in
                t.column(self.id, primaryKey: true)
                t.column(self.dogName)
                t.column(self.timeGoal)
                t.column(self.walksGoal)
                t.column(self.distGoal)
                t.column(self.curTime)
                t.column(self.curWalks)
                t.column(self.curDist)
                t.column(self.streak)
                t.column(self.totWalks)
                t.column(self.totTime)
                t.column(self.totDist)
                t.column(self.totDays)
                t.column(self.bestTime)
                t.column(self.bestDist)
                t.column(self.bestTimeDay)
                t.column(self.bestDistDay)
                t.column(self.bestWalks)
                t.column(self.bestStreak)
                t.column(self.lastDaySync)
                t.column(self.picPath)
                t.column(self.onlineID)}))
            
            try self.db!.run(self.achievements.create(temporary: false, ifNotExists:true, block: { t in
                t.column(self.id, primaryKey: true)
                t.column(self.achievement)
                t.column(self.completed)
                t.column(self.seen)
                t.column(self.date)
                t.column(self.threshold)
                t.column(self.progress)
                t.column(self.type)
                t.column(self.updateTracker)}))
        } catch {
            print("connection failed")
        }
        
    }
    
    
    func setUpTables(){
        DispatchQueue.global(qos: .background).async {
       
        do {
            if try self.db!.scalar(self.achievements.count) == 0 {
            let rowID = try self.db!.run(self.achievements.insert(self.achievement <- "Potted a Puppy;Make your first dog.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1, self.progress <- 0, self.type <- 0, self.updateTracker <- 0))
            print("inserted id: \(rowID)")
            try self.db!.run(self.achievements.insert(self.achievement <- "Windowsill Lab Garden;Make five dogs.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 5, self.progress <- 0, self.type <- 0, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Backyard Pug Plot;Make ten dogs.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10, self.progress <- 0, self.type <- 0, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Corgi Farmer; Make 100 dogs.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 100, self.progress <- 0, self.type <- 0, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Walking the Dog;Take your first walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1, self.progress <- 0, self.type <- 1, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Stretching Your Legs; Take ten walks.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10, self.progress <- 0, self.type <- 1, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Professional Dog Walker; Take one hundred walks.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 100, self.progress <- 0, self.type <- 1, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Dog Walking Mastery;Take one thousand walks.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1000, self.progress <- 0, self.type <- 1, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "You Could Have Watched an Episode of Criminal Minds;One hour of walk time.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 60, self.progress <- 0, self.type <- 2, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "You Could Have Watched 2/3s of the Lord Of The Rings Extended Edition;Ten hours of walk time.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 600, self.progress <- 0, self.type <- 2, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Ain't Got Time to Sleep;24 hours of walk time.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1440, self.progress <- 0, self.type <- 2, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "You're All Out of Bubble Gum;100 hours of walk time.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 6000, self.progress <- 0, self.type <- 2, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Still Have Time Before the First Line in 2001: A Space Odyssey;A week of walk time.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10080, self.progress <- 0, self.type <- 2, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Game Over Man, Game Over;1000 hours of walk time.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 60000, self.progress <- 0, self.type <- 2, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Can I Have My Shoes Back?;Walk a mile.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1, self.progress <- 0, self.type <- 3, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Hot to Trot;Walk ten miles.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10, self.progress <- 0, self.type <- 3, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Made It to Athens (Please Don't Die Now);Walk a marathon.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 26.2, self.progress <- 0, self.type <- 3, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "How Do I Get Home?;Walk 100 miles.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 100, self.progress <- 0, self.type <- 3, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "The Iditarod? Show Off;Walk 1000 miles.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1000, self.progress <- 0, self.type <- 3, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Warming Up;Half an hour in one walk", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 30, self.progress <- 0, self.type <- 4, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Was It a Good Podcase?;Hour in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 60, self.progress <- 0, self.type <- 4, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Hope You Brought Water; Hour and a half in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 90, self.progress <- 0, self.type <- 4, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Up Next, Nap Time;2 hours in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 120, self.progress <- 0, self.type <- 4, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "You Got Lost;5 hours in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 300, self.progress <- 0, self.type <- 4, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "A Smile a Mile;Mile in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Gotta Hit That Distance Goal;2 miles in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 2, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "It Was For Charity;5k in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 3, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "I Hope You Don't Have a Dachsund;5 miles in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 5, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Dog Athlete;10k in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 6, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "WHY WON'T YOU POO?;10 miles in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Do You Bring Up Your Rescue Dog Or Your Marathon First?;26.2 miles in one walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 26.2, self.progress <- 0, self.type <- 5, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Power Walker; 3 miles an hour in a walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 3, self.progress <- 0, self.type <- 6, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Don't Forget To Pee;5 miles an hour in a walk.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 5, self.progress <- 0, self.type <- 6, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "I Like Stars;Hit your goals.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1, self.progress <- 0, self.type <- 11, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Star Gazing;5 day streak.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 5, self.progress <- 0, self.type <- 7, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "The Perfect Week;7 day streak.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 7, self.progress <- 0, self.type <- 7, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "In the Habit;10 day streak.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10, self.progress <- 0, self.type <- 7, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Streaking;30 day streak.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 30, self.progress <- 0, self.type <- 7, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Luckiest Dog in the World;365 day streak.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 365, self.progress <- 0, self.type <- 7, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Getting Your Daily Dose of Vitamin D;Walk an hour in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 60, self.progress <- 0, self.type <- 8, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Gameification, Heard of It?;Walk 1.5 hours in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 90, self.progress <- 0, self.type <- 8, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "The Kids Put On The Teletubbies Movies Again?;2 hours in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 120, self.progress <- 0, self.type <- 8, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "How's Retirement?;5 hours in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 300, self.progress <- 0, self.type <- 8, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Bring Your Dog To Work Day;8 hours in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 480, self.progress <- 0, self.type <- 8, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Round the Block;Mile in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 1, self.progress <- 0, self.type <- 9, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "There and Back Again;2 miles in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 2, self.progress <- 0, self.type <- 9, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Summer Has Finally Come;5 miles in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 5, self.progress <- 0, self.type <- 9, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Day at the Dog Park;10 miles in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 10, self.progress <- 0, self.type <- 9, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "Took You All Day?;26.2 miles in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 26.2, self.progress <- 0, self.type <- 9, self.updateTracker <- 0))
            try self.db!.run(self.achievements.insert(self.achievement <- "I'm Sorry Your Dog Has IBS;Five walks in a day.", self.completed <- 0, self.date <- 0, self.seen <- 1, self.threshold <- 5, self.progress <- 0, self.type <- 10, self.updateTracker <- 0))
            }
        } catch {
            print("insertion failed: \(error)")
        }
        }
    
    }
    
    func updateAchievements(updateType: Int64, value: Double){
        DispatchQueue.global(qos: .background).async {
        let query = self.achievements.select(self.progress, self.threshold, self.updateTracker, self.completed, self.date, self.seen, self.id).filter(updateType == self.type)
        do {
            for results in try self.db!.prepare(query){
                var prog = results[self.progress] + value
                if (updateType == 7){
                    prog = value
                }
                let update = self.achievements.filter(self.id == results[self.id])
                try self.db!.run(update.update(self.progress <- prog))
                if (prog >= results[self.threshold] && results[self.updateTracker] == 0){
                    try self.db!.run(update.update(self.completed <- results[self.completed] + 1))
                    try self.db!.run(update.update(self.updateTracker <- 1))
                    let time = Double(NSDate().timeIntervalSince1970) * 1000
                    try self.db!.run(update.update(self.date <- time))
                    try self.db!.run(update.update(self.seen <- 0))
                    }
                
            }
        } catch {
            print("update failed \(error)")
        }
        }
        
        
    }
    
    func resetAchievements(updateType: Int64){
        DispatchQueue.global(qos: .background).async {

        let query = self.achievements.select(self.updateTracker, self.progress, self.id).filter(updateType == self.type)
        do {
            for results in try self.db!.prepare(query){
                let update = self.achievements.filter(self.id == results[self.id])
                try self.db!.run(update.update(self.updateTracker <- 0))
                try self.db!.run(update.update(self.progress <- 0))
            }
        } catch{
            print("reset failed \(error)")
        }
        }
    }
    
    func markAsSeen(){
        do{
            try db!.run(self.achievements.update(seen <- 1))
        } catch{
            print("mark ans self.seen failed \(error)")
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
        DispatchQueue.global(qos: .background).async {

        do{
            let dogToUpdate = self.dogs.filter(self.onlineID == onlId)
            try self.db!.run(dogToUpdate.update(self.dogName <- newDogName))
            try self.db!.run(dogToUpdate.update(self.walksGoal <- newWalksGoal))
            try self.db!.run(dogToUpdate.update(self.timeGoal <- newTimeGoal))
            try self.db!.run(dogToUpdate.update(self.distGoal <- newDistGoal))
            try self.db!.run(dogToUpdate.update(self.curTime <- newcurTime))
            try self.db!.run(dogToUpdate.update(self.curWalks <- newCurWalks))
            try self.db!.run(dogToUpdate.update(self.curDist <- newCurDist))
            try self.db!.run(dogToUpdate.update(self.streak <- newStreak))
            try self.db!.run(dogToUpdate.update(self.totWalks <- newTotWalks))
            try self.db!.run(dogToUpdate.update(self.totTime <- newTotTime))
            try self.db!.run(dogToUpdate.update(self.totDist <- newTotDist))
            try self.db!.run(dogToUpdate.update(self.totDays <- newTotDays))
            try self.db!.run(dogToUpdate.update(self.bestTime <- newBestTime))
            try self.db!.run(dogToUpdate.update(self.bestDist <- newBestDist))
            try self.db!.run(dogToUpdate.update(self.bestTimeDay <- newBestTimeDay))
            try self.db!.run(dogToUpdate.update(self.bestDistDay <- newBestDistDay))
            try self.db!.run(dogToUpdate.update(self.bestWalks <- newBestWAlks))
            try self.db!.run(dogToUpdate.update(self.bestStreak <- newBestStreaks))
            try self.db!.run(dogToUpdate.update(self.lastDaySync <- newLastDaySynced))
        } catch{
            print("add dog failed \(error)")
        }
        }
    }
    
    public func setListeners(ref: DatabaseReference){
        DispatchQueue.global(qos: .background).async {
        do{
            let query = self.dogs.filter(self.onlineID != nil && self.onlineID != "")
            for dogs in try self.db!.prepare(query){
                let onlID = dogs[self.onlineID]
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
            print("making self.achievement cells failed \(error)")
            let cell = achievementsCellData(inName: "failed to load achievements;sorry", inCompleted: 1, inSeen: 1, inThreshold: 1, inProgress: 1, inType: 1)
            return[cell]
        }
        
    }
    
    func newAchievements() -> [achievementsCellData]{
        do {
            var allData = [achievementsCellData]()
            let query = self.achievements.filter(SQLHelper.sharedInstance.seen == 0)
            for ach in try db!.prepare(query){
                let cell = achievementsCellData(inName: ach[achievement], inCompleted: ach[completed], inSeen: ach[seen], inThreshold: ach[threshold], inProgress: ach[progress], inType: ach[type])
                allData.append(cell)
            }
            return allData
        } catch {
            print("making self.achievement cells failed \(error)")
            let cell = achievementsCellData(inName: "failed to load self.achievements;sorry", inCompleted: 1, inSeen: 1, inThreshold: 1, inProgress: 1, inType: 1)
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





