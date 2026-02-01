
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

let NA_SIGN = "—"
let APP_GROUP_NAME = "group.maxrys.rwx-editor"
let URL_PREFIX_THIS_APP = "rwxEditor://"

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
