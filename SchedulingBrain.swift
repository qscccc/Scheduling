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
    
    
    private var daysOfWeekendAndHolidays: Array<Int> = []
    //TODO: make user can set holidays
    
    
    
    init(){}
    init(daysOfAMonth: Int){
        self.daysOfAMonth = daysOfAMonth
    }
    init(firstDayOfAMonth: Int){
        self.firstDayOfTheMonth = firstDayOfAMonth
    }
    init(daysOfAMonth: Int, firstDayOfAMonth: Int){
        self.daysOfAMonth = daysOfAMonth
        self.firstDayOfTheMonth = firstDayOfAMonth
    }
    
    
    
    
    private mutating func performScheduling(){
        // empty the "daysForScheduling"
        // while daysForScheduling has empty duty, then
        // for each employee(currentEmployee) in "employeesForScheduling":
        // while currentPersons duty not greater than aysOfAMonth/personsForScheduling.count)
        // perform scheduling
        
        daysForScheduling = [String](repeating: "emptyDuty", count: daysOfAMonth )
        while(daysForScheduling.contains("emptyDuty")){
            
            for currentEmployee in employeesForScheduling{
                
                var currentEmployeesDuty = daysForScheduling.filter({S1 in return S1==currentEmployee})
                while(currentEmployeesDuty.count <= daysOfAMonth/employeesForScheduling.count){
                    //
                    let currentDate = Int(arc4random())%daysOfAMonth
                    // assign a random date to current date
                    if daysForScheduling[currentDate] != currentEmployee
                        &&
                        (currentDate >= daysForScheduling.count-1  || daysForScheduling[currentDate+1] != currentEmployee) //  QD
                        &&
                        (currentDate <= 0 || daysForScheduling[currentDate-1] != currentEmployee) //QD
                        &&
                        (currentDate >= daysForScheduling.count-2  || daysForScheduling[currentDate+2] != currentEmployee) //QOD
                        &&
                        (currentDate <= 1 || daysForScheduling[currentDate-2] != currentEmployee) //QOD
                        // if current date's one or two day after/before was not the currentPersons duty
                        // then fill this person into current date
                        //TODO: add conditions to avoid weekend/holiday overduties
                    {
                        daysForScheduling[currentDate] = currentEmployee
                        
                    }
                    currentEmployeesDuty = daysForScheduling.filter({S1 in return S1==currentEmployee})
                    //recount current persons duty
                    
                }
            }
        }
    }
    
    public var holidays: Array<Int>{
        mutating get{
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
            return daysOfWeekendAndHolidays
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
    
    public var dutyDays: Dictionary<String,Int> {
        //read only duty days of workers
        get{
            var dutyDaysDict: Dictionary<String,Int> = [:]
            for operatingPerson in employeesForScheduling{
                let filteredArray = daysForScheduling.filter({S1 in return S1==operatingPerson})
                dutyDaysDict[operatingPerson] = filteredArray.count
            }
            return dutyDaysDict
        }
    }
    
}
