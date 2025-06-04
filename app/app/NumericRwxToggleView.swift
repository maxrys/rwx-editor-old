
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct NumericRwxToggleView: View {

    private var rights: Binding<UInt>

    init(_ rights: Binding<UInt>) {
        self.rights = rights
    }

    let valueUnpack: (UInt, Subject) -> UInt = { rightsValue, subject in
        let bitR = rightsValue.bitGet(position: subject.offset + Permission.r.offset)
        let bitW = rightsValue.bitGet(position: subject.offset + Permission.w.offset)
        let bitX = rightsValue.bitGet(position: subject.offset + Permission.x.offset)
        var result: UInt = 0
            result.bitSet(position: Permission.r.offset, isOn: bitR == 1)
            result.bitSet(position: Permission.w.offset, isOn: bitW == 1)
            result.bitSet(position: Permission.x.offset, isOn: bitX == 1)
        return result
    }

    let valuePack: (UInt, UInt, Subject) -> UInt = { value, rightsValue, subject in
        let bitR = value.bitGet(position: Permission.r.offset)
        let bitW = value.bitGet(position: Permission.w.offset)
        let bitX = value.bitGet(position: Permission.x.offset)
        var result = rightsValue
            result.bitSet(position: subject.offset + Permission.r.offset, isOn: bitR == 1)
            result.bitSet(position: subject.offset + Permission.w.offset, isOn: bitW == 1)
            result.bitSet(position: subject.offset + Permission.x.offset, isOn: bitX == 1)
        return result
    }

    var body: some View {
        let values: [String] = ["0", "1", "2", "3", "4", "5", "6", "7"]
        let ownerProxy = Binding<UInt> { self.valueUnpack(self.rights.wrappedValue, .owner) } set: { value in self.rights.wrappedValue = self.valuePack(value, self.rights.wrappedValue, .owner) }
        let groupProxy = Binding<UInt> { self.valueUnpack(self.rights.wrappedValue, .group) } set: { value in self.rights.wrappedValue = self.valuePack(value, self.rights.wrappedValue, .group) }
        let otherProxy = Binding<UInt> { self.valueUnpack(self.rights.wrappedValue, .other) } set: { value in self.rights.wrappedValue = self.valuePack(value, self.rights.wrappedValue, .other) }
        HStack(spacing: 3) {
            CustomPicker(selectedIndex: ownerProxy, values: values)
            CustomPicker(selectedIndex: groupProxy, values: values)
            CustomPicker(selectedIndex: otherProxy, values: values)
        }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        NumericRwxToggleView($rights)
    }.padding(20)
}
