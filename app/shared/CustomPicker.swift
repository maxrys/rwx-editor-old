
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
        ZStack {

            /* MARK: value list */
            if (self.isOpened) {
                VStack(spacing: 2) {
                    ForEach(self.values.indices, id: \.self) { index in
                        Button {
                            self.selection.wrappedValue = UInt(index)
                            self.isOpened = false
                        } label: {
                            Text("\(self.values[index])")
                        }
                        .buttonStyle(.plain)
                        .onHover { isInView in
                            if (isInView) { NSCursor.pointingHand.push() }
                            else          { NSCursor.pop() }
                        }
                    }
                }
                .padding(5)
                .background(Color(.white))
                .color(Color(.black))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.5), radius: 2.0)
                .frame(width: 20)
                .offset(y: -100)
            }

            /* MARK: selected value */
            Button {
                self.isOpened.toggle()
            } label: {
                Text(self.values[Int(self.selection.wrappedValue)])
                    .padding(5)
                    .background(Color(.white))
                    .color(Color(.black))
                    .cornerRadius(5)
            }
            .buttonStyle(.plain)
            .onHover { isInView in
                if (isInView) { NSCursor.pointingHand.push() }
                else          { NSCursor.pop() }
            }

        }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selection: UInt = 0
    HStack {
        CustomPicker(
            selection: $selection,
            values: [
                "value 1",
                "value 2",
                "value 3",
                "value 4",
                "value 5",
            ]
        )
    }
    .padding(20)
    .frame(maxHeight: 400)
}
