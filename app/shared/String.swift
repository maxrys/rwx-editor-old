
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension String {

    func paddingLeft(toLength: Int, withPad: String) -> String {
        String(repeating: withPad, count: toLength - self.count) + self
    }

}
