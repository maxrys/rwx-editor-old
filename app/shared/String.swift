
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension String {

    func paddingLeft(toLength: Int, withPad: String) -> String {
        String(repeating: withPad, count: toLength - self.count) + self
    }

    subscript(position: Int) -> Character {
        let position = position >= 0 ? position : self.count + position
        let index = self.index(self.startIndex, offsetBy: position.fixBounds(max: self.count-1))
        return self[index]
    }

    subscript(startPosition: Int, endPosition: Int) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: startPosition.fixBounds(max: self.count-1))
        let endIndex   = self.index(self.startIndex, offsetBy: endPosition  .fixBounds(max: self.count-1))
        return self[startIndex ... endIndex]
    }

}
