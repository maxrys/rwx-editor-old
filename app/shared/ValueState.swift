
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

class ValueState<T>: ObservableObject {

    @Published var value: T

    init(_ value: T) {
        self.value = value
    }

}
