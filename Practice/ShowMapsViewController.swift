//
//  ShowMapsViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 02/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit

class ShowMapsViewController: UIViewController {

    @IBOutlet weak var myMap: GMSMapView!
    var listToShow : Array<FetchedData> = []
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.myMap.isMyLocationEnabled = true
//        let targetLocation = self.fetchedData.location
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude, zoom: 12.0)
        myMap.camera = camera
        for tmpData in listToShow {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: tmpData.location.coordinate.latitude, longitude: tmpData.location.coordinate.longitude)
            marker.title = tmpData.nameOfFetchedData
            marker.map = myMap
        }
        
        
//        marker.position = CLLocationCoordinate2D(latitude: targetLocation.coordinate.latitude, longitude: targetLocation.coordinate.longitude)
//        marker.title = self.fetchedData.nameOfFetchedData
        //        marker.snippet = "Australia"
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    @IBAction func dismissScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
