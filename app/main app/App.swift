
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import SwiftUI
import Combine

class ThisApp: NSObject, NSApplicationDelegate, NSWindowDelegate {

    private var mainWindow: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow.makeAndShowFromSwiftUIView(
            ID: "main",
            title: NSLocalizedString("RWX Editor (Settings)", comment: ""),
            styleMask: [.titled, .closable],
            isVisible: true,
            delegate: self,
            view: MainView()
        )
    }

    func application(_ sender: NSApplication, open urls: [URL]) {
        for url in urls {
            let path = url.absoluteString.trimPrefix(URL_PREFIX_THIS_APP)
            let info = FSEntityInfo(path)
            if (info.type != .unknown) {
                NSWindow.makeAndShowFromSwiftUIView(
                    ID: path,
                    title: NSLocalizedString("RWX Editor", comment: ""),
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
     // self.mainWindow.makeKeyAndOrderFront(nil)
     // app.setActivationPolicy(.accessory)
        return true
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
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
