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
                // Vercel's primary-CTA convention: inverted white-on-black,
                // not the accent color - accent stays a sparing highlight
                // elsewhere (stat icons, the unlocked-badge ring, links).
                Circle()
                    .fill(.white)
                VStack(spacing: Metrics.spacingXS) {
                    Image(systemName: "circle.dashed")
                        .font(.system(size: 30, weight: .medium))
                    Text("Do Nothing")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(.black)
            }
            .frame(width: 176, height: 176)
        }
        .buttonStyle(PressScaleButtonStyle())
        .changeEffect(.jump(height: 12), value: bounceTrigger)
        .accessibilityLabel("Do nothing")
        .accessibilityHint("Logs one more instance of doing absolutely nothing.")
    }
}
