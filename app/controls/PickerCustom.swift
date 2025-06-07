
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
    @State private var hovered: Key?
           private var selected: Binding<Key>

    private let values: [Key: String]
    private let isPlainListStyle: Bool
    private let flexibility: Flexibility

    init(selected: Binding<Key>, values: [Key: String], isPlainListStyle: Bool = false, flexibility: Flexibility = .none) {
        self.selected         = selected
        self.values           = values
        self.isPlainListStyle = isPlainListStyle
        self.flexibility      = flexibility
    }

    var body: some View {

        /* MARK: selected value */
        Button {
            self.isOpened = true
        } label: {
            let textView = Text(self.values[self.selected.wrappedValue] ?? "n/a")
                .lineLimit(1)
                .padding(.horizontal, 9)
                .padding(.vertical  , 5)
            switch self.flexibility {
                case .size(let size): textView.frame(width: size)        .background(Color(Self.ColorNames.background.rawValue)).color(Color(Self.ColorNames.text.rawValue)).cornerRadius(10)
                case .infinity      : textView.frame(maxWidth: .infinity).background(Color(Self.ColorNames.background.rawValue)).color(Color(Self.ColorNames.text.rawValue)).cornerRadius(10)
                case .none          : textView                           .background(Color(Self.ColorNames.background.rawValue)).color(Color(Self.ColorNames.text.rawValue)).cornerRadius(10)
            }
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
                    self.selected.wrappedValue = key
                    self.isOpened = false
                } label: {
                    var background: Color {
                        if (self.selected.wrappedValue == key) { return Color(Self.ColorNames.itemSelectedBackground.rawValue) }
                        if (self.hovered               == key) { return Color(Self.ColorNames.itemHoveredBackground .rawValue) }
                        return self.isPlainListStyle ?
                            Color.clear :
                            Color(Self.ColorNames.itemBackground.rawValue
                        )
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
                            self.hovered = isHovered ? key : nil
                        }
                }.buttonStyle(.plain)
            }
        }.padding(10)
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selectedV1: UInt = 0
    @Previewable @State var selectedV2: UInt = 0
    @Previewable @State var selectedV3: UInt = 0

    VStack {

        /* n/a */

        let valuesV1: [UInt: String] = [:]

        VStack {
            PickerCustom<UInt>(selected: $selectedV1, values: valuesV1, isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedV1, values: valuesV1)
        }.padding(10)

        /* single value */

        let valuesV2: [UInt: String] = [
            0: "Single value"
        ]

        VStack {
            PickerCustom<UInt>(selected: $selectedV2, values: valuesV2, isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedV2, values: valuesV2)
        }.padding(10)

        /* multiple values */

        let valuesV3 = {
            var result: [UInt: String] = [:]
            for i in 0 ..< 100 {
                if (i == 5) { result[UInt(i)] = "Value \(i) long long long long long long" }
                else        { result[UInt(i)] = "Value \(i)" }
            }
            return result
        }()

        VStack {
            PickerCustom<UInt>(selected: $selectedV3, values: valuesV3, isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedV3, values: valuesV3)
        }.padding(10)

    }.frame(width: 200)
}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selected: UInt = 0

    VStack {

        let values = {
            var result: [UInt: String] = [:]
            for i in 0 ..< 10 {
                if (i == 5) { result[UInt(i)] = "Value \(i) long long long long long long" }
                else        { result[UInt(i)] = "Value \(i)" }
            }
            return result
        }()

        VStack {
            PickerCustom<UInt>(selected: $selected, values: values)
            PickerCustom<UInt>(selected: $selected, values: values, flexibility: .none)
            PickerCustom<UInt>(selected: $selected, values: values, flexibility: .size(100))
            PickerCustom<UInt>(selected: $selected, values: values, flexibility: .infinity)
        }.padding(10)

    }.frame(width: 200)
}
