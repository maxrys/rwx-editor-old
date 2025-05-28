
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct EditorView: View {

    @State private var rights: UInt
           private var rightsOriginal: UInt

    private let onApplyRights: (UInt) -> Void

    init(rights: UInt, onApplyRights: @escaping (UInt) -> Void) {
        self.rights         = rights
        self.rightsOriginal = rights
        self.onApplyRights  = onApplyRights
    }

    var body: some View {
        VStack(spacing: 20) {

            /* MARK: rules via toggles */
            HStack(spacing: 0) {

                let textW: CGFloat = 60
                let textH: CGFloat = 25

                VStack(spacing: 10) {
                    Text("").frame(width: textW, height: textH)
                    Text(NSLocalizedString("Owner", comment: "")).frame(width: textW, height: textH)
                    Text(NSLocalizedString("Group", comment: "")).frame(width: textW, height: textH)
                    Text(NSLocalizedString("Other", comment: "")).frame(width: textW, height: textH)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Read", comment: "")).frame(width: textW, height: textH)
                    ColoredSwitcherView(.owner, self.$rights, bitPosition: 8)
                    ColoredSwitcherView(.group, self.$rights, bitPosition: 5)
                    ColoredSwitcherView(.other, self.$rights, bitPosition: 2)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Write", comment: "")).frame(width: textW, height: textH)
                    ColoredSwitcherView(.owner, self.$rights, bitPosition: 7)
                    ColoredSwitcherView(.group, self.$rights, bitPosition: 4)
                    ColoredSwitcherView(.other, self.$rights, bitPosition: 1)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Execute", comment: "")).frame(width: textW, height: textH)
                    ColoredSwitcherView(.owner, self.$rights, bitPosition: 6)
                    ColoredSwitcherView(.group, self.$rights, bitPosition: 3)
                    ColoredSwitcherView(.other, self.$rights, bitPosition: 0)
                }

            }.frame(width: 250)

            /* MARK: rules via text */
            VStack(spacing: 10) {
                TextSwitcherView($rights)
                Text("oct: \(self.rights.oct)")
            }

            /* MARK: cancel/apply buttons */
            HStack(spacing: 10) {

                Button {
                    self.rights = self.rightsOriginal
                } label: { Text(NSLocalizedString("cancel", comment: "")) }
                .onHover { isInView in
                    if (isInView) { NSCursor.pointingHand.push() }
                    else          { NSCursor.pop() }
                }

                Button {
                    self.onApplyRights(
                        self.rights
                    )
                } label: { Text(NSLocalizedString("apply", comment: "")) }
                .onHover { isInView in
                    if (isInView) { NSCursor.pointingHand.push() }
                    else          { NSCursor.pop() }
                }

            }

        }.padding(20)
    }

}

#Preview {
    EditorView(
        rights: 0o644,
        onApplyRights: { rights in
            print("rights: \(String(rights, radix: 8))")
        }
    )
}
