
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

struct FinderEvent: Codable {

    var paths: [String]

    init(paths: [String]) {
        self.paths = paths
    }

    init?(from json: String) {
        do {
            self = try JSONDecoder().decode(
                Self.self,
                from: json.data(
                    using: .utf8
                )!
            )
        } catch { return nil }
    }

    func encode() -> String {
        return String(
            data: try! JSONEncoder().encode(self),
            encoding: .utf8
        )!
    }

}
