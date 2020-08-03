//
//  CalendarListViewController+UITableViewDelegate.swift
//  DailyCal
//
//  Created by nyagoro on 2020/08/01.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate,UITableViewDataSource

extension CalendarListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell") as! CalendarListTableViewCell
        cell.calendar = calendarArray[indexPath.row]
        if checkMarkArray[indexPath.row] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkMarkArray[indexPath.row] = changeBool(value: checkMarkArray[indexPath.row], row: indexPath.row)
        UserDefaults.standard.set(checkMarkArray, forKey: "checkmarkarray")
        
//        let cell = self.calendarTableVIew.cellForRow(at: indexPath) as! CalendarListTableViewCell
//        cell.calendar.isSelected = checkMarkArray
        self.calendarTableVIew.reloadData()
    }
}
