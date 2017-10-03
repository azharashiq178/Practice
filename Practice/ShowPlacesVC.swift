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
import ARKit



extension ShowPlacesVC: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
//        annotationView.backgroundColor = UIColor.blue
        
        return annotationView
    }
}
extension ShowPlacesVC: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        print("Tapped view for POI: \(annotationView.titleLabel?.text)")
    }
}


class ShowPlacesVC: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var fetchedTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    var fetchedNames : Array<FetchedData> = []
    var typeToSearch : String = ""
    let locationManager = CLLocationManager()
    var dataToPass : FetchedData = FetchedData()
    fileprivate var arViewController: ARViewController!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mySegmentedControl.selectedSegmentIndex = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mySegmentedControl.addTarget(self, action: #selector(segmentControlAction(sender:)), for: .valueChanged)
        let myButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(showLiveView))
        myButton.tintColor = UIColor.black
        self.title = "AroundMe"
        
//        self.navigationItem.rightBarButtonItem = myButton
        
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
    @objc func showLiveView() {
        arViewController = ARViewController()
        //1
        arViewController.dataSource = self as ARDataSource
        //2
        arViewController.maxVisibleAnnotations = 30
        arViewController.headingSmoothingFactor = 0.05
        //3
        var places = [Place]()
        for tmp in self.fetchedNames {
            let location = tmp.location as! CLLocation
            let name = tmp.nameOfFetchedData as! String
            let address = tmp.locationOfFetchedData as! String
            let place = Place(location: location, reference: "", name: name, address: address)
            
            places.append(place)
        }
        arViewController.setAnnotations(places)

        self.present(arViewController, animated: true, completion: nil)
    }
    func showMapAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! ShowMapsViewController
        vc.listToShow = self.fetchedNames
        self.present(vc, animated: true, completion: nil)
    }
    @objc func segmentControlAction(sender:UISegmentedControl){
        if(sender.selectedSegmentIndex == 0){}
        if(sender.selectedSegmentIndex == 1){
            self.showMapAction()
        }
        if(sender.selectedSegmentIndex == 2){
            self.showLiveView()
        }
    }
}
