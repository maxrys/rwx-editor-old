
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import SwiftUI
import Combine

class ThisApp: NSObject, NSApplicationDelegate, NSWindowDelegate {

    static let GROUP_NAME = "group.maxrys.rwx-editor"
    static let NA_SIGN = "—"

    private var mainWindow: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.showMainWindow()
    }

    func application(_ sender: NSApplication, open urls: [URL]) {
        for url in urls {
            let path = url.absoluteString.trimPrefix(URL_PREFIX_THIS_APP)
            let info = FSEntityInfo(path)
            if (info.type != .unknown) {
                NSWindow.makeAndShowFromSwiftUIView(
                    ID: path,
                    title: "RWX Editor",
                    isVisible: true,
                    delegate: self,
                    view: PopupView(path)
                )
            } else {
                let alert: NSAlert = NSAlert()
                alert.messageText = NSLocalizedString("This type is not supported!", comment: "")
                alert.alertStyle = .critical
                alert.runModal()
            }
        }
    }

    func applicationShouldHandleReopen(_ app: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        self.mainWindow.makeKeyAndOrderFront(nil)
        app.setActivationPolicy(.accessory)
        return true
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func showMainWindow() {
        let mainView = MainView()
        let mainHostingView = NSHostingView(
            rootView: mainView
        )

        self.mainWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        self.mainWindow.delegate = self
        self.mainWindow.contentView = mainHostingView
        self.mainWindow.isReleasedWhenClosed = false
        self.mainWindow.title = NSLocalizedString("Rwx Editor (Settings)", comment: "")
        self.mainWindow.level = .normal
        self.mainWindow.makeKeyAndOrderFront(nil)
        self.mainWindow.center()

        mainHostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHostingView.leadingAnchor .constraint(equalTo: self.mainWindow.contentView!.leadingAnchor),
            mainHostingView.trailingAnchor.constraint(equalTo: self.mainWindow.contentView!.trailingAnchor),
            mainHostingView.topAnchor     .constraint(equalTo: self.mainWindow.contentView!.topAnchor),
            mainHostingView.bottomAnchor  .constraint(equalTo: self.mainWindow.contentView!.bottomAnchor),
        ])
    }

    func windowWillClose(_ notification: Notification) {
        let windows = notification.object as? NSWindow
        if (windows != self.mainWindow) {
            for (path, current) in NSWindow.customWindows {
                if (current == windows) {
                    NSWindow.customWindows[path] = nil
                }
            }
        }
    }

}
