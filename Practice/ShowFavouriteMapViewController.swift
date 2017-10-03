//
//  ShowFavouriteMapViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 03/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import CoreData

class ShowFavouriteMapViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var myMap: GMSMapView!
    @IBOutlet weak var myImage: UIImageView!
    var objectToShow : NSManagedObject? = nil
    let locationManager = CLLocationManager()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        self.myMap.settings.myLocationButton = true
        
        self.myMap.isMyLocationEnabled = true
        //        let targetLocation = self.fetchedData.location
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(self.objectToShow?.value(forKey: "latOfLocation")! as! String)!, longitude: Double(self.objectToShow?.value(forKey: "longOfLocation")! as! String)!, zoom: 12.0)
        myMap.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(self.objectToShow?.value(forKey: "latOfLocation")! as! String)!, longitude: Double(self.objectToShow?.value(forKey: "longOfLocation")! as! String)!)
        marker.title = self.objectToShow?.value(forKey: "nameOfLocation")! as? String
        marker.map = myMap
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(self.objectToShow?.value(forKey: "nameOfLocation")! as! String)
//        locationManager.delegate = self as? CLLocationManagerDelegate
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//
//        self.myMap.isMyLocationEnabled = true
//        //        let targetLocation = self.fetchedData.location
//        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(self.objectToShow?.value(forKey: "latOfLocation")! as! String)!, longitude: Double(self.objectToShow?.value(forKey: "longOfLocation")! as! String)!, zoom: 12.0)
//        myMap.camera = camera
//
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: Double(self.objectToShow?.value(forKey: "latOfLocation")! as! String)!, longitude: Double(self.objectToShow?.value(forKey: "longOfLocation")! as! String)!)
//        marker.title = self.objectToShow?.value(forKey: "nameOfLocation")! as? String
//        marker.map = myMap
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //        double rotation = newHeading.magneticHeading * 3.14159 / 180;
        let rotation = newHeading.magneticHeading * 3.14159 / 180
        //    NSLog(@"Rotation is %f",rotation);
        
        //        [self.compassImage setTransform:CGAffineTransformMakeRotation(-rotation)];
        self.myImage.transform = .init(rotationAngle: CGFloat(-rotation))
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _:CLLocationCoordinate2D = manager.location!.coordinate
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
