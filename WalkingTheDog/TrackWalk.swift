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

class TrackWalk: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var dogsTable: UITableView!
    
    @IBOutlet weak var milesValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var totalDistance = 0.0
    var locationCount = 0
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    @IBAction func changeDogs(_ sender: Any) {
    }
    @IBAction func endWalk(_ sender: Any) {
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
            totalDistance = totalDistance + (lastLocation?.distance(from: locations[0]))! / 1609.34
            milesValue.text = "\(totalDistance)"
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
