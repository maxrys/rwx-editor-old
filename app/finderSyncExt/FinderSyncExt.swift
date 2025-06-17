
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa
import FinderSync

class FinderSyncExt: FIFinderSync {

    var folderURL = URL(
        fileURLWithPath: "/Users/" // "/Users/Shared/MySyncExtension Documents"
    )

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [self.folderURL]
//      print("RwxFinderSync launched from: \(Bundle.main.bundlePath as NSString)")
//      FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.colorPanelName)!, label: "Status One" , forBadgeIdentifier: "One")
//      FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.cautionName)!, label: "Status Two", forBadgeIdentifier: "Two")
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "Rwx Editor Menu")
        switch menuKind {
            case .contextualMenuForItems, .contextualMenuForContainer:
                let menuItem = NSMenuItem()
                    menuItem.title = String(NSLocalizedString("Permissions", comment: ""))
                    menuItem.toolTip = "Permissions"
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
            EventsDispatcher.shared.send(
                "finderContextMenu",
                message: Message(
                    name: "forDirs",
                    data: paths.joined(separator: "|")
                )
            )
        }
    }

//  override func beginObservingDirectory(at url: URL) {
//      print("beginObservingDirectoryAtURL: \(url.path as NSString)")
//  }

//  override func endObservingDirectory(at url: URL) {
//      print("endObservingDirectoryAtURL: \(url.path as NSString)")
//  }

//  override func requestBadgeIdentifier(for url: URL) {
//      print("requestBadgeIdentifierForURL: \(url.path as NSString)")
//      let whichBadge = abs(url.path.hash) % 3
//      let badgeIdentifier = ["", "One", "Two"][whichBadge]
//      FIFinderSyncController.default().setBadgeIdentifier(badgeIdentifier, for: url)
//  }

//  override var toolbarItemName: String {
//      return "FinderSy"
//  }

//  override var toolbarItemToolTip: String {
//      return "FinderSy: Click the toolbar item for a menu."
//  }

//  override var toolbarItemImage: NSImage {
//      return NSImage(named: NSImage.cautionName)!
//  }

//  override func menu(for menuKind: FIMenuKind) -> NSMenu {
//      let menu = NSMenu(title: "")
//      menu.addItem(
//          withTitle: "Example Menu Item",
//          action: #selector(sampleAction(_:)),
//          keyEquivalent: ""
//      )
//      return menu
//  }

//  @IBAction func sampleAction(_ sender: AnyObject?) {
//      let target = FIFinderSyncController.default().targetedURL()
//      let items = FIFinderSyncController.default().selectedItemURLs()
//      let item = sender as! NSMenuItem
//      print("sampleAction: menu item: \(item.title as NSString), target = \(target!.path as NSString)")
//      for obj in items! {
//          print("\(obj.path as NSString)")
//      }
//  }

}
