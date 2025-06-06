
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

    @State private var isISOcreated: Bool = false
    @State private var isISOupdated: Bool = false
    @State private var rights: UInt
    @State private var owner: UInt
    @State private var group: UInt

    private let kind: Kind
    private let name: String
    private let path: String
    private let size: UInt
    private let created: Date
    private let updated: Date
    private let originalRights: UInt
    private let originalOwner: UInt
    private let originalGroup: UInt
    private let onApply: (UInt, UInt, UInt) -> Void

    init(kind: Kind, name: String, path: String, size: UInt, created: Date, updated: Date, rights: UInt, owner: UInt, group: UInt, onApply: @escaping (UInt, UInt, UInt) -> Void) {
        self.kind           = kind
        self.name           = name
        self.path           = path
        self.size           = size
        self.created        = created
        self.updated        = updated
        self.rights         = rights
        self.owner          = owner
        self.group          = group
        self.onApply        = onApply
        self.originalRights = rights
        self.originalOwner  = owner
        self.originalGroup  = group
    }

    @ViewBuilder func iconToggle(value: Binding<Bool>) -> some View {
        Button {
            value.wrappedValue.toggle()
        } label: {
            Image(systemName: "arcade.stick")
                .font(.system(size: 10, weight: .regular))
        }
        .buttonStyle(.plain)
        .onHoverCursor()
    }

    var body: some View {
        VStack(spacing: 0) {

            /* ########## */
            /* MARK: head */
            /* ########## */

            VStack(alignment: .leading, spacing: 6) {
                let titleColumnWidth: CGFloat = 90
                /* kind */
                HStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Kind", comment: ""))
                    }.frame(width: titleColumnWidth, alignment: .trailing)
                    HStack(spacing: 5) {
                        if (self.kind == .dirrectory) { Text(NSLocalizedString("dirrectory", comment: "")) }
                        if (self.kind == .file      ) { Text(NSLocalizedString("file"      , comment: "")) }
                    }
                }
                /* name */
                HStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Name", comment: ""))
                    }.frame(width: titleColumnWidth, alignment: .trailing)
                    HStack(spacing: 5) {
                        Text("\(self.name)")
                    }
                }
                /* path */
                HStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Path", comment: ""))
                    }.frame(width: titleColumnWidth, alignment: .trailing)
                    HStack(spacing: 5) {
                        Text("\(self.path)")
                    }
                }
                /* size */
                HStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Size", comment: ""))
                    }.frame(width: titleColumnWidth, alignment: .trailing)
                    HStack(spacing: 5) {
                        Text("\(self.size)")
                    }
                }
                /* created */
                HStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Created", comment: ""))
                        self.iconToggle(value: self.$isISOcreated)
                    }.frame(width: titleColumnWidth, alignment: .trailing)
                    HStack(spacing: 5) {
                        Text(self.isISOcreated ? self.created.ISO8601 : self.created.convenient)
                    }
                }
                /* updated */
                HStack(spacing: 10) {
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Updated", comment: ""))
                        self.iconToggle(value: self.$isISOupdated)
                    }.frame(width: titleColumnWidth, alignment: .trailing)
                    HStack(spacing: 5) {
                        Text(self.isISOupdated ? self.updated.ISO8601 : self.updated.convenient)
                    }
                }
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.head.rawValue))

            /* ########## */
            /* MARK: body */
            /* ########## */

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

                }

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

            /* ########## */
            /* MARK: foot */
            /* ########## */

            HStack(spacing: 10) {

                /* MARK: cancel button */
                ButtonCustom(NSLocalizedString("cancel", comment: "")) {
                    self.rights = self.originalRights
                    self.owner  = self.originalOwner
                    self.group  = self.originalGroup
                }
                .disabled(
                    self.rights == self.originalRights &&
                    self.owner  == self.originalOwner  &&
                    self.group  == self.originalGroup
                )
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

        }.frame(width: 300)
    }

}

#Preview {
    MainView(
        kind: .file,
        name: "Rwx Editor.icns",
        path: "/usr/local/bin/some/long/path",
        size: 1_234_567,
        created: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
        updated: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
        rights: 0o644,
        owner: 0,
        group: 0,
        onApply: { rights, owner, group in
            print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
        }
    ).frame(width: 300)
}
