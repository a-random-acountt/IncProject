import SwiftUI

/// Button variants modeled on shadcn/ui's `buttonVariants`, rebuilt directly
/// in this codebase for Void's Vercel-black theme rather than pulled in as a
/// black-box dependency - the same "copy it, own it, customize it" spirit
/// shadcn/ui itself is built on (see community ports like SwiftCN and
/// swiftcn-ui for a packaged alternative, if you'd rather depend on one).
///
/// `.primary` is the one Vercel convention worth calling out: the CTA fill
/// is an inverted white-on-black, not the accent color - the accent is
/// reserved for small, sparing highlights elsewhere.
enum ShadcnButtonVariant {
    case primary
    case secondary
    case ghost
    case destructive
}

struct ShadcnButtonStyle: ButtonStyle {
    var variant: ShadcnButtonVariant = .primary
    var fullWidth: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, Metrics.spacingLG)
            .padding(.vertical, Metrics.spacingSM + 2)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .foregroundStyle(foreground)
            .background(background(pressed: configuration.isPressed))
            .clipShape(RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous)
                    .strokeBorder(border, lineWidth: Metrics.hairline)
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }

    private var foreground: Color {
        switch variant {
        case .primary: return .black
        case .secondary, .ghost: return .primary
        case .destructive: return .appDanger
        }
    }

    private func background(pressed: Bool) -> Color {
        switch variant {
        case .primary: return pressed ? Color.white.opacity(0.85) : .white
        case .secondary: return pressed ? Color.appSurfaceOverlay : Color.appSurface
        case .ghost: return pressed ? Color.appSurface : .clear
        case .destructive: return pressed ? Color.appDanger.opacity(0.14) : .clear
        }
    }

    private var border: Color {
        switch variant {
        case .primary, .ghost: return .clear
        case .secondary: return Color.appBorder
        case .destructive: return Color.appDanger.opacity(0.4)
        }
    }
}

extension ButtonStyle where Self == ShadcnButtonStyle {
    static var shadcnPrimary: ShadcnButtonStyle { ShadcnButtonStyle(variant: .primary) }
    static var shadcnSecondary: ShadcnButtonStyle { ShadcnButtonStyle(variant: .secondary) }
    static var shadcnGhost: ShadcnButtonStyle { ShadcnButtonStyle(variant: .ghost) }
    static var shadcnDestructive: ShadcnButtonStyle { ShadcnButtonStyle(variant: .destructive) }

    static func shadcn(_ variant: ShadcnButtonVariant, fullWidth: Bool = false) -> ShadcnButtonStyle {
        ShadcnButtonStyle(variant: variant, fullWidth: fullWidth)
    }
}
