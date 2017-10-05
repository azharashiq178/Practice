//
//  FavouritesViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 03/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class FavouritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate {
    var location: [NSManagedObject] = []
    @IBOutlet weak var myConstraint: NSLayoutConstraint!
    @IBOutlet weak var myBanner: GADBannerView!
    var objToPass : NSManagedObject? = nil
    var interstitial: GADInterstitial!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myBanner.adUnitID = "ca-app-pub-6412217023250030/8468198649"
        self.myBanner.rootViewController = self
        let request = GADRequest()
        self.myBanner.delegate = self
//        request.testDevices = [kGADSimulatorID ];
        
        self.myBanner.load(request)
        interstitial = createAndLoadInterstitial()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        self.navigationController?.navigationBar.topItem?.title = "Favorites"
        self.tableView.allowsMultipleSelectionDuringEditing = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        do {
            self.location  = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.location.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.location[indexPath.row].value(forKey: "nameOfLocation") as? String
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.objToPass = self.location[indexPath.row]
        self.performSegue(withIdentifier: "showFavourite", sender: self)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("hey")
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.persistentContainer.viewContext
            managedContext.delete(self.location[indexPath.row])
            do {
                try managedContext.save() // <- remember to put this :)
                self.location.remove(at: indexPath.row)
                tableView.reloadData()
            } catch {
                // Do something... fatalerror
            }
            
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavourite"{
            let vc = segue.destination as! ShowFavouriteMapViewController
            vc.objectToShow = self.objToPass
            
        }
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
