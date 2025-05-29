
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct CustomPicker: View {

    enum MainColor: String {
        case text                      = "color CustomPicker Text"
        case background                = "color CustomPicker Background"
        case item___SelectedBackground = "color CustomPicker Item Selected Background"
        case itemNotSelectedBackground = "color CustomPicker Item Not Selected Background"
    }

    @State private var isOpened: Bool = false
    @State private var hoverIndex: Int = -1

    private var selectedIndex: Binding<UInt>
    private var values: [String]

    init(selectedIndex: Binding<UInt>, values: [String]) {
        self.selectedIndex = selectedIndex
        self.values        = values
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
                .background(Color(Self.MainColor.background.rawValue))
                .color(Color(Self.MainColor.text.rawValue))
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .onHoverCursor()

        /* MARK: value list */
        .popover(isPresented: self.$isOpened) {
            ScrollView(.vertical) {
                VStack(spacing: 6) {
                    ForEach(self.values.indices, id: \.self) { index in
                        Button {
                            self.selectedIndex.wrappedValue = UInt(index)
                            self.isOpened = false
                        } label: {
                            Text("\(self.values[index])")
                                .lineLimit(1)
                                .padding(.horizontal, 9)
                                .padding(.vertical  , 5)
                                .frame(maxWidth: .infinity)
                                .color(Color(Self.MainColor.text.rawValue))
                                .background(
                                    self.hoverIndex == index || self.selectedIndex.wrappedValue == index ?
                                    Color(Self.MainColor.item___SelectedBackground.rawValue) :
                                    Color(Self.MainColor.itemNotSelectedBackground.rawValue)
                                )
                                .cornerRadius(10)
                                .onHover { isHovered in
                                    self.hoverIndex = isHovered ? index : -1
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }.padding(10)
            }.frame(maxHeight: 300)
        }

    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selectedIndex: UInt = 0
    let values: [String] = {
        var result: [String] = []
        for i in 1 ... 100 {
            if (i == 5) { result.append("Value \(i) long long long long long long") }
            else        { result.append("Value \(i)") }
        }
        return result
    }()
    HStack {
        CustomPicker(
            selectedIndex: $selectedIndex,
            values: values
        ).frame(maxWidth: 100)
    }
    .frame(width: 200, height: 200)
}
