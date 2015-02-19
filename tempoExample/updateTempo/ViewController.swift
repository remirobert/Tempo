//
//  ViewController.swift
//  updateTempo
//
//  Created by Remi Robert on 17/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let t3 = Tempo(stringDate: "12/02/1992")
        let t = Tempo(stringDate: "12/02/1992")
        let t1 = Tempo(stringDate: "12/02/1992")
        t1.hours = 23
        

        let s1 = t.format(format: "dd/MM/yyyy HH:mm ss")
        let s2 = t.format(format: "dd/MM/yyyy HH:mm ss")
        
        let calendar = NSCalendar.currentCalendar()

        let c = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: t.date, toDate: t1.date, options: NSCalendarOptions.allZeros)
        println("is tokday : \(t.isToday(t1))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

