//
//  DateHelper.swift
//  Podcasts
//
//  Created by Owen Henley on 12/30/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation

extension Date {
    func dateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// struct DateHelper {
//     static func formatDate() {
//         let dateFormatter = DateFormatter()
//         dateFormatter.dateFormat = "MMM dd, yyyy"
//     }
// }
