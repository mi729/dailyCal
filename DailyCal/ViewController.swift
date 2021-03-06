//
//  ViewController.swift
//  DailyCal
//
//  Created by nyagoro on 2020/05/09.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        performSegue(withIdentifier: "toCalendarList", sender: nil)
    }
    @IBAction func logInButtonDidTap(_ sender: Any) {
        if isAuthorized(status) {
            dialogAuthorized()
        } else {
            dialogLinkCal()
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.contentHorizontalAlignment = .right
        }
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
    
    let defaults = UserDefaults.standard
    
    let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
    let today = Date()
    var eventStore = EKEventStore()
    var eventArray: [EKEvent] = []
    
    var calendarTitleArray: [String] = []
    
    var isAuthorized = { (status: EKAuthorizationStatus) -> Bool in
        if status == .authorized {
            print("Authorized")
            return true
        }
        print("denided")
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setLabelText()
//        checkAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAuth()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func setLabelText() {
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

    private func getEvents(_ date: Date) {
        let predicate = eventStore.predicateForEvents(withStart: date, end: date, calendars: nil)
        let calendarArray = EKEventStore().calendars(for: .event)
        if defaults.array(forKey: "calendarstring") == nil {
            for i in 0 ... calendarArray.count - 1 {
                calendarTitleArray.append("\(calendarArray[i].title)")
            }
            defaults.set(calendarTitleArray, forKey: "calendarstring")
        } else {
            calendarTitleArray = defaults.array(forKey: "calendarstring") as! [String]
        }
        
//        let getCalendarStrings: [String] = defaults.array(forKey: "calendarstring") as! [String]
        eventArray = eventStore.events(matching: predicate)
            .filter { calendarTitleArray.contains("\($0.calendar.title)") }
        
        DispatchQueue.main.async {
                self.tableView.reloadData()
        }
        print(calendarTitleArray)
        dump(eventArray)
    }
        
    private func checkAuth() {
        if isAuthorized(status) {
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
    
    private func dialogAuthorized() {
        let dialog = UIAlertController(title: "カレンダーは連携済みです", message: "", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: {
            self.getEvents(self.today)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    private func dialogLinkCal() {
        let dialog = UIAlertController(title: "カレンダーを連携する", message: "設定アプリを開いてカレンダーを連携しますか？", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "「設定」を開く", style: .default, handler: { action in
            let url = URL(string: "app-settings:root=General&path=com.118neko.DailyCal")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }))
        dialog.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
      getEvents(today)
//    updateView()
  }
}
