import SwiftUI

struct HeroOrb: View {
    let snapshot: CountdownSnapshot
    let date: Date

    var body: some View {
        let phase = date.timeIntervalSinceReferenceDate

        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(AppTheme.orbitGradient, lineWidth: index == 0 ? 8 : 3)
                    .frame(width: 255 + CGFloat(index * 36), height: 255 + CGFloat(index * 36))
                    .blur(radius: index == 0 ? 0 : 0.8)
                    .opacity(index == 0 ? 0.94 : 0.48)
                    .rotationEffect(.degrees(phase * (index.isMultiple(of: 2) ? 8 : -7)))
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white,
                            AppTheme.cyan.opacity(0.92),
                            AppTheme.violet.opacity(0.6),
                            .clear
                        ],
                        center: .center,
                        startRadius: 8,
                        endRadius: 142
                    )
                )
                .blur(radius: 2)
                .scaleEffect(snapshot.isComplete ? 1.05 : 0.94 + 0.035 * sin(phase * 1.4))

            VStack(spacing: 8) {
                Text("WW")
                    .font(.system(size: 62, weight: .black, design: .rounded))
                    .overlay(AppTheme.glowGradient)
                    .mask {
                        Text("WW")
                            .font(.system(size: 62, weight: .black, design: .rounded))
                    }

                Text("DC26")
                    .font(.system(size: 70, weight: .black, design: .rounded))
                    .overlay(AppTheme.glowGradient)
                    .mask {
                        Text("DC26")
                            .font(.system(size: 70, weight: .black, design: .rounded))
                    }

                Text(snapshot.isComplete ? "LIVE" : "KEYNOTE")
                    .font(.caption.weight(.black))
                    .tracking(3)
                    .foregroundStyle(.white.opacity(0.72))
            }
            .shadow(color: AppTheme.cyan.opacity(0.5), radius: 28)
        }
        .animation(.smooth(duration: 0.6), value: snapshot.isComplete)
    }
}
