//
//  tempo.swift
//  tempo
//
//  Created by Remi Robert on 18/12/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

import UIKit

protocol DateFormat {
    var years: Int? {get}
    var months: Int? {get}
    var days: Int? {get}
    var hours: Int? {get}
    var minutes: Int? {get}
    var seconds: Int? {get}
}

class Tempo: DateFormat {
    var years: Int?
    var months: Int?
    var days: Int?
    var hours: Int?
    var minutes: Int?
    var seconds: Int?
    
    typealias DateFormatBuilder = (newTemp:Tempo) -> ()
    
    init(buildClosure: DateFormatBuilder) {
        buildClosure(newTemp: self)
    }
    
    init(date: NSDate) {
        self.initFromDate(date)
    }
    
    init() {
        self.initFromDate(NSDate())
    }
    
    private func initFromDate(date: NSDate) {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var dateComponents = calendar!.components(NSCalendarUnit.YearCalendarUnit |
            NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit |
            NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit |
            NSCalendarUnit.SecondCalendarUnit, fromDate: date)
        
        self.years = dateComponents.year
        self.months = dateComponents.month
        self.days = dateComponents.day
        self.hours = dateComponents.hour
        self.minutes = dateComponents.minute
        self.seconds = dateComponents.second
    }
    
    private func formNSDate() -> NSDate? {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        var dateComponents = calendar!.components(NSCalendarUnit.WeekdayOrdinalCalendarUnit, fromDate: NSDate())
        
        dateComponents.year = (self.years != nil) ? self.years! : 0
        dateComponents.month = (self.months != nil) ? self.months! : 0
        dateComponents.day = (self.days != nil) ? self.days! : 0
        dateComponents.hour = (self.hours != nil) ? self.hours! : 0
        dateComponents.minute = (self.minutes != nil) ? self.minutes! : 0
        dateComponents.second = (self.seconds != nil) ? self.seconds! : 0
        
        return calendar!.dateFromComponents(dateComponents)
    }
    
    private func formatNSDate(formatString: String, date: NSDate) -> String? {
        var dateFormater = NSDateFormatter()
        dateFormater.dateFormat = formatString
        return dateFormater.stringFromDate(date)
    }
    
    func convertToNSDate() -> NSDate? {
        return self.formNSDate()
    }
    
    func formatDate() -> String? {
        return self.formatDate("yyyy MM dd HH:mm:ss")
    }
    
    func formatDate(format: String) -> String? {
        if let dateFormated = self.formNSDate() {
            return self.formatNSDate(format, date: dateFormated)
        }
        return nil
    }
}

extension Tempo {
    
    private func diffAgoFromDate(fromDate: NSDate, toDate: NSDate) -> String? {
        func getDiffSpecificComponent(calendar: NSCalendar, unitComponent: NSCalendarUnit) -> NSDateComponents {
            return (calendar.components(unitComponent,
                fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros))
        }
        
        let calendarDate = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let unitComponent = [NSCalendarUnit.SecondCalendarUnit, NSCalendarUnit.MinuteCalendarUnit,
            NSCalendarUnit.HourCalendarUnit, NSCalendarUnit.DayCalendarUnit,
            NSCalendarUnit.MonthCalendarUnit, NSCalendarUnit.YearCalendarUnit]
        var diffComponent = Array<NSDateComponents>()
        var indexComponent = 0
        
        for currentComponent in ComponentDate.components {
            diffComponent.append(getDiffSpecificComponent(calendarDate!, unitComponent[indexComponent]))
            indexComponent++
        }
        
        switch (diffComponent[0] as NSDateComponents).second {
        case (0...45): return ("seconds ago")
        case (45...90): return ("a minute ago")
        case (90...2700): return ("\((diffComponent[1] as NSDateComponents).minute) minutes ago")
        default: Void()
        }
        switch (diffComponent[1] as NSDateComponents).minute {
        case (45...90): return ("an hour ago")
        case (90...1320): return ("\(((diffComponent[2] as NSDateComponents).hour)) hours ago")
        default: Void()
        }
        switch (diffComponent[2] as NSDateComponents).hour {
        case (1320...2160): return ("a day ago")
        case (1320...36000): return ("\((diffComponent[3] as NSDateComponents).day) days ago")
        default: Void()
        }
        switch (diffComponent[3] as NSDateComponents).day {
        case (25...45): return ("a month ago")
        case (45...345): return ("\((diffComponent[4] as NSDateComponents).month) months ago")
        case (345...547): return ("a year ago")
        default: Void()
        }
        if ((diffComponent[3] as NSDateComponents).day >= 548) {
            return ("\((diffComponent[5] as NSDateComponents).year) years ago")
        }
        return nil
    }
    
