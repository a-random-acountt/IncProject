import SwiftUI

/// Design tokens for Void. Colors are backed by Assets.xcassets color sets
/// (each with its own light/dark appearance) so the system dark mode toggle
/// "just works"; this file only names them and adds spacing/type scale.
extension Color {
    static let appBackground = Color("VoidBackground")
    static let appSurface = Color("VoidSurface")
    static let appSurfaceOverlay = Color("VoidSurfaceOverlay")
    static let appBorder = Color("VoidBorder")
    static let appTextSecondary = Color("VoidTextSecondary")
    static let appTextMuted = Color("VoidTextMuted")
    static let appSuccess = Color("VoidSuccess")
    static let appWarning = Color("VoidWarning")
    static let appDanger = Color("VoidDanger")

    /// Categorical chart colors, in fixed order (never reassigned per-filter).
    static let appSeries1 = Color("VoidSeries1")
    static let appSeries2 = Color("VoidSeries2")
    static let appSeries3 = Color("VoidSeries3")
}

enum Metrics {
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 12
    static let spacingLG: CGFloat = 20
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48

    static let radiusSM: CGFloat = 8
    static let radiusMD: CGFloat = 12
    static let radiusLG: CGFloat = 20

    static let hairline: CGFloat = 1
}

/// A card-like container: one consistent surface, border, and radius used
/// everywhere something needs to read as "a distinct object" (stat tiles,
/// chart cards, achievement badges). Everything else stays flat.
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

    /// A small monospaced numeric style for timestamps, shortcut hints, and
    /// other figures that need to line up in a column. Uses the system's
    /// built-in monospaced design (SF Mono) - no bundled fonts required.
    func monospacedLabel(_ size: CGFloat = 13, weight: Font.Weight = .medium) -> some View {
        font(.system(size: size, weight: weight, design: .monospaced))
    }
}
