
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct NumericSwitcherView: View {

    private var rights: Binding<UInt>

    init(_ rights: Binding<UInt>) {
        self.rights = rights
    }

    let valueExtract: (UInt, Subject) -> UInt = { rightsValue, subject in
        let bitR = rightsValue.bitGet(position: subject.offset + Permission.r.offset)
        let bitW = rightsValue.bitGet(position: subject.offset + Permission.w.offset)
        let bitX = rightsValue.bitGet(position: subject.offset + Permission.x.offset)
        var result: UInt = 0
            result.bitSet(position: 2, isOn: bitR == 1)
            result.bitSet(position: 1, isOn: bitW == 1)
            result.bitSet(position: 0, isOn: bitX == 1)
        return result
    }

    var body: some View {
        HStack(spacing: 0) {
            self.switcher(self.valueExtract(self.rights.wrappedValue, .owner))
            self.switcher(self.valueExtract(self.rights.wrappedValue, .group))
            self.switcher(self.valueExtract(self.rights.wrappedValue, .other))
        }
    }

    @ViewBuilder func switcher(_ value: UInt) -> some View {
        Text("\(value)")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        NumericSwitcherView($rights)
    }.padding(20)
}
