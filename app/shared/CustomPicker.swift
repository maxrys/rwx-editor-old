
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct CustomPicker: View {

    private var selection: Binding<UInt>
    private var values: [String]

    @State var isOpened: Bool = false

    init(selection: Binding<UInt>, values: [String]) {
        self.selection = selection
        self.values    = values
    }

    var body: some View {

        /* MARK: selected value */
        Button {
            self.isOpened = true
        } label: {
            Text(self.values[Int(self.selection.wrappedValue)])
                .lineLimit(1)
                .padding(.horizontal, 9)
                .padding(.vertical  , 5)
                .background(Color(.white))
                .color(Color(.black))
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .onHoverCursor()

        /* MARK: value list */
        .popover(isPresented: self.$isOpened) {
            VStack(spacing: 2) {
                ForEach(self.values.indices, id: \.self) { index in
                    Button {
                        self.selection.wrappedValue = UInt(index)
                        self.isOpened = false
                    } label: {
                        Text("\(self.values[index])")
                            .lineLimit(1)
                    }
                    .buttonStyle(.plain)
                    .onHover { _ in
                        print("\(index)")
                    }
                }
            }
            .padding(10)
            .background(Color(.white))
            .color(Color(.black))
        }

    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selection: UInt = 0
    HStack {
        CustomPicker(
            selection: $selection,
            values: [
                "Value 1",
                "Value 2",
                "Value 3",
                "Value 4",
                "Value 5 (long)",
            ]
        )
    }
    .padding(100)
    .frame(maxHeight: 400)
}
