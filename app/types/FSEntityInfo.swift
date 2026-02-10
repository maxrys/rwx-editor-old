
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */


final class FSEntityInfo: Equatable {

    static func == (lhs: FSEntityInfo, rhs: FSEntityInfo) -> Bool {
        return Self.equalViaMirror(lhs: lhs, rhs: rhs)
    }

}
