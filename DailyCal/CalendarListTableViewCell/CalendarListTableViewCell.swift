//
//  CalendarListTableViewCell.swift
//  
//
//  Created by nyagoro on 2020/08/01.
//

import UIKit
import EventKit

class CalendarListTableViewCell: UITableViewCell {
    @IBOutlet weak var circleLabel: UILabel! {
        didSet {
        self.circleLabel.text = "●"
        }
    }
    @IBOutlet weak var calendarName: UILabel!
    
    var calendar: EKCalendar! {
        didSet {
            circleLabel.textColor = UIColor(cgColor: calendar.cgColor)
            calendarName.text = calendar.title
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
