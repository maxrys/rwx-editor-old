
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct NumericSwitcherView: View {

    private var rights: Binding<UInt>

    @State var selectedOwnerValue: UInt = 0
    @State var selectedGroupValue: UInt = 0
    @State var selectedOtherValue: UInt = 0
    @State var selectorOwnerIsOpened: Bool = false
    @State var selectorGroupIsOpened: Bool = false
    @State var selectorOtherIsOpened: Bool = false

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
        HStack(spacing: 0) {
            self.switcher(self.$selectedOwnerValue, self.$selectorOwnerIsOpened)
            self.switcher(self.$selectedGroupValue, self.$selectorGroupIsOpened)
            self.switcher(self.$selectedOtherValue, self.$selectorOtherIsOpened)
        }
    }

    @ViewBuilder func switcher(_ value: Binding<UInt>, _ isOpened: Binding<Bool>) -> some View {
        ZStack {

            /* MARK: value list */
            if (isOpened.wrappedValue) {
                VStack(spacing: 2) {
                    ForEach(0 ... 7, id: \.self) { number in
                        Button {
                            value.wrappedValue = UInt(number)
                            isOpened.wrappedValue = false
                        } label: { Text("\(number)") }
                        .buttonStyle(.plain)
                        .onHover { isInView in
                            if (isInView) { NSCursor.pointingHand.push() }
                            else          { NSCursor.pop() }
                        }
                    }
                }
                .padding(5)
                .background(Color(.gray))
                .color(Color(.white))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.5), radius: 2.0)
                .frame(width: 20)
                .offset(y: -90)
            }

            /* MARK: selected value */
            Button {
                isOpened.wrappedValue.toggle()
            } label: {
                Text("\(value.wrappedValue)")
            }
            .buttonStyle(.plain)
            .onHover { isInView in
                if (isInView) { NSCursor.pointingHand.push() }
                else          { NSCursor.pop() }
            }

        }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        NumericSwitcherView($rights)
    }
    .padding(20)
    .frame(maxHeight: 400)
}
