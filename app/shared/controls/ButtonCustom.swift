
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

struct ButtonCustom: View {

    enum ColorNames: String {
        case text       = "color ButtonCustom Text"
        case background = "color ButtonCustom Background"
    }

    @Environment(\.colorScheme) private var colorScheme

    private let text: String
    private let textColor: Color
    private let backgroundColor: Color
    private let flexibility: Flexibility
    private let onClick: () -> Void

    init(_ text: String = "button", textColor: Color = Color.white, backgroundColor: Color = Color.accentColor, flexibility: Flexibility = .none, onClick: @escaping () -> Void = { }) {
        self.text            = text
        self.textColor       = textColor
        self.backgroundColor = backgroundColor
        self.flexibility     = flexibility
        self.onClick         = onClick
    }

    var body: some View {
        Button { self.onClick() } label: {
            Text(self.text)
                .lineLimit(1)
                .flexibility(self.flexibility)
                .font(.system(size: 12, weight: .regular))
                .foregroundPolyfill(self.textColor)
                .padding(.init(top: 6, leading: 10, bottom: 7, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(self.backgroundColor.gradient)
                        .shadow(
                            color: self.colorScheme == .dark ?
                                .black.opacity(1.0) :
                                .black.opacity(0.3),
                            radius: 1.0,
                            y: 1
                        )
                )
        }
        .buttonStyle(.plain)
        .onHoverCursor()
    }

}

@available(macOS 14.0, *) #Preview {
    VStack {
        ButtonCustom()
        ButtonCustom(flexibility: .none)
        ButtonCustom(flexibility: .size(100))
        ButtonCustom(flexibility: .infinity)
        ButtonCustom(
            textColor: Color(ButtonCustom.ColorNames.text.rawValue),
            backgroundColor: Color(ButtonCustom.ColorNames.background.rawValue)
        )
    }
    .frame(width: 200)
    .padding(20)
}
