//
//  WalkSummary.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/24/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation

class WalkSummary: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var mUserSettings: UserWalkingTheDogSettings?
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var mphLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    let cellArray = SQLHelper.sharedInstance.newAchievements()
    
    var filePath: String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    override func viewDidLoad() {
        mUserSettings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserWalkingTheDogSettings
        let walkTime = mUserSettings!.lastWalkTime.roundTo(places: 2)
        timeLabel.text = "You walked for \(walkTime) minutes!"
        let walkDist = mUserSettings!.lastWalkDist.roundTo(places: 2)
        distLabel.text = "You went \(walkDist) miles!"
        var mph = (mUserSettings?.lastWalkDist)! / (mUserSettings?.lastWalkTime)!
        mph = mph.roundTo(places: 2)
        mphLabel.text = "that is \(mph) mph!"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "achCell", for: indexPath) as? AchievementsCell2
        let achNameArray = cellArray[indexPath.row].getName().components(separatedBy: ";")
        let row = indexPath.row
        cell?.title.text = achNameArray[0]
        cell?.achDescription.text = achNameArray[1]
        var percentage = Int(cellArray[row].getProgress() / cellArray[row].getThreshold() * 100)
        if percentage > 100 {percentage = 100}
        var progress = "\(percentage)%"
        if cellArray[row].getCompleted() == 0 {
            cell?.achPic.isHidden = true
            cell?.title.textColor = UIColor.black
            cell?.progress.text = progress
            if cellArray[row].getType() > 6 && cellArray[row].getType() != 11 {
                if self.cellArray[row].getCompleted() == 1 { progress = progress + " - Earned 1 time."}
                else if self.cellArray[row].getCompleted() > 1 { progress = progress + " - Earned \(self.cellArray[row].getCompleted()) times."}
                cell?.achPic.isHidden = true
                cell?.progress.isHidden = false
                cell?.progress.text = progress
            } else if cellArray[row].getType() > 3 || cellArray[row].getType() == 11 {
                progress = "Earned 0 times."
                cell?.achPic.isHidden = true
                cell?.progress.isHidden = false
                cell?.progress.text = progress
            }
        } else {
            cell?.achPic.isHidden = false
            cell?.progress.isHidden = true
            if cellArray[row].getType() > 6 && cellArray[row].getType() != 11 {
                if self.cellArray[row].getCompleted() == 1 { progress = progress + " - Earned 1 time."}
                else if self.cellArray[row].getCompleted() > 1 { progress = progress + " - Earned \(self.cellArray[row].getCompleted()) times."}
                cell?.achPic.isHidden = true
                cell?.progress.isHidden = false
                cell?.progress.text = progress
            } else if cellArray[row].getType() > 3 || cellArray[row].getType() == 11 {
                if self.cellArray[row].getCompleted() == 1 { progress = progress + " - Earned 1 time."}
                else if self.cellArray[row].getCompleted() > 1 { progress = progress + " - Earned \(self.cellArray[row].getCompleted()) times."}
                else {progress = "Earned 0 times."}
                cell?.achPic.isHidden = true
                cell?.progress.isHidden = false
                cell?.progress.text = progress
            }
        }
        
        return cell!
        
    }
    
    
}

class AchievementsCell2: UITableViewCell {
    
    
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var achDescription: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var achPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
