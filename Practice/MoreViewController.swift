//
//  MoreViewController.swift
//  Practice
//
//  Created by Muhammad Azher on 04/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds
class MoreViewController: UIViewController,SKStoreProductViewControllerDelegate,GADBannerViewDelegate,GADInterstitialDelegate {

    @IBOutlet weak var myActivity: UIActivityIndicatorView!
    @IBOutlet weak var myBanner: GADBannerView!
    @IBOutlet weak var myConstraint: NSLayoutConstraint!
    var interstitial: GADInterstitial!
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
    override func viewDidAppear(_ animated: Bool) {
        self.myActivity.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showRateUsAction(_ sender: Any) {
//        if interstitial.isReady {
//            interstitial.present(fromRootViewController: self)
//        }
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func showMoreAppsAction(_ sender: Any) {
        self.myActivity.isHidden = false
        self.myActivity.startAnimating()
        let vc : SKStoreProductViewController = SKStoreProductViewController()
        vc.delegate = self
        vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : "1258137713"] , completionBlock: nil)
        self.myActivity.stopAnimating()
        self.myActivity.isHidden = true
        self.present(vc, animated: true, completion: nil)
    }
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
