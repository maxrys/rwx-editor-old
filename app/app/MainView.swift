
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

    @State private var rights: UInt
    @State private var owner: String
    @State private var group: String
    @State private var sizeMode: BytesViewMode = .bytes
    @State private var createdMode: DateViewMode = .convenient
    @State private var updatedMode: DateViewMode = .convenient

    private let kind: Kind
    private let name: String
    private let path: String
    private let size: UInt
    private let created: Date
    private let updated: Date
    private let originalRights: UInt
    private let originalOwner: String
    private let originalGroup: String
    private let onApply: (UInt, String, String) -> Void

    init(kind: Kind, name: String, path: String, size: UInt, created: Date, updated: Date, rights: UInt, owner: String, group: String, onApply: @escaping (UInt, String, String) -> Void) {
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

    @ViewBuilder func iconRoll<T: CaseIterable & Equatable>(value: Binding<T>) -> some View {
        Button {
            value.wrappedValue.roll()
        } label: {
            Image(systemName: "arcade.stick")
                .font(.system(size: 10, weight: .regular))
        }
        .buttonStyle(.plain)
        .onHoverCursor()
    }

    @ViewBuilder func tableRow(tint: Bool = false, _ title: some View, _ value: some View) -> some View {
        let titleColumnWidth: CGFloat = 90
        let valueColumnWidth: CGFloat = 180
        HStack(spacing: 10) {
            HStack(spacing: 0) { title }.frame(width: titleColumnWidth, alignment: .trailing)
            HStack(spacing: 0) { value }.frame(width: valueColumnWidth, alignment: .leading)
        }
        .padding(6)
        .background(
            tint ?
            Color.white.opacity(0.5) :
            Color.clear
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            /* ########## */
            /* MARK: head */
            /* ########## */

            VStack(alignment: .leading, spacing: 0) {
                /* kind */
                self.tableRow(tint: true,
                    Text(NSLocalizedString("Kind", comment: "")),
                    {switch self.kind {
                        case .dirrectory: Text(NSLocalizedString("dirrectory", comment: ""))
                        case .file      : Text(NSLocalizedString("file"      , comment: ""))
                    }}()
                )
                /* name */
                self.tableRow(
                    Text(NSLocalizedString("Name", comment: "")),
                    Text("\(self.name)")
                )
                /* path */
                self.tableRow(tint: true,
                    Text(NSLocalizedString("Path", comment: "")),
                    Text("\(self.path)")
                )
                /* size */
                self.tableRow(
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Size", comment: ""))
                        self.iconRoll(value: self.$sizeMode)
                    },
                    Text("\(self.size.format(mode: self.sizeMode))")
                )
                /* created */
                self.tableRow(tint: true,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Created", comment: ""))
                        self.iconRoll(value: self.$createdMode)
                    },
                    {switch self.createdMode {
                        case .convenient   : Text(self.created.convenient)
                        case .iso8601withTZ: Text(self.created.ISO8601withTZ)
                        case .iso8601      : Text(self.created.ISO8601)
                    }}()
                )
                /* updated */
                self.tableRow(
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Updated", comment: ""))
                        self.iconRoll(value: self.$updatedMode)
                    },
                    {switch self.updatedMode {
                        case .convenient   : Text(self.updated.convenient)
                        case .iso8601withTZ: Text(self.updated.ISO8601withTZ)
                        case .iso8601      : Text(self.updated.ISO8601)
                    }}()
                )
            }

            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.head.rawValue))
            .font(.system(size: 12, weight: .regular))

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

                VStack(alignment: .trailing, spacing: 10) {

                    /* MARK: owner picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Owner", comment: ""))
                        PickerCustom<String>(
                            selected: self.$owner,
                            values: ThisApp.owners,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

                    /* MARK: group picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Group", comment: ""))
                        PickerCustom<String>(
                            selected: self.$group,
                            values: ThisApp.groups,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

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
                ButtonCustom(NSLocalizedString("cancel", comment: ""), flexibility: .size(100)) {
                    self.rights = self.originalRights
                    self.owner  = self.originalOwner
                    self.group  = self.originalGroup
                }
                .disabled(
                    self.rights == self.originalRights &&
                    self.owner  == self.originalOwner  &&
                    self.group  == self.originalGroup
                )

                /* MARK: apply button */
                ButtonCustom(NSLocalizedString("apply", comment: ""), flexibility: .size(100)) {
                    self.onApply(
                        self.rights,
                        self.owner,
                        self.group
                    )
                }

            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.foot.rawValue))

        }.frame(width: 300)
    }

}

#Preview {
    MainView(
        kind: .file,
        name: "Rwx Editor.icns",
        path: "/usr/local/bin/some/long/long/path",
        size: 1_234_567,
        created: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
        updated: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
        rights: 0o644,
        owner: "nobody",
        group: "staff",
        onApply: { rights, owner, group in
            print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
        }
    )
}
