
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ScopesView: View {

    static let BOOKMARK_KEY = "selectedDirectory"

    @Environment(\.colorScheme) private var colorScheme

    init() {
        if let bookmark = UserDefaults.standard.data(forKey: Self.BOOKMARK_KEY) {
            var isExpired = false
            if let url = try? URL(
                resolvingBookmarkData: bookmark,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isExpired
            ) {
                if (isExpired == false) {
                    let _ = url.startAccessingSecurityScopedResource()
                    print("access for \(url.absoluteString) was granted")
                }
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            Text(NSLocalizedString("disk access", comment: ""))
                .font(.system(size: 11))
                .padding(7)
                .frame(maxWidth: .infinity)
                .background(
                    self.colorScheme == .dark ?
                        Color.white.opacity(0.07) :
                        Color.black.opacity(0.07)
                )

            Button { self.addScope() } label: {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: 30))
            }
            .buttonStyle(.plain)
            .onHoverCursor()
            .padding(20)

        }
    }

    func addScope() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.prompt = NSLocalizedString("select a directory to grant access", comment: "")

        guard openPanel.runModal() == .OK else { return }
        guard let url = openPanel.url     else { return }

        if let bookmarkData = try? url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        ) {
            UserDefaults.standard.set(
                bookmarkData,
                forKey: Self.BOOKMARK_KEY
            )
            if url.startAccessingSecurityScopedResource() {
                print("access for \(url.absoluteString) was granted")
            }
        }
    }

}

#Preview {
    ScopesView()
}
