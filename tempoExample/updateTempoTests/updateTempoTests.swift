//
//  updateTempoTests.swift
//  updateTempoTests
//
//  Created by Remi Robert on 17/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import XCTest

class updateTempoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitDate() {
        let t1 = Tempo(date: NSDate())
        let t2 = Tempo()
        
        XCTAssertTrue("\(t1.date)" == "\(t2.date)")
        XCTAssertTrue(t1.representation() == t2.representation())
    }
    
    func testInitwithFormat() {
        let t = Tempo(stringDate: "1992/02/12")
        XCTAssertTrue(t.years == 1992)
        XCTAssertTrue(t.months == 02)
        XCTAssertTrue(t.days == 12)

        
        let t1 = Tempo(stringDate: "12/02/1992", format: "dd/MM/yyyy")
        XCTAssertTrue(t1.years == 1992)
        XCTAssertTrue(t1.months == 02)
        XCTAssertTrue(t1.days == 12)
        

        let t2 = Tempo(stringDate: "12 02 1992", format: "dd MM yyyy")
        XCTAssertTrue(t2.years == 1992)
        XCTAssertTrue(t2.months == 02)
        XCTAssertTrue(t2.days == 12)


        let t3 = Tempo(stringDate: "12 02 1992 à 23:56 43", format: "dd MM yyyy à HH:mm ss")
        XCTAssertTrue(t3.years == 1992)
        XCTAssertTrue(t3.months == 02)
        XCTAssertTrue(t3.days == 12)
        XCTAssertTrue(t3.hours == 23)
        XCTAssertTrue(t3.minutes == 56)
        XCTAssertTrue(t3.seconds == 43)
        
        let t4 = Tempo(stringDate: "à 23:56 43", format: "à HH:mm ss")
        XCTAssertTrue(t4.hours == 23)
        XCTAssertTrue(t4.minutes == 56)
        XCTAssertTrue(t4.seconds == 43)

        
    }

    func testFormatDateWithLocal() {
        let t5 = Tempo()
        let s = t5.format(format: "MMMM")
        t5.locale = NSLocale(localeIdentifier: "en_US")
        XCTAssertTrue(s == "February")
        
        t5.locale = NSLocale(localeIdentifier: "fr_FR")
        let s2 = t5.format(format: "MMMM")
        XCTAssertTrue(s2 == "février")
        
        let s3 = t5.format(format: "fdsfdskljfdsjfdslkfjdslfjdslkjfdlkgklfdjgjkfdl")
        XCTAssertTrue(s3 == nil)
        
        let s4 = t5.format(["MM-DD-YYYY", "YYYY-MM-DD"])
        XCTAssertTrue(s4 != nil)
    }
    
    func testBlockCompletionDate() {
        let t = Tempo { (newTemp) -> () in
            newTemp.years = 1992
            newTemp.months = 12
            newTemp.days = 02
            newTemp.hours = 12
            newTemp.minutes = 34
            newTemp.seconds = 56
        }
        XCTAssertTrue(t.years == 1992)
        XCTAssertTrue(t.months == 12)
        XCTAssertTrue(t.days == 02)
        XCTAssertTrue(t.hours == 12)
        XCTAssertTrue(t.minutes == 34)
        XCTAssertTrue(t.seconds == 56)
    }
    
    func testUnixTimeInterval() {
        let t = Tempo(unixOffset: 1424274223)
        XCTAssertTrue(t.years == 2015)
        XCTAssertTrue(t.months == 2)
        XCTAssertTrue(t.days == 18)
    }
    
    func testCompareOperator() {
        let t = Tempo()
        let t2 = Tempo()
        
        XCTAssertTrue((t == t2) == true)
        t2.years = 3
        XCTAssertTrue((t == t2) == false)
    }
    
    func testWrongDate() {
        let t = Tempo()
        t.days = 64
        println("representation : \(t.representation())")
    }
    
    func testAfter() {
        let t = Tempo()
        let t2 = Tempo()
        t2.seconds! -= 1
        
        XCTAssertTrue((t > t2) == true)
        t.years! -= 1
        XCTAssertTrue((t > t2) == false)
        
        XCTAssertTrue((Tempo() > Tempo()) == nil)
    }
    
    func testBefore() {
        let t = Tempo()
        let t2 = Tempo()
        t2.seconds! -= 1
        
        XCTAssertTrue((t < t2) == false)
        t.years! -= 1
        XCTAssertTrue((t < t2) == true)
        
        XCTAssertTrue((Tempo() < Tempo()) == nil)
    }
    
    func testSame() {
        let t = Tempo()
        let t2 = Tempo()
        t2.seconds! -= 1

        XCTAssertTrue((t == t2) == false)
        t.years! -= 1
        XCTAssertTrue((t == t2) == false)
        
        XCTAssertTrue((Tempo() == Tempo()) == true)
    }
    
    func testIsBetween() {
        let t = Tempo()
        let t2 = Tempo(stringDate: "12/02/2015", format: "dd/MM/yyyy")
        let t3 = Tempo(stringDate: "22/02/2015", format: "dd/MM/yyyy")
        
        XCTAssertTrue(t.isBetween(Tempo(), tempoRight: Tempo()) == false)
        XCTAssertTrue(t.isBetween(t2, tempoRight: t3) == true)
        
        t3.days = t.days
        println("representation : :\(t.isBetween(t2, tempoRight: t3))")
        XCTAssertTrue(t.isBetween(t2, tempoRight: t3) == false)
        
        t3.years = 2200
        XCTAssertTrue(t.isBetween(t2, tempoRight: t3) == true)
        
        t3.years = 2001
        t2.years = 2200
        XCTAssertTrue(t.isBetween(t2, tempoRight: t3) == false)

    }
    
    func testIsIntervalDate() {
        let t = Tempo(stringDate: "12/02/1992")
        let t1 = Tempo(stringDate: "12/02/1992")
        
        XCTAssertTrue(t.isToday(t1) == true)
        XCTAssertTrue(t.isThisMonth(t1) == true)
        XCTAssertTrue(t.isThisYear(t1) == true)
        
        t1.hours = 23
        println("--------> \(t.description)")
        println("--------> \(t1.description)")
        XCTAssertTrue(t.isToday(t1) == true)
        XCTAssertTrue(t.isThisMonth(t1) == true)
        XCTAssertTrue(t.isThisYear(t1) == true)
        
        t1.days = 13
        
        XCTAssertTrue(t.isToday(t1) == false)
        XCTAssertTrue(t.isThisMonth(t1) == true)
        XCTAssertTrue(t.isThisYear(t1) == true)
        
        t1.months = 10
        
        XCTAssertTrue(t.isToday(t1) == false)
        XCTAssertTrue(t.isThisMonth(t1) == false)
        XCTAssertTrue(t.isThisYear(t1) == true)

        t1.years = 2000
        XCTAssertTrue(t.isToday(t1) == false)
        XCTAssertTrue(t.isThisMonth(t1) == false)
        XCTAssertTrue(t.isThisYear(t1) == false)
    }
    
    func testTimeAgoNow() {
        let t = Tempo()
        t.hours! -= 1
        XCTAssertTrue(t.timeAgoNow() == "An hour ago")
        
        t.hours! += 1
        t.minutes! -= 1
        XCTAssertTrue(t.timeAgoNow() == "A minute ago")

        t.minutes! += 1
        t.seconds! -= 1
        XCTAssertTrue(t.timeAgoNow() == "Just now")
        
        t.seconds! += 1
        t.months! -= 1
        XCTAssertTrue(t.timeAgoNow() == "Last month")
        
        t.months! -= 1
        XCTAssertTrue(t.timeAgoNow() == "2 months ago")
        
        t.months! -= 1
        XCTAssertTrue(t.timeAgoNow() == "3 months ago")
        
        t.years! -= 4
        XCTAssertTrue(t.timeAgoNow() == "4 years ago")
    }
    
    func testTimeSimple() {
        let t = Tempo()
        t.hours! -= 1
        XCTAssertTrue(t.timeAgoSimpleNow() == "1h")
        
        t.hours! += 1
        t.minutes! -= 1
        XCTAssertTrue(t.timeAgoSimpleNow() == "1m")
        
        t.minutes! += 1
        t.seconds! -= 1
        XCTAssertTrue(t.timeAgoSimpleNow() == "1s")
        
        t.seconds! += 1
        t.months! -= 1
        XCTAssertTrue(t.timeAgoSimpleNow() == "1mo")
        
        t.months! -= 1
        XCTAssertTrue(t.timeAgoSimpleNow() == "2mo")
        
        t.months! -= 1
        XCTAssertTrue(t.timeAgoSimpleNow() == "3mo")
        
        t.years! -= 4
        XCTAssertTrue(t.timeAgoSimpleNow() == "4yr")
    }
    
    func testTimeUntil() {
        let t = Tempo()
        t.hours! -= 1
        XCTAssertTrue(t.dateTimeUntilNow() == "Today")
        
        t.hours! += 1
        t.minutes! -= 1
        XCTAssertTrue(t.dateTimeUntilNow() == "Today")
        
        t.minutes! += 1
        t.seconds! -= 1
        XCTAssertTrue(t.dateTimeUntilNow() == "Today")
        
        t.seconds! += 1
        t.months! -= 1
        XCTAssertTrue(t.dateTimeUntilNow() == "Last month")
        
        t.months! -= 1
        println("DATE DIFF : \(t.dateTimeUntilNow())")
        XCTAssertTrue(t.dateTimeUntilNow() == "This year")
        
        t.months! -= 1
        XCTAssertTrue(t.dateTimeUntilNow() == "This year")
        
        t.years! -= 4
        XCTAssertTrue(t.dateTimeUntilNow() == "4 years ago")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
