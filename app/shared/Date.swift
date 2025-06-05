
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

extension Date {

    enum DateError: Error {
        case valueIsNil
    }

    static let FORMAT_ISO8601          = "yyyy-MM-dd HH:mm:ss"
    static let FORMAT_ISO8601_TIMEZONE = "yyyy-MM-dd HH:mm:ss Z"
    static let FORMAT_CONVENIENT_DATE  = "d MMM yyyy"
    static let FORMAT_CONVENIENT_TIME  = "HH:mm:ss"

    var ISO8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Self.FORMAT_ISO8601_TIMEZONE
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }

    var convenient: String {
        let formatter = DateFormatter()
        formatter.dateFormat = String(
            format: NSLocalizedString("%@ 'at' %@", comment: ""),
            Self.FORMAT_CONVENIENT_DATE,
            Self.FORMAT_CONVENIENT_TIME )
        return formatter.string(from: self)
    }

    init(fromISO8601: String) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.FORMAT_ISO8601_TIMEZONE
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: fromISO8601) else {
            throw DateError.valueIsNil
        }
        self = date
    }

}
