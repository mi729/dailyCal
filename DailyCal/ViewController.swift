//
//  ViewController.swift
//  DailyCal
//
//  Created by nyagoro on 2020/05/09.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit
import EventKit
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController {
    
    @IBAction func logInButtonDidTap(_ sender: Any) {
        
    }
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               tableView.delegate = self
               tableView.dataSource = self
            tableView.register(UINib(nibName:"TableViewCell", bundle: nil),forCellReuseIdentifier:"tableCell")
           }
       }
    
    var eventStore = EKEventStore()
    let calendar = Calendar.current
    let today = Date()
    var eventArray: [EKEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setLabelText()
        checkAuth()
    }

    func setLabelText() {
        let f = DateFormatter()
        f.setTemplate(.yearMonth)
        let currentYearMonth = f.string(from: today)
        
        f.setTemplate(.date)
        let currentDate = f.string(from: today)
        
        f.setTemplate(.weekDay)
        let currentDay = f.string(from: today)
        
        yearMonthLabel.text = "\(currentYearMonth)"
        dateLabel.text = currentDate
        dayLabel.text = currentDay
    }

    func getEvents(_ date: Date) {
        let predicate = eventStore.predicateForEvents(withStart: date, end: date, calendars: nil)
        eventArray = eventStore.events(matching: predicate)
        print(eventArray)
        DispatchQueue.main.async {
                self.tableView.reloadData()
        }
    }
        
    func checkAuth() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if status == .authorized {
            getEvents(today)
            return
        }
        if status == .notDetermined {
            eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
                guard granted else {
                    return
                }
                self.getEvents(self.today)
            }
        }
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        let eventColor = UIColor(cgColor: eventArray[indexPath.row].calendar.cgColor)
        cell.setData(color: eventColor, titleText: eventArray[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
extension DateFormatter {
    enum Template: String {
        case yearMonth = "yM"
        case date = "d"
        case weekDay = "EE"
    }

    func setTemplate(_ template: Template) {
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: Locale.current)
    }
}
