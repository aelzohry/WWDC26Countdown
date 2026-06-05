import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openURL) private var openURL
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

                        ControlStrip(
                            snapshot: snapshot,
                            showSeconds: $showSeconds,
                            sparkleSeed: $sparkleSeed,
                            openWWDCPage: { openURL(EventDates.wwdcURL) }
                        )
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

private struct ControlStrip: View {
    let snapshot: CountdownSnapshot
    @Binding var showSeconds: Bool
    @Binding var sparkleSeed: Int
    var openWWDCPage: () -> Void

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
                openWWDCPage()
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
