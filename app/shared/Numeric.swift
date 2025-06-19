
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

extension Numeric {

    func fixBounds(min: Self = 0, max: Self) -> Self where Self: Comparable {
        if self < min {return min}
        if self > max {return max}
        return self
    }

}
