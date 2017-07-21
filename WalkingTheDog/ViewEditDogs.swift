//
//  ViewEditDogs.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/21/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
class ViewEditDogs: UITableViewController{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    let cellArray = SQLHelper.sharedInstance.allDogs()
    var mUserSettings: UserWalkingTheDogSettings?
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    override func viewDidLoad() {
        sideMenu()
        if let userSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings{
            mUserSettings = userSettings
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SQLHelper.sharedInstance.numberOfDogs()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllDogsCells
        cell.dogName.text = cellArray[indexPath.row].getName()
        cell.dogPicture.image = cellArray[indexPath.row].getImage()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mUserSettings!.currentDog = cellArray[indexPath.row].getID()
        NSKeyedArchiver.archiveRootObject(mUserSettings!, toFile: filePath)
        UIApplication.shared.sendAction(backButton.action!, to: backButton.target, from: self, for: nil)
        //_ = navigationController?.popViewController(animated: true)
        
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

class AllDogsCells: UITableViewCell{
    
    @IBOutlet weak var dogPicture: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
