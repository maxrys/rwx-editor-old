
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToggleRwxColored: View {

    enum ColorNames: String {
        case empty = "color ToggleRwxColored Empty"
        case owner = "color Soft Green"
        case group = "color Soft Orange"
        case other = "color Soft Red"
    }

    private var color: ColorNames
    private var rights: Binding<UInt>
    private var bitPosition: UInt
    private let iconR: CGFloat = 25
    private var isOn: Bool {
        self.rights.wrappedValue.bitGet(
            position: self.bitPosition
        ) == 1
    }

    init(_ color: ColorNames, _ rights: Binding<UInt>, bitPosition: UInt) {
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
                        .foregroundPolyfill(Color.white)
                }
            } else {
                Circle()
                    .fill(Color(Self.ColorNames.empty.rawValue))
                    .frame(width: self.iconR, height: self.iconR)
            }
        }
        .buttonStyle(.plain)
        .onHoverCursor()
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o7
    HStack(spacing: 10) {
        ToggleRwxColored(.group, $rights, bitPosition: Permission.x.offset)
        ToggleRwxColored(.other, $rights, bitPosition: Permission.w.offset)
        ToggleRwxColored(.owner, $rights, bitPosition: Permission.r.offset)
    }.padding(20)
}
