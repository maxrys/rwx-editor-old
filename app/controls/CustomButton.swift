
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

struct CustomButton: View {

    enum ColorNames: String {
        case text           = "color CustomButton Text"
        case backgroundFrom = "color CustomButton Background From"
        case backgroundTo   = "color CustomButton Background To"
    }

    private let text: String
    private let onClick: () -> Void

    init(_ text: String = "button", onClick: @escaping () -> Void = { }) {
        self.text = text
        self.onClick = onClick
    }

    var body: some View {
        Button { self.onClick() } label: {
            Text(self.text)
                .frame(maxWidth: .infinity)
                .font(.system(size: 12, weight: .bold))
                .color(Color(Self.ColorNames.text.rawValue))
                .lineLimit(1)
                .padding(.horizontal, 7)
                .padding(.vertical  , 6)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(Self.ColorNames.backgroundFrom.rawValue),
                                    Color(Self.ColorNames.backgroundTo.rawValue)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                       )
                )
        }
        .buttonStyle(.plain)
        .onHoverCursor()
    }

}

@available(macOS 14.0, *) #Preview {
    VStack {
        CustomButton()
        CustomButton().frame(width: 100)
    }
    .frame(width: 200, height: 200)
    .padding(20)
}
