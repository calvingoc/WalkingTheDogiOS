//
//  ImportDog.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/20/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
import Firebase

class ImportDog: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var createNewDogButton: UIButton!
    @IBOutlet weak var importID: UITextField!
    @IBOutlet weak var checkIDButton: UIButton!
    @IBOutlet weak var importLabel: UILabel!
    @IBOutlet weak var importDogButton: UIButton!
    var mUserSettings: UserWalkingTheDogSettings!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        sideMenu()
        if let userSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings {
            mUserSettings = userSettings
        }
        ref = Database.database().reference()
        importID.text = nil
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImportDog.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func createNewDog(_ sender: Any) {
        if (mUserSettings != nil){
            mUserSettings.currentDog = -1
            NSKeyedArchiver.archiveRootObject(mUserSettings, toFile: filePath)
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "New Dog") as! AddEditDog
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    
    @IBAction func checkID(_ sender: Any) {
        view.endEditing(true)
        let tempID = importID.text
        if (tempID?.characters.count != 6 && tempID?.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil){
            importLabel.text = "Invalid ID please check your entry and try again."
        } else {
            if (SQLHelper.sharedInstance.findDogByOnlineID(ID: tempID!) == nil){
                
            ref.child(tempID!).observeSingleEvent(of: .value , with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                if (name.characters.count != 0){
                    self.importLabel.text = "Would you like to import \(name)?"
                    self.importDogButton.isHidden = false
                }
                else{
                    self.importLabel.text = "Invalid ID please check your entry and try again."
                }}) { (error) in print(error.localizedDescription)}
            } else {
                self.importLabel.text = "You already have that dog on your phone!"
            }
        }
    }
    
    @IBAction func importDog(_ sender: Any) {
        let tempID = importID.text
        ref.child(tempID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let dog = snapshot.value as? NSDictionary
            let newID2 = SQLHelper.sharedInstance.importDog(newDogName: dog?["name"] as? String ?? "", onlId: tempID!, newWalksGoal: dog?["numWalksGoals"] as? Double ?? 0, newTimeGoal: dog?["timeGoals"] as? Double ?? 0, newDistGoal: dog?["distanceGoal"] as? Double ?? 0, newcurTime: dog?["walkTime"] as? Double ?? 0, newCurWalks: dog?["numWalks"] as? Double ?? 0, newCurDist: dog?["curentDistance"] as? Double ?? 0, newStreak: dog?["streak"] as? Double ?? 0, newTotWalks: dog?["totalWalks"] as? Double ?? 0, newTotTime: dog?["totalTime"] as? Double ?? 0, newTotDist: dog?["totalDist"] as? Double ?? 0, newTotDays: dog?["totalDays"] as? Double ?? 0, newBestTime: dog?["bestTimeWalk"] as? Double ?? 0, newBestDist: dog?["BestDistWalk"] as? Double ?? 0, newBestTimeDay: dog?["bestTimeDay"] as? Double ?? 0, newBestDistDay: dog?["bestDistDay"] as? Double ?? 0, newBestWAlks: dog?["bestWalks"] as? Double ?? 0, newBestStreaks: dog?["bestStreak"] as? Double ?? 0, newLastDaySynced: dog?["lastDaySynced"] as? Double ?? 0)!
            print("import id check  1 \(String(describing: newID2))")})
        { (error) in print("import failed" + error.localizedDescription)}
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
        let newID = SQLHelper.sharedInstance.findDogByOnlineID(ID: tempID!)?.get(SQLHelper.sharedInstance.id)
        print("import id check  2 \(String(describing: newID))")
        if (newID == nil){
            self.importLabel.text = "Import failed, please try again later."
        } else {
            self.ref.child(tempID!).observe(DataEventType.value, with: { (snapshot) in
                let dog = snapshot.value as? NSDictionary
                SQLHelper.sharedInstance.onlineUpdate(newDogName: dog?["name"] as? String ?? "", onlId: tempID!, newWalksGoal: dog?["numWalksGoals"] as? Double ?? 0, newTimeGoal: dog?["timeGoals"] as? Double ?? 0, newDistGoal: dog?["distanceGoal"] as? Double ?? 0, newcurTime: dog?["walkTime"] as? Double ?? 0, newCurWalks: dog?["numWalks"] as? Double ?? 0, newCurDist: dog?["curentDistance"] as? Double ?? 0, newStreak: dog?["streak"] as? Double ?? 0, newTotWalks: dog?["totalWalks"] as? Double ?? 0, newTotTime: dog?["totalTime"] as? Double ?? 0, newTotDist: dog?["totalDist"] as? Double ?? 0, newTotDays: dog?["totalDays"] as? Double ?? 0, newBestTime: dog?["bestTimeWalk"] as? Double ?? 0, newBestDist: dog?["BestDistWalk"] as? Double ?? 0, newBestTimeDay: dog?["bestTimeDay"] as? Double ?? 0, newBestDistDay: dog?["bestDistDay"] as? Double ?? 0, newBestWAlks: dog?["bestWalks"] as? Double ?? 0, newBestStreaks: dog?["bestStreak"] as? Double ?? 0, newLastDaySynced: dog?["lastDaySynced"] as? Double ?? 0)
                ViewController().setUpPage()
            })
            { (error) in print(error.localizedDescription)}
        }
            if (self.mUserSettings != nil){
                self.mUserSettings.currentDog = newID!
            } else {
                let userData = UserWalkingTheDogSettings(defaultDog: newID!, currentDog: newID!, dogsOnWalk: "1", defDogsOnWalk: "1")
                self.mUserSettings = userData
                self.mUserSettings.currentDog = newID!
                self.mUserSettings.defaultDog = newID!
            }
            self.importID.text = nil
            NSKeyedArchiver.archiveRootObject(self.mUserSettings, toFile: self.filePath)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "New Dog") as! AddEditDog
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    @IBAction func onEditChange(_ sender: UITextField) {
        importDogButton.isHidden = true
    }
    
}


