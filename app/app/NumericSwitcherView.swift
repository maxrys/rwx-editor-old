
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct NumericSwitcherView: View {

    private var rights: Binding<UInt>

    @State var selectedOwnerValue: UInt = 0
    @State var selectedGroupValue: UInt = 0
    @State var selectedOtherValue: UInt = 0

    let valueExtract: (UInt, Subject) -> UInt = { rightsValue, subject in
        let bitR = rightsValue.bitGet(position: subject.offset + Permission.r.offset)
        let bitW = rightsValue.bitGet(position: subject.offset + Permission.w.offset)
        let bitX = rightsValue.bitGet(position: subject.offset + Permission.x.offset)
        var result: UInt = 0
            result.bitSet(position: Permission.r.offset, isOn: bitR == 1)
            result.bitSet(position: Permission.w.offset, isOn: bitW == 1)
            result.bitSet(position: Permission.x.offset, isOn: bitX == 1)
        return result
    }

    init(_ rights: Binding<UInt>) {
        self.rights = rights
        self.selectedOwnerValue = self.valueExtract(self.rights.wrappedValue, .owner)
        self.selectedGroupValue = self.valueExtract(self.rights.wrappedValue, .group)
        self.selectedOtherValue = self.valueExtract(self.rights.wrappedValue, .other)
    }

    var body: some View {
        let values: [String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        HStack(spacing: 3) {
            CustomPicker(selection: self.$selectedOwnerValue, values: values)
            CustomPicker(selection: self.$selectedGroupValue, values: values)
            CustomPicker(selection: self.$selectedOtherValue, values: values)
        }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        NumericSwitcherView($rights)
    }
    .padding(20)
}
