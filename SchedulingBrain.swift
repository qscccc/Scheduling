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
    public var firstDayOfAMonth: Int = 0
    public var daysOfAMonth:Int = 30              // range from 28~31
    public var employeesCountForScheduling = 8
    public var notConsiderQOD = false
    public var notConsiderQD = false
    
    // "daysForScheduling was the array we performed on
    lazy private var employeesForScheduling: ArraySlice<String> = ["A","B","C","D","E","F","G","H","I","J","K","L"].prefix(upTo: self.employeesCountForScheduling)
    //TODO: make user can set empolyees count, then name
    private var daysForScheduling = [String]()
    
    
    public var daysOfWeekendAndHolidays: Array<Int> {
        mutating get{
            var weekendAndHolidays = [Int]()
            var weekendDay: Int = 0 - firstDayOfAMonth
            while(weekendDay < daysOfAMonth){
                if weekendDay >= 0{
                    weekendAndHolidays.append(weekendDay)
                }
                weekendDay += 7
            }
            weekendDay = 6 - firstDayOfAMonth
            while(weekendDay < daysOfAMonth){
                if weekendDay >= 0{
                    weekendAndHolidays.append(weekendDay)
                }
                weekendDay += 7
            }
            return weekendAndHolidays
        }
        set{
            
        }
    }
    //TODO: make user can set holidays
    init(){
        
    }

    init(daysOfAMonth: Int){
        self.init(daysOfAMonth:daysOfAMonth, firstDayOfAMonth: 0)
    }
    init(firstDayOfAMonth: Int){
        self.init(daysOfAMonth: 30, firstDayOfAMonth: firstDayOfAMonth)
    }
    init(daysOfAMonth: Int, firstDayOfAMonth: Int){
        self.daysOfAMonth = daysOfAMonth
        self.firstDayOfAMonth = firstDayOfAMonth
    }
    
    private func dutiesNotTheSame(with currentEmployee: String, within daysForScheduling:[String], around currentDate: Int ,beforeAndAfter days: Int)->Bool{
        return (
            (currentDate+days > daysForScheduling.count-1  || daysForScheduling[currentDate+days] != currentEmployee)
                && (currentDate-days < 0 || daysForScheduling[currentDate-days] != currentEmployee)
        )
    }
    private mutating func dutiesCountDuringHoliday(of currentEmployee: String )-> Int{
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
        // while currentPersons duty not greater than DaysOfAMonth/personsForScheduling.count)
        // perform scheduling for eachEmployee
        
        daysForScheduling = [String](repeating: "emptyDuty", count: daysOfAMonth )
        while(daysForScheduling.contains("emptyDuty")){
            //filling fist time until every one's duty was equal
            for eachEmployee in employeesForScheduling{
                print(eachEmployee + "has been arranged")
                var currentEmployeesDuty = daysForScheduling.filter({S1 in return S1==eachEmployee})
                var dateHadBeenArranged :Array<Int> = []
                while(currentEmployeesDuty.count < daysOfAMonth/employeesForScheduling.count - 1){
                    
                    let currentDate = Int(arc4random())%daysOfAMonth
                    // assign a random date to current date
                    if !dateHadBeenArranged.contains(currentDate){dateHadBeenArranged.append(currentDate)}
                    if  daysForScheduling[currentDate] == "emptyDuty"
                        && (dutiesNotTheSame(with: eachEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 1) || notConsiderQD)    //QD
                        && (dutiesNotTheSame(with: eachEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 2) || notConsiderQOD)    //QOD
                        && (!daysOfWeekendAndHolidays.contains(currentDate) || (dutiesCountDuringHoliday(of: eachEmployee) < daysOfWeekendAndHolidays.count/employeesForScheduling.count) )
                        // if notConsiderQD  is false the check
                        // if current date's one or two day after/before was not the currentPersons duty
                        // then fill this person into current date
                    {
                             daysForScheduling[currentDate] = eachEmployee
                             currentEmployeesDuty = daysForScheduling.filter({S1 in return S1==eachEmployee})
                            //recount current persons duty
                    }
                    if(dateHadBeenArranged.count >= daysOfAMonth){break}
                        // if all date had been tried, test next employee
                }
            }
            
            for eachEmployee in employeesForScheduling{
                // filling rest of empty days according to employeesForScheduling sequence

                    for (currentDate, currentDuty) in daysForScheduling.enumerated(){
                        if  currentDuty == "emptyDuty"
                            && (dutiesNotTheSame(with: eachEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 1) || notConsiderQD)    //QD
                            && (dutiesNotTheSame(with: eachEmployee, within: daysForScheduling, around: currentDate, beforeAndAfter: 2) || notConsiderQOD)    //QOD
                        {
                            daysForScheduling[currentDate] = eachEmployee
                            break //break for (currentDate, currentDuty) ....
                        }
                }
            }
            
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
        mutating get{
            //figure out why it should be mutating
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
