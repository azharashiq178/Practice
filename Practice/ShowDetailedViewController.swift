//
//  ShowDetailedViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 28/09/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import Alamofire

class ShowDetailedViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var myMap: GMSMapView!
    let locationManager = CLLocationManager()
    var fetchedData : FetchedData = FetchedData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.myMap.isMyLocationEnabled = true
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

    @IBAction func draDirection(_ sender: UIBarButtonItem) {
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
    
}
