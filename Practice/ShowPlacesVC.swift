//
//  ShowPlacesVC.swift
//  Practice
//
//  Created by Muhammad Azher on 26/09/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import Alamofire




class ShowPlacesVC: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var fetchedTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var fetchedNames : Array<FetchedData> = []
    var typeToSearch : String = ""
    let locationManager = CLLocationManager()
    var dataToPass : FetchedData = FetchedData()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.fetchedTableView.register(ShowFetchedDataTableViewCell.self, forCellReuseIdentifier: "cell")
        self.fetchedTableView.delegate = self
        self.fetchedTableView.dataSource = self
        
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print("My Location")
        print(locationManager.location!.coordinate.latitude,locationManager.location!.coordinate.longitude)
        self.fetchedTableView.isHidden = true
        self.activityIndicator.startAnimating()
        let ab = locationManager.location?.distance(from: locationManager.location!)
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationManager.location!.coordinate.latitude),\(locationManager.location!.coordinate.longitude)&radius=5000&type=\(self.typeToSearch)&keyword=&key=AIzaSyAYiNNVx2EBB8EUJBMWO1g4LD-ndzZDExg").responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                
                let a = json as! [String:Any]
                
                print("My a is :",a["results"]!)
                let b = a["results"] as! Array<Dictionary<String,Any>>
                if(b.count != 0){
                    
                    print("My Data is ",b[0]["name"]!)
                    
                    for tmp in b {
                        print("Searched name is ",tmp["geometry"]!)
                        let myLoc = tmp["geometry"] as! Dictionary<String,Dictionary<String,Any>>
                        print("My Location is ",myLoc["location"]!["lat"]!)
                        let myLat = myLoc["location"]!["lat"]! as! Double
                        let myLong = myLoc["location"]!["lng"]! as! Double
                        print("My Latitude is ",myLat,myLong)
                        let myCoordinate = CLLocation(latitude: myLat, longitude: myLong)
                        let tmpData = FetchedData()
                        
                        tmpData.nameOfFetchedData = tmp["name"]! as! String
                        
                        tmpData.locationOfFetchedData = tmp["vicinity"]! as! String
                        tmpData.location = myCoordinate
                        if(tmp["rating"] != nil){
                            tmpData.ratings = tmp["rating"]! as! Float
                        }
                        
                        self.fetchedNames.append(tmpData)
                    }
                    self.fetchedTableView.reloadData()
                    self.fetchedTableView.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                else{
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    let controller = UIAlertController(title: "No Data Found", message: "No Data Found", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    controller.addAction(cancelAction)
                    self.present(controller, animated: true, completion: nil)
                    print("No Data found")
                }
                
//                print("My Value: ")
//                let tmp = b[0]
//
//                print(tmp["geometry"]!)
//                print(b[0]["geometry"]!)
//                print("value of a is",b0["geometry"]!)

//                print("ab")
                
            }
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//
//            }
        }

        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let controller = segue.destination as! ShowDetailedViewController
            controller.fetchedData = self.dataToPass
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowFetchedDataTableViewCell
        let tmpData = self.fetchedNames[indexPath.row]
        cell.fetchedName?.text = tmpData.nameOfFetchedData
        cell.fetchedLocation?.text = tmpData.locationOfFetchedData
        cell.totalRating.value = CGFloat(tmpData.ratings)
        let ab = locationManager.location?.distance(from: tmpData.location)
        print("Distance is ",ab!/1000)
        cell.totalDistance.text = String(format: "%.1f km", ab!/1000)
//        let numberFormatter = NumberFormatter()
//        let number = numberFormatter.number(from: tmpData.ratings as! String)
//        cell.totalRating?.value = tmpData.ratings as! CGFloat
//        cell.totalRating?.value = CGFloat(tmpData.ratings as! CGFloat)
//        cell.fetchedName.text = "Azher"
        
//        cell.backgroundColor = UIColor.blue
//        cell.textLabel?.text = self.fetchedNames[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataToPass = self.fetchedNames[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
}
