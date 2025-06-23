
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension URL {

    var pathNameParts: (path: String, name: String) {
        var path = self.path()
        let name = self.lastPathComponent
        if (path.last == "/")
             { path = String(path[0, UInt(path.count - name.count - 2)]) }
        else { path = String(path[0, UInt(path.count - name.count - 1)]) }
        return (path: path, name: name)
    }

}
