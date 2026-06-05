import SwiftUI

struct AuroraBackground: View {
    let date: Date
    let reduceMotion: Bool

    var body: some View {
        let phase = reduceMotion ? 0 : date.timeIntervalSinceReferenceDate

        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(AppTheme.deepSpace))

            let blobs: [(Color, CGPoint, CGSize, Double)] = [
                (AppTheme.cyan, CGPoint(x: 0.18, y: 0.18), CGSize(width: 520, height: 360), 0.7),
                (AppTheme.pink, CGPoint(x: 0.78, y: 0.2), CGSize(width: 540, height: 380), 1.1),
                (AppTheme.mint, CGPoint(x: 0.66, y: 0.82), CGSize(width: 620, height: 400), 0.9),
                (AppTheme.violet, CGPoint(x: 0.26, y: 0.78), CGSize(width: 480, height: 340), 1.3)
            ]

            for (index, blob) in blobs.enumerated() {
                let x = blob.1.x * size.width + cos(phase * blob.3 + Double(index)) * 44
                let y = blob.1.y * size.height + sin(phase * blob.3 + Double(index) * 2) * 36
                let rect = CGRect(
                    x: x - blob.2.width / 2,
                    y: y - blob.2.height / 2,
                    width: blob.2.width,
                    height: blob.2.height
                )

                context.addFilter(.blur(radius: 70))
                context.opacity = 0.55
                context.fill(Path(ellipseIn: rect), with: .color(blob.0))
                context.opacity = 1
            }
        }
        .background(AppTheme.ink)
    }
}

struct StarField: View {
    let date: Date
    let reduceMotion: Bool

    var body: some View {
        let phase = reduceMotion ? 0 : date.timeIntervalSinceReferenceDate

        Canvas { context, size in
            for index in 0..<82 {
                let x = size.width * seeded(index, salt: 11)
                let y = size.height * seeded(index, salt: 29)
                let twinkle = 0.35 + 0.65 * abs(sin(phase * (0.45 + seeded(index, salt: 7)) + Double(index)))
                let radius = 0.7 + seeded(index, salt: 41) * 1.8
                let rect = CGRect(x: x, y: y, width: radius, height: radius)

                context.opacity = twinkle * 0.64
                context.fill(Path(ellipseIn: rect), with: .color(.white))
            }
        }
    }

    private func seeded(_ value: Int, salt: Int) -> Double {
        let raw = sin(Double(value * 12_989 + salt * 78_233)) * 43_758.5453
        return raw - floor(raw)
    }
}

struct CelebrationBurst: View {
    let seed: Int

    var body: some View {
        TimelineView(.animation) { context in
            let phase = context.date.timeIntervalSinceReferenceDate

            ZStack {
                ForEach(0..<22) { index in
                    let angle = Double(index) / 22 * .pi * 2
                    let distance = seed == 0 ? 0 : min(180, (phase.truncatingRemainder(dividingBy: 1.4) / 1.4) * 180)

                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: 7, height: 7)
                        .offset(x: cos(angle) * distance, y: sin(angle) * distance)
                        .opacity(seed == 0 ? 0 : max(0, 1 - distance / 180))
                }
            }
            .animation(.easeOut(duration: 0.7), value: seed)
        }
    }

    private var colors: [Color] {
        [AppTheme.cyan, AppTheme.mint, AppTheme.amber, AppTheme.pink, AppTheme.violet, .white]
    }
}
