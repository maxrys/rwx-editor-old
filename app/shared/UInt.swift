
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension UInt {

    var rwx: String {
        (self.bitGet(position: 8) == 1 ? "r" : "-") +
        (self.bitGet(position: 7) == 1 ? "w" : "-") +
        (self.bitGet(position: 6) == 1 ? "x" : "-") +
        (self.bitGet(position: 5) == 1 ? "r" : "-") +
        (self.bitGet(position: 4) == 1 ? "w" : "-") +
        (self.bitGet(position: 3) == 1 ? "x" : "-") +
        (self.bitGet(position: 2) == 1 ? "r" : "-") +
        (self.bitGet(position: 1) == 1 ? "w" : "-") +
        (self.bitGet(position: 0) == 1 ? "x" : "-")
    }

    var oct: String {
        String(self, radix: 8)
    }

    func bitGet(position: UInt8) -> UInt8 {
        return UInt8(self >> position & 0b1)
    }

    mutating func bitSet(position: UInt8, isOn: Bool = false) {
        if (isOn) { self = self |  (0b1 << position) }
        else      { self = self & ~(0b1 << position) }
    }

    mutating func bitToggle(position: UInt8) {
        self = self ^ (0b1 << position)
    }

}
