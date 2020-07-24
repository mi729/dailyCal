//
//  Date+Addition.swift
//  DailyCal
//
//  Created by nyagoro on 2020/07/24.
//  Copyright © 2020 Nyago. All rights reserved.
//

import Foundation

extension DateFormatter {
    enum Template: String {
        case yearMonth = "yM"
        case date = "d"
        case weekDay = "EE"
        case eventTime = "HH:mm"
        case eventDate = "yMd"
    }
    func setTemplate(_ template: Template) {
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: Locale.current)
    }
}
