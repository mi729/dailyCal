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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(calendarArray)

        if UserDefaults.standard.array(forKey: "checkmarkarray") == nil {
            for _ in 0 ... calendarArray.count - 1 {
                checkMarkArray.append(true)
            }
            UserDefaults.standard.set(checkMarkArray, forKey: "checkmarkarray")
        } else {
            checkMarkArray = UserDefaults.standard.array(forKey: "checkmarkarray") as! [Bool]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendarTableVIew.reloadData()
    }


    func changeBool(value: Bool) -> Bool {
        if value == true {
            return false
        } else {
            return true
        }
    }
}
