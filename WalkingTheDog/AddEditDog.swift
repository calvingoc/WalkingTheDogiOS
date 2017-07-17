//
//  AddEditDog.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/17/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
class AddEditDog: UIViewController{
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
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
