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
    
    
    var bannerView: GADBannerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = SQLHelper().openDataBase()
        
        if let data = UserDefaults.standard.data(forKey: "WalkingTheDog"),
            let userSettings = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserWalkingTheDogSettings {
            dogName.text = SQLHelper().findDogName(dogID: userSettings.defaultDog, db: db!)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "New Dog") as! AddEditDog
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
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
    

}

