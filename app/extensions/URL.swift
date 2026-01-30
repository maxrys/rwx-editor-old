
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension URL {

    static let URL_PREFIX = "file://"
    static let URL_SUFFIX = "/"

    var pathAndName: (path: String, name: String) {
        var absolute = self.absoluteString

        if (absolute.hasPrefix(Self.URL_PREFIX)) { absolute = String(absolute.dropFirst(Self.URL_PREFIX.count)) }
        if (absolute.hasSuffix(Self.URL_SUFFIX)) { absolute = String(absolute.dropLast (Self.URL_SUFFIX.count)) }

        let splitResult = absolute.split(
            separator: "/",
            omittingEmptySubsequences: false
        )

        if (splitResult.count >= 2) {
            let path = String(describing: splitResult.dropLast().joined(separator: "/"))
            let name = String(describing: splitResult.last!)
            return (
                path: path.hasSuffix("/") == false ? path + "/" : path,
                name: name
            )
        }
        return (path: "/", name: "")
    }

}
