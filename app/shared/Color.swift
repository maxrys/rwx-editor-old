
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    typealias _CustomPropSignature = (
        text      : Self,
        softGreen : Self,
        softOrange: Self,
        softRed   : Self,
        darkGreen : Self,
        darkOrange: Self,
        darkRed   : Self,
    )

    static var custom: (_CustomPropSignature) {(
        text      : Self("color Text"),
        softGreen : Self("color Soft Green"),
        softOrange: Self("color Soft Orange"),
        softRed   : Self("color Soft Red"),
        darkGreen : Self("color Dark Green"),
        darkOrange: Self("color Dark Orange"),
        darkRed   : Self("color Dark Red"),
    )}

}

/* Picker Custom */

extension Color {

    typealias _PickerPropSignature = (
        text          : Self,
        border        : Self,
        background    : Self,
        itemText      : Self,
        itemBackground: Self,
    )

    static var picker: (_PickerPropSignature) {(
        text          : Self("color PickerCustom Text"),
        border        : Self("color PickerCustom Border"),
        background    : Self("color PickerCustom Background"),
        itemText      : Self("color PickerCustom Item Text"),
        itemBackground: Self("color PickerCustom Item Background"),
    )}

}
