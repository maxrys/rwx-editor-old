
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension UInt {

    func bitGet(index: UInt) -> Bool {
        return (self >> index & 0b1) == 1
    }

    mutating func bitSet(index: UInt, isOn: Bool = false) {
        if (isOn) { self = self |  (0b1 << index) }
        else      { self = self & ~(0b1 << index) }
    }

    mutating func bitToggle(position: UInt) {
        self = self ^ (0b1 << position)
    }

}
