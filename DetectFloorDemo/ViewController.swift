//
//  ViewController.swift
//  DetectFloorDemo
//
//  Created by qingjiezhao on 7/16/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    var locationManager:CLLocationManager?
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("Updating locations ... \(__FUNCTION__)")
        txtView.text = "Updating locations ... \(__FUNCTION__)"
        if locations.count > 0 {
            let location = (locations as! [CLLocation])[0]
            println("Location found = \(location)")
            if let theFloor = location.floor{
                println("The floor information is  = \(theFloor)")
                
                lbl.text = "The floor information is  = \(theFloor)"
                lbl.backgroundColor = UIColor.greenColor()
            }else{
                println("No floor information is available")
                lbl.text = "No floor information is available"
                lbl.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("Latitude = \(newLocation.coordinate.latitude)")
        println("Longitude = \(newLocation.coordinate.longitude)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("The authorization status of location services is changed to: ")
      
        switch CLLocationManager.authorizationStatus() {
            case .Denied:
                println("Denied")
            case .NotDetermined:
                println("Not determined")
                if let manager = locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                println("Restricted")
            default:
                println("Authorized")
            
        }
    }
    
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func createLocationManager(startImmediately:Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            println("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .Denied:
                displayAlertWithTitle("Denied",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                createLocationManager(false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            default:
                createLocationManager(true)
            }
        }else{
            println("Location services are not enabled")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var systemVersion = UIDevice.currentDevice().systemVersion;
        println(systemVersion)
    }



}









