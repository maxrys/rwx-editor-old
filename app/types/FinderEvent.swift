
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

struct FinderEvent: Codable {

    let paths: [String]

    init(paths: [String]) {
        self.paths = paths
    }

    init?(decode json: String) {
        do {
            guard let data = json.data(using: .utf8) else {
                return nil
            }
            self = try JSONDecoder().decode(
                Self.self,
                from: data
            )
        } catch {
            return nil
        }
    }

    func encode() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(
            data: data,
            encoding: .utf8
        )
    }

}
