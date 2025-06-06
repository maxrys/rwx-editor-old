
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import CoreGraphics

enum Permission: String {

    case r = "r"
    case w = "w"
    case x = "x"

    var offset: UInt {
        switch self {
            case .r: return 2
            case .w: return 1
            case .x: return 0
        }
    }

}

enum Subject {

    case owner
    case group
    case other

    var offset: UInt {
        switch self {
            case .owner: return 6
            case .group: return 3
            case .other: return 0
        }
    }

}

enum Kind {

    case dirrectory
    case file

}

enum Flexibility {

    case size(CGFloat)
    case infinity
    case none

}

enum DateState: Int, CaseIterable & Equatable {

    case iso8601    = 0
    case convenient = 1

}

enum BytesState: String, CaseIterable & Equatable {

    case bytes  = "Bytes"
    case kbytes = "KBytes"
    case mbytes = "MBytes"
    case gbytes = "GBytes"
    case tbytes = "TBytes"

}
