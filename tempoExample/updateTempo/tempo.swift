//
//  Tempo.swift
//  updateTempo
//
//  Created by Remi Robert on 17/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import Foundation
import ObjectiveC

class Tempo {
    private var _years: Int!
    private var _months: Int!
    private var _days: Int!
    private var _hours: Int!
    private var _minutes: Int!
    private var _seconds: Int!
    private var _date: NSDate!
    private var _locale: NSLocale!
    private var _timeZone: NSTimeZone!
    
    var timeZone: NSTimeZone! {
        get {
            return self._timeZone
        }
        set {
            self._timeZone = newValue
            if (self.timeZone != nil) {
                TempoDateFormatter.sharedInstance.dateFormatter.timeZone = self.timeZone
                self.updateDate()
                self.updateComponents()
            }
        }
    }
    
    var locale: NSLocale! {
        get {
            return self._locale
        }
        set {
            self._locale = newValue
            if (self.locale != nil) {
                TempoDateFormatter.sharedInstance.dateFormatter.locale = self.locale
                self.updateDate()
                self.updateComponents()
            }
        }
    }
    
    var years: Int! {
        get {
            return self._years
        }
        set {
            self._years = newValue
            self.updateDate()
        }
    }
    var months: Int! {
        get {
            return self._months
        }
        set {
            self._months = newValue
            self.updateDate()
        }
    }
    var days: Int! {
        get {
            return self._days
        }
        set {
            self._days = newValue
            self.updateDate()
        }
    }
    var hours: Int! {
        get {
            return self._hours
        }
        set {
            self._hours = newValue
            self.updateDate()
        }
    }
    var minutes: Int! {
        get {
            return self._minutes
        }
        set {
            self._minutes = newValue
            self.updateDate()
        }
    }
    var seconds: Int! {
        get {
            return self._seconds
        }
        set {
            self._seconds = newValue
            self.updateDate()
        }
    }
    var date: NSDate! {
        get {
            return self._date
        }
        set {
            self._date = newValue
            self.updateComponents()
        }
    }

    typealias DateFormatBuilder = (newTemp:Tempo) -> ()
    
    private class TempoDateFormatter {
        
        var dateFormatter: NSDateFormatter!
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        class var sharedInstance: TempoDateFormatter {
            struct Static {
                static var instance: TempoDateFormatter?
                static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) {
                Static.instance = TempoDateFormatter()
                Static.instance?.dateFormatter = NSDateFormatter()
                Static.instance?.dateFormatter.locale = NSLocale.autoupdatingCurrentLocale()
                Static.instance?.dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
            }
            return Static.instance!
        }
    }
    
    private func updateDate() {
        var dateComponents = TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.WeekdayOrdinalCalendarUnit, fromDate: NSDate())
        
