import SwiftUI

/// A small labeled tag, modeled on shadcn/ui's `Badge` (rounded-rect, not a
/// full pill - that's the "New York" style default). Used for changelog
/// tags today; reach for it anywhere else a short status label is needed.
struct ShadcnBadge: View {
    enum Tone {
        case neutral, accent, success, warning, danger
    }

    let text: String
    var tone: Tone = .neutral

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, Metrics.spacingSM)
            .padding(.vertical, 2)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.radiusSM, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: Metrics.hairline)
            )
    }

    private var foreground: Color {
        switch tone {
        case .neutral: return .primary
        case .accent: return .accentColor
        case .success: return .appSuccess
        case .warning: return .appWarning
        case .danger: return .appDanger
        }
    }

    private var background: Color {
        switch tone {
        case .neutral: return Color.appSurface
        case .accent: return Color.accentColor.opacity(0.12)
        case .success: return Color.appSuccess.opacity(0.12)
        case .warning: return Color.appWarning.opacity(0.12)
        case .danger: return Color.appDanger.opacity(0.12)
        }
    }

    private var borderColor: Color {
        tone == .neutral ? Color.appBorder : .clear
    }
}
