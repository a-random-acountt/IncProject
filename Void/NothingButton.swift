import SwiftUI

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct NothingButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
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
        .accessibilityLabel("Do nothing")
        .accessibilityHint("Logs one more instance of doing absolutely nothing.")
    }
}
