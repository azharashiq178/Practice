//
//  CenterVC.swift
//  Practice
//
//  Created by Muhammad Azher on 26/09/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit

class CenterVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
//    var categories : Array<String> = []
    var myCategories : Array<CategoryData> = []
    var myType : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.categories = ["Banks/ATM","Bars","Cinema","Coffee Bar","Airport","Clothing Store","Hospitals","Hostels","Doctor","Parking","Mosque","Pharmacies","gas_station","Resturants","grocery_or_supermarket","bus_station","movie_theater"]
        ///
        self.appendInMyCategory(name: "Banks/ATM", searchName: "bank")
        self.appendInMyCategory(name: "Bars", searchName: "bar")
        self.appendInMyCategory(name: "Cinema", searchName: "movie_theater")
        self.appendInMyCategory(name: "Coffee Bar", searchName: "cafe")
        self.appendInMyCategory(name: "Airport", searchName: "airport")
        self.appendInMyCategory(name: "Clothing", searchName: "clothing_store")
        self.appendInMyCategory(name: "Store", searchName: "store")
        self.appendInMyCategory(name: "Hospitals", searchName: "hospital")
        self.appendInMyCategory(name: "Doctor", searchName: "doctor")
        self.appendInMyCategory(name: "Parking", searchName: "parking")
        self.appendInMyCategory(name: "Mosque", searchName: "mosque")
        self.appendInMyCategory(name: "Pharmacies", searchName: "pharmacy")
        self.appendInMyCategory(name: "Petrol Station", searchName: "gas_station")
        self.appendInMyCategory(name: "Restaurant", searchName: "restaurant")
        self.appendInMyCategory(name: "Grocery", searchName: "grocery_or_supermarket")
        self.appendInMyCategory(name: "Bus Stop", searchName: "bus_station")
        ////
        
//        let myButton = UIBarButtonItem(title: "A", style: .plain, target: self, action: #selector(openPanel))
        let myButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openPanel))
        myButton.tintColor = UIColor.black
        self.title = "AroundMe"
        
        self.navigationItem.leftBarButtonItem = myButton
        
        self.categoryCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    func appendInMyCategory(name : String, searchName : String) {
        let tmpCategory = CategoryData()
        tmpCategory.nameOfCategory = name
        tmpCategory.searchNameOfCategory = searchName
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
 
}
