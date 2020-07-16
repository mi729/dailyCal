//
//  TableViewCell.swift
//  DailyCal
//
//  Created by nyagoro on 2020/05/09.
//  Copyright © 2020 Nyago. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(color: UIColor, titleText: String){
        colorTag.backgroundColor = color
        titleLabel.text = titleText
    }
}
