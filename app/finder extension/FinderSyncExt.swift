
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import FinderSync

class FinderSyncExt: FIFinderSync {

    static let EVENT_NAME_FOR_FINDER_CONTEXT_MENU = "finderContextMenu"

    var folderURL = URL(
        fileURLWithPath: "/Users/"
    )

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [self.folderURL]
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "Rwx Editor Menu")
        switch menuKind {
            case .contextualMenuForItems, .contextualMenuForContainer:
                let menuItem = NSMenuItem()
                    menuItem.title = String(NSLocalizedString("Rwx Editor", comment: ""))
                    menuItem.image = NSImage(systemSymbolName: "folder.badge.person.crop", accessibilityDescription: "")!
                    menuItem.action = #selector(onContextMenu(_:))
                    menuItem.target = self
                    menuItem.tag = 0
                menu.addItem(menuItem)
            default: break
        }
        return menu
    }

    @objc func onContextMenu(_ menuItem: NSMenuItem) {
        if (menuItem.tag == 0) {
            let _ = FIFinderSyncController.default().targetedURL()
            let items = FIFinderSyncController.default().selectedItemURLs()
            var paths: [String] = []
            items?.forEach { url in
                paths.append(url.absoluteString)
            }
            EventsDispatcherGlobal.shared.send(
                FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU,
                object: FinderEvent(
                    type: .directory,
                    items: paths
                ).encode()
            )
        }
    }

}
