
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ScopesView: View {

    static var userDefaults: UserDefaults? {
        UserDefaults(suiteName: App.GROUP_NAME)
    }

    static var bookmarksStore: Data? {
        get { Self.userDefaults?.data(forKey: "bookmarks") ?? nil }
        set { Self.userDefaults?.set(newValue, forKey: "bookmarks") }
    }

    @Environment(\.colorScheme) private var colorScheme

    init() {
    }

    func getValidURLs() -> URL? {
        if let bookmark = Self.bookmarksStore {
            var isExpired = false
            if let url = try? URL(
                resolvingBookmarkData: bookmark,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isExpired
            ) {
                if (isExpired == false) {
                    let _ = url.startAccessingSecurityScopedResource()
                    return url
                }
            }
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 10) {

            Text(NSLocalizedString("disk access", comment: ""))
                .font(.system(size: 11))
                .padding(7)
                .frame(maxWidth: .infinity)
                .background(
                    self.colorScheme == .dark ?
                        Color.white.opacity(0.07) :
                        Color.black.opacity(0.07)
                )

            if let url = self.getValidURLs()
                 { Text("URL: \(url.absoluteString)") }
            else { Text("URL: \(App.NA_SIGN)") }

            ButtonCustom(NSLocalizedString("add directory", comment: ""), style: .custom, flexibility: .infinity) {
                self.addScope()
            }.padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))

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
            Self.bookmarksStore = bookmarkData
            if url.startAccessingSecurityScopedResource() {
                print("access for \(url.absoluteString) was granted")
            }
        }
    }

}

#Preview {
    ScopesView()
        .frame(width: 200)
}
