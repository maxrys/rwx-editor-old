
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import SwiftUI
import Combine

class ThisApp: NSObject, NSApplicationDelegate, NSWindowDelegate {

    static let GROUP_NAME = "group.maxrys.rwx-editor"
    static let NA_SIGN = "—"

    private var cancellableBag = Set<AnyCancellable>()
    private var mainWindow: NSWindow!
    private var popupWindows: [String: NSWindow] = [:]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DistributedNotificationCenter.default.publisher(
            for: Notification.Name(
                FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU
            )
        ).sink(receiveValue: { notification in
            do {
                guard let json = notification.object as? String else { return }
                guard let finderEvent = FinderEvent(json: json) else { return }
                for pathWithName in finderEvent.items {
                    let info = FSEntityInfo(pathWithName)
                    if (info.type != .unknown) {
                        self.showPopupWindow(pathWithName)
                    } else {
                        let alert: NSAlert = NSAlert()
                        alert.messageText = NSLocalizedString("This type is not supported!", comment: "")
                        alert.alertStyle = .critical
                        alert.runModal()
                    }
                }
            }
        }).store(in: &self.cancellableBag)
        self.showMainWindow()
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

    func showPopupWindow(_ pathWithName: String) {
        if let existingWindow = self.popupWindows[pathWithName] {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }

        let popupHostingView = NSHostingView(
            rootView: PopupView(pathWithName)
        )

        self.popupWindows[pathWithName] = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        guard let window = self.popupWindows[pathWithName] else {
            return
        }

        window.delegate = self
        window.contentView = popupHostingView
        window.isReleasedWhenClosed = false
        window.title = NSLocalizedString("Rwx Editor", comment: "")
        window.level = .normal
        window.makeKeyAndOrderFront(nil)
        window.center()

        popupHostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupHostingView.leadingAnchor .constraint(equalTo: window.contentView!.leadingAnchor),
            popupHostingView.trailingAnchor.constraint(equalTo: window.contentView!.trailingAnchor),
            popupHostingView.topAnchor     .constraint(equalTo: window.contentView!.topAnchor),
            popupHostingView.bottomAnchor  .constraint(equalTo: window.contentView!.bottomAnchor),
        ])
    }

    func windowWillClose(_ notification: Notification) {
        let windows = notification.object as? NSWindow
        if (windows != self.mainWindow) {
            for (path, current) in self.popupWindows {
                if (current == windows) {
                    self.popupWindows[path] = nil
                }
            }
        }
    }

}
