
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupHeadView: View {

    enum ColorNames: String {
        case head     = "color PopupView Head Background"
        case gridTint = "color PopupView Head Grid Tint"
    }

    struct GridRow {
        var title: AnyView
        var value: AnyView
        init(title: some View, value: some View) {
            self.title = AnyView(title)
            self.value = AnyView(value)
        }
    }

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
            case .directory: NSLocalizedString("directory", comment: "")
            case .file     : NSLocalizedString("file"     , comment: "")
            case .alias    : NSLocalizedString("alias"    , comment: "")
            case .link     : NSLocalizedString("link"     , comment: "")
            case .unknown  : NSLocalizedString(NA_SIGN    , comment: "")
        }
    }

    var formattedName: String {
        if let name = self.info.name
             { name }
        else { NSLocalizedString(NA_SIGN, comment: "") }
    }

    var formattedPath: String {
        if let path = self.info.path
             { path }
        else { NSLocalizedString(NA_SIGN, comment: "") }
    }

    var formattedRealName: String {
        if let realName = self.info.realName
             { realName }
        else { NSLocalizedString(NA_SIGN, comment: "") }
    }

    var formattedRealPath: String {
        if let realPath = self.info.realPath
             { realPath }
        else { NSLocalizedString(NA_SIGN, comment: "") }
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
                NA_SIGN, comment: ""
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
                NA_SIGN, comment: ""
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
                NA_SIGN, comment: ""
            )
        }
    }

    var formattedReferences: String {
        if let references = self.info.references {
            String(format: NSLocalizedString("%@ pcs.", comment: ""), String(references))
        } else {
            NSLocalizedString(
                NA_SIGN, comment: ""
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
        .pointerStyleLinkPolyfill()
    }

    var body: some View {

        var gridRows: [GridRow] {
            var result: [GridRow] = []

            /* MARK: field: type */
            result.append(GridRow(
                title: Text(NSLocalizedString("Type", comment: "")),
                value: Text(self.formattedType)
            ))

            /* MARK: field: name */
            result.append(GridRow(
                title: Text(NSLocalizedString("Name", comment: "")),
                value: Text(self.formattedName).textSelectionPolyfill()
            ))

            /* MARK: field: path */
            result.append(GridRow(
                title: Text(NSLocalizedString("Path", comment: "")),
                value: Text(self.formattedPath).textSelectionPolyfill()
            ))

            /* MARK: field: real name */
            if (self.info.realName != nil) {
                result.append(GridRow(
                    title: Text(NSLocalizedString("Real Name", comment: "")),
                    value: Text(self.formattedRealName).textSelectionPolyfill()
                ))
            }

            /* MARK: field: real path */
            if (self.info.realPath != nil) {
                result.append(GridRow(
                    title: Text(NSLocalizedString("Real Path", comment: "")),
                    value: Text(self.formattedRealPath).textSelectionPolyfill()
                ))
            }

            /* MARK: field: references */
            result.append(GridRow(
                title: Text(NSLocalizedString("References", comment: "")),
                value: Text(self.formattedReferences)
            ))

            /* MARK: field: size */
            result.append(GridRow(
                title: HStack(spacing: 5) {
                    Text(NSLocalizedString("Size", comment: ""))
                    if (self.info.size != nil) {
                        self.iconRoll(
                            value: self.$visibilityModeForSize
                        )
                    }
                },
                value: Text(self.formattedSize).textSelectionPolyfill()
            ))

            /* MARK: field: created */
            result.append(GridRow(
                title: HStack(spacing: 5) {
                    Text(NSLocalizedString("Created", comment: ""))
                    if (self.info.created != nil) {
                        self.iconRoll(
                            value: self.$visibilityModeForCreated
                        )
                    }
                },
                value: Text(self.formattedCreated).textSelectionPolyfill()
            ))

            /* MARK: field: updated */
            result.append(GridRow(
                title: HStack(spacing: 5) {
                    Text(NSLocalizedString("Updated", comment: ""))
                    if (self.info.updated != nil) {
                        self.iconRoll(
                            value: self.$visibilityModeForUpdated
                        )
                    }
                },
                value: Text(self.formattedUpdated).textSelectionPolyfill()
            ))

            return result
        }

        let columns = [
            GridItem(.fixed(100), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]

        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(gridRows.indices, id: \.self) { index in
                let background = index % 2 == 0 ?
                    Color(Self.ColorNames.gridTint.rawValue) :
                    Color.clear
                HStack(spacing: 0) { gridRows[index].title }
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, 7)
                    .padding(.vertical  , 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .background(background)
                HStack(spacing: 0) { gridRows[index].value }
                    .padding(.horizontal, 7)
                    .padding(.vertical  , 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(background)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(Self.ColorNames.head.rawValue))
        .font(.system(size: 12, weight: .regular))
    }

}

#Preview {
    VStack(spacing: 10) {
        PopupHeadView(FSEntityInfo("/private/etc/"))
        PopupHeadView(FSEntityInfo("/private/etc/hosts"))
    }
    .padding(10)
    .background(Color.black)
    .frame(width: 300)
}
