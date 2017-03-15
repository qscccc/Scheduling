//
//  SchedulingBrain.swift
//  Scheduling
//
//  Created by qscccc on 26/02/2017.
//  Copyright © 2017 qscccc. All rights reserved.
//


import Foundation



struct SchedulingBrain{
    
    // set first day and days of a month in VC
    public var firstDayOfTheMonth: Int = 0
    public var daysOfAMonth:Int = 30              // range from 28~31
    
    // "daysForScheduling was the array we performed on
    private let employeesForScheduling = ["A","B","C","D","E","F","G","H"]
    //TODO: make user can set empolyees count, then name
    private var daysForScheduling = [String]()
    public var daysOfWeekendAndHolidays: Array<Int> = []
    //TODO: make user can set holidays
    
    

    init(daysOfAMonth: Int){
        self.init(daysOfAMonth:daysOfAMonth, firstDayOfAMonth: 0)
    }
    init(firstDayOfAMonth: Int){
        self.init(daysOfAMonth: 30, firstDayOfAMonth: firstDayOfAMonth)
    }
    init(daysOfAMonth: Int, firstDayOfAMonth: Int){
        self.daysOfAMonth = daysOfAMonth
        self.firstDayOfTheMonth = firstDayOfAMonth
        defaultWeekend()
    }
    
    private func dutiesNotTheSame(with currentEmployee: String, within daysForScheduling:[String], around currentDate: Int ,beforeAndAfter days: Int)->Bool{
        return (
            (currentDate+days > daysForScheduling.count-1  || daysForScheduling[currentDate+days] != currentEmployee)
                && (currentDate-days < 0 || daysForScheduling[currentDate-days] != currentEmployee)
        )
    }
    private func dutiesCountDuringHoliday(of currentEmployee: String )-> Int{
        var holidayDutiesCount = 0
        if let dutyDaysOfCurrentEmployeeArray = dutyDays[currentEmployee] {
            for dutyDaysOfCurrentEmployee in dutyDaysOfCurrentEmployeeArray{
                if daysOfWeekendAndHolidays.contains(dutyDaysOfCurrentEmployee){
                    holidayDutiesCount += 1
                }
            }
        }
        return holidayDutiesCount
    }
    
    
    private mutating func performScheduling(){
        // empty the "daysForScheduling"
        // while daysForScheduling has empty duty, then
        // for each employee(currentEmployee) in "employeesForScheduling":
        // while currentPersons duty not greater than aysOfAMonth/personsForScheduling.count)
        // perform scheduling
        
        daysForScheduling = [String](repeating: "emptyDuty", count: daysOfAMonth )
        while(daysForScheduling.contains("emptyDuty")){
            //filling fist time until every one's duty was equal
            for currentEmployee in employeesForScheduling{
                var currentEmployeesDuty = daysForScheduling.filter({S1 in return S1==currentEmployee})
                while(currentEmployeesDuty.count < daysOfAMonth/employeesForScheduling.count){
                ///!!!!BUG: CANNOT ESCAPE LOOP IF SCHEDULING FAILED
                    let currentDate = Int(arc4random())%daysOfAMonth
                    // assign a random date to current date
                    if  daysForScheduling[currentDate] == "emptyDuty"
                        && dutiesNotTheSame(with: currentEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 0)
                        && dutiesNotTheSame(with: currentEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 1)     //QD
                        && dutiesNotTheSame(with: currentEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 2)    //QOD
                        && (!daysOfWeekendAndHolidays.contains(currentDate) || (dutiesCountDuringHoliday(of: currentEmployee) < daysOfWeekendAndHolidays.count/employeesForScheduling.count) )
                        // if current date's one or two day after/before was not the currentPersons duty
                        // then fill this person into current date
                        //TODO: add conditions to avoid weekend/holiday overduties
                    {
                             daysForScheduling[currentDate] = currentEmployee
                            currentEmployeesDuty = daysForScheduling.filter({S1 in return S1==currentEmployee})
                            //recount current persons duty
                    }
                    
                }
            }
            
            for currentEmployee in employeesForScheduling{
                // filling rest of empty days according to employeesForScheduling sequence
                    for (currentDate, currentDuty) in daysForScheduling.enumerated(){
                        if currentDuty == "emptyDuty"
                            && dutiesNotTheSame(with: currentEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 0)
                            && dutiesNotTheSame(with: currentEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 1)     //QD
                            && dutiesNotTheSame(with: currentEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 2)
                        {
                            daysForScheduling[currentDate] = currentEmployee
                            break //break for (currentDate, currentDuty) ....
                        }
                }
            }
            
        }
        
    }
    mutating func defaultWeekend(){
        daysOfWeekendAndHolidays = []
        var weekendDay: Int = 0 - firstDayOfTheMonth
        while(weekendDay < daysOfAMonth){
            if weekendDay >= 0{
                daysOfWeekendAndHolidays.append(weekendDay)
            }
            weekendDay += 7
        }
        weekendDay = 6 - firstDayOfTheMonth
        while(weekendDay < daysOfAMonth){
            if weekendDay >= 0{
                daysOfWeekendAndHolidays.append(weekendDay)
            }
            weekendDay += 7
        }
    }

    
    
    public var resultInString:String{
        //read only result, which return a String
        mutating get{
            performScheduling()
            var resultString = ""
            for compileDaysForScheduling in daysForScheduling{
                resultString = resultString + compileDaysForScheduling
            }
            return resultString
        }
    }
    
    
    public var resultInArray:[String]{
        //read only result, which return an Array
        mutating get{
            performScheduling()
            return daysForScheduling
        }
    }
    
    public var dutyDays: Dictionary<String,[Int]> {
        //read only duty days of workers
        // as [(A: 1,3,5), (B: 2,4,6)....]
        get{
            var dutyDaysDict: Dictionary<String,Array<Int>> = [:]
            for operatingPerson in employeesForScheduling{
                for (currentDate, currentEmployee) in daysForScheduling.enumerated(){
                    if operatingPerson == currentEmployee{
                        if  dutyDaysDict[operatingPerson] != nil{
                            dutyDaysDict[operatingPerson]!.append(currentDate)
                        }else{
                            dutyDaysDict[operatingPerson] = [currentDate]
                        }
                    }
                }
            }
            return dutyDaysDict
        }
    }
    
}
