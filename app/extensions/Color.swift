
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

/* Picker Custom */

extension Color {

    struct PickerColorSet {
        let text           = Color("color PickerCustom Text")
        let border         = Color("color PickerCustom Border")
        let background     = Color("color PickerCustom Background")
        let itemText       = Color("color PickerCustom Item Text")
        let itemBackground = Color("color PickerCustom Item Background")
    }

    static let picker = PickerColorSet()

}
