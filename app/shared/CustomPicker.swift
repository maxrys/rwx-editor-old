
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct CustomPicker: View {

    @State private var isOpened: Bool = false
    @State private var hovers: [UInt: Bool] = [:]

    private var selection: Binding<UInt>
    private var values: [String]

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
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(self.values.indices, id: \.self) { index in
                        Button {
                            self.selection.wrappedValue = UInt(index)
                            self.isOpened = false
                        } label: {
                            Text("\(self.values[index])")
                                .lineLimit(1)
                                .padding(5)
                                .frame(maxWidth: .infinity)
                                .background(Color(self.hovers[UInt(index)] == true ? .gray : .clear))
                                .cornerRadius(10)
                                .onHover { isHovered in
                                    self.hovers[UInt(index)] = isHovered
                                }
                        }
                        .buttonStyle(.plain)
                        .onHoverCursor()
                    }
                }
                .padding(10)
                .background(Color(.white))
                .color(Color(.black))
            }.frame(maxHeight: 300)
        }

    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var selection: UInt = 0
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
            selection: $selection,
            values: values
        ).frame(maxWidth: 100)
    }
    .frame(width: 200, height: 200)
}
