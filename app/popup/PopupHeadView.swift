
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



    var body: some View {

        var gridRows: [GridRow] {
            var result: [GridRow] = []



            
            return result
        }



        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(gridRows.indices, id: \.self) { index in
                let background = index % 2 == 0 ?
                    Color(Self.ColorNames.gridTint.rawValue) :
                    Color.clear
                HStack(spacing: 0) { gridRows[index].title }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .background(background)
                HStack(spacing: 0) { gridRows[index].value }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(background)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(Self.ColorNames.head.rawValue))
        .font(.system(size: 12, weight: .regular))
    }

}

