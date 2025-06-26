
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = ThisApp()
app.delegate = delegate
app.run()
