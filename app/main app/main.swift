
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa

let app = NSApplication.shared
let delegate = ThisApp()
app.setActivationPolicy(.accessory)
app.delegate = delegate
app.run()
