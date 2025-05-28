
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
            let bitR = self.rights.wrappedValue.bitGet(position: subject.offset + Permission.r.offset)
            let bitW = self.rights.wrappedValue.bitGet(position: subject.offset + Permission.w.offset)
            let bitX = self.rights.wrappedValue.bitGet(position: subject.offset + Permission.x.offset)
            var result: UInt = 0
                result.bitSet(position: 2, isOn: bitR == 1)
                result.bitSet(position: 1, isOn: bitW == 1)
                result.bitSet(position: 0, isOn: bitX == 1)
            return result
        }
        HStack(spacing: 0) {
            Text("\(valueGet(.owner))")
            Text("\(valueGet(.group))")
            Text("\(valueGet(.other))")
        }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        NumericSwitcherView($rights)
    }.padding(20)
}
