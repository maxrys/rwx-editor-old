
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PickerCustom<Key>: View where Key: Hashable & Comparable {

    enum ColorNames: String {
        case text                   = "color PickerCustom Text"
        case background             = "color PickerCustom Background"
        case itemBackground         = "color PickerCustom Item Background"
        case itemSelectedBackground = "color PickerCustom Item Selected Background"
        case itemHoveredBackground  = "color PickerCustom Item Hovered Background"
    }

    @State private var isOpened: Bool = false
    @State private var hoverIndex: Key?

    private var selectedIndex: Binding<Key>
    private var values: [Key: String]
    private var isPlainListStyle: Bool

    init(selectedIndex: Binding<Key>, values: [Key: String], isPlainListStyle: Bool = false) {
        self.selectedIndex    = selectedIndex
        self.values           = values
        self.isPlainListStyle = isPlainListStyle
    }

    var body: some View {

        /* MARK: selected value */
        Button {
            self.isOpened = true
        } label: {
            Text(self.values[self.selectedIndex.wrappedValue] ?? "n/a")
                .lineLimit(1)
                .padding(.horizontal, 9)
                .padding(.vertical  , 5)
                .background(Color(Self.ColorNames.background.rawValue))
                .color(Color(Self.ColorNames.text.rawValue))
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .onHoverCursor()

        /* MARK: value list */
        .popover(isPresented: self.$isOpened) {
            if (self.values.count <= 10) { self.list }
            else { ScrollView(.vertical) { self.list }.frame(maxHeight: 370) }
        }

    }

    @ViewBuilder var list: some View {
        VStack (alignment: .leading, spacing: 6) {
            ForEach(self.values.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Button {
                    self.selectedIndex.wrappedValue = key
                    self.isOpened = false
                } label: {
                    var background: Color {
                        if (self.selectedIndex.wrappedValue == key) { return Color(Self.ColorNames.itemSelectedBackground.rawValue) }
                        if (self.hoverIndex                 == key) { return Color(Self.ColorNames.itemHoveredBackground .rawValue) }
                        return self.isPlainListStyle ? Color(.clear) : Color(Self.ColorNames.itemBackground.rawValue)
                    }
                    Text("\(value)")
                        .lineLimit(1)
                        .padding(.horizontal, 9)
                        .padding(.vertical  , 5)
                        .frame(maxWidth: .infinity, alignment: self.isPlainListStyle ? .leading : .center)
                        .color(Color(Self.ColorNames.text.rawValue))
                        .background(background)
                        .cornerRadius(10)
                        .onHover { isHovered in
                            self.hoverIndex = isHovered ? key : nil
                        }
                }.buttonStyle(.plain)
            }
        }.padding(10)
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selectedIndexV1: UInt = 0
    @Previewable @State var selectedIndexV2: UInt = 0

    let valuesV1: [UInt: String] = [
        0: "Single value"
    ]

    VStack {
        PickerCustom<UInt>(selectedIndex: $selectedIndexV1, values: valuesV1, isPlainListStyle: true).frame(maxWidth: 100)
        PickerCustom<UInt>(selectedIndex: $selectedIndexV1, values: valuesV1                        ).frame(maxWidth: 100)
    }.padding(10)

    let valuesV2 = {
        var result: [UInt: String] = [:]
        for i in 0 ..< 100 {
            if (i == 5) { result[UInt(i)] = "Value \(i) long long long long long long" }
            else        { result[UInt(i)] = "Value \(i)" }
        }
        return result
    }()

    VStack {
        PickerCustom<UInt>(selectedIndex: $selectedIndexV2, values: valuesV2, isPlainListStyle: true).frame(maxWidth: 100)
        PickerCustom<UInt>(selectedIndex: $selectedIndexV2, values: valuesV2                        ).frame(maxWidth: 100)
    }.padding(10)
}
