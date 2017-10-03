//
//  ShowDetailedViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 28/09/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ShowDetailedViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var myMap: GMSMapView!
    @IBOutlet weak var myImage: UIImageView!
    let locationManager = CLLocationManager()
    var fetchedData : FetchedData = FetchedData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        self.myMap.isMyLocationEnabled = true
        self.myMap.delegate = self
        self.myMap.settings.myLocationButton = true
        let targetLocation = self.fetchedData.location
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: targetLocation.coordinate.latitude, longitude: targetLocation.coordinate.longitude, zoom: 16.0)
        myMap.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: targetLocation.coordinate.latitude, longitude: targetLocation.coordinate.longitude)
        marker.title = self.fetchedData.nameOfFetchedData
//        marker.snippet = "Australia"
        marker.map = myMap
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

    @IBAction func draDirection(_ sender: UIButton) {
//        let str = String(format: "%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@","https://maps.googleapis.com/maps/api/directions/json", locationManager.location!.coordinate.latitude,locationManager.location!.coordinate.longitude,self.fetchedData.location.coordinate.latitude,self.fetchedData.location.coordinate.longitude,"AIzaSyAYiNNVx2EBB8EUJBMWO1g4LD-ndzZDExg")
        
        Alamofire.request(String(format: "%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@","https://maps.googleapis.com/maps/api/directions/json", locationManager.location!.coordinate.latitude,locationManager.location!.coordinate.longitude,self.fetchedData.location.coordinate.latitude,self.fetchedData.location.coordinate.longitude,"AIzaSyAYiNNVx2EBB8EUJBMWO1g4LD-ndzZDExg")).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let a = json as! Dictionary<String,Any>
                
                let routes = a["routes"]! as! Array<Dictionary<String,Any>>
                
//                let legs = routes[0]["legs"] as! Array<Dictionary<String,Any>>
                
//                let steps = legs[0]["steps"] as! Array<Dictionary<String,Any>>
                for route in routes{
                    let overview_polyline = route["overview_polyline"] as! Dictionary<String,String>
                    let points = overview_polyline["points"] as String!
                    print("Points are ",points!)
                    let path1 = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path1)
                    polyline.strokeWidth = 5
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.myMap
                    
                }
//                var fetchedPolylines : Array<String> = []
//                var path = GMSPath()

//                for step in steps{
//
//                    let polyLine = step["polyline"] as! Dictionary<String,String>
//
//                    let point = polyLine["points"]! as! String
//
//                    fetchedPolylines.append(point)
//                }
//                print("Polyline is",fetchedPolylines[0])
                
                
//                for  i in 0...fetchedPolylines[0].count{
//                    print(i)
//                }
//                var singleLinePath = GMSMutablePath()
//                var singleLine = GMSPolyline()
//                singleLinePath.addLatitude(self.fetchedData.location.coordinate.latitude, longitude: self.fetchedData.location.coordinate.longitude)
//                singleLinePath.addLatitude((self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
//                for character in fetchedPolylines[0].characters{
//                    print(character)
////                    path = GMSPath.encodedPath(character)
//                    path = GMSPath.init(fromEncodedPath: String(character))!
//                    singleLine = GMSPolyline.init(path: path)
//                    singleLine.strokeColor = UIColor.red
//                    singleLine.strokeWidth = 5
//                    singleLine.map = self.myMap
//                    path = GMSPath()
//                }
                
            }
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        double rotation = newHeading.magneticHeading * 3.14159 / 180;
        let rotation = newHeading.magneticHeading * 3.14159 / 180
        //    NSLog(@"Rotation is %f",rotation);
        
//        [self.compassImage setTransform:CGAffineTransformMakeRotation(-rotation)];
        self.myImage.transform = .init(rotationAngle: CGFloat(-rotation))
    }
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
        let controller = UIAlertController(title: "Select Action", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Add Location to Favorites", style: .default) { (ab) in
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
        let shareAction = UIAlertAction(title: "Share Location", style: .default) { (shar) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(shareAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
}
