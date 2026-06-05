import SwiftUI

struct MenuBarCountdownView: View {
    var openMainWindow: () -> Void = {}
    var dismissMenu: () -> Void = {}

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let snapshot = CountdownSnapshot(now: context.date, target: EventDates.wwdc26Keynote)

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: snapshot.hypeStage.symbol)
                        .font(.title2)
                        .foregroundStyle(AppTheme.glowGradient)
                        .symbolEffect(.pulse, options: .repeating)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(snapshot.menuBarTitle)
                            .font(.headline.weight(.bold))
                            .monospacedDigit()

                        Text(snapshot.hypeStage.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                CompactCountdown(snapshot: snapshot)

                Text(snapshot.keynoteLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                HStack {
                    Button("Open Window") {
                        openMainWindow()
                    }

                    Button("WWDC Page") {
                        NSWorkspace.shared.open(URL(string: "https://developer.apple.com/wwdc26/")!)
                        dismissMenu()
                    }

                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(18)
            .frame(width: 330)
        }
    }
}

private struct CompactCountdown: View {
    let snapshot: CountdownSnapshot

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                compactTile(value: snapshot.days, label: "d")
                compactTile(value: snapshot.hours, label: "h")
                compactTile(value: snapshot.minutes, label: "m")
                compactTile(value: snapshot.seconds, label: "s")
            }

            ProgressView(value: snapshot.progress)
                .tint(AppTheme.cyan)
        }
    }

    private func compactTile(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value, format: .number.precision(.integerLength(2)))
                .font(.system(.title3, design: .rounded, weight: .black))
                .monospacedDigit()
                .contentTransition(.numericText(value: Double(value)))

            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
