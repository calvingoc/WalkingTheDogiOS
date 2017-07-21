//
//  Achievements.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/21/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
class Achievements: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    let cellArray = SQLHelper.sharedInstance.allAchievements()
    
    override func viewDidLoad() {
        sideMenu()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SQLHelper.sharedInstance.markAsSeen()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AchievementsCell
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
            if self.cellArray[row].getSeen() == 0 { cell?.title.textColor = UIColor(rgb: 0xFF4081)}
            else { cell?.title.textColor = UIColor.black}
            cell?.layer.backgroundColor = UIColor(rgb: 0xADD8Ef).cgColor
        }
        
        return cell!
        
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

class AchievementsCell: UITableViewCell {
    
    
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
