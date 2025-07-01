
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct BookmarksView: View {

    static var userDefaults: UserDefaults? {
        UserDefaults(suiteName: App.GROUP_NAME)
    }

    static var bookmarksStore: Data? {
        get { Self.userDefaults?.data(forKey: "bookmarks") ?? nil }
        set { Self.userDefaults?.set(newValue, forKey: "bookmarks") }
    }

    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var urls = ValueState<[URL]>([])

    init(demoURLs: [URL]? = nil) {
        if let demoURLs {
            for url in demoURLs {
                self.urls.value.append(url)
            }
        } else {
            if let url = self.getBookmarkURLs() {
                self.urls.value.append(url)
            }
        }
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

            if (self.urls.value.isEmpty) {
                Text("no bookmarks")
            } else {
                VStack(spacing: 0) {
                    ForEach(self.urls.value.indices, id: \.self) { id in
                        Text(self.urls.value[id].absoluteString)
                    }
                }
            }

            ButtonCustom(NSLocalizedString("add directory", comment: ""), style: .custom, flexibility: .infinity) {
                self.addBookmark()
            }.padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))

        }
    }

    func getBookmarkURLs() -> URL? {
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

    func addBookmark() {
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
    VStack(spacing: 10) {
        BookmarksView(demoURLs: []).frame(width: 200)
        BookmarksView(demoURLs: [
            URL("/private/etc/")!,
            URL("/private/etc/hosts")!
        ]).frame(width: 200)
    }
    .padding(10)
}
