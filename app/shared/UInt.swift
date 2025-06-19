
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension UInt {

    subscript(index: UInt) -> Bool {
        get {
            (self >> index & 0b1) == 1
        }
        set(isOn) {
            if (isOn) { self = self |  (0b1 << index) }
            else      { self = self & ~(0b1 << index) }
        }
    }

    mutating func bitToggle(position: UInt) {
        self = self ^ (0b1 << position)
    }

}
