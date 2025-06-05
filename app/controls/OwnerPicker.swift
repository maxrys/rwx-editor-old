
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct OwnerPicker: View {

    private var selected: Binding<UInt>

    init(_ selected: Binding<UInt>) {
        self.selected = selected
    }

    var body: some View {
        PickerCustom(
            selectedIndex: self.selected,
            values: ThisApp.owners,
            isPlainListStyle: true
        )
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selected: UInt = 0
    HStack {
        OwnerPicker($selected)
    }.padding(20)
}
