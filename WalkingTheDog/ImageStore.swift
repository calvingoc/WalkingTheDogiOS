//
//  ImageStore.swift
//  WalkingTheDog
//
//  Created by Application Development on 7/18/17.
//  Copyright © 2017 cagocapps. All rights reserved.
//

import Foundation
import UIKit

class ImageStore{
    func saveImage(image: UIImage, key: String) {
        let pngImageData:NSData = UIImagePNGRepresentation(image)! as NSData
        UserDefaults.standard.set(pngImageData, forKey: key)
    }
    
    func loadImage(key: String) -> UIImage {
        let data = UserDefaults.standard.object(forKey: key) as! NSData
        return UIImage(data: data as Data)!
    }
}