        dateComponents.year = self.years
        dateComponents.month = self.months
        dateComponents.day = self.days
        dateComponents.hour = self.hours
        dateComponents.minute = self.minutes
        dateComponents.second = self.seconds
        self.date = TempoDateFormatter.sharedInstance.calendar?.dateFromComponents(dateComponents)
    }
    
    private func updateComponents() {
        var dateComponents = TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.YearCalendarUnit |
            NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit |
            NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit |
            NSCalendarUnit.SecondCalendarUnit, fromDate: self._date)
        
        println("y = \(dateComponents.year)")
        self._years = dateComponents.year
        self._months = dateComponents.month
        self._days = dateComponents.day
        self._hours = dateComponents.hour
        self._minutes = dateComponents.minute
        self._seconds = dateComponents.second
    }
        
    init() {
        self._locale = NSLocale.autoupdatingCurrentLocale()
        self._date = NSDate()
        self.updateComponents()
    }
    
    convenience init(stringDate: String, timeLocale: NSLocale = NSLocale.autoupdatingCurrentLocale(),
        timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()) {
        self.init()
        
        let dateFormats = [
            "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'",
            "yyyy-MM-dd",
            "h:mm:ss A",
            "h:mm A",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "MMMM d, yyyy",
            "MMMM d, yyyy LT",
            "dddd, MMMM D, yyyy LT",
            "yyyyyy-MM-dd",
            "yyyy-MM-dd",
            "GGGG-[W]WW-E",
            "GGGG-[W]WW",
            "yyyy-ddd",
            "HH:mm:ss.SSSS",
            "HH:mm:ss",
            "HH:mm",
            "HH"
        ]
        
        for currentDateFormat in dateFormats {
            TempoDateFormatter.sharedInstance.dateFormatter.dateFormat = currentDateFormat
            if let date = TempoDateFormatter.sharedInstance.dateFormatter.dateFromString(stringDate) {

                var dateComponents = TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.YearCalendarUnit |
                    NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit |
                    NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit |
                    NSCalendarUnit.SecondCalendarUnit, fromDate: date)

                self._years = dateComponents.year
                self._months = dateComponents.month
                self._days = dateComponents.day
                self._hours = dateComponents.hour
                self._minutes = dateComponents.minute
                self._seconds = dateComponents.second
                self._date = TempoDateFormatter.sharedInstance.calendar!.dateFromComponents(dateComponents)
            }
        }
    }

    convenience init(stringDate: String, format: String,
        timeLocale: NSLocale = NSLocale.autoupdatingCurrentLocale(),
        timeZone: NSTimeZone = NSTimeZone.defaultTimeZone()) {
            self.init()

            TempoDateFormatter.sharedInstance.dateFormatter.dateFormat = format
            if let date = TempoDateFormatter.sharedInstance.dateFormatter.dateFromString(stringDate) {
            
                var dateComponents = TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.YearCalendarUnit |
                    NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit |
                    NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit |
                    NSCalendarUnit.SecondCalendarUnit, fromDate: date)
                
                self._years = dateComponents.year
                self._months = dateComponents.month
                self._days = dateComponents.day
                self._hours = dateComponents.hour
                self._minutes = dateComponents.minute
                self._seconds = dateComponents.second
                self._date = TempoDateFormatter.sharedInstance.calendar!.dateFromComponents(dateComponents)
            }
    }
    
    convenience init(date: NSDate) {
        self.init()
        _date = date
        updateComponents()
    }

    convenience init(unixOffset: Double) {
        self.init()
        _date = NSDate(timeIntervalSince1970: unixOffset)
        updateComponents()
    }
    
    convenience init(buildClosure: DateFormatBuilder) {
        self.init()
        buildClosure(newTemp: self)
        self.updateComponents()
        self.updateDate()
    }
    
    /**
    Get the Tempo date to a string format easy to read.
    
    :param: format The format, you want to display, by default, it's : YYYY-MM-DD HH:mm.
    */
    func format(format: String = "YYYY-MM-DD HH:mm") -> String? {
        return self.format([format])
    }

    /**
    Get the Tempo date to a string format easy to read.
    
    :param: formats It's a list of format, user it, if you don't know which format is your date.
    */
    func format(formats: [String]) -> String! {
        for currentFormat in formats {
            TempoDateFormatter.sharedInstance.dateFormatter.dateFormat = currentFormat
            
            let dateString = TempoDateFormatter.sharedInstance.dateFormatter.stringFromDate(_date)
            let dateConvert = TempoDateFormatter.sharedInstance.dateFormatter.dateFromString(dateString)
            if (dateConvert != nil) {
                return dateString
            }
        }
        return nil
    }
    
    /**
    Get the Tempo date to the Unix Timestamp format.
    */
    func formatUnixTimestamp() -> Double? {
        if let returnString = self.format(format: "X") {
            return (returnString as NSString).doubleValue
        }
        return nil
    }

    /**
    Get the current month name of the current year.
    */
    func monthOfTheYear() -> String? {
        return self.format(format: "MMMM")
    }

    /**
    Get the current day name of the current week.
    */
    func dayOfTheWeek() -> String? {
        return self.format(format: "EEEE")
    }
    
    /**
    Know if a tempo is after an another tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func isAfter(tempo: Tempo) -> Bool? {
        return self > tempo
    }

    /**
    Know if a tempo is before an another tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func isBefore(tempo: Tempo) -> Bool? {
        return self < tempo
    }

    /**
    Know if a tempo is the same to an another tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func isSame(tempo: Tempo) -> Bool {
        return self == tempo
    }
    
    /**
    Know if a tempo is between to tempos.
    tempoLeft > your tempo > tempoRight
    
    :param: tempoLeft The tempo object, you want to compare in the left interval.
    :param: tempoRight The tempo object, you want to compare in the right interval.
    */
    func isBetween(tempoLeft: Tempo, tempoRight: Tempo) -> Bool {
        if isSame(tempoLeft) || isSame(tempoRight) {
            return false
        }
        return (self > tempoLeft)! && (self < tempoRight)!
    }
    
    /**
    Know if a tempo is in the same day of an another tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func isToday(tempo: Tempo) -> Bool {
        return (self.diffDay(tempo) == 0 ? true : false)
    }

    /**
    Know if a tempo is in the same month of an another tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func isThisMonth(tempo: Tempo) -> Bool {
        return (self.diffMonth(tempo) == 0 ? true : false)
    }
    
    /**
    Know if a tempo is in the same year of an another tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func isThisYear(tempo: Tempo) -> Bool {
        return (self.diffYear(tempo) == 0 ? true : false)
    }
    
    /**
    Debug representation of a tempo, can be usefull in a development.
    */
    func representation() -> String {
        return "years:\(self.years) months:\(self.months) days:\(self.days) hours:\(self.hours) minutes:\(self.minutes) seconds:\(self.seconds)"
    }
}

