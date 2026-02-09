
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

