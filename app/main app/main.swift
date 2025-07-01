
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Cocoa

let app = NSApplication.shared
let delegate = App()
app.setActivationPolicy(.accessory)
app.delegate = delegate
app.run()
