//
//  SettingViewController.swift
//  Scheduling
//
//  Created by qscccc on 26/04/2017.
//  Copyright © 2017 qscccc. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBAction func stepperForPeopleCount(_ sender: UIStepper) {
        
        peopleCount.text = String(Int(sender.value))
    }
    
    @IBOutlet weak var peopleCount: UILabel!
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // identifier: which segue, destination: what's the UIView we want created
        var destinationViewController = segue.destination
        if let navigationController =  destinationViewController as? UINavigationController{
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
            // if destinationVC is an UINavigationC, then make visibleViewController as destinationVC
        }
    }
    
}