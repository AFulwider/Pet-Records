//
//  DateHelper.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/26/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import Foundation
import UIKit

class DateHelper {
    static let shared = DateHelper()
    
    // returns a string from date
    public func dateToString(_ format: String, _ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    // returns a date from String
    public func stringToDate(_ format: String, _ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    // return reformatted date string
    public func longToShortDateString(_ fromFormat: String, _ dateString: String, _ toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let fromDateString = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = toFormat
        let toDateString = dateFormatter.string(from: fromDateString!)
        return toDateString
    }
    
    // return true if endDate is passed
    public func passedEndDate(_ dateFormat: String, _ endDate: String)->Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: endDate)
        if date! < Date() {
            // if date is before now
            return true
        } else {
            return false
        }
    }
}
