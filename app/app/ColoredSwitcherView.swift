
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ColoredSwitcherView: View {

    enum MainColor: String {
        case empty = "color ColoredSwitcherView Empty"
        case owner = "color ColoredSwitcherView Owner"
        case group = "color ColoredSwitcherView Group"
        case other = "color ColoredSwitcherView Other"
    }

    private var color: MainColor
    private var rights: Binding<UInt>
    private var bitPosition: UInt8

    private let iconR: CGFloat = 25
    private var isOn: Bool {
        self.rights.wrappedValue.bitGet(
            position: self.bitPosition
        ) == 1
    }

    init(_ color: MainColor, _ rights: Binding<UInt>, bitPosition: UInt8) {
        self.color       = color
        self.rights      = rights
        self.bitPosition = bitPosition
    }

    var body: some View {
        Button {
            self.rights.wrappedValue.bitToggle(
                position: self.bitPosition
            )
        } label: {
            if (self.isOn) {
                ZStack {
                    Circle()
                        .fill(Color(self.color.rawValue))
                        .frame(width: self.iconR, height: self.iconR)
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .color(Color(.white))
                }
            } else {
                Circle()
                    .fill(Color(MainColor.empty.rawValue))
                    .frame(width: self.iconR, height: self.iconR)
            }
        }
        .buttonStyle(.plain)
        .onHover { isInView in
            if (isInView) { NSCursor.pointingHand.push() }
            else          { NSCursor.pop() }
        }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o7
    HStack(spacing: 10) {
        ColoredSwitcherView(.group, $rights, bitPosition: 0)
        ColoredSwitcherView(.other, $rights, bitPosition: 1)
        ColoredSwitcherView(.owner, $rights, bitPosition: 2)
    }.padding(20)
}
