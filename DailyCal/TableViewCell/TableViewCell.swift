//
//  TableViewCell.swift
//  DailyCal
//
//  Created by nyagoro on 2020/05/09.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit
import EventKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel?.adjustsFontSizeToFitWidth = true
            titleLabel?.lineBreakMode = .byClipping
        }
    }

    var event: EKEvent! {
        didSet {
            titleLabel.text = event.title
            colorTag.backgroundColor = UIColor(cgColor: event.calendar.cgColor)
            if event.isAllDay {
                startTime.text = "終日"
                endTime.text = ""
            } else {
                let f = DateFormatter()
                
                f.setTemplate(.eventDate)
                let todayString = f.string(from: Date())
                let endDateString = f.string(from: event.endDate)
                
                f.setTemplate(.eventTime)
                startTime.text = f.string(from: event.startDate)
                
                guard todayString == endDateString else {  //正しく動くか確認
                    endTime.text = ""
                    return
                }
                endTime.text = f.string(from: event.endDate)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
