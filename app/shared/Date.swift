
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

extension Date {

    static let FORMAT_ISO8601          = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_ISO8601_TIMEZONE = "yyyy-MM-dd HH:mm:ss Z"
    static let FORMAT_CONVENIENT       = "dd MMM yyyy HH:mm:ss"

    var ISO8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.FORMAT_ISO8601_TIMEZONE
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }

    var convenient: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.FORMAT_CONVENIENT
        return formatter.string(from: self)
    }

    init(fromISO8601: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.FORMAT_ISO8601_TIMEZONE
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        self = formatter.date(from: fromISO8601)!
    }

}
