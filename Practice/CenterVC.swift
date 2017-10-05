//
//  CenterVC.swift
//  Practice
//
//  Created by Muhammad Azher on 26/09/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import GoogleMobileAds
class CenterVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GADBannerViewDelegate,GADInterstitialDelegate,UITabBarControllerDelegate {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var myBanner: GADBannerView!
    @IBOutlet weak var myConstraint: NSLayoutConstraint!
    var interstitial: GADInterstitial!
    //    var categories : Array<String> = []
    var myCategories : Array<CategoryData> = []
    var myType : String = ""
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "AroundMe"
        
//        print(self.didMove(toParentViewController: self.navigationController) as Bool!)
//        print(self.tabBarController?.selectedIndex as Int!)
        
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.topItem?.title = "AroundMe"
        self.myBanner.adUnitID = "ca-app-pub-6412217023250030/8468198649"
        self.myBanner.rootViewController = self
        let request = GADRequest()
        self.myBanner.delegate = self
//        request.testDevices = [kGADSimulatorID ];
        
        self.myBanner.load(request)
        
        interstitial = createAndLoadInterstitial()
        
        
//        self.categories = ["Banks/ATM","Bars","Cinema","Coffee Bar","Airport","Clothing Store","Hospitals","Hostels","Doctor","Parking","Mosque","Pharmacies","gas_station","Resturants","grocery_or_supermarket","bus_station","movie_theater"]
        ///
        self.appendInMyCategory(name: "Banks/ATM", searchName: "bank", imageName: "bank")
        self.appendInMyCategory(name: "Hospitals", searchName: "hospital", imageName: "hospital")
        self.appendInMyCategory(name: "Pharmacies", searchName: "pharmacy", imageName: "pharmacy")
        self.appendInMyCategory(name: "Doctor", searchName: "doctor", imageName: "doctor")
        self.appendInMyCategory(name: "Petrol Station", searchName: "gas_station", imageName: "gas_station")
        self.appendInMyCategory(name: "Airport", searchName: "airport", imageName: "airport")
        self.appendInMyCategory(name: "Bus Stop", searchName: "bus_station", imageName: "bus_station")
        self.appendInMyCategory(name: "Train Station", searchName: "train_station", imageName: "train_station")
        self.appendInMyCategory(name: "Fire Station", searchName: "fire_station", imageName: "fire-station")
        self.appendInMyCategory(name: "Park", searchName: "park", imageName: "park")
        self.appendInMyCategory(name: "Parking", searchName: "parking", imageName: "parking")
        self.appendInMyCategory(name: "Car Rental", searchName: "car_rental", imageName: "car_rental")
        self.appendInMyCategory(name: "Car Wash", searchName: "car_wash", imageName: "car_wash")
        self.appendInMyCategory(name: "Shopping Mall", searchName: "shopping_mall", imageName: "shopping_mall")
        self.appendInMyCategory(name: "Clothing", searchName: "clothing_store", imageName: "clothing_store")
        self.appendInMyCategory(name: "Store", searchName: "store", imageName: "store")
        self.appendInMyCategory(name: "Grocery", searchName: "grocery_or_supermarket", imageName: "grocery")
        self.appendInMyCategory(name: "Beauty Saloon", searchName: "beauty_salon", imageName: "beauty_salon")
        self.appendInMyCategory(name: "Gym", searchName: "gym", imageName: "gym")
        self.appendInMyCategory(name: "Cinema", searchName: "movie_theater", imageName: "movie_theater")
        self.appendInMyCategory(name: "Restaurant", searchName: "restaurant", imageName: "resturant")
        self.appendInMyCategory(name: "Coffee Bar", searchName: "cafe", imageName: "cafe")
        self.appendInMyCategory(name: "Bars", searchName: "bar", imageName: "bar")
        self.appendInMyCategory(name: "Bakery", searchName: "bakery", imageName: "bakery")
        self.appendInMyCategory(name: "Mosque", searchName: "mosque", imageName: "mosque")
        self.appendInMyCategory(name: "Church", searchName: "church", imageName: "church")
        self.appendInMyCategory(name: "School", searchName: "school", imageName: "school")
        self.appendInMyCategory(name: "Book Store", searchName: "book_store", imageName: "book_store")
        self.appendInMyCategory(name: "Accounting", searchName: "accounting", imageName: "accounting")
        self.appendInMyCategory(name: "Aquarium", searchName: "aquarium", imageName: "aquarium")
        self.appendInMyCategory(name: "Art Gallery", searchName: "art_gallery", imageName: "art_gallery")
        self.appendInMyCategory(name: "Laundry", searchName: "laundry", imageName: "laundry")
        self.appendInMyCategory(name: "Casino", searchName: "casino", imageName: "casino")
        self.appendInMyCategory(name: "Zoo", searchName: "zoo", imageName: "zoo")
        
        ////
        
//        let myButton = UIBarButtonItem(title: "A", style: .plain, target: self, action: #selector(openPanel))
//        let myButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openPanel))
//        myButton.tintColor = UIColor.black
////        self.title = "AroundMe"
//
//        self.navigationItem.leftBarButtonItem = myButton
        
        self.categoryCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    func appendInMyCategory(name : String, searchName : String, imageName: String) {
        let tmpCategory = CategoryData()
        tmpCategory.nameOfCategory = name
        tmpCategory.searchNameOfCategory = searchName
        tmpCategory.imageName = imageName
        self.myCategories.append(tmpCategory)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func openPanel() {
        panel?.openLeft(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        cell.myText.text = self.myCategories[indexPath.row].nameOfCategory
        cell.categoryImage.image = UIImage(named: self.myCategories[indexPath.row].imageName)
        if indexPath.row % 2 == 0{
            cell.myView.backgroundColor = UIColor(red:0.95, green:0.43, blue:0.49, alpha:1.0)
        }
        else{
            cell.myView.backgroundColor = UIColor(red:0.52, green:0.38, blue:0.66, alpha:1.0)
        }
        if indexPath.row % 3 == 0{
            cell.myView.backgroundColor = UIColor(red:0.20, green:0.84, blue:0.51, alpha:1.0)
        }
        if indexPath.row % 4 == 0{
            cell.myView.backgroundColor = UIColor(red:0.00, green:0.75, blue:0.95, alpha:1.0)
        }
        if indexPath.row % 5 == 0{
            cell.myView.backgroundColor = UIColor(red:0.93, green:0.67, blue:0.28, alpha:1.0)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 12, height: 107)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.myType = self.myCategories[indexPath.row].searchNameOfCategory
//        print(self.myCategories[indexPath.row].searchNameOfCategory)
        self.performSegue(withIdentifier: "showPlaces", sender: self);
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaces"{
            let controller = segue.destination as? ShowPlacesVC
            controller?.typeToSearch = self.myType
//            self.present(controller!, animated: true, completion: nil)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-6412217023250030/7837465646")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
}