extension Tempo {
    /**
    Get the difference of days between two tempos.
    
    :param: tempo The tempo object, you want to compare.
    */
    func diffDay(tempo: Tempo) -> Int {
        return TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.CalendarUnitDay,
            fromDate: self.date, toDate: tempo.date, options: NSCalendarOptions.allZeros).day
    }

    /**
    Get the difference of weeks between two tempos.
    
    :param: tempo The tempo object, you want to compare.
    */
    func diffWeek(tempo: Tempo) -> Int {
        return TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.CalendarUnitWeekOfYear,
            fromDate: self.date, toDate: tempo.date, options: NSCalendarOptions.allZeros).weekOfYear
    }

    /**
    Get the difference of month between two tempos.
    
    :param: tempo The tempo object, you want to compare.
    */
    func diffMonth(tempo: Tempo) -> Int {
        return TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.CalendarUnitMonth,
            fromDate: self.date, toDate: tempo.date, options: NSCalendarOptions.allZeros).month
    }
    
    /**
    Get the difference of year between two tempos.
    
    :param: tempo The tempo object, you want to compare.
    */
    func diffYear(tempo: Tempo) -> Int {
        return TempoDateFormatter.sharedInstance.calendar!.components(NSCalendarUnit.CalendarUnitYear,
            fromDate: self.date, toDate: tempo.date, options: NSCalendarOptions.allZeros).year
    }
}

extension Tempo {
    private func timeAgoSimple(tempo: Tempo?) -> String {
        var now: NSDate!
        if tempo != nil {
            now = tempo?.date
        }
        else {
            now = NSDate()
        }
        let deltaSeconds = fabs(_date.timeIntervalSinceDate(now))
        let deltaMinutes = deltaSeconds / 60.0
        
        if deltaSeconds < 60 {
            return "\(Int(deltaSeconds))s"
        }
        else if deltaMinutes < 60 {
            return "\(Int(deltaMinutes))m"
        }
        else if deltaMinutes < (24 * 60) {
            return "\(Int(floor(deltaMinutes / 60)))h"
        }
        else if deltaMinutes < (24 * 60 * 7) {
            return "\(Int(floor(deltaMinutes / (60 * 24))))d"
        }
        else if deltaMinutes < (24 * 60 * 31) {
            return "\(Int(floor(deltaMinutes / (60 * 24 * 7))))w"
        }
        else if deltaMinutes < (24 * 60 * 365.25) {
            return "\(Int(floor(deltaMinutes / (60 * 24 * 30))))mo"
        }
        return "\(Int(floor(deltaMinutes / (60 * 24 * 365))))yr"
    }
    
    private func timeAgo(tempo: Tempo?) -> String {
        var now: NSDate!
        if tempo != nil {
            now = tempo?.date
        }
        else {
            now = NSDate()
        }
        let deltaSeconds = fabs(_date.timeIntervalSinceDate(now))
        let deltaMinutes = deltaSeconds / 60.0

        if deltaSeconds < 5 {
            return "Just now"
        }
        else if deltaSeconds < 60 {
            return "\(Int(deltaSeconds)) seconds ago"
        }
        else if deltaSeconds < 120 {
            return  "A minute ago"
        }
        else if deltaMinutes < 60 {
            return "\(Int(deltaMinutes)) minutes ago"
        }
        else if deltaMinutes < 120 {
            return "An hour ago"
        }
        else if deltaMinutes < (24 * 60) {
            return "\(Int(floor(deltaMinutes / 60))) hours ago"
        }
        else if deltaMinutes < (24 * 60 * 2) {
            return "Yesterday"
        }
        else if deltaMinutes < (24 * 60 * 7) {
            return "\(Int(floor(deltaMinutes / (60 * 24)))) days ago"
        }
        else if deltaMinutes < (24 * 60 * 14) {
            return "Last week"
        }
        else if deltaMinutes < (24 * 60 * 31) {
            return "\(Int(floor(deltaMinutes / (60 * 24 * 7)))) weeks ago"
        }
        else if deltaMinutes < (24 * 60 * 61) {
            return "Last month"
        }
        else if deltaMinutes < (24 * 60 * 365.25) {
            return "\(Int(floor(deltaMinutes / (60 * 24 * 30)))) months ago"
        }
        else if deltaMinutes < (24 * 60 * 731) {
            return "Last year"
        }
        return "\(Int(floor(deltaMinutes / (60 * 24 * 365)))) years ago"
    }
    
