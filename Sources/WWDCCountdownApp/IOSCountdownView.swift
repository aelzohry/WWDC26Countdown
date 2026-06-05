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

            GeometryReader { proxy in
                let contentWidth = min(proxy.size.width - 40, 520)
                let compactHeight = proxy.size.height < 840
                let heroSize = min(compactHeight ? 192 : 222, max(166, proxy.size.height * 0.24))
                let tileWidth = min(showSeconds ? 78 : 94, (contentWidth - 36) / CGFloat(showSeconds ? 4 : 3))
                let tileHeight: CGFloat = compactHeight ? 72 : 78
                let verticalPadding: CGFloat = compactHeight ? 8 : 12

                VStack(spacing: compactHeight ? 10 : 13) {
                    MobileHeader(snapshot: snapshot, compact: compactHeight)

                    HeroOrb(snapshot: snapshot, date: date)
                        .frame(width: heroSize, height: heroSize)
                        .accessibilityHidden(true)

                    VStack(spacing: compactHeight ? 6 : 8) {
                        Text(snapshot.headline)
                            .font(.system(size: compactHeight ? 32 : 36, weight: .black, design: .rounded))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.74)

                        Text(snapshot.statusLine)
                            .font(.system(size: compactHeight ? 14 : 15, weight: .medium))
                            .foregroundStyle(.white.opacity(0.72))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.78)
                    }

                    CountdownGrid(
                        snapshot: snapshot,
                        showSeconds: showSeconds,
                        tileWidth: tileWidth,
                        tileHeight: tileHeight,
                        valueFontSize: compactHeight ? 28 : 30
                    )

                    MobileHypeCard(snapshot: snapshot, compact: compactHeight)

                    MobileActionDock(
                        snapshot: snapshot,
                        showSeconds: $showSeconds,
                        sparkleSeed: $sparkleSeed,
                        compact: compactHeight,
                        openWWDCPage: { openURL(EventDates.wwdcURL) }
                    )

                    Spacer(minLength: compactHeight ? 4 : 12)

                    CreatorFooter()
                }
                .padding(.horizontal, 20)
                .safeAreaPadding(.top, verticalPadding)
                .safeAreaPadding(.bottom, verticalPadding)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
            }
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
    let compact: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: snapshot.hypeStage.symbol)
                .font(compact ? .body : .title3)
                .foregroundStyle(AppTheme.glowGradient)
                .symbolEffect(.pulse, options: .repeating)

            VStack(alignment: .leading, spacing: 2) {
                Text("WWDC26")
                    .font((compact ? Font.subheadline : Font.headline).weight(.bold))

                Text("June 8-12, 2026")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Text(snapshot.hypeStage.rawValue)
                .font(.caption.weight(.bold))
                .padding(.horizontal, compact ? 8 : 10)
                .padding(.vertical, compact ? 6 : 7)
                .background(.white.opacity(0.1), in: Capsule())
        }
        .padding(compact ? 12 : 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }
}

private struct MobileHypeCard: View {
    let snapshot: CountdownSnapshot
    let compact: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 8 : 10) {
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
        .padding(compact ? 14 : 18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }
}

private struct MobileActionDock: View {
    let snapshot: CountdownSnapshot
    @Binding var showSeconds: Bool
    @Binding var sparkleSeed: Int
    let compact: Bool
    var openWWDCPage: () -> Void

    var body: some View {
        VStack(spacing: compact ? 9 : 11) {
            Toggle(isOn: $showSeconds) {
                Label("Show Seconds", systemImage: "timer")
            }
            .toggleStyle(.switch)

            HStack(spacing: compact ? 10 : 12) {
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
        .controlSize(compact ? .regular : .large)
        .padding(compact ? 14 : 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }
}
