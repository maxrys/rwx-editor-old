
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

let FINDER_EXT_DIRECTORY_URLS: Set<URL> = [
    URL(fileURLWithPath: "/")
]

let FINDER_EXT_MENU_TITLE = "RWX Editor Menu"
let FINDER_EXT_MENU_ITEMS = [
    (
        eventName: "RWXEditorFinderContextMenu",
        titleLocalized: NSLocalizedString("RWX Editor", comment: ""),
        iconName: "folder.badge.person.crop"
    )
]
