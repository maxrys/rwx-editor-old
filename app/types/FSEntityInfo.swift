
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */


final class FSEntityInfo: Equatable {

    var realPath: String?
    var realName: String?


    static func == (lhs: FSEntityInfo, rhs: FSEntityInfo) -> Bool {
        return Self.equalViaMirror(lhs: lhs, rhs: rhs)
    }

    init(_ fullPath: String) {

        if let subtype = try? url.resourceValues(forKeys: [.isAliasFileKey, .isSymbolicLinkKey, .isRegularFileKey]) {
            switch (subtype.isRegularFile, subtype.isAliasFile, subtype.isSymbolicLink) {
                case (true, true, false):
                    self.type = .alias
                    self.realPath = "—"
                    self.realName = "—"
                case (false, true, true):
                    self.type = .link
                    let (realPath, realName) = url.resolvingSymlinksInPath().pathAndName
                    self.realPath = realPath
                    self.realName = realName
                default: break
            }
        }



    }

}
