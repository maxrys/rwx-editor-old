
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension String {

    func paddingLeft(toLength: Int, withPad: String) -> String {
        String(repeating: withPad, count: toLength - self.count) + self
    }

    subscript(position: Int) -> Character {
        let index = position >= 0 ? self.startIndex : self.endIndex
        return self[self.index(index, offsetBy: position)]
    }

    subscript(startPosition: Int, endPosition: Int) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: startPosition)
        let endIndex = self.index(self.startIndex, offsetBy: endPosition)
        return self[startIndex ... endIndex]
    }

}
