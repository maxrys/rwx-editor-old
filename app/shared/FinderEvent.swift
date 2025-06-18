
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

struct FinderEvent: Codable {

    var paths: [String]

    func encode() -> String {
        return String(
            data: try! JSONEncoder().encode(self),
            encoding: .utf8
        )!
    }

    static func decode(_ event: String) throws -> Self {
        return try JSONDecoder().decode(
            Self.self,
            from: event.data(
                using: .utf8
            )!
        )
    }

}
