
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupView: View {

    enum ColorNames: String {
        case headTint = "color PopupView Head Tint"
        case head     = "color PopupView Head Background"
        case body     = "color PopupView Body Background"
        case foot     = "color PopupView Foot Background"
    }

    static let NA_SIGN = "—"
    static let FRAME_WIDTH: CGFloat = 300

    static var owners: [String: String] = {
        var result: [String: String] = [:]
        for value in MainApp.owners {
            result[value] = value }
        return result
    }()

    static var groups: [String: String] = {
        var result: [String: String] = [:]
        for value in MainApp.groups {
            result[value] = value
        }
        return result
    }()

    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme

    @State private var sizeViewMode: BytesViewMode = .bytes
    @State private var createdViewMode: DateViewMode = .convenient
    @State private var updatedViewMode: DateViewMode = .convenient
    @State private var rights: UInt = 0
    @State private var owner: String = ""
    @State private var group: String = ""

    private let windowId: WindowInfo.ID
    private let info: FSEntityInfo

    init(windowId: WindowInfo.ID) {
        let fsEntityInfo = FSEntityInfo(windowId)
        self.windowId = windowId
        self.rights   = fsEntityInfo.rights
        self.owner    = fsEntityInfo.owner
        self.group    = fsEntityInfo.group
        self.info     = fsEntityInfo
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

    var formattedType: String {
        switch self.info.type {
            case .dirrectory: NSLocalizedString("dirrectory", comment: "")
            case .file      : NSLocalizedString("file"      , comment: "")
            case .unknown   : NSLocalizedString(Self.NA_SIGN, comment: "")
        }
    }

    var formattedName: String {
        if let name = self.info.name
             { name }
        else { NSLocalizedString(Self.NA_SIGN, comment: "") }
    }

    var formattedPath: String {
        if let path = self.info.path
             { path }
        else { NSLocalizedString(Self.NA_SIGN, comment: "") }
    }

    var formattedSize: String {
        if let size = self.info.size {
            switch self.sizeViewMode {
                case  .bytes: ByteCountFormatter.format(size, unit: .useBytes)
                case .kbytes: ByteCountFormatter.format(size, unit: .useKB)
                case .mbytes: ByteCountFormatter.format(size, unit: .useMB)
                case .gbytes: ByteCountFormatter.format(size, unit: .useGB)
                case .tbytes: ByteCountFormatter.format(size, unit: .useTB)
            }
        } else {
            NSLocalizedString(
                Self.NA_SIGN, comment: ""
            )
        }
    }

    var formattedCreated: String {
        if let created = self.info.created {
            switch self.createdViewMode {
                case .convenient   : created.convenient
                case .iso8601withTZ: created.ISO8601withTZ
                case .iso8601      : created.ISO8601
            }
        } else {
            NSLocalizedString(
                Self.NA_SIGN, comment: ""
            )
        }
    }

    var formattedUpdated: String {
        if let updated = self.info.updated {
            switch self.updatedViewMode {
                case .convenient   : updated.convenient
                case .iso8601withTZ: updated.ISO8601withTZ
                case .iso8601      : updated.ISO8601
            }
        } else {
            NSLocalizedString(
                Self.NA_SIGN, comment: ""
            )
        }
    }

    var formattedReferences: String {
        if let references = self.info.references {
            String(format: NSLocalizedString("%@ pcs.", comment: ""), String(references))
        } else {
            NSLocalizedString(
                Self.NA_SIGN, comment: ""
            )
        }
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

                /* MARK: type */

                self.gridCellWrapper(alignment: .trailing, tint: true,
                    Text(NSLocalizedString("Type", comment: ""))
                )
                self.gridCellWrapper(tint: true,
                    Text(self.formattedType)
                )

                /* MARK: name */

                self.gridCellWrapper(alignment: .trailing,
                    Text(NSLocalizedString("Name", comment: ""))
                )
                self.gridCellWrapper(
                    Text(self.formattedName)
                        .textSelection(.enabled)
                )

                /* MARK: path */

                self.gridCellWrapper(alignment: .trailing, tint: true,
                    Text(NSLocalizedString("Path", comment: ""))
                )
                self.gridCellWrapper(tint: true,
                    Text(self.formattedPath)
                        .textSelection(.enabled)
                )

                /* MARK: references */

                self.gridCellWrapper(alignment: .trailing,
                    Text(NSLocalizedString("References", comment: ""))
                )
                self.gridCellWrapper(
                    Text(self.formattedReferences)
                )

                /* MARK: size */

                self.gridCellWrapper(alignment: .trailing, tint: true,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Size", comment: ""))
                        if (self.info.size != nil) {
                            self.iconRoll(
                                value: self.$sizeViewMode
                            )
                        }
                    }
                )
                self.gridCellWrapper(tint: true,
                    Text(self.formattedSize)
                        .textSelection(.enabled)
                )

                /* MARK: created */

                self.gridCellWrapper(alignment: .trailing,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Created", comment: ""))
                        if (self.info.created != nil) {
                            self.iconRoll(
                                value: self.$createdViewMode
                            )
                        }
                    }
                )
                self.gridCellWrapper(
                    Text(self.formattedCreated)
                        .textSelection(.enabled)
                )

                /* MARK: updated */

                self.gridCellWrapper(alignment: .trailing, tint: true,
                    HStack(spacing: 5) {
                        Text(NSLocalizedString("Updated", comment: ""))
                    if (self.info.updated != nil) {
                            self.iconRoll(
                                value: self.$updatedViewMode
                            )
                        }
                    }
                )
                self.gridCellWrapper(tint: true,
                    Text(self.formattedUpdated)
                        .textSelection(.enabled)
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
                        Color.clear.frame(width: textW, height: textH)
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
                        let text = self.info.type == .file ? "Execute" : "Access"
                        Text(NSLocalizedString(text, comment: "")).frame(width: textW, height: textH)
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.x.offset);
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.x.offset);
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.x.offset);
                    }

                }

                /* MARK: rules via text/numeric */
                HStack(spacing: 20) {
                    RwxTextView(self.$rights)
                    ToggleRwxNumeric(self.$rights)
                }

                VStack(alignment: .trailing, spacing: 10) {

                    /* MARK: owner picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Owner", comment: ""))
                        PickerCustom<String>(
                            selected: self.$owner,
                            values: PopupView.owners,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

                    /* MARK: group picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Group", comment: ""))
                        PickerCustom<String>(
                            selected: self.$group,
                            values: PopupView.groups,
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
                    self.rights = self.info.rights
                    self.owner  = self.info.owner
                    self.group  = self.info.group
                }
                .disabled(
                    self.rights == self.info.rights &&
                    self.owner  == self.info.owner  &&
                    self.group  == self.info.group
                )

                /* MARK: apply button */
                ButtonCustom(NSLocalizedString("apply", comment: ""), flexibility: .size(100)) {
                    self.onApply(
                        rights: self.rights,
                        owner : self.owner,
                        group : self.group
                    )
                }
                .disabled(self.info.type == .unknown)

            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.foot.rawValue))

            #if DEBUG
                HStack {
                    let debugInfo: [String] = [
                        String(format: "%@: %@", "state rights", String(self.rights)),
                        String(format: "%@: %@", "state owner" , self.owner.isEmpty ? Self.NA_SIGN : self.owner),
                        String(format: "%@: %@", "state group" , self.group.isEmpty ? Self.NA_SIGN : self.group),
                        String(format: "%@: %@", "rights"      , String(self.info.rights)),
                        String(format: "%@: %@", "owner"       , self.info.owner.isEmpty ? Self.NA_SIGN : self.info.owner),
                        String(format: "%@: %@", "group"       , self.info.group.isEmpty ? Self.NA_SIGN : self.info.group),
                        String(format: "%@: %@", "url"         , String(self.info.incommingUrl)),
                        String(format: "%@: %@", "winId"       , String(self.windowId))
                    ]
                    Text("Debug: \(debugInfo.joined(separator: " | "))")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundPolyfill(Color(.white))
                .background(Color.gray)
            #endif

        }
        .foregroundPolyfill(Color.getCustom(.text))
        .environment(\.layoutDirection, .leftToRight)
        .frame(width: Self.FRAME_WIDTH)
//      .onChange(of: scenePhase) { phase in
//          if (phase == .background) {
//              NSApplication.shared.terminate(nil)
//          }
//      }
    }

    func onApply(rights: UInt, owner: String, group: String) {
        print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
    }

}

#Preview {
    VStack(spacing: 10) {
        PopupView(windowId: "/private/etc/")
        PopupView(windowId: "/private/etc/hosts")
    }
    .padding(10)
    .background(.black)
}
