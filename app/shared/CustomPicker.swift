
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct CustomPicker: View {

    private var selection: Binding<UInt>
    private var values: [UInt]

    @State var isOpened: Bool = false

    init(selection: Binding<UInt>, values: [UInt]) {
        self.selection = selection
        self.values    = values
    }

    var body: some View {
        ZStack {

            /* MARK: value list */
            if (self.isOpened) {
                VStack(spacing: 2) {
                    ForEach(0 ... 7, id: \.self) { value in
                        Button {
                            self.selection.wrappedValue = UInt(value)
                            self.isOpened = false
                        } label: {
                            Text("\(value)")
                        }
                        .buttonStyle(.plain)
                        .onHover { isInView in
                            if (isInView) { NSCursor.pointingHand.push() }
                            else          { NSCursor.pop() }
                        }
                    }
                }
                .padding(5)
                .background(Color(.gray))
                .color(Color(.white))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.5), radius: 2.0)
                .frame(width: 20)
                .offset(y: -90)
            }

            /* MARK: selected value */
            Button {
                self.isOpened.toggle()
            } label: {
                Text("\(self.selection.wrappedValue)")
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
        let values: [UInt] = [0, 1, 2, 3, 4, 5, 6, 7]
        CustomPicker(
            selection: $selection,
            values: values
        )
    }
    .padding(20)
    .frame(maxHeight: 400)
}
