
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension ByteCountFormatter {

    static func format(_ value: UInt, unit: ByteCountFormatter.Units = .useBytes) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [unit]
        formatter.countStyle = .binary
        formatter.isAdaptive = false
        return formatter.string(
            fromByteCount: Int64(value)
        )
    }

}
