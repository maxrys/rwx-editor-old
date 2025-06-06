
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension CaseIterable where Self: Equatable {

    var next: Self {
        var isMatch: Bool = false
        var first: Self?
        for value in Self.allCases {
            if (first == nil) { first = value }
            if (isMatch) { return value }
            if (self == value) {
                isMatch = true
            }
        }
        return first!
    }

    mutating func roll() {
        self = self.next
    }

}
