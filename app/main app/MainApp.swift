
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import Combine

@main struct MainApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    private var cancellableBag = Set<AnyCancellable>()
    private var mainWindow: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {

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

        NSApp.setActivationPolicy(.accessory)
        self.showMainWindow()
    }

    func showMainWindow() {
        let mainView = MainView()
        let mainHostingView = NSHostingView(rootView: mainView)

        self.mainWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        self.mainWindow.title = "Rwx Editor (Settings)"
        self.mainWindow.contentView = mainHostingView
        self.mainWindow.makeKeyAndOrderFront(nil)
        self.mainWindow.delegate = self
        self.mainWindow.center()
    }

    func showPopupWindow(_ path: String) {
        let popupView = PopupView(path)
        let popupHostingView = NSHostingView(rootView: popupView)

        let popupWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: PopupView.FRAME_WIDTH, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        popupWindow.title = "Rwx Editor"
        popupWindow.contentView = NSView()
        popupWindow.contentView?.addSubview(popupHostingView)
        popupWindow.makeKeyAndOrderFront(nil)
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
            //mainWindow.orderOut(nil)
        }
    }

}
