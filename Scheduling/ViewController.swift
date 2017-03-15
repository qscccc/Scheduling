//
//  ViewController.swift
//  Scheduling
//
//  Created by qscccc on 26/02/2017.
//  Copyright © 2017 qscccc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,  UIPickerViewDelegate {

    // "display" showed result after performButton was touched
    @IBOutlet var display: [UILabel]!
    
    // firstday of the month
    @IBOutlet weak var firstday: UISegmentedControl!
    
  
  
    ///set the picker of days per month///
    
    @IBOutlet weak var textFieldOfDaysPerMonth: UITextField!
    
    var daysOfThisMonthPicker = UIPickerView()
    let DaysOfAMonthOptions = ["28","29","30","31"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysOfThisMonthPicker.delegate = self
        daysOfThisMonthPicker.dataSource = self
        textFieldOfDaysPerMonth.inputView = daysOfThisMonthPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return DaysOfAMonthOptions.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return DaysOfAMonthOptions[row]
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldOfDaysPerMonth.text = DaysOfAMonthOptions[row]
        self.view.endEditing(false)
    }
    ///done picker view setter///
    
   
    
    @IBAction func performButton(_ sender: UIButton) {
        var scheduling = SchedulingBrain( daysOfAMonth: Int(textFieldOfDaysPerMonth.text!)!, firstDayOfAMonth: firstday.selectedSegmentIndex)
        let resultArray = scheduling.resultInArray
        print(scheduling.dutyDays.description)
        
        
        display.forEach({$0.text = "  "})
        display.forEach({$0.textColor = UIColor.black})
        // set label content and UIcolor
        
        for result in resultArray.enumerated(){
            display[result.offset+firstday.selectedSegmentIndex].text = "\(result.offset+1)\n" + result.element
            // display result on UILables, arrange it according to firstday selected
            if scheduling.daysOfWeekendAndHolidays.contains(result.offset){
                // if result is in the holidays array, set label color into red
                display[result.offset+firstday.selectedSegmentIndex].textColor = UIColor.red
            }
        }

    }
}


