import SwiftUI

@main
struct WWDCCountdownApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open Countdown") {
                    appDelegate.showMainWindow()
                }
                .keyboardShortcut("0", modifiers: [.command])
            }
        }
    }
}
