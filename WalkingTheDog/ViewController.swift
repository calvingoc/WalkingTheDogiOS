//
//  ViewController.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/14/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var startWalkButton: UIButton!
    @IBOutlet weak var viewForAd: UIView!
    @IBOutlet weak var dogPicture: UIImageView!
    @IBOutlet weak var dogTitle: UILabel!
    @IBOutlet weak var todayWalkValue: UILabel!
    @IBOutlet weak var todayTimeValue: UILabel!
    @IBOutlet weak var todayDistanceValue: UILabel!
    @IBOutlet weak var todayStreakValue: UILabel!
    @IBOutlet weak var lifeWalks: UILabel!
    @IBOutlet weak var lifeTime: UILabel!
    @IBOutlet weak var lifeDistance: UILabel!
    @IBOutlet weak var bestWalksDay: UILabel!
    @IBOutlet weak var bestTimeDay: UILabel!
    @IBOutlet weak var bestTimeWalk: UILabel!
    @IBOutlet weak var bestDistanceDay: UILabel!
    @IBOutlet weak var bestDistanceWalk: UILabel!
    @IBOutlet weak var bestStreak: UILabel!
    @IBOutlet weak var aveTimeWalk: UILabel!
    @IBOutlet weak var aveMilesWalk: UILabel!
    @IBOutlet weak var aveWalksDay: UILabel!
    @IBOutlet weak var aveTimeDay: UILabel!
    @IBOutlet weak var aveMilesDay: UILabel!
    @IBOutlet weak var aveMilesHour: UILabel!
    @IBOutlet weak var editGoals: UIButton!
    
    @IBOutlet weak var walksStar: UIImageView!
    @IBOutlet weak var timeStar: UIImageView!
    @IBOutlet weak var distanceStar: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var mUserSettings: UserWalkingTheDogSettings?
    
    
    var bannerView: GADBannerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame = CGRect(x:0, y:0, width: 320, height: 50)
        viewForAd.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-9578879157437430/6995428906"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        bannerView.load(request)
        bannerView.delegate = self
        
        startWalkButton.imageEdgeInsets = UIEdgeInsets(top:10, left:10, bottom: 10, right: 10)
        startWalkButton.layer.cornerRadius = startWalkButton.bounds.size.width/2
        startWalkButton.layer.zPosition = 5
        
        editGoals.layer.cornerRadius = 5
        
        
        sideMenu()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings{
            if userSettings.currentDog == -1 { userSettings.currentDog = userSettings.defaultDog}
            if  userSettings.defaultDog == -1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ImportDog") as! ImportDog
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            }else{
                mUserSettings = userSettings
                setUpListener()
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ImportDog") as! ImportDog
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("did receiveAd")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func sideMenu(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            revealViewController().rightViewRevealWidth = 175
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 48/255, green: 63/255, blue: 159/255, alpha: 1)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
    }
    
    public func setUpPage(){
        if (mUserSettings != nil){
            let dogRow = SQLHelper.sharedInstance.findDog(dogID: (mUserSettings!.currentDog))
            dogName.text = (dogRow?.get(SQLHelper.sharedInstance.dogName))! + "'s Progress"
            if (dogRow?.get(SQLHelper.sharedInstance.picPath) != "default"){
                dogPicture.image = ImageStore().loadImage(key: "WalkingTheDog\(String(mUserSettings!.currentDog))")
            }
            print ("imageKey 3 WalkingTheDog\(String(mUserSettings!.currentDog))")
            var hours = Int(dogRow!.get(SQLHelper.sharedInstance.curTime) / 60)
            var minutes = Int(dogRow!.get(SQLHelper.sharedInstance.curTime).truncatingRemainder(dividingBy: 60))
            var seconds = Int((dogRow!.get(SQLHelper.sharedInstance.curTime) * 100).truncatingRemainder(dividingBy: 100) * 0.6)
            var minutesString = "\(minutes):"
            if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
            var secondsString = "\(seconds)"
            if secondsString.characters.count == 1 {
                secondsString = "0" + secondsString
            }
            todayWalkValue.text = "\(Int(dogRow!.get(SQLHelper.sharedInstance.curWalks))) / \(Int(dogRow!.get(SQLHelper.sharedInstance.walksGoal)))"
            todayTimeValue.text = "\(hours):" + minutesString + secondsString + "/ \(Int(dogRow!.get(SQLHelper.sharedInstance.timeGoal)))"
            todayDistanceValue.text = "\(String(describing: dogRow!.get(SQLHelper.sharedInstance.curDist))) / \(String(describing: dogRow!.get(SQLHelper.sharedInstance.distGoal)))"
            todayStreakValue.text = "\(String(describing: dogRow!.get(SQLHelper.sharedInstance.streak)))"
            if dogRow!.get(SQLHelper.sharedInstance.curWalks) >= dogRow!.get(SQLHelper.sharedInstance.walksGoal) {
                walksStar.image = UIImage(named: "btn_star_big_on")
            }
            if dogRow!.get(SQLHelper.sharedInstance.curTime) >= dogRow!.get(SQLHelper.sharedInstance.timeGoal){
                timeStar.image = UIImage(named: "btn_star_big_on")
            }
            if dogRow!.get(SQLHelper.sharedInstance.curDist) >= dogRow!.get(SQLHelper.sharedInstance.distGoal){
                distanceStar.image = UIImage(named: "btn_star_big_on")
            }
            todayStreakValue.text = "\(Int(dogRow!.get(SQLHelper.sharedInstance.streak)))"
            lifeWalks.text = "\(Int(dogRow!.get(SQLHelper.sharedInstance.totWalks)))"
            hours = Int(dogRow!.get(SQLHelper.sharedInstance.totTime) / 60)
            minutes = Int(dogRow!.get(SQLHelper.sharedInstance.totTime).truncatingRemainder(dividingBy: 60))
            seconds = Int((dogRow!.get(SQLHelper.sharedInstance.totTime) * 100).truncatingRemainder(dividingBy: 100) * 0.6)
            minutesString = "\(minutes):"
            if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
            secondsString = "\(seconds)"
            if secondsString.characters.count == 1 {
                secondsString = "0" + secondsString
            }
            lifeTime.text = "\(hours):" + minutesString + secondsString
            lifeDistance.text = "\(dogRow!.get(SQLHelper.sharedInstance.totDist))"
            bestWalksDay.text = "\(Int(dogRow!.get(SQLHelper.sharedInstance.bestWalks)))"
            hours = Int(dogRow!.get(SQLHelper.sharedInstance.bestTime) / 60)
            minutes = Int(dogRow!.get(SQLHelper.sharedInstance.bestTime).truncatingRemainder(dividingBy: 60))
            seconds = Int((dogRow!.get(SQLHelper.sharedInstance.bestTime) * 100).truncatingRemainder(dividingBy: 100) * 0.6)
            minutesString = "\(minutes):"
            if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
            secondsString = "\(seconds)"
            if secondsString.characters.count == 1 {
                secondsString = "0" + secondsString
            }
            bestTimeWalk.text = "\(hours):" + minutesString + secondsString
            hours = Int(dogRow!.get(SQLHelper.sharedInstance.bestTimeDay) / 60)
            minutes = Int(dogRow!.get(SQLHelper.sharedInstance.bestTimeDay).truncatingRemainder(dividingBy: 60))
            seconds = Int((dogRow!.get(SQLHelper.sharedInstance.bestTimeDay) * 100).truncatingRemainder(dividingBy: 100) * 0.6)
            minutesString = "\(minutes):"
            if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
            secondsString = "\(seconds)"
            if secondsString.characters.count == 1 {
                secondsString = "0" + secondsString
            }
            bestTimeDay.text = "\(hours):" + minutesString + secondsString
            bestDistanceDay.text = "\(dogRow!.get(SQLHelper.sharedInstance.bestDistDay))"
            bestDistanceWalk.text = "\(dogRow!.get(SQLHelper.sharedInstance.bestDist))"
            bestStreak.text = "\(dogRow!.get(SQLHelper.sharedInstance.bestStreak))"
            if dogRow!.get(SQLHelper.sharedInstance.totWalks) != 0 {
                hours = Int(dogRow!.get(SQLHelper.sharedInstance.totTime) / dogRow!.get(SQLHelper.sharedInstance.totWalks) / 60)
                minutes = Int((dogRow!.get(SQLHelper.sharedInstance.totTime) / dogRow!.get(SQLHelper.sharedInstance.totWalks)).truncatingRemainder(dividingBy: 60))
                seconds = Int((dogRow!.get(SQLHelper.sharedInstance.totTime) / dogRow!.get(SQLHelper.sharedInstance.totWalks) * 100).truncatingRemainder(dividingBy: 100) * 0.6)
                minutesString = "\(minutes):"
                if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
                secondsString = "\(seconds)"
                if secondsString.characters.count == 1 {
                    secondsString = "0" + secondsString
                }
                aveTimeWalk.text = "\(hours):" + minutesString + secondsString
                let distWalk = dogRow!.get(SQLHelper.sharedInstance.totDist) / dogRow!.get(SQLHelper.sharedInstance.totWalks)
                aveMilesWalk.text = "\(distWalk)"
            } else {
                aveTimeWalk.text = "0"
                aveMilesWalk.text = "0"
            }
            if dogRow!.get(SQLHelper.sharedInstance.totDays) != 0 {
                hours = Int(dogRow!.get(SQLHelper.sharedInstance.totTime) / dogRow!.get(SQLHelper.sharedInstance.totDays) / 60)
                minutes = Int((dogRow!.get(SQLHelper.sharedInstance.totTime) / dogRow!.get(SQLHelper.sharedInstance.totDays)).truncatingRemainder(dividingBy: 60))
                seconds = Int((dogRow!.get(SQLHelper.sharedInstance.totTime) / dogRow!.get(SQLHelper.sharedInstance.totDays) * 100).truncatingRemainder(dividingBy: 100) * 0.6)
                minutesString = "\(minutes):"
                if minutesString.characters.count == 2 { minutesString = "0" + minutesString}
                secondsString = "\(seconds)"
                if secondsString.characters.count == 1 {
                    secondsString = "0" + secondsString
                }
                aveTimeDay.text = "\(hours):" + minutesString + secondsString
                let distDay = dogRow!.get(SQLHelper.sharedInstance.totDist) / dogRow!.get(SQLHelper.sharedInstance.totDays)
                aveMilesDay.text = "\(distDay)"
                let walksDay = dogRow!.get(SQLHelper.sharedInstance.totWalks) / dogRow!.get(SQLHelper.sharedInstance.totDays)
                aveWalksDay.text = "\(walksDay)"
                
            } else {
                aveTimeDay.text = "0"
                aveMilesDay.text = "0"
                aveWalksDay.text = "0"
            }
            if dogRow!.get(SQLHelper.sharedInstance.totTime) != 0 {
                let mph = dogRow!.get(SQLHelper.sharedInstance.totDist) / dogRow!.get(SQLHelper.sharedInstance.totTime) / 60
                aveMilesHour.text = "\(mph)"
            }
            else {
                aveMilesHour.text = "0"
            }
            
            
            
        }
    }
    
    func setUpListener()  {
        let dog = SQLHelper.sharedInstance.findDog(dogID: (mUserSettings?.currentDog)!)
        let ref = Database.database().reference()
        ref.child((dog?.get(SQLHelper.sharedInstance.onlineID))!).observe(DataEventType.value, with: { (snapshot) in
            self.setUpPage()}) { (error) in print(error.localizedDescription)}
    }
    
    @IBAction func editDog(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "New Dog") as! AddEditDog
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    

}

