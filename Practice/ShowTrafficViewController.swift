//
//  ShowTrafficViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 03/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ShowTrafficViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var myMap: GMSMapView!
    let locationManager = CLLocationManager()
//    var location: [NSManagedObject] = []
    
    @IBOutlet weak var myImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        self.myMap.isMyLocationEnabled = true
        self.myMap.settings.myLocationButton = true
        
        
        self.myMap.isMyLocationEnabled = true
        self.myMap.delegate = self
        self.myMap.isTrafficEnabled = true
        //        let targetLocation = self.fetchedData.location
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude, zoom: 12.0)
        myMap.camera = camera
        
        // Do any additional setup after loading the view.
    }
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

    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.myMap.mapType = .normal
            break
        case 1:
            self.myMap.mapType = .satellite
            break
        case 3:
            self.myMap.mapType = .hybrid
            break
        case 4:
            self.myMap.mapType = .terrain
            break
        default:
            self.myMap.mapType = .normal
        }
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You long pressed coordinate",coordinate)
        var nameOfCoordinate = ""
        Alamofire.request(String(format: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinate.latitude),\(coordinate.longitude)&key=AIzaSyAYiNNVx2EBB8EUJBMWO1g4LD-ndzZDExg")).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
                let a = json as! Dictionary<String,Any>
                let ab = a["results"] as! Array<Dictionary<String,Any>>
//                let b = a["results"]![0]
//                print(b["address_components"]!)
                let tmpArr = ab[0]["address_components"] as! Array<Dictionary<String,Any>>
//                print(ab[0]["address_components"]!)
                nameOfCoordinate = tmpArr[0]["long_name"]! as! String
                
//                print("Value is ",tmpArr[0]["long_name"]!)
                
            }
        }
        let controller = UIAlertController(title: "Add to Favourite?", message: "Do you want to add this Location to Favourite", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (ab) in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: managedContext)!
            let tmpLocation = NSManagedObject(entity: entity,insertInto: managedContext)
            tmpLocation.setValue(nameOfCoordinate, forKey: "nameOfLocation")
            tmpLocation.setValue(String(format: "%f", coordinate.latitude), forKey: "latOfLocation")
            tmpLocation.setValue(String(format: "%f", coordinate.longitude), forKey: "longOfLocation")
            do {
                try managedContext.save()
                print("Saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            
            print("Your location name is ",nameOfCoordinate)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
}
