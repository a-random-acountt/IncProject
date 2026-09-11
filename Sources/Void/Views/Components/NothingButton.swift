import SwiftUI
import Pow

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

/// The one piece of functionality this app has. Everything else is
/// scaffolding built around the fact that this button does nothing.
struct NothingButton: View {
    var bounceTrigger: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.gradient)
                Circle()
                    .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                VStack(spacing: Metrics.spacingXS) {
                    Image(systemName: "circle.dashed")
                        .font(.system(size: 30, weight: .medium))
                    Text("Do Nothing")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(.white)
            }
            .frame(width: 176, height: 176)
            .shadow(color: Color.accentColor.opacity(0.4), radius: 24, y: 10)
        }
        .buttonStyle(PressScaleButtonStyle())
        .changeEffect(.jump(height: 12), value: bounceTrigger)
        .accessibilityLabel("Do nothing")
        .accessibilityHint("Logs one more instance of doing absolutely nothing.")
    }
}
