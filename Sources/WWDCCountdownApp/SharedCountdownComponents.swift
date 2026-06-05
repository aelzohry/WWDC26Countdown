import SwiftUI

struct CountdownGrid: View {
    let snapshot: CountdownSnapshot
    let showSeconds: Bool
    var tileWidth: CGFloat = 120
    var tileHeight: CGFloat = 112
    var valueFontSize: CGFloat = 48

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
                    CountdownTile(
                        label: label,
                        value: value,
                        width: tileWidth,
                        height: tileHeight,
                        valueFontSize: valueFontSize
                    )
                }
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: showSeconds)
    }
}

struct CountdownTile: View {
    let label: String
    let value: Int
    var width: CGFloat = 120
    var height: CGFloat = 112
    var valueFontSize: CGFloat = 48

    var body: some View {
        VStack(spacing: 6) {
            Text(value, format: .number.precision(.integerLength(2)))
                .font(.system(size: valueFontSize, weight: .black, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText(value: Double(value)))
                .animation(.smooth(duration: 0.28), value: value)

            Text(label.uppercased())
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.55))
        }
        .frame(width: width, height: height)
        .brightCard()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(value) \(label)")
    }
}

struct CreatorFooter: View {
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
