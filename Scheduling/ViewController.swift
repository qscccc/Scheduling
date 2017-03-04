//
//  ViewController.swift
//  Scheduling
//
//  Created by qscccc on 26/02/2017.
//  Copyright © 2017 qscccc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    private var setter: Int = 30
    
    @IBInspectable
    var daysOfThisMonthInspectable :Int {
        set(newValue){
            setter = max(newValue, 28)
            setter = min(setter, 31)
        }
        get{
            return setter
        }
    }
    
    
    
    
    
    @IBOutlet var display: [UILabel]!
    
    @IBOutlet weak var firstday: UISegmentedControl!
    
    
    
    
    
    @IBAction func setItForTest(_ sender: UIButton) {
        var scheduling = SchedulingBrain( daysOfAMonth: daysOfThisMonthInspectable, firstDayOfAMonth: firstday.selectedSegmentIndex)
        let resultArray = scheduling.resultArray
        
        
        
        
        display.forEach({$0.text = "  "})
        display.forEach({$0.textColor = UIColor.black})
        // set label content and UIcolor
        
        for result in resultArray.enumerated(){
            display[result.offset+firstday.selectedSegmentIndex].text = "\(result.offset+1)\n" + result.element
            // display result on UILables, arrange it according to firstday selected
            if scheduling.holidays.contains(result.offset){
                // if result is in the holidays array, set label color into red
                display[result.offset+firstday.selectedSegmentIndex].textColor = UIColor.red
            }
        }
        //print(scheduling.dutyDays)
    }
    
}


