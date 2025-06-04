
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct GroupPicker: View {

    private var selected: Binding<UInt>

    init(_ selected: Binding<UInt>) {
        self.selected = selected
    }

    var body: some View {
        CustomPicker(
            selectedIndex: self.selected,
            values: ThisApp.groups
        )
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selected: UInt = 0
    HStack {
        GroupPicker($selected)
    }.padding(20)
}
