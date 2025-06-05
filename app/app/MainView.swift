
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainView: View {

    enum ColorNames: String {
        case head = "color MainView Head Background"
        case body = "color MainView Body Background"
        case foot = "color MainView Foot Background"
    }

    @State private var created: Date
    @State private var updated: Date
    @State private var rights: UInt
    @State private var owner: UInt
    @State private var group: UInt

    private let rightsOriginal: UInt
    private let onApply: (UInt, UInt, UInt) -> Void

    init(created: Date, updated: Date, rights: UInt, owner: UInt, group: UInt, onApply: @escaping (UInt, UInt, UInt) -> Void) {
        self.created        = created
        self.updated        = updated
        self.rights         = rights
        self.rightsOriginal = rights
        self.owner          = owner
        self.group          = group
        self.onApply        = onApply
    }

    var body: some View {
        VStack(spacing: 0) {

            /* MARK: head */
            VStack(spacing: 6) {
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Created", comment: ""))
                    Text(self.created.formatCustom())
                }
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Updated", comment: ""))
                    Text(self.updated.formatCustom())
                }
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.head.rawValue))

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
                    PickerCustom(
                        selectedIndex: self.$owner,
                        values: ThisApp.owners,
                        isPlainListStyle: true
                    )
                }

                /* MARK: group picker */
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Group", comment: ""))
                    PickerCustom(
                        selectedIndex: self.$group,
                        values: ThisApp.groups,
                        isPlainListStyle: true
                    )
                }

            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.body.rawValue))

            /* MARK: foot */
            HStack(spacing: 10) {

                /* MARK: cancel button */
                ButtonCustom(NSLocalizedString("cancel", comment: "")) {
                    self.rights = self.rightsOriginal
                }
                .disabled(self.rights == self.rightsOriginal)
                .frame(width: 110)

                /* MARK: apply button */
                ButtonCustom(NSLocalizedString("apply", comment: "")) {
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
    MainView(
        created: Date(),
        updated: Date(),
        rights: 0o644,
        owner: 0,
        group: 0,
        onApply: { rights, owner, group in
            print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
        }
    ).frame(width: 300)
}
