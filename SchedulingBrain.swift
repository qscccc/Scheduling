//
//  SchedulingBrain.swift
//  Scheduling
//
//  Created by qscccc on 26/02/2017.
//  Copyright © 2017 qscccc. All rights reserved.
//


import Foundation



struct SchedulingBrain{
    
    public var firstDayOfTheMonth: Int = 0
    public var daysOfAMonth:Int = 30              // range from 28~31
    private let personsPendingForScheduling = ["A","B","C","D","E","F","G","H"]
    private var daysPendingForScheduling = [String]()
    
    
    private var daysOfWeekendAndHolidays: Array<Int> = [] // not modified yet
    
    
    
    
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
    
    
    // TODO: add code for weekendsOrHoliday
    
    
    
    private mutating func performScheduling(){
        daysPendingForScheduling = [String](repeating: "noBodyOnDuty", count: daysOfAMonth )
        while(daysPendingForScheduling.contains("noBodyOnDuty")){
            //如果有天數是空的
            for operatingPerson in personsPendingForScheduling{
                //一個人一人排
                let filteredArray = daysPendingForScheduling.filter({S1 in return S1==operatingPerson})
                var dutiesOfThisPerson = filteredArray.count
                while(dutiesOfThisPerson <= daysOfAMonth/personsPendingForScheduling.count){
                    //如果這個人的班數<= 天數/人數，就開始排
                    let operatingDate = Int(arc4random())%daysOfAMonth
                    if daysPendingForScheduling[operatingDate] != operatingPerson //不重複
                        &&
                        (operatingDate >= daysPendingForScheduling.count-1  || daysPendingForScheduling[operatingDate+1] != operatingPerson) // avoid QD
                        &&
                        (operatingDate <= 0 || daysPendingForScheduling[operatingDate-1] != operatingPerson) //QD
                        &&
                        (operatingDate >= daysPendingForScheduling.count-2  || daysPendingForScheduling[operatingDate+2] != operatingPerson) //QOD
                        &&
                        (operatingDate <= 1 || daysPendingForScheduling[operatingDate-2] != operatingPerson) //QOD
                        
                    {
                        daysPendingForScheduling[operatingDate] = operatingPerson
                        
                    }
                    dutiesOfThisPerson = daysPendingForScheduling.filter({S1 in return S1==operatingPerson}).count
                    
                    
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
    
    
    public var result:String{
        mutating get{
            performScheduling()
            var resultString = ""
            for compileDaysForScheduling in daysPendingForScheduling{
                resultString = resultString + compileDaysForScheduling
            }
            return resultString
        }
    }
    
    
    public var resultArray:[String]{
        mutating get{
            performScheduling()
            return daysPendingForScheduling
            
        }
    }
    
    public var dutyDays:String{
        var dutyDaysDict: Dictionary<String,Int> = [:]
        for operatingPerson in personsPendingForScheduling{
            let filteredArray = daysPendingForScheduling.filter({S1 in return S1==operatingPerson})
            dutyDaysDict[operatingPerson] = filteredArray.count
        }
        return(String(describing: dutyDaysDict))
        
    }
    
}
