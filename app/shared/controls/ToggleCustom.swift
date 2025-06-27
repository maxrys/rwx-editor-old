
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

struct ToggleCustom: View {

    var width: CGFloat = 50
    var height: CGFloat = 22
    var innerPadding: CGFloat = 3

    private var text: String
    private var isOn: Binding<Bool>
    private var isFlexible: Bool

    init(text: String = "", isOn: Binding<Bool>, isFlexible: Bool = false) {
        self.text = text
        self.isOn = isOn
        self.isFlexible = isFlexible
    }

    var body: some View {
        if (self.isFlexible) {
            HStack {
                Text(self.text)
                    .font(.system(size: 14))
                Spacer()
                self.switcher
            }.frame(maxWidth: .infinity)
        } else {
            HStack {
                Text(self.text)
                    .font(.system(size: 14))
                self.switcher
            }
        }
    }

    @ViewBuilder var switcher: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.isOn.wrappedValue.toggle()
            }
        } label: {
            ZStack(alignment: self.isOn.wrappedValue ? .trailing : .leading) {
                Capsule()
                    .fill(self.isOn.wrappedValue ? .green : .black.opacity(0.3))
                    .frame(width: self.width, height: self.height)
                Capsule()
                    .fill(.white)
                    .frame(width: (self.height * 1.5) - (self.innerPadding * 2), height: self.height - (self.innerPadding * 2))
                    .padding(self.innerPadding)
                    .shadow(
                        color: .black.opacity(0.5),
                        radius: 2.0
                    )
            }.contentShapePolyfill(Capsule())
        }.buttonStyle(.plain)
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var isOn: Bool = false
    HStack {
        ToggleCustom(
            text: "Test",
            isOn: $isOn
        ).frame(width: 100, height: 50)
    }
    .padding(20)
}
