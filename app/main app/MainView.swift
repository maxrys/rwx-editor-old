
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync
import ServiceManagement

struct MainView: View {

    static let FRAME_WIDTH: CGFloat = 300
    static let BOOKMARK_KEY = "selectedDirectory"

    static var launchAtLogin: Bool {
        get {
            if #available(macOS 13.0, *)
                 { return SMAppService.mainApp.status == .enabled }
            else { return false }
        }
        set(isEnabled) {
            do {
                if #available(macOS 13.0, *) {
                    if (isEnabled) { try SMAppService.mainApp.register  () }
                    else           { try SMAppService.mainApp.unregister() }
                }
            } catch {}
        }
    }

    static var appVersion      : String { if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String { return version } else { return "?" } }
    static var appBundleVersion: String { if let version = Bundle.main.infoDictionary?["CFBundleVersion"           ] as? String { return version } else { return "?" } }
    static var appCopyright    : String { if let version = Bundle.main.infoDictionary?["NSHumanReadableCopyright"  ] as? String { return version } else { return "?" } }

    @Environment(\.colorScheme) private var colorScheme
    @State var isEnabledExtension: Bool = false
    @State var isEnabledLaunchAtLogin: Bool = false

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

    @ViewBuilder var groupBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(
                self.colorScheme == .dark ?
                    Color.white.opacity(0.5) :
                    Color.black.opacity(0.5),
                lineWidth: 1
            )
            .background(
                self.colorScheme == .dark ?
                    Color.black.opacity(0.2) :
                    Color.white.opacity(0.7)
            )
    }

    var body: some View {
        VStack(spacing: 10) {

            VStack(spacing: 20) {

                /* MARK: extension status */

                VStack(spacing: 10) {

                    let icon  = self.isEnabledExtension ? "checkmark.circle.fill" : "xmark.circle.fill"
                    let color = self.isEnabledExtension ? Color.getCustom(.darkGreen) : Color.getCustom(.darkRed)
                    let text  = self.isEnabledExtension ? "extension is enabled" : "extension is disabled"

                    Image(systemName: icon)
                        .frame(width: 40, height: 40)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundPolyfill(color)
                        .background(Color.white)
                        .clipShape(Circle())

                    Text(NSLocalizedString(text, comment: ""))
                        .font(.system(size: 14, weight: .regular))

                    ButtonCustom(NSLocalizedString("Open Settings", comment: ""), style: .custom, flexibility: .infinity) {
                        FinderSync.FIFinderSyncController.showExtensionManagementInterface()
                    }.padding(.top, 10)

                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(self.groupBackground)

                /* MARK: scopes */

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

                    Button { self.addScope() } label: {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 30))
                    }
                    .buttonStyle(.plain)
                    .onHoverCursor()
                    .padding(20)

                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .background(self.groupBackground)

                /* MARK: launch at login */

                if #available(macOS 13.0, *) {
                    ToggleCustom(
                        text: NSLocalizedString("Launch at login", comment: ""),
                        isOn: self.$isEnabledLaunchAtLogin
                    ).onChange(of: self.isEnabledLaunchAtLogin) { value in
                        Self.launchAtLogin = value
                    }
                }

            }.padding(15)

            /* MARK: version, build, copyright */

            VStack(spacing: 0) {

                /* shadow */
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(self.colorScheme == .light ? 0.1 : 0.4),
                                Color.clear ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    ).frame(height: 6)

                /* version + build + copyright */
                VStack(spacing: 10) {
                    Text(String(format: NSLocalizedString("Version: %@ | Build: %@", comment: ""), Self.appVersion, Self.appBundleVersion))
                        .font(.system(size: 13))
                    Text(Self.appCopyright)
                        .font(.system(size: 11))
                }
                .padding(.init(top: 10, leading: 15, bottom: 15, trailing: 15))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .foregroundPolyfill(.gray)

            }.background(
                self.colorScheme == .dark ?
                Color.white.opacity(0.03) :
                Color.black.opacity(0.06)
            )

        }
        .foregroundPolyfill(Color.getCustom(.text))
        .environment(\.layoutDirection, .leftToRight)
        .frame(width: Self.FRAME_WIDTH)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
             { _ in self.updateView() }
        .onAppear { self.updateView() }
    }

    func updateView() {
        self.isEnabledExtension = FIFinderSyncController.isExtensionEnabled
        self.isEnabledLaunchAtLogin = Self.launchAtLogin
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
    MainView()
}
