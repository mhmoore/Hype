//
//  DateHelper.swift
//  Hype
//
//  Created by Michael Moore on 8/27/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation


class DateHelper {
    
    static let shared = DateHelper()
    
    // this ensures that this class can only be initialized once (true singleton)
    private init() {}
    
    let dateFormatter = DateFormatter()
    
    func mediumStringFor(date: Date) -> String {
        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "MM/d/YYYY" // can't mix Format and Style
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    // func longStringFor(date: Date)
    // func shortStringFor(date: Date)
}
