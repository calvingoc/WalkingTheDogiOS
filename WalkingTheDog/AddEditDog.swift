//
//  AddEditDog.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/17/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
import Firebase
class AddEditDog: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var dogName: UITextField!
    @IBOutlet weak var walksEditText: UITextField!
    @IBOutlet weak var timeEditText: UITextField!
    @IBOutlet weak var distanceEditText: UITextField!
    @IBOutlet weak var defaultDogToggle: UISwitch!
    @IBOutlet weak var onWalkToggle: UISwitch!
    @IBOutlet weak var dogPicture: UIImageView!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareableIDButton: UIButton!
    var newDog = true
    var onlineID: String = ""
    var ref: DatabaseReference!
    var mUserSettings: UserWalkingTheDogSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        sideMenu()
        
        if let userSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings {
            mUserSettings = userSettings
            if userSettings.currentDog == -1 as Int64{
                newDogSetUp()
            } else {
                updateDog()
            }
            
        } else {
            newDogSetUp()
            SQLHelper.sharedInstance.setUpTables()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEditDog.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    func newDogSetUp(){
        newDog = true
        deleteButton.isHidden = true
    }
    
    func updateDog(){
        newDog = false
        let dogRow = SQLHelper.sharedInstance.findDog(dogID: mUserSettings.currentDog)
        dogName.text = dogRow?[SQLHelper().dogName]
        walksEditText.text = "\(dogRow?[SQLHelper().walksGoal] ?? 0)"
        timeEditText.text = "\(dogRow?[SQLHelper().timeGoal] ?? 0)"
        distanceEditText.text = "\(dogRow?[SQLHelper().distGoal] ?? 0)"
        
        if (mUserSettings.currentDog == mUserSettings.defaultDog){
            defaultDogToggle.isOn = true
        } else {
            defaultDogToggle.isOn = false
        }
        let dogsOnWalksArray = mUserSettings.dogsOnWalk.components(separatedBy: ",")
        var dogOnWalk = false
        for id in dogsOnWalksArray{
            if (Int64(id) == mUserSettings.currentDog){
                dogOnWalk = true
            }
        }
        onWalkToggle.isOn = dogOnWalk
        if  (dogRow?.get(SQLHelper.sharedInstance.picPath) != "default"){
            dogPicture.image = ImageStore().loadImage(key: "WalkingTheDog\(mUserSettings.currentDog)")
        }
        if dogRow?[SQLHelper().onlineID] != ""{
            shareableIDButton.isEnabled = false
            onlineID = (dogRow?[SQLHelper().onlineID])!
            shareableIDButton.setTitle(onlineID, for: .normal)
        }
        addButton.setTitle("Update", for: .normal)
        deleteButton.setTitle("Take " + (dogRow?[SQLHelper().dogName])! + " to the farm?", for: .normal)
        
    }
    
    
    @IBAction func takePicture(_ sender: UIButton){
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dogPicture.image = UIImage(cgImage: image.cgImage!, scale: CGFloat(1.0), orientation: .right)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func generateOnlineID(_ sender: Any) {
        if dogName.text != "" {
        var name: String? = nil
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 6 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        ref.child(randomString).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            name = value?["name"] as? String ?? "" })
        { (error) in
            print(error.localizedDescription)}
        if name == nil {
            ref.child(randomString).setValue(["name": dogName.text])
            shareableIDButton.isEnabled = false
            shareableIDButton.setTitle(randomString, for: .normal)
            onlineID = randomString
        } else {
            generateOnlineID(shareableIDButton)
        }
        } else {
            shareableIDButton.setTitle("Please enter a name and try again.", for: .normal)
        }
        
        
    }
    
    @IBAction func addUpdate(_ sender: Any) {
        if (dogName.text != "" && walksEditText.text != "" && timeEditText.text != "" && distanceEditText.text != "" && dogName.text?.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil){
            if (newDog){
                let id = SQLHelper.sharedInstance.addDog(newDogName: dogName.text!, nWalksGoal: NSString(string: walksEditText.text!).doubleValue, nTimeGoal: NSString(string: timeEditText.text!).doubleValue, distanceGoal: NSString(string: distanceEditText.text!).doubleValue, picturePath: "WalkingTheDog", shareID: onlineID)
                ImageStore().saveImage(image: dogPicture.image!, key: "WalkingTheDog\(id ?? 1)")
                print("imageKey 1 WalkingTheDog\(id ?? 1)")
                if (mUserSettings == nil){
                    let userData = UserWalkingTheDogSettings(defaultDog: id!, currentDog: id!, dogsOnWalk: ",1", defDogsOnWalk: ",1")
                    mUserSettings = userData
                    mUserSettings.currentDog = id!
                    mUserSettings.defaultDog = id!
                }
                else{
                    mUserSettings.currentDog = id!
                }
                if (onlineID != ""){
                    ref.child(onlineID).observe(DataEventType.value, with: { (snapshot) in
                        let dog = snapshot.value as? NSDictionary
                        SQLHelper.sharedInstance.onlineUpdate(newDogName: dog?["name"] as? String ?? "", onlId: self.onlineID, newWalksGoal: dog?["numWalksGoals"] as? Double ?? 0, newTimeGoal: dog?["timeGoals"] as? Double ?? 0, newDistGoal: dog?["distanceGoal"] as? Double ?? 0, newcurTime: dog?["walkTime"] as? Double ?? 0, newCurWalks: dog?["numWalks"] as? Double ?? 0, newCurDist: dog?["curentDistance"] as? Double ?? 0, newStreak: dog?["streak"] as? Double ?? 0, newTotWalks: dog?["totalWalks"] as? Double ?? 0, newTotTime: dog?["totalTime"] as? Double ?? 0, newTotDist: dog?["totalDist"] as? Double ?? 0, newTotDays: dog?["totalDays"] as? Double ?? 0, newBestTime: dog?["bestTimeWalk"] as? Double ?? 0, newBestDist: dog?["BestDistWalk"] as? Double ?? 0, newBestTimeDay: dog?["bestTimeDay"] as? Double ?? 0, newBestDistDay: dog?["bestDistDay"] as? Double ?? 0, newBestWAlks: dog?["bestWalks"] as? Double ?? 0, newBestStreaks: dog?["bestStreak"] as? Double ?? 0, newLastDaySynced: dog?["lastDaySynced"] as? Double ?? 0)
                        ViewController().setUpPage()
                    })
                    { (error) in print(error.localizedDescription)}
                }
                SQLHelper.sharedInstance.updateAchievements(updateType: 0, value: 1)
            }else{
                SQLHelper().updateDog(newDogName: dogName.text!, nWalksGoal: NSString(string: walksEditText.text!).doubleValue, nTimeGoal: NSString(string: timeEditText.text!).doubleValue, distanceGoal: NSString(string: distanceEditText.text!).doubleValue, picturePath: "WalkingTheDog", shareID: onlineID, dogID: mUserSettings.currentDog)
                ImageStore().saveImage(image: dogPicture.image!, key: "WalkingTheDog\(String(describing: mUserSettings.currentDog))")
                print("imageKey 2 WalkingTheDog\(String(describing: mUserSettings.currentDog))")
            }
            if defaultDogToggle.isOn {
                mUserSettings.defaultDog = mUserSettings.currentDog
            }
            let dogsOnWalksArray = mUserSettings.dogsOnWalk.components(separatedBy: ",")
            var dogOnWalk = false
            for ids in dogsOnWalksArray{
                if (Int64(ids) == mUserSettings.currentDog){
                    dogOnWalk = true
                }
            }
            if (onWalkToggle.isOn && !dogOnWalk){
                mUserSettings.dogsOnWalk = mUserSettings.dogsOnWalk + "," + "\(String(describing: mUserSettings.currentDog))"
                mUserSettings.defDogsOnWalk = mUserSettings.dogsOnWalk
            }
            if (!onWalkToggle.isOn && dogOnWalk){
                mUserSettings.dogsOnWalk = mUserSettings.dogsOnWalk.replacingOccurrences(of: ",\(mUserSettings.currentDog)", with: "")
            }
            NSKeyedArchiver.archiveRootObject(mUserSettings, toFile: filePath)
            
            if onlineID != "" {
                ref.child(onlineID + "/name").setValue(dogName.text)
                ref.child(onlineID + "/numWalksGoals").setValue(NSString(string: walksEditText.text!).doubleValue)
                ref.child(onlineID + "/timeGoals").setValue(NSString(string: timeEditText.text!).doubleValue)
                ref.child(onlineID + "/distanceGoal").setValue(NSString(string: distanceEditText.text!).doubleValue)
            }
            
            _ = navigationController?.popToRootViewController(animated: true)
            
        } else{
            addButton.setTitle("Please fill all feilds and try again.", for: .normal)
        }
        
    }
    
    @IBAction func deleteDog(_ sender: Any) {
        let newDefDog = SQLHelper.sharedInstance.deleteDog(dogID: mUserSettings.currentDog)
        let deletedDogID = mUserSettings.currentDog
        if (mUserSettings.defaultDog == mUserSettings.currentDog){
            mUserSettings.defaultDog = newDefDog!
            mUserSettings.currentDog = newDefDog!
        } else {
            mUserSettings.currentDog = mUserSettings.defaultDog
        }
        let dogsOnWalksArray = mUserSettings.dogsOnWalk.components(separatedBy: ",")
        var newDogsOnWalk = ""
        var first = true
        for ids in dogsOnWalksArray{
            if (Int64(ids) != deletedDogID){
                if first {
                    newDogsOnWalk = ids
                    first = false
                }
                else {
                    newDogsOnWalk = newDogsOnWalk + "," + ids
                }
            }
        }
        mUserSettings.defDogsOnWalk = newDogsOnWalk
        mUserSettings.dogsOnWalk = newDogsOnWalk
        NSKeyedArchiver.archiveRootObject(mUserSettings, toFile: filePath)
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
}
