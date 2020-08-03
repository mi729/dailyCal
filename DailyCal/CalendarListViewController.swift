//
//  CalendarListViewController.swift
//  DailyCal
//
//  Created by nyagoro on 2020/08/01.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit
import EventKit

class CalendarListViewController: UIViewController {
    @IBOutlet weak var calendarTableVIew: UITableView! {
        didSet {
            calendarTableVIew.delegate = self
            calendarTableVIew.dataSource = self
            calendarTableVIew.register(UINib(nibName:"CalendarListTableViewCell", bundle: nil),forCellReuseIdentifier:"calendarCell")
            calendarTableVIew.allowsMultipleSelection = false
        }
    }
    var calendarArray = EKEventStore().calendars(for: .event)
    var checkMarkArray: [Bool] = []
    var calendarTitleArray: [String] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(calendarArray)

        if UserDefaults.standard.array(forKey: "checkmarkarray") == nil {
            for _ in 0 ... calendarArray.count - 1 {
                checkMarkArray.append(true)
            }
            defaults.set(checkMarkArray, forKey: "checkmarkarray")
        } else {
            checkMarkArray = defaults.array(forKey: "checkmarkarray") as! [Bool]
        }
        
        if defaults.array(forKey: "calendarstring") == nil {
            for i in 0 ... calendarArray.count - 1 {
                calendarTitleArray.append("\(calendarArray[i].title)")
            }
            defaults.set(calendarTitleArray, forKey: "calendarstring")
        } else {
            calendarTitleArray = defaults.array(forKey: "calendarstring") as! [String]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendarTableVIew.reloadData()
    }


    func changeBool(value: Bool, row: Int) -> Bool {
        if value == true {
            calendarTitleArray.remove(at: row)
            defaults.set(calendarTitleArray, forKey: "calendarstring")
            return false
        } else {
            let calendarTitle = calendarArray[row].title
            calendarTitleArray.append(calendarTitle)
            return true
        }
    }
}
