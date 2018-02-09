//
//  Date+CalendarInterval.swift
//  Delegate
//
//  Created by Dmitry Ivashin on 2/10/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import Foundation

extension Date {
    
    // Returns the amount of years from another date
    func years(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the amount of months from another date
    func months(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    // Returns the amount of days from another date
    func days(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // Returns the a custom time interval description from another date
    func offset(from date: Date) -> String
    {
        if years(from: date)   > 0 { let interval = "\(years(from: date))y ago"; return interval.localized }
        if months(from: date)  > 0 { let interval = "\(months(from: date))m ago"; return interval.localized  }
        if weeks(from: date)   > 0 { let interval = "\(weeks(from: date))w ago"; return interval.localized   }
        if days(from: date)    > 0 { let interval = "\(days(from: date))d ago"; return interval.localized    }
        if hours(from: date)   > 0 { let interval = "\(hours(from: date))h ago"; return interval.localized   }
        if minutes(from: date) > 0 { let interval = "\(minutes(from: date))m ago"; return interval.localized }
        if seconds(from: date) > 0 { let interval = "\(seconds(from: date))s ago"; return interval.localized }
        return ""
    }
}

