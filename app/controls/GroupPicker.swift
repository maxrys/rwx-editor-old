
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
        let values: [String] = ["group 1", "group 2", "group 3"]
        CustomPicker(selectedIndex: self.selected, values: values)
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selected: UInt = 0
    HStack {
        GroupPicker($selected)
    }.padding(20)
}
