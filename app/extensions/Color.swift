
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct CustomColorSet {
        let text       = Color("color Text")
        let softGreen  = Color("color Soft Green")
        let softOrange = Color("color Soft Orange")
        let softRed    = Color("color Soft Red")
        let darkGreen  = Color("color Dark Green")
        let darkOrange = Color("color Dark Orange")
        let darkRed    = Color("color Dark Red")
    }

    static let custom = CustomColorSet()

}

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
