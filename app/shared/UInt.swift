
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

}
