import SwiftUI

extension Color {
    static let appBackground = Color("VoidBackground")
    static let appSurface = Color("VoidSurface")
    static let appBorder = Color("VoidBorder")
    static let appTextSecondary = Color("VoidTextSecondary")
    static let appTextMuted = Color("VoidTextMuted")
}

enum Metrics {
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 12
    static let spacingLG: CGFloat = 20
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48

    static let radiusSM: CGFloat = 6
    static let radiusMD: CGFloat = 8
    static let radiusLG: CGFloat = 12

    static let hairline: CGFloat = 1
}

struct CardBackground: ViewModifier {
    var padding: CGFloat = Metrics.spacingLG

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: Metrics.radiusMD, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.radiusMD, style: .continuous)
                    .strokeBorder(Color.appBorder, lineWidth: Metrics.hairline)
            )
    }
}

extension View {
    func cardBackground(padding: CGFloat = Metrics.spacingLG) -> some View {
        modifier(CardBackground(padding: padding))
    }

    func monospacedLabel(_ size: CGFloat = 13, weight: Font.Weight = .medium) -> some View {
        font(.system(size: size, weight: weight, design: .monospaced))
    }
}
