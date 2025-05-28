
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct NumericSwitcherView: View {

    private var rights: Binding<UInt>

    init(_ rights: Binding<UInt>) {
        self.rights = rights
    }

    var body: some View {
        let valueGet: (Subject) -> UInt = { subject in
            let bit2 = self.rights.wrappedValue.bitGet(position: 3 * subject.offset + 2)
            let bit1 = self.rights.wrappedValue.bitGet(position: 3 * subject.offset + 1)
            let bit0 = self.rights.wrappedValue.bitGet(position: 3 * subject.offset + 0)
            var result: UInt = 0
                result.bitSet(position: 2, isOn: bit2 == 1 ? true : false)
                result.bitSet(position: 1, isOn: bit1 == 1 ? true : false)
                result.bitSet(position: 0, isOn: bit0 == 1 ? true : false)
            return result
        }
        Text("\(valueGet(.owner))")
        Text("\(valueGet(.group))")
        Text("\(valueGet(.other))")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        NumericSwitcherView($rights)
    }.padding(20)
}
