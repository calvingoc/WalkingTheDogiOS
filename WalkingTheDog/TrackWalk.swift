//
//  TrackWalk.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/21/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import GoogleMobileAds
import Firebase
import UserNotifications
import UIKit

class TrackWalk: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var changeDogsView: UIView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var dogsTable: UITableView!
    var bannerView: GADBannerView!
    @IBOutlet weak var viewForAd: UIView!
    @IBOutlet weak var changeDogsTable: UITableView!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    @IBOutlet weak var milesValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var totalDistance = 0.00
    var locationCount = 0
    var cellArray = SQLHelper.sharedInstance.allDogsOnWalk()
    let allDogsArray = SQLHelper.sharedInstance.allDogs()
    var walkTimer = Timer()
    var totalSeconds = 0.0
    let identifier = "WalkingTheDogNotification"
    let center = UNUserNotificationCenter.current()
    
    var mUserSettings: UserWalkingTheDogSettings?
    
    let startTime = Date()
    
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mUserSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings
        
        walkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame = CGRect(x:0, y:0, width: 320, height: 50)
        viewForAd.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-9578879157437430/9168610299"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        bannerView.load(request)
        bannerView.delegate = self
        
        let contents = UNMutableNotificationContent()
        contents.title = "Walking the Dog"
        contents.body = "You have a walk active."
        let triggers = UNTimeIntervalNotificationTrigger(timeInterval: 900, repeats: true)
        let notRequest = UNNotificationRequest(identifier: identifier, content: contents, trigger: triggers)
        center.add(notRequest, withCompletionHandler: { (error) in
            if let error = error{
                print("notification failed \(error)")
            }
        })
        
    }
    
    func updateTimer(){
        let now = Date()
        totalSeconds = now.timeIntervalSince(startTime)
        print("Time: \(totalSeconds)")
        let mins = (totalSeconds / 60).rounded(.down)
        var curSecs = totalSeconds
        if mins > 0 {
            curSecs = curSecs - (mins * 60)
        }
        var time = "\(Int (curSecs))"
        if curSecs < 10 {
            time = "0\(Int (curSecs))"
        }
        timeValue.text = "\(Int (mins)):\(time)"
    }
    
    
    @IBAction func changeDogs(_ sender: Any) {
        changeDogsView.isHidden = false
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        if mUserSettings?.dogsOnWalk != "" {
            NSKeyedArchiver.archiveRootObject(mUserSettings!, toFile: filePath)
            changeDogsView.isHidden = true
            cellArray = SQLHelper.sharedInstance.allDogsOnWalk()
            dogsTable.reloadData()
        } else {
            saveChangesButton.setTitle("There needs to be at least 1 dog on the walk.", for: .normal)
        }
    }
    
    @IBAction func endWalk(_ sender: Any) {
        let ref = Database.database().reference()
        walkTimer.invalidate()
        locationManager.stopUpdatingLocation()
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        var streakHit = false
        for pups in cellArray{
            if (pups.curTime < pups.timeGoal || pups.curDist < pups.distGoal || pups.curWalks < pups.walkGoal) {
                streakHit = false
            } else {streakHit = true}
            let newTime = Double(totalSeconds) / 60.0 + pups.curTime
            let newDist = totalDistance + pups.curDist
            let newWalks = pups.curWalks + 1
            var streak = pups.streak
            if (!streakHit && newTime >= pups.timeGoal && newDist >= pups.distGoal && newWalks >= pups.walkGoal) {
                streak += 1
                SQLHelper.sharedInstance.updateAchievements(updateType: 7, value: streak)
                SQLHelper.sharedInstance.updateAchievements(updateType: 11, value: 1)
            }
            var bestDist = pups.dogRow?.get(SQLHelper.sharedInstance.bestDist)
            if bestDist! < totalDistance {
                bestDist = totalDistance
            }
            var bestTime = pups.dogRow?.get(SQLHelper.sharedInstance.bestTime)
            if bestTime! < (Double(totalSeconds) / 60.0) {
                bestTime = (Double(totalSeconds) / 60.0)
            }
            SQLHelper.sharedInstance.endWalkUpdate(updateId: pups.id, time: newTime, distance: newDist, walks: newWalks, newStreak: streak, newBestDist: bestDist!, newBestTime: bestTime!)
            let onlineID = pups.dogRow?.get(SQLHelper.sharedInstance.onlineID)
            if onlineID != "" && onlineID != nil {
                ref.child(onlineID!).child("walkTime").setValue(newTime)
                ref.child(onlineID!).child("curentDistance").setValue(newDist)
                ref.child(onlineID!).child("numWalks").setValue(newWalks)
                ref.child(onlineID!).child("streak").setValue(streak)
                ref.child(onlineID!).child("BestDistWalk").setValue(bestDist)
                ref.child(onlineID!).child("bestTimeWalk").setValue(bestTime)
            }
            
        }
        var mph = 0.0;
        if totalSeconds > 0 {
            mph = Double(totalDistance / (Double(totalSeconds) / 360.0))
        }
        SQLHelper.sharedInstance.updateAchievements(updateType: 1, value: 1)
        SQLHelper.sharedInstance.updateAchievements(updateType: 2, value: (Double(totalSeconds) / 60.0))
        SQLHelper.sharedInstance.updateAchievements(updateType: 3, value: totalDistance)
        SQLHelper.sharedInstance.updateAchievements(updateType: 4, value: (Double(totalSeconds) / 60.0))
        SQLHelper.sharedInstance.updateAchievements(updateType: 5, value: totalDistance)
        SQLHelper.sharedInstance.updateAchievements(updateType: 6, value: mph)
        SQLHelper.sharedInstance.updateAchievements(updateType: 8, value: (Double(totalSeconds) / 60.0))
        SQLHelper.sharedInstance.updateAchievements(updateType: 9, value: totalDistance)
        SQLHelper.sharedInstance.updateAchievements(updateType: 10, value: 1)
        SQLHelper.sharedInstance.resetAchievements(updateType: 4)
        SQLHelper.sharedInstance.resetAchievements(updateType: 5)
        SQLHelper.sharedInstance.resetAchievements(updateType: 6)
        mUserSettings?.lastWalkTime = Double(totalSeconds) / 60.0
        mUserSettings?.lastWalkDist = totalDistance
        NSKeyedArchiver.archiveRootObject(mUserSettings!, toFile: filePath)
        
        
    }
    
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dogsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogsOnWalkCell
            cell.dogPicture.image = cellArray[indexPath.row].getImage()
            cell.dogName.text = cellArray[indexPath.row].getName()
            var milesVal = cellArray[indexPath.row].getDistGoal() - cellArray[indexPath.row].getCurDist()
            if milesVal < 0 {milesVal = 0}
            var timeVal = cellArray[indexPath.row].getTimeGoal() - cellArray[indexPath.row].getCurTime()
            if timeVal < 0 {timeVal = 0}
            var walksVal = cellArray[indexPath.row].getWalkGoal() - cellArray[indexPath.row].getCurWalks()
            if walksVal < 0 {walksVal = 0}
            let hours = Int(timeVal / 60)
            let minutes = Int((timeVal).truncatingRemainder(dividingBy: 60))
            let seconds = Int((timeVal * 100).truncatingRemainder(dividingBy: 100) * 0.6)
            var minutesString = "\(minutes):"
            if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
            var secondsString = "\(seconds)"
            if secondsString.characters.count == 1 {
                secondsString = "0" + secondsString
            }
            cell.time.text = "\(hours):" + minutesString + secondsString
            cell.walks.text = "\(Int(walksVal))"
            cell.miles.text = "\(milesVal)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogCell", for: indexPath) as! AllDogsCell
            cell.dogPic.image = allDogsArray[indexPath.row].image
            cell.dogName.text = allDogsArray[indexPath.row].name
            if allDogsArray[indexPath.row].onWalk {
                cell.layer.backgroundColor = UIColor(rgb: 0xADD8Ef).cgColor
            } else {
                cell.layer.backgroundColor = UIColor.white.cgColor
            }
            return cell
        }
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dogsTable{
            return cellArray.count
        } else {
            return allDogsArray.count
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == changeDogsTable {
            if (allDogsArray[indexPath.row].onWalk){
                allDogsArray[indexPath.row].onWalk = false
                tableView.cellForRow(at: indexPath)?.layer.backgroundColor = UIColor.white.cgColor
                mUserSettings?.dogsOnWalk = (mUserSettings?.dogsOnWalk.replacingOccurrences(of: ",\(allDogsArray[indexPath.row].id)", with: ""))!
            } else {
                allDogsArray[indexPath.row].onWalk = true
                tableView.cellForRow(at: indexPath)?.layer.backgroundColor = UIColor(rgb: 0xADD8Ef).cgColor
                mUserSettings?.dogsOnWalk = (mUserSettings?.dogsOnWalk)! + ",\(allDogsArray[indexPath.row].id)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if lastLocation == nil{
            lastLocation = locations[0]
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        } else if (lastLocation?.distance(from: locations[0]))! / 1609.34 < 0.25 {
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
            totalDistance = totalDistance + (lastLocation?.distance(from: locations[0]))! / 1609.34
            milesValue.text = "\(totalDistance.roundTo(places: 2))"
            lastLocation = locations[0]
            locationCount = 0
        } else {
            locationCount = locationCount + 1
            if locationCount > 5 {
                lastLocation = locations[0]
                locationCount = 0
            }
        }
    }

}

class DogsOnWalkCell : UITableViewCell{
    
    @IBOutlet weak var dogPicture: UIImageView!
    
    @IBOutlet weak var miles: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var walks: UILabel!
    @IBOutlet weak var dogName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class AllDogsCell: UITableViewCell{
    
    @IBOutlet weak var dogPic: UIImageView!
    
    @IBOutlet weak var dogName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
