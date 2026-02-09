
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import SwiftUI
import Combine

class ThisApp: NSObject, NSApplicationDelegate, NSWindowDelegate {

    private var mainWindow: NSWindow!

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

}
