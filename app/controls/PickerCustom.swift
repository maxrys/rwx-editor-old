
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PickerCustom: View {

    enum ColorNames: String {
        case text                   = "color PickerCustom Text"
        case background             = "color PickerCustom Background"
        case itemBackground         = "color PickerCustom Item Background"
        case itemSelectedBackground = "color PickerCustom Item Selected Background"
        case itemHoveredBackground  = "color PickerCustom Item Hovered Background"
    }

    @State private var isOpened: Bool = false
    @State private var hoverIndex: Int = -1

    private var selectedIndex: Binding<UInt>
    private var values: [String]
    private var isPlainListStyle: Bool

    init(selectedIndex: Binding<UInt>, values: [String], isPlainListStyle: Bool = false) {
        self.selectedIndex    = selectedIndex
        self.values           = values
        self.isPlainListStyle = isPlainListStyle
    }

    var body: some View {

        /* MARK: selected value */
        Button {
            self.isOpened = true
        } label: {
            Text(self.values[Int(self.selectedIndex.wrappedValue)])
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
            ForEach(self.values.indices, id: \.self) { index in
                Button {
                    self.selectedIndex.wrappedValue = UInt(index)
                    self.isOpened = false
                } label: {
                    var background: Color {
                        if (self.selectedIndex.wrappedValue == index) { return Color(Self.ColorNames.itemSelectedBackground.rawValue) }
                        if (self.hoverIndex                 == index) { return Color(Self.ColorNames.itemHoveredBackground .rawValue) }
                        return self.isPlainListStyle ? Color(.clear) : Color(Self.ColorNames.itemBackground.rawValue)
                    }
                    Text("\(self.values[index])")
                        .lineLimit(1)
                        .padding(.horizontal, 9)
                        .padding(.vertical  , 5)
                        .frame(maxWidth: .infinity, alignment: self.isPlainListStyle ? .leading : .center)
                        .color(Color(Self.ColorNames.text.rawValue))
                        .background(background)
                        .cornerRadius(10)
                        .onHover { isHovered in
                            self.hoverIndex = isHovered ? index : -1
                        }
                }.buttonStyle(.plain)
            }
        }.padding(10)
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selectedIndexV1: UInt = 0
    @Previewable @State var selectedIndexV2: UInt = 0

    let valuesV1: [String] = ["Single value"]

    VStack {
        PickerCustom(selectedIndex: $selectedIndexV1, values: valuesV1, isPlainListStyle: true).frame(maxWidth: 100)
        PickerCustom(selectedIndex: $selectedIndexV1, values: valuesV1                        ).frame(maxWidth: 100)
    }.padding(10)

    let valuesV2: [String] = {
        var result: [String] = []
        for i in 1 ... 100 {
            if (i == 5) { result.append("Value \(i) long long long long long long") }
            else        { result.append("Value \(i)") }
        }
        return result
    }()

    VStack {
        PickerCustom(selectedIndex: $selectedIndexV2, values: valuesV2, isPlainListStyle: true).frame(maxWidth: 100)
        PickerCustom(selectedIndex: $selectedIndexV2, values: valuesV2                        ).frame(maxWidth: 100)
    }.padding(10)
}
