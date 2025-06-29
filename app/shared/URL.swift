
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension URL {

    static let URL_PREFIX = "file://"

    var pathAndName: (path: String, name: String) {
        var absolute = self.absoluteString
        if (absolute.hasPrefix(Self.URL_PREFIX)) {
            absolute = String(absolute.dropFirst(Self.URL_PREFIX.count))
        }
        let splitResult = absolute.split(
            separator: "/",
            omittingEmptySubsequences: false
        )
        switch splitResult.count {
            case 1: return (path: "", name: absolute)
            case 2...:
                var path = String(describing: splitResult.dropLast().joined(separator: "/"))
                let name = String(describing: splitResult.last!)
                if (path.first != "/") { path = "/" + path       }
                if (path.last  != "/") { path =       path + "/" }
                return (
                    path: path,
                    name: name
                )
            default: return (path: "", name: "")
        }
    }

}
