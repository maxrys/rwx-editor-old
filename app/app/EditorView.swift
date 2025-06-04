
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct EditorView: View {

    enum ColorNames: String {
        case head = "color EditorView Head Background"
        case body = "color EditorView Body Background"
        case foot = "color EditorView Foot Background"
    }

    @State private var rights: UInt
           private var rightsOriginal: UInt
    @State private var owner: UInt
    @State private var group: UInt

    private let onApply: (UInt, UInt, UInt) -> Void

    init(rights: UInt, owner: UInt, group: UInt, onApply: @escaping (UInt, UInt, UInt) -> Void) {
        self.rights         = rights
        self.rightsOriginal = rights
        self.owner          = owner
        self.group          = group
        self.onApply        = onApply
    }

    var body: some View {
        VStack(spacing: 0) {

            /* MARK: body */
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
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.r.offset)
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.r.offset)
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.r.offset)
                    }

                    VStack(spacing: 10) {
                        Text(NSLocalizedString("Write", comment: "")).frame(width: textW, height: textH)
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.w.offset)
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.w.offset)
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.w.offset)
                    }

                    VStack(spacing: 10) {
                        Text(NSLocalizedString("Execute", comment: "")).frame(width: textW, height: textH)
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.x.offset);
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.x.offset);
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.x.offset);
                    }

                }.frame(width: 250)

                /* MARK: rules via text/numeric */
                HStack(spacing: 20) {
                    RwxTextView($rights)
                    ToggleRwxNumeric($rights)
                }

                /* MARK: owner picker */
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Owner", comment: ""))
                    OwnerPicker(self.$owner)
                }

                /* MARK: group picker */
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Group", comment: ""))
                    GroupPicker(self.$group)
                }

            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.body.rawValue))

            /* MARK: foot */
            HStack(spacing: 10) {

                /* MARK: cancel button */
                CustomButton(NSLocalizedString("cancel", comment: "")) {
                    self.rights = self.rightsOriginal
                }
                .disabled(self.rights == self.rightsOriginal)
                .frame(width: 110)

                /* MARK: apply button */
                CustomButton(NSLocalizedString("apply", comment: "")) {
                    self.onApply(
                        self.rights,
                        self.owner,
                        self.group
                    )
                }.frame(width: 110)

            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.foot.rawValue))

        }
    }

}

#Preview {
    EditorView(
        rights: 0o644,
        owner: 0,
        group: 0,
        onApply: { rights, owner, group in
            print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
        }
    ).frame(width: 300)
}
