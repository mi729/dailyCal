//
//  ViewController.swift
//  DailyCal
//
//  Created by nyagoro on 2020/05/09.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController {
    
    @IBAction func logInButtonDidTap(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        // ログイン画面の表示元を設定
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if GIDSignIn.sharedInstance()!.hasPreviousSignIn() {
            GIDSignIn.sharedInstance()!.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance()?.signIn()
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
    
    var schedule:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            print("currentUser.profile.email: \(user.profile!.email!)")
        } else {
            print("currentUser is nil")
        }
        
        let f = DateFormatter()
        f.setTemplate(.yearMonth)
        let today = Date()
        let currentYearMonth = f.string(from: today)
        
        f.setTemplate(.date)
        let currentDate = f.string(from: today)
        
        f.setTemplate(.weekDay)
        let currentDay = f.string(from: today)

        yearMonthLabel.text = "\(currentYearMonth)"
        dateLabel.text = currentDate
        dayLabel.text = currentDay

        schedule = ["FakeMotion CD発売日", "星名‪美怜‬誕生日", "コニファーライブ配信"]
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let device = bluetoothService.peripherals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
//        cell.backgroundColor = UIColor.clear
//        cell.connectButton.tag = indexPath.row
//
        cell.setData(color: .blue, titleText: schedule[indexPath.row])
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

extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            print("signIned user email: \(user!.profile!.email!)")
        } else {
            print("error: \(error!.localizedDescription)")
        }
    }
}
