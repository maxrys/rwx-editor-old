
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct GridCustom: View {

    enum ColorNames: String {
        case headTint = "color GridCustom Tint"
    }

    struct Row {
        var title: AnyView
        var value: AnyView
        init(title: some View, value: some View) {
            self.title = AnyView(title)
            self.value = AnyView(value)
        }
    }

    var data: [Row] = []

    init(_ data: [Row?] = []) {
        data.forEach { row in
            if let row {
                self.data.append(row)
            }
        }
    }

    var body: some View {

        let columns = [
            GridItem(.fixed(100), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]

        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(self.data.indices, id: \.self) { index in
                let background = index % 2 == 0 ?
                    Color(Self.ColorNames.headTint.rawValue) :
                    Color.clear
                HStack(spacing: 0) { self.data[index].title }
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, 7)
                    .padding(.vertical  , 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .background(background)
                HStack(spacing: 0) { self.data[index].value }
                    .padding(.horizontal, 7)
                    .padding(.vertical  , 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(background)
            }
        }

    }

}
