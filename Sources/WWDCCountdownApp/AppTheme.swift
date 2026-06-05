import SwiftUI

enum AppTheme {
    static let deepSpace = Color(red: 0.015, green: 0.017, blue: 0.035)
    static let ink = Color(red: 0.035, green: 0.035, blue: 0.07)
    static let cyan = Color(red: 0.25, green: 0.9, blue: 1)
    static let mint = Color(red: 0.45, green: 1, blue: 0.72)
    static let pink = Color(red: 1, green: 0.34, blue: 0.72)
    static let amber = Color(red: 1, green: 0.72, blue: 0.32)
    static let violet = Color(red: 0.56, green: 0.44, blue: 1)

    static let glowGradient = LinearGradient(
        colors: [cyan, mint, amber, pink, violet],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let orbitGradient = AngularGradient(
        colors: [.clear, cyan, mint, amber, pink, violet, .clear],
        center: .center
    )
}

extension View {
    func glassPanel(cornerRadius: CGFloat = 28) -> some View {
        self
            .padding(24)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.white.opacity(0.16), lineWidth: 1)
            }
            .shadow(color: AppTheme.cyan.opacity(0.18), radius: 28, y: 16)
    }

    func brightCard(cornerRadius: CGFloat = 22) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.white.opacity(0.085))
                    .shadow(color: .black.opacity(0.25), radius: 20, y: 12)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.white.opacity(0.14), lineWidth: 1)
            }
    }
}