    func timeAgoFromNow() -> String? {
        if let currentDate = self.formNSDate() {
            return self.diffAgoFromDate(currentDate, toDate: NSDate())
        }
        return nil
    }
    
    func timeAgoFrom(date: Tempo) -> String? {
        if let currentDate = self.formNSDate() {
            if let testDate = date.convertToNSDate() {
                return self.diffAgoFromDate(currentDate, toDate: testDate)
            }
        }
        return nil
    }
}

extension Tempo {
    
    private func diffDate(component: ComponentDate, fromDate: NSDate, toDate: NSDate) -> Int {
        let calendarDate = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        switch component {
        case .Years: return (calendarDate!.components(NSCalendarUnit.YearCalendarUnit,
            fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros).year)
        case .Months: return (calendarDate!.components(NSCalendarUnit.MonthCalendarUnit,
            fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros).month)
        case .Days: return (calendarDate!.components(NSCalendarUnit.DayCalendarUnit,
            fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros).day)
        case .Hours: return (calendarDate!.components(NSCalendarUnit.HourCalendarUnit,
            fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros).hour)
        case .Minutes: return (calendarDate!.components(NSCalendarUnit.MinuteCalendarUnit,
            fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros).minute)
        case .Seconds: return (calendarDate!.components(NSCalendarUnit.SecondCalendarUnit,
            fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros).second)
        default: return 0
        }
    }
    
    func diff(component: ComponentDate, date: Tempo) -> Int? {
        if let currentDate = self.formNSDate() {
            if let testDate = date.convertToNSDate() {
                return self.diffDate(component, fromDate: currentDate, toDate: testDate)
            }
        }
        return nil
    }
}

extension Tempo {
    
    private func getValueDiff(date: Tempo, component: ComponentDate, isAfter: Bool) -> Bool? {
        if let valueDiff = self.diff(component, date: date) {
            if (valueDiff < 0) {
                if (isAfter == false) {
                    return false
                }
                return true
            }
            else if (valueDiff > 0) {
                if (isAfter == false) {
                    return true
                }
                return false
            }
        }
        return nil
    }
    
    private func getValueSame(date: Tempo, component: ComponentDate) -> Bool? {
        if let valueDiff = self.diff(component, date: date) {
            if (valueDiff == 0) {
                return true
            }
            return false
        }
        return nil
    }
    
    func isBefore(date: Tempo) -> Bool? {
        return self.getValueDiff(date, component: .Seconds, isAfter: false)
    }
    
    func isBefore(date: Tempo, component: ComponentDate) -> Bool? {
        return self.getValueDiff(date, component: component, isAfter: false)
    }
    
    func isAfter(date: Tempo) -> Bool? {
        return self.getValueDiff(date, component: .Seconds, isAfter: true)
    }
    
    func isAfter(date: Tempo, component: ComponentDate) -> Bool? {
        return self.getValueDiff(date, component: component, isAfter: true)
    }
    
    func isSame(date: Tempo) -> Bool? {
        return self.getValueSame(date, component: .Seconds)
    }
    
    func isSame(date: Tempo, component: ComponentDate) -> Bool? {
        return self.getValueSame(date, component: component)
    }
}

extension Tempo {
    
    private func changeValueDate(component: ComponentDate, value: Int) {
        switch component {
        case .Years: self.years! = (self.years != nil) ? self.years! + value : 0
        case .Months: self.months = (self.months != nil) ? self.months! + value : 0
        case .Days: self.days = (self.days != nil) ? self.days! + value : 0
        case .Hours: self.hours = (self.hours != nil) ? self.hours! + value : 0
        case .Minutes: self.minutes = (self.minutes != nil) ? self.minutes! + value : 0
        case .Seconds: self.seconds = (self.seconds != nil) ? self.seconds! + value : 0
        default: return
        }
    }
    
    func subtract(component: ComponentDate, value: UInt) -> Self {
        self.changeValueDate(component, value: Int(value) * -1)
        return self
    }
    
    func add(component: ComponentDate, value: UInt) -> Self {
        self.changeValueDate(component, value: Int(value))
        return self
    }
}

enum ComponentDate {
    case Years, Months, Days, Hours, Minutes, Seconds
    static let components = [Seconds, Minutes, Hours, Days, Months, Years]
}
