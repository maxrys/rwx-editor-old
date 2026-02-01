
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension NSWindow {

    static var customWindows: [
        String: NSWindow
    ] = [:]

    static func show(_ ID: String) { self.customWindows[ID]?.makeKeyAndOrderFront(nil) }
    static func hide(_ ID: String) { self.customWindows[ID]?.orderOut(nil) }

    static func makeAndShowFromSwiftUIView(
        ID: String,
        title: String,
        styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable],
        level: NSWindow.Level = .normal,
        isVisible: Bool = true,
        isReleasedWhenClosed: Bool = false,
        delegate: any NSWindowDelegate,
        view: some View
    ) {
        if (Self.customWindows[ID] != nil) {
            Self.show(ID)
            return
        }

        let hostingView = NSHostingView(
            rootView: view
        )

        Self.customWindows[ID] = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 1000),
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )

        guard let window = Self.customWindows[ID] else {
            return
        }

        window.delegate = delegate
        window.contentView = hostingView
        window.isReleasedWhenClosed = isReleasedWhenClosed
        window.title = title
        window.level = level

        if (isVisible) {
            Self.show(ID)
            window.center()
        } else {
            Self.hide(ID)
        }

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor .constraint(equalTo: window.contentView!.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: window.contentView!.trailingAnchor),
            hostingView.topAnchor     .constraint(equalTo: window.contentView!.topAnchor),
            hostingView.bottomAnchor  .constraint(equalTo: window.contentView!.bottomAnchor),
        ])
    }

}
