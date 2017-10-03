//
//  TabBarController.swift
//  Practice
//
//  Created by Muhammad Azher on 03/10/2017.
//  Copyright © 2017 Muhammad Azher. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "AroundMe"
//        let myButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openPanel))
//        myButton.tintColor = UIColor.black
//        self.title = "AroundMe"
//        
//        self.navigationItem.leftBarButtonItem = myButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func openPanel() {
        panel?.openLeft(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
