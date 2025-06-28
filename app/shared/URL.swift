
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension URL {

    var pathNameParts: (path: String, name: String) {
        let pathWithName = self.path
        let name = self.lastPathComponent
        let path = String(
            pathWithName[0, UInt(pathWithName.count - name.count - 1)]
        )
        return (
            path: path,
            name: name
        )
    }

}
