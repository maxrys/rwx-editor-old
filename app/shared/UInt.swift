
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension UInt {

    func bitGet(position: UInt) -> UInt {
        return UInt(self >> position & 0b1)
    }

    mutating func bitSet(position: UInt, isOn: Bool = false) {
        if (isOn) { self = self |  (0b1 << position) }
        else      { self = self & ~(0b1 << position) }
    }

    mutating func bitToggle(position: UInt) {
        self = self ^ (0b1 << position)
    }

    func format(state: BytesState) -> String {
        switch state {
            case  .bytes: return ByteCountFormatter.format(self, unit: .useBytes)
            case .kbytes: return ByteCountFormatter.format(self, unit: .useKB)
            case .mbytes: return ByteCountFormatter.format(self, unit: .useMB)
            case .gbytes: return ByteCountFormatter.format(self, unit: .useGB)
            case .tbytes: return ByteCountFormatter.format(self, unit: .useTB)
        }
    }

}