    private func dateTimeUntil(tempo: Tempo?) -> String {
        var now: Tempo!
        if tempo != nil {
            now = Tempo(date: tempo!.date!)
        }
        else {
            now = Tempo()
        }
        if self.isToday(now) {
            if self.days == now.days {
                if self.hours < 12 && now.hours > 12 {
                    return "This morning"
                }
                else if self.hours >= 12 && self.hours < 18 && now.hours >= 18 {
                    return "This afternoon"
                }
                return "Today"
            }
        }
        else if self.isThisMonth(now) {
            if self.days == now.days - 1 {
                return "Yesterday"
            }
            let diffWeek = self.diffWeek(now)
            if diffWeek == 0 {
                return "This week"
            }
            else if diffWeek == 1 {
                return "Last week"
            }
        }
        else if self.isThisYear(now) {
            let diffMonth = self.diffMonth(now)
            println("diff month : \(diffMonth))")
            if diffMonth == 0 {
                return "This month"
            }
            else if diffMonth == 1 {
                return "Last month"
            }
        }
        let diffYear = self.diffYear(now)
        if diffYear == 0 {
            return "This year"
        }
        else if diffYear == 1 {
            return "Last year"
        }
        return self.timeAgo(nil)
    }
    
    /**
    Get the time ago, with a simple version for the current time.
    */
    func timeAgoSimpleNow() -> String {
        return self.timeAgoSimple(nil)
    }

    /**
    Get the time ago, with a simple version for a tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func timeAgoSimple(tempo: Tempo) -> String {
        return self.timeAgoSimple(tempo)
    }

    /**
    Get the time ago, for the current time.
    */
    func timeAgoNow() -> String {
        return self.timeAgo(nil)
    }

    /**
    Get the time ago, for a tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func timeAgo(tempo: Tempo) -> String {
        return self.timeAgo(tempo)
    }
    
    /**
    Get the time ago, with a more readeble version for the current time.
    */
    func dateTimeUntilNow() -> String {
        return self.dateTimeUntil(nil)
    }

    /**
    Get the time ago, with a more readable version for a tempo.
    
    :param: tempo The tempo object, you want to compare.
    */
    func dateTimeUntil(tempo: Tempo) -> String {
        return self.dateTimeUntil(tempo)
    }
}

func >(left: Tempo, right: Tempo) -> Bool? {
    if left.years != right.years {
        return left.years > right.years
    }
    if left.months != right.months {
        return left.months > right.months
    }
    if left.days != right.days {
        return left.days > right.days
    }
    if left.hours != right.hours {
        return left.hours > right.hours
    }
    if left.minutes != right.minutes {
        return left.minutes > right.minutes
    }
    if left.seconds != right.seconds {
        return left.seconds > right.seconds
    }
    return nil
}

func <(left: Tempo, right: Tempo) -> Bool? {
    if left.years != right.years {
        return left.years < right.years
    }
    if left.months != right.months {
        return left.months < right.months
    }
    if left.days != right.days {
        return left.days < right.days
    }
    if left.hours != right.hours {
        return left.hours < right.hours
    }
    if left.minutes != right.minutes {
        return left.minutes < right.minutes
    }
    if left.seconds != right.seconds {
        return left.seconds < right.seconds
    }
    return nil
}

func ==(left: Tempo, right: Tempo) -> Bool {
    return left.years == right.years && left.months == right.months &&
        left.days == right.days && left.hours == right.hours &&
        left.minutes == right.minutes && left.seconds == right.seconds
}

func +(left: Tempo, right: Tempo) -> Tempo {
    return Tempo(buildClosure: { (newTemp) -> () in
        newTemp.years = left.years + right.years
        newTemp.months = left.months + right.months
        newTemp.days = left.days + right.days
        newTemp.hours = left.hours + right.hours
        newTemp.minutes = left.minutes + right.minutes
    })
}

func -(left: Tempo, right: Tempo) -> Tempo {
    return Tempo(buildClosure: { (newTemp) -> () in
        newTemp.years = left.years - right.years
        newTemp.months = left.months - right.months
        newTemp.days = left.days - right.days
        newTemp.hours = left.hours - right.hours
        newTemp.minutes = left.minutes - right.minutes
    })
}

extension Tempo: Printable {
    internal var description: String {
        return format()!
    }
}

extension Tempo: DebugPrintable {
    internal var debugDescription: String {
        return description
    }
}