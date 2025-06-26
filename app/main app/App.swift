
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import SwiftUI
import Combine

class ThisApp: NSObject, NSApplicationDelegate, NSWindowDelegate {

    private var cancellableBag = Set<AnyCancellable>()
    private var mainWindow: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DistributedNotificationCenter.default.publisher(
            for: Notification.Name(
                FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU
            )
        ).sink(receiveValue: { notification in
            do {
                guard let json = notification.object as? String else { return }
                guard let finderEvent = FinderEvent(from: json) else { return }
                for path in finderEvent.paths {
                    self.showPopupWindow(path)
                }
            }
        }).store(in: &self.cancellableBag)
        self.showMainWindow()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func showMainWindow() {
        let mainView = MainView()
        let mainHostingView = NSHostingView(rootView: mainView)

        self.mainWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        self.mainWindow.center()
        self.mainWindow.title = "Rwx Editor (Settings)"
        self.mainWindow.level = .normal
        self.mainWindow.makeKeyAndOrderFront(nil)
        self.mainWindow.contentView = mainHostingView
        self.mainWindow.delegate = self
        self.mainWindow.center()

        mainHostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHostingView.leadingAnchor .constraint(equalTo: self.mainWindow.contentView!.leadingAnchor),
            mainHostingView.trailingAnchor.constraint(equalTo: self.mainWindow.contentView!.trailingAnchor),
            mainHostingView.topAnchor     .constraint(equalTo: self.mainWindow.contentView!.topAnchor),
            mainHostingView.bottomAnchor  .constraint(equalTo: self.mainWindow.contentView!.bottomAnchor),
        ])
    }

    func showPopupWindow(_ path: String) {
        let popupView = PopupView(path)
        let popupHostingView = NSHostingView(rootView: popupView)

        let popupWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        popupWindow.center()
        popupWindow.title = "Rwx Editor"
        popupWindow.level = .normal
        popupWindow.makeKeyAndOrderFront(nil)
        popupWindow.contentView = NSView()
        popupWindow.contentView?.addSubview(popupHostingView)
     // popupWindow.contentView = popupHostingView
        popupWindow.delegate = self
        popupWindow.center()

        popupHostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupHostingView.leadingAnchor .constraint(equalTo: popupWindow.contentView!.leadingAnchor),
            popupHostingView.trailingAnchor.constraint(equalTo: popupWindow.contentView!.trailingAnchor),
            popupHostingView.topAnchor     .constraint(equalTo: popupWindow.contentView!.topAnchor),
            popupHostingView.bottomAnchor  .constraint(equalTo: popupWindow.contentView!.bottomAnchor),
        ])
    }

    private func windowWillClose(_ sender: NSWindow) {
        if sender == mainWindow {
            // mainWindow.orderOut(nil)
        }
    }

}
