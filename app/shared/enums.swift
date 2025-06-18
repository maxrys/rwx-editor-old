
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import CoreGraphics

public enum Permission: String {

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

public enum Subject {

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

public enum Kind {

    case dirrectory
    case file
    case unknown

}

public enum Flexibility {

    case none
    case size(CGFloat)
    case infinity

}

public enum BytesViewMode: String, CaseIterable & Equatable {

    case bytes  = "Bytes"
    case kbytes = "KBytes"
    case mbytes = "MBytes"
    case gbytes = "GBytes"
    case tbytes = "TBytes"

}

public enum DateViewMode: CaseIterable & Equatable {

    case convenient
    case iso8601withTZ
    case iso8601

}
