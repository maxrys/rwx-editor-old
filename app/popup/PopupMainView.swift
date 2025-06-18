
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupMainView: View {

    @Environment(\.colorScheme) private var colorScheme

    enum ColorNames: String {
        case headTint = "color PopupMainView Head Tint"
        case head     = "color PopupMainView Head Background"
        case body     = "color PopupMainView Body Background"
        case foot     = "color PopupMainView Foot Background"
    }

    @State private var rights: UInt
    @State private var owner: String
    @State private var group: String

    @State private var sizeViewMode: BytesViewMode = .bytes
    @State private var createdViewMode: DateViewMode = .convenient
    @State private var updatedViewMode: DateViewMode = .convenient

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

    init(info: EntityInfo, onApply: @escaping (UInt, String, String) -> Void) {
        self.kind           = info.kind
        self.name           = info.name
        self.path           = info.path
        self.size           = info.size
        self.created        = info.created
        self.updated        = info.updated
        self.rights         = info.rights
        self.owner          = info.owner
        self.group          = info.group
        self.originalRights = info.rights
        self.originalOwner  = info.owner
        self.originalGroup  = info.group
        self.onApply        = onApply
    }

    @ViewBuilder func iconRoll<T: CaseIterable & Equatable>(value: Binding<T>) -> some View {
        Button {
            value.wrappedValue.roll()
        } label: {
            Image(systemName: "arcade.stick")
                .foregroundPolyfill(Color.accentColor)
                .font(.system(size: 10, weight: .regular))
        }
        .buttonStyle(.plain)
        .onHoverCursor()
    }

    @ViewBuilder func gridCellWrapper(alignment: Alignment = .leading, tint: Bool = false, _ value: some View) -> some View {
        let background = tint ? Color(Self.ColorNames.headTint.rawValue) : Color.clear
        HStack(spacing: 0) { value }
            .padding(.horizontal, 7)
            .padding(.vertical  , 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .background(background)
    }

    var body: some View {
        VStack(spacing: 0) {

            /* ########## */
            /* MARK: head */
            /* ########## */

            let columns = [
                GridItem(.fixed(100), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ]

            LazyVGrid(columns: columns, spacing: 0) {

                /* kind */
                self.gridCellWrapper(alignment: .trailing,
                    Text(NSLocalizedString("Kind", comment: ""))
                )
                self.gridCellWrapper(
                    {switch self.kind {
                        case .dirrectory: Text(NSLocalizedString("dirrectory", comment: ""))
                        case .file      : Text(NSLocalizedString("file"      , comment: ""))
                        case .unknown   : Text(NSLocalizedString("n/a"       , comment: ""))
                    }}()
                )

                /* name */
                self.gridCellWrapper(alignment: .trailing, tint: true,
                    Text(NSLocalizedString("Name", comment: ""))
                )
                self.gridCellWrapper(tint: true,
                    Text("\(self.name)").textSelectionPolyfill()
                )

                /* path */
                self.gridCellWrapper(alignment: .trailing,
                    Text(NSLocalizedString("Path", comment: ""))
                )
                self.gridCellWrapper(
                    Text("\(self.path)").textSelectionPolyfill()
                )

                /* size */
                self.gridCellWrapper(alignment: .trailing, tint: true,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Size", comment: ""))
                        self.iconRoll(value: self.$sizeViewMode)
                    }
                )
                self.gridCellWrapper(tint: true,
                    {switch self.sizeViewMode {
                        case  .bytes: return Text(ByteCountFormatter.format(self.size, unit: .useBytes))
                        case .kbytes: return Text(ByteCountFormatter.format(self.size, unit: .useKB))
                        case .mbytes: return Text(ByteCountFormatter.format(self.size, unit: .useMB))
                        case .gbytes: return Text(ByteCountFormatter.format(self.size, unit: .useGB))
                        case .tbytes: return Text(ByteCountFormatter.format(self.size, unit: .useTB))
                    }}().textSelectionPolyfill()
                )

                /* created */
                self.gridCellWrapper(alignment: .trailing,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Created", comment: ""))
                        self.iconRoll(value: self.$createdViewMode)
                    }
                )
                self.gridCellWrapper(
                    {switch self.createdViewMode {
                        case .convenient   : Text(self.created.convenient)
                        case .iso8601withTZ: Text(self.created.ISO8601withTZ)
                        case .iso8601      : Text(self.created.ISO8601)
                    }}().textSelectionPolyfill()
                )

                /* updated */
                self.gridCellWrapper(alignment: .trailing, tint: true,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Updated", comment: ""))
                        self.iconRoll(value: self.$updatedViewMode)
                    }
                )
                self.gridCellWrapper(tint: true,
                    {switch self.updatedViewMode {
                        case .convenient   : Text(self.updated.convenient)
                        case .iso8601withTZ: Text(self.updated.ISO8601withTZ)
                        case .iso8601      : Text(self.updated.ISO8601)
                    }}().textSelectionPolyfill()
                )

            }
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.head.rawValue))
            .font(.system(size: 12, weight: .regular))

            /* ########## */
            /* MARK: body */
            /* ########## */

            VStack(spacing: 20) {

                /* shadow */
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(.black).opacity(self.colorScheme == .light ? 0.1 : 0.4),
                                Color(.black).opacity(self.colorScheme == .light ? 0.0 : 0.0) ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    ).frame(height: 6)

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
                        if (self.kind == .file) { Text(NSLocalizedString("Execute", comment: "")).frame(width: textW, height: textH) }
                        if (self.kind != .file) { Text(NSLocalizedString("Access" , comment: "")).frame(width: textW, height: textH) }
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
                            values: PopupApp.owners,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

                    /* MARK: group picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Group", comment: ""))
                        PickerCustom<String>(
                            selected: self.$group,
                            values: PopupApp.groups,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

                }.padding(.top, 10)

                /* shadow */
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(.black).opacity(self.colorScheme == .light ? 0.0 : 0.0),
                                Color(.black).opacity(self.colorScheme == .light ? 0.1 : 0.4) ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 6)
                    .padding(.top, 6)

            }
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
                .disabled(self.kind == .unknown)

            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.foot.rawValue))

        }
        .foregroundPolyfill(Color.getCustom(.text))
    }

}

#Preview {
    PopupMainView(
        info: EntityInfo(
            kind: .file,
            name: "Rwx Editor.icns",
            path: "/usr/local/bin/some",
            size: 1_234_567,
            created: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
            updated: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
            rights: 0o644,
            owner: "nobody",
            group: "staff"
        ),
        onApply: { rights, owner, group in
            print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
        }
    ).frame(width: PopupApp.FRAME_WIDTH)
}
