import SwiftUI

@main
struct WWDCCountdownApp: App {
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup("WWDC26 Countdown", id: "main") {
            ContentView()
                .frame(minWidth: 900, minHeight: 620)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 980, height: 680)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open Countdown") {
                    openWindow(id: "main")
                }
                .keyboardShortcut("0", modifiers: [.command])
            }
        }

        MenuBarExtra {
            MenuBarCountdownView()
        } label: {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let snapshot = CountdownSnapshot(now: context.date, target: EventDates.wwdc26Keynote)

                Label {
                    Text(snapshot.menuBarTitle)
                        .monospacedDigit()
                } icon: {
                    Image(systemName: snapshot.isComplete ? "sparkles" : "apple.terminal")
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
