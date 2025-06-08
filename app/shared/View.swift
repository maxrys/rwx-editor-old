
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension View {

    @ViewBuilder public func foregroundPolyfill(_ color: Color) -> some View {
        if #available(macOS 14.0, iOS 17.0, *) { self.foregroundStyle(color) }
        else                                   { self.foregroundColor(color) }
    }

    @ViewBuilder public func textSelectionPolyfill(isEnabled: Bool = true) -> some View {
        if #available(macOS 12.0, *) {
            if (isEnabled == true) { self.textSelection(.enabled ) }
            if (isEnabled != true) { self.textSelection(.disabled) }
        } else { self }
    }

    @ViewBuilder public func flexibility(_ value: Flexibility = .none) -> some View {
        switch value {
            case .size(let size): self.frame(width: size)
            case .infinity      : self.frame(maxWidth: .infinity)
            case .none          : self
        }
    }

    @ViewBuilder public func onHoverCursor(isEnabled: Bool = true) -> some View {
        self.onHover { isInView in
            if (isEnabled) {
                if (isInView) { NSCursor.pointingHand.push() }
                else          { NSCursor.pop() }
            }   else          { NSCursor.pop() }
        }
    }

}
