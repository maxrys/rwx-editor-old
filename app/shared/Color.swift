
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    enum ColorNames: String {
        case text       = "color Text"
        case softGreen  = "color Soft Green"
        case softOrange = "color Soft Orange"
        case softRed    = "color Soft Red"
        case darkGreen  = "color Dark Green"
        case darkOrange = "color Dark Orange"
        case darkRed    = "color Dark Red"
    }

    static func getCustom(_ name: ColorNames = .text) -> Self {
        Self(name.rawValue)
    }

}
