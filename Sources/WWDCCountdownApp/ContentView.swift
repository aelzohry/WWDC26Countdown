import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("showSeconds") private var showSeconds = true
    @State private var sparkleSeed = 0

    var body: some View {
        if reduceMotion {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                countdownScene(date: context.date)
            }
        } else {
            TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
                countdownScene(date: context.date)
            }
        }
    }

    private func countdownScene(date: Date) -> some View {
        let snapshot = CountdownSnapshot(now: date, target: EventDates.wwdc26Keynote)

        return ZStack {
            AuroraBackground(date: date, reduceMotion: reduceMotion)
                .ignoresSafeArea()

            StarField(date: date, reduceMotion: reduceMotion)
                .ignoresSafeArea()

            VStack(spacing: 26) {
                HeaderBar(snapshot: snapshot)

                HStack(spacing: 28) {
                    HeroOrb(snapshot: snapshot, date: date)
                        .frame(width: 330, height: 330)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(snapshot.headline)
                                .font(.system(size: 54, weight: .black, design: .rounded))
                                .lineLimit(2)
                                .minimumScaleFactor(0.74)

                            Text(snapshot.statusLine)
                                .font(.title3.weight(.medium))
                                .foregroundStyle(.white.opacity(0.74))
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        CountdownGrid(snapshot: snapshot, showSeconds: showSeconds)

                        ControlStrip(snapshot: snapshot, showSeconds: $showSeconds, sparkleSeed: $sparkleSeed)
                    }
                }

                HypeRibbon(snapshot: snapshot, date: date)

                CreatorFooter()
            }
            .padding(34)
        }
        .foregroundStyle(.white)
        .overlay {
            CelebrationBurst(seed: sparkleSeed)
                .allowsHitTesting(false)
        }
    }
}

private struct HeaderBar: View {
    let snapshot: CountdownSnapshot

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .foregroundStyle(AppTheme.glowGradient)
                    .font(.title2)
                    .symbolEffect(.pulse, options: .repeating)

                VStack(alignment: .leading, spacing: 2) {
                    Text("WWDC26 Countdown")
                        .font(.headline.weight(.semibold))

                    Text("June 8-12, 2026")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.62))
                }
            }

            Spacer()

            HStack(spacing: 10) {
                Image(systemName: snapshot.hypeStage.symbol)
                Text(snapshot.hypeStage.rawValue)
            }
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(.white.opacity(0.1), in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.15), lineWidth: 1)
            }
        }
    }
}

private struct CreatorFooter: View {
    private let profileURL = URL(string: "https://bio.link/aelzohry")!

    var body: some View {
        Link(destination: profileURL) {
            HStack(spacing: 8) {
                Text("Created with")

                Image(systemName: "heart.fill")
                    .foregroundStyle(AppTheme.pink)
                    .symbolEffect(.pulse, options: .repeating)
                    .accessibilityLabel("love")

                Text("by Ahmed Elzohry")
                    .fontWeight(.semibold)

                Image(systemName: "arrow.up.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.68))
            }
            .font(.footnote.weight(.medium))
            .foregroundStyle(.white.opacity(0.72))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.white.opacity(0.075), in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.12), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Created with love by Ahmed Elzohry. Opens developer profile.")
    }
}

private struct CountdownGrid: View {
    let snapshot: CountdownSnapshot
    let showSeconds: Bool

    private var units: [(String, Int)] {
        var values = [
            ("days", snapshot.days),
            ("hours", snapshot.hours),
            ("minutes", snapshot.minutes)
        ]

        if showSeconds {
            values.append(("seconds", snapshot.seconds))
        }

        return values
    }

    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                ForEach(units, id: \.0) { label, value in
                    CountdownTile(label: label, value: value)
                }
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: showSeconds)
    }
}

private struct CountdownTile: View {
    let label: String
    let value: Int

    var body: some View {
        VStack(spacing: 6) {
            Text(value, format: .number.precision(.integerLength(2)))
                .font(.system(size: 48, weight: .black, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText(value: Double(value)))
                .animation(.smooth(duration: 0.28), value: value)

            Text(label.uppercased())
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.55))
        }
        .frame(width: 120, height: 112)
        .brightCard()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(value) \(label)")
    }
}

private struct ControlStrip: View {
    let snapshot: CountdownSnapshot
    @Binding var showSeconds: Bool
    @Binding var sparkleSeed: Int

    var body: some View {
        HStack(spacing: 12) {
            Toggle("Seconds", isOn: $showSeconds)
                .toggleStyle(.switch)

            Button {
                sparkleSeed += 1
            } label: {
                Label("Tiny celebration", systemImage: "sparkles")
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.pink)

            Button {
                NSWorkspace.shared.open(URL(string: "https://developer.apple.com/wwdc26/")!)
            } label: {
                Label(snapshot.isComplete ? "Watch WWDC" : "Open WWDC", systemImage: "safari")
            }
            .buttonStyle(.bordered)
        }
        .controlSize(.large)
    }
}

private struct HypeRibbon: View {
    let snapshot: CountdownSnapshot
    let date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Hype meter", systemImage: "waveform.path.ecg")
                    .font(.headline.weight(.semibold))

                Spacer()

                Text(snapshot.hypeStage.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
            }

            GeometryReader { proxy in
                let width = proxy.size.width
                let sparkleOffset = width * snapshot.progress

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.1))

                    Capsule()
                        .fill(AppTheme.glowGradient)
                        .frame(width: max(22, width * snapshot.progress))
                        .shadow(color: AppTheme.cyan.opacity(0.6), radius: 18)

                    Circle()
                        .fill(.white)
                        .frame(width: 12, height: 12)
                        .shadow(color: .white, radius: 10)
                        .offset(x: max(5, sparkleOffset - 8))
                        .opacity(snapshot.isComplete ? 0 : 1)
                }
            }
            .frame(height: 16)
        }
        .glassPanel(cornerRadius: 24)
    }
}
