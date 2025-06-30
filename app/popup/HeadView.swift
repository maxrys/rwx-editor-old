
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct HeadView: View {

    enum ColorNames: String {
        case head = "color PopupView Head Background"
    }

    static let NA_SIGN = "—"

    @State private var visibilityModeForSize: BytesVisibilityMode
    @State private var visibilityModeForCreated: DateVisibilityMode
    @State private var visibilityModeForUpdated: DateVisibilityMode
    @State private var info: FSEntityInfo

    init(_ info: FSEntityInfo) {
        self.visibilityModeForSize = .bytes
        self.visibilityModeForCreated = .convenient
        self.visibilityModeForUpdated = .convenient
        self.info = info
    }

    var formattedType: String {
        switch self.info.type {
            case .directory: NSLocalizedString("directory" , comment: "")
            case .file     : NSLocalizedString("file"      , comment: "")
            case .alias    : NSLocalizedString("alias"     , comment: "")
            case .link     : NSLocalizedString("link"      , comment: "")
            case .unknown  : NSLocalizedString(Self.NA_SIGN, comment: "")
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

    var formattedRealName: String {
        if let realName = self.info.realName
             { realName }
        else { NSLocalizedString(Self.NA_SIGN, comment: "") }
    }

    var formattedRealPath: String {
        if let realPath = self.info.realPath
             { realPath }
        else { NSLocalizedString(Self.NA_SIGN, comment: "") }
    }

    var formattedSize: String {
        if let size = self.info.size {
            switch self.visibilityModeForSize {
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
            switch self.visibilityModeForCreated {
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
            switch self.visibilityModeForUpdated {
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

    var body: some View {
        GridCustom([

            /* MARK: field: type */
            GridCustom.Row(
                title: Text(NSLocalizedString("Type", comment: "")),
                value: Text(self.formattedType)
            ),

            /* MARK: field: name */
            GridCustom.Row(
                title: Text(NSLocalizedString("Name", comment: "")),
                value: Text(self.formattedName).textSelectionPolyfill()
            ),

            /* MARK: field: path */
            GridCustom.Row(
                title: Text(NSLocalizedString("Path", comment: "")),
                value: Text(self.formattedPath).textSelectionPolyfill()
            ),

            /* MARK: field: real name */
            self.info.realName != nil ?
                GridCustom.Row(
                    title: Text(NSLocalizedString("Real Name", comment: "")),
                    value: Text(self.formattedRealName).textSelectionPolyfill()
                ) : nil,

            /* MARK: field: real path */
            self.info.realPath != nil ?
                GridCustom.Row(
                    title: Text(NSLocalizedString("Real Path", comment: "")),
                    value: Text(self.formattedRealPath).textSelectionPolyfill()
                ) : nil,

            /* MARK: field: references */
            GridCustom.Row(
                title: Text(NSLocalizedString("References", comment: "")),
                value: Text(self.formattedReferences)
            ),

            /* MARK: field: size */
            GridCustom.Row(
                title: HStack(spacing: 5) {
                    Text(NSLocalizedString("Size", comment: ""))
                    if (self.info.size != nil) {
                        self.iconRoll(
                            value: self.$visibilityModeForSize
                        )
                    }
                },
                value: Text(self.formattedSize).textSelectionPolyfill()
            ),

            /* MARK: field: created */
            GridCustom.Row(
                title: HStack(spacing: 5) {
                    Text(NSLocalizedString("Created", comment: ""))
                    if (self.info.created != nil) {
                        self.iconRoll(
                            value: self.$visibilityModeForCreated
                        )
                    }
                },
                value: Text(self.formattedCreated).textSelectionPolyfill()
            ),

            /* MARK: field: updated */
            GridCustom.Row(
                title: HStack(spacing: 5) {
                    Text(NSLocalizedString("Updated", comment: ""))
                    if (self.info.updated != nil) {
                        self.iconRoll(
                            value: self.$visibilityModeForUpdated
                        )
                    }
                },
                value: Text(self.formattedUpdated).textSelectionPolyfill()
            )

        ])
        .frame(maxWidth: .infinity)
        .background(Color(Self.ColorNames.head.rawValue))
        .font(.system(size: 12, weight: .regular))
    }

}

#Preview {
    VStack(spacing: 10) {
        HeadView(FSEntityInfo("/private/etc/"))
        HeadView(FSEntityInfo("/private/etc/hosts"))
    }
    .padding(10)
    .background(Color.black)
    .frame(width: 300)
}
