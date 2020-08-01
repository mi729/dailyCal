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
    @IBOutlet weak var calendarTableVIew: UITableView!
    
    let calendarArray = EKEventStore().calendars(for: .event)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTableVIew.dataSource = self
    }
    

}
