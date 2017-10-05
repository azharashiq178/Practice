//
//  ShowMapsViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 02/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import GoogleMobileAds

class ShowMapsViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,GADBannerViewDelegate {

    @IBOutlet weak var myBanner: GADBannerView!
    @IBOutlet weak var myMap: GMSMapView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myConstraint: NSLayoutConstraint!
    var listToShow : Array<FetchedData> = []
    var typeOfSearch : String = ""
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myBanner.adUnitID = "ca-app-pub-6412217023250030/8468198649"
        self.myBanner.rootViewController = self
        let request = GADRequest()
        self.myBanner.delegate = self
//        request.testDevices = [kGADSimulatorID ];
        
        self.myBanner.load(request)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        self.myMap.isMyLocationEnabled = true
        self.myMap.delegate = self
        self.myMap.settings.myLocationButton = true
        self.myMap.settings.compassButton = true
//        let targetLocation = self.fetchedData.location
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude, zoom: 12.0)
        myMap.camera = camera
        for tmpData in listToShow {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: tmpData.location.coordinate.latitude, longitude: tmpData.location.coordinate.longitude)
            marker.title = tmpData.nameOfFetchedData
            marker.map = myMap
            marker.icon = UIImage(named: "pin_\(self.typeOfSearch)")
        }
        
        
//        marker.position = CLLocationCoordinate2D(latitude: targetLocation.coordinate.latitude, longitude: targetLocation.coordinate.longitude)
//        marker.title = self.fetchedData.nameOfFetchedData
        //        marker.snippet = "Australia"
//        marker.map = myMap
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //        double rotation = newHeading.magneticHeading * 3.14159 / 180;
        let rotation = newHeading.magneticHeading * 3.14159 / 180
        //    NSLog(@"Rotation is %f",rotation);
        
        //        [self.compassImage setTransform:CGAffineTransformMakeRotation(-rotation)];
        self.myImage.transform = .init(rotationAngle: CGFloat(-rotation))
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
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You long pressed coordinate",coordinate)
        var nameOfCoordinate = ""
        var nameOfSelectedLocation = ""
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
                nameOfSelectedLocation = ab[0]["formatted_address"] as! String
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
            let activityViewController = UIActivityViewController(activityItems: [nameOfSelectedLocation], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(shareAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        self.myConstraint.constant = 44
        self.myBanner.layoutIfNeeded()
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
