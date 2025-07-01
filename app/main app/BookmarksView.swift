
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct BookmarksView: View {

    static var userDefaults: UserDefaults? {
        UserDefaults(suiteName: App.GROUP_NAME)
    }

    static var bookmarksStore: [Data] {
        get { Self.userDefaults?.array(forKey: "bookmarks") as? [Data] ?? [] }
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
            for url in self.getBookmarkURLs() {
                self.urls.value.append(url)
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            Text(NSLocalizedString("disk access", comment: ""))
                .font(.system(size: 11))
                .padding(15)
                .frame(maxWidth: .infinity)
                .background(
                    self.colorScheme == .dark ?
                    Color.white.opacity(0.10) :
                    Color.black.opacity(0.12)
                )

            if (self.urls.value.isEmpty) {
                Text("no bookmarks")
                    .padding(20)
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.fixed (40), spacing: 0)
                ]
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(self.urls.value.indices, id: \.self) { index in
                            let background = index % 2 == 0 ?
                                Color.clear :
                                Color.black.opacity(0.05)
                            HStack(spacing: 0) { Text(self.urls.value[index].path) }
                                .padding(.horizontal, 9)
                                .padding(.vertical  , 6)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .background(background)
                            HStack(spacing: 0) {
                                Button {
                                    print("delete \(index)")
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundPolyfill(Color.getCustom(.softRed))
                                }
                                .buttonStyle(.plain)
                                .onHoverCursor()
                            }
                            .padding(.horizontal, 9)
                            .padding(.vertical  , 6)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .background(background)
                        }
                    }
                }
                .background(
                    self.colorScheme == .dark ?
                    Color.black :
                    Color.white
                )
                .border(.black.opacity(0.2), width: 1)
                .padding(15)
            }

            Spacer()

            ButtonCustom(NSLocalizedString("add directory", comment: ""), style: .custom, flexibility: .none) {
                self.addBookmark()
            }.padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            self.colorScheme == .dark ?
            Color.black.opacity(0.4) :
            Color.white.opacity(0.7)
        )
    }

    func getBookmarkURLs() -> [URL] {
        var result: [URL] = []
        for bookmark in Self.bookmarksStore {
            var isExpired = false
            let url = try? URL(
                resolvingBookmarkData: bookmark,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isExpired
            )
            if let url, !isExpired {
                result.append(url)
                let _ = url.startAccessingSecurityScopedResource()
            }
        }
        return result
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

        let bookmark = try? url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        if let bookmark {
            Self.bookmarksStore.append(bookmark)
            let _ = url.startAccessingSecurityScopedResource()
            self.urls.value = []
            for url in self.getBookmarkURLs() {
                self.urls.value.append(url)
            }
        }
    }

}

#Preview {
    VStack(spacing: 10) {
        BookmarksView(demoURLs: [])
        BookmarksView(demoURLs: [
            URL("/path/to/directory/1")!,
            URL("/path/to/directory/2")!,
            URL("/path/to/directory/3")!,
            URL("/path/to/directory/4")!,
            URL("/path/to/directory/5")!,
            URL("/path/to/directory/6")!,
            URL("/path/to/directory/7")!,
            URL("/path/to/directory/8")!,
            URL("/path/to/directory/9")!,
        ])
    }
    .frame(maxWidth: 400)
    .frame(height: 600)
    .padding(10)
}
