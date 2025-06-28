
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension String {

    subscript(startPosition: UInt, endPosition: UInt) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: Int(startPosition.fixBounds(max: UInt(self.count-1))))
        let endIndex   = self.index(self.startIndex, offsetBy: Int(endPosition  .fixBounds(max: UInt(self.count-1))))
        return startIndex <= endIndex ? self[startIndex ... endIndex] : self[endIndex ... startIndex]
    }

}
