
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

struct FinderEvent: Codable {

    enum FinderEventType: Codable {
        case directory
        case file
    }

    var type: FinderEventType
    var items: [String]

    func encode() -> String {
        return String(
            data: try! JSONEncoder().encode(self),
            encoding: .utf8
        )!
    }

    static func decode(_ event: String) -> Self {
        return try! JSONDecoder().decode(
            Self.self,
            from: event.data(
                using: .utf8
            )!
        )
    }

}
