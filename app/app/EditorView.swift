
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
                    ColoredSwitcherView(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.r.offset)
                    ColoredSwitcherView(.group, self.$rights, bitPosition: Subject.group.offset + Permission.r.offset)
                    ColoredSwitcherView(.other, self.$rights, bitPosition: Subject.other.offset + Permission.r.offset)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Write", comment: "")).frame(width: textW, height: textH)
                    ColoredSwitcherView(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.w.offset)
                    ColoredSwitcherView(.group, self.$rights, bitPosition: Subject.group.offset + Permission.w.offset)
                    ColoredSwitcherView(.other, self.$rights, bitPosition: Subject.other.offset + Permission.w.offset)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Execute", comment: "")).frame(width: textW, height: textH)
                    ColoredSwitcherView(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.x.offset);
                    ColoredSwitcherView(.group, self.$rights, bitPosition: Subject.group.offset + Permission.x.offset);
                    ColoredSwitcherView(.other, self.$rights, bitPosition: Subject.other.offset + Permission.x.offset);
                }

            }.frame(width: 250)

            HStack(spacing: 20) {

                /* MARK: rules via text */
                TextSwitcherView($rights)

                /* MARK: rules via numeric */
                NumericSwitcherView($rights)

            }.padding(.vertical, 20)

            /* MARK: cancel/apply buttons */
            HStack(spacing: 10) {

                CustomButton(NSLocalizedString("cancel", comment: "")) {
                    self.rights = self.rightsOriginal
                }
                .disabled(self.rights == self.rightsOriginal)
                .frame(width: 110)

                CustomButton(NSLocalizedString("apply", comment: "")) {
                    self.onApplyRights(
                        self.rights
                    )
                }.frame(width: 110)

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
