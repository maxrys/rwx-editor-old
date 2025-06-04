
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct OwnerPickerView: View {

    private var selected: Binding<UInt>

    init(_ selected: Binding<UInt>) {
        self.selected = selected
    }

    var body: some View {
        let values: [String] = ["user 1", "user 2", "user 3"]
        CustomPicker(selectedIndex: self.selected, values: values)
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selected: UInt = 0
    HStack {
        OwnerPickerView($selected)
    }
    .padding(20)
}
