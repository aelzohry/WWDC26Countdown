import SwiftUI

struct IOSCountdownView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.openURL) private var openURL
    @AppStorage("showSeconds") private var showSeconds = true
    @State private var sparkleSeed = 0

    var body: some View {
        if reduceMotion {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                mobileScene(date: context.date)
            }
        } else {
            TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
                mobileScene(date: context.date)
            }
        }
    }

    private func mobileScene(date: Date) -> some View {
        let snapshot = CountdownSnapshot(now: date, target: EventDates.wwdc26Keynote)

        return ZStack {
            AuroraBackground(date: date, reduceMotion: reduceMotion)
                .ignoresSafeArea()

            StarField(date: date, reduceMotion: reduceMotion)
                .ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: 22) {
                    MobileHeader(snapshot: snapshot)

                    HeroOrb(snapshot: snapshot, date: date)
                        .frame(width: 250, height: 250)
                        .padding(.top, 2)
                        .accessibilityHidden(true)

                    VStack(spacing: 10) {
                        Text(snapshot.headline)
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.76)

                        Text(snapshot.statusLine)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.white.opacity(0.72))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    CountdownGrid(
                        snapshot: snapshot,
                        showSeconds: showSeconds,
                        tileWidth: showSeconds ? 78 : 92,
                        tileHeight: 86,
                        valueFontSize: 32
                    )

                    MobileHypeCard(snapshot: snapshot)

                    MobileActionDock(
                        snapshot: snapshot,
                        showSeconds: $showSeconds,
                        sparkleSeed: $sparkleSeed,
                        openWWDCPage: { openURL(EventDates.wwdcURL) }
                    )

                    CreatorFooter()
                        .padding(.top, 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 28)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
        }
        .foregroundStyle(.white)
        .overlay {
            CelebrationBurst(seed: sparkleSeed)
                .allowsHitTesting(false)
        }
    }
}

private struct MobileHeader: View {
    let snapshot: CountdownSnapshot

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: snapshot.hypeStage.symbol)
                .font(.title3)
                .foregroundStyle(AppTheme.glowGradient)
                .symbolEffect(.pulse, options: .repeating)

            VStack(alignment: .leading, spacing: 2) {
                Text("WWDC26")
                    .font(.headline.weight(.bold))

                Text("June 8-12, 2026")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Text(snapshot.hypeStage.rawValue)
                .font(.caption.weight(.bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(.white.opacity(0.1), in: Capsule())
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }
}

private struct MobileHypeCard: View {
    let snapshot: CountdownSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Hype meter", systemImage: "sparkles")
                    .font(.subheadline.weight(.bold))

                Spacer()

                Text(snapshot.hypeStage.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.66))
            }

            ProgressView(value: snapshot.progress)
                .tint(AppTheme.mint)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
        }
        .glassPanel(cornerRadius: 22)
    }
}

private struct MobileActionDock: View {
    let snapshot: CountdownSnapshot
    @Binding var showSeconds: Bool
    @Binding var sparkleSeed: Int
    var openWWDCPage: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Toggle(isOn: $showSeconds) {
                Label("Show Seconds", systemImage: "timer")
            }
            .toggleStyle(.switch)

            HStack(spacing: 12) {
                Button {
                    sparkleSeed += 1
                } label: {
                    Label("Celebrate", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.pink)

                Button {
                    openWWDCPage()
                } label: {
                    Label(snapshot.isComplete ? "Watch" : "WWDC", systemImage: "safari")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.cyan)
            }
        }
        .controlSize(.large)
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }
}
