import SwiftUI

struct ToastMessage: Equatable, Identifiable {
    let id = UUID()
    let text: String
    let symbolName: String

    static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool { lhs.id == rhs.id }
}

private struct ToastOverlay: View {
    let message: ToastMessage

    var body: some View {
        HStack(spacing: Metrics.spacingSM) {
            Image(systemName: message.symbolName)
            Text(message.text)
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, Metrics.spacingLG)
        .padding(.vertical, Metrics.spacingMD)
        .glassEffect(in: Capsule())
        .shadow(color: .black.opacity(0.35), radius: 16, y: 6)
    }
}

private struct ToastModifier: ViewModifier {
    @Binding var message: ToastMessage?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let message {
                    ToastOverlay(message: message)
                        .padding(.bottom, Metrics.spacingXL)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .task(id: message.id) {
                            try? await Task.sleep(for: .seconds(2.2))
                            if self.message?.id == message.id {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    self.message = nil
                                }
                            }
                        }
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: message)
    }
}

extension View {
    /// Shows a transient bottom toast whenever `message` is non-nil, then
    /// clears it automatically after a couple of seconds.
    func toast(_ message: Binding<ToastMessage?>) -> some View {
        modifier(ToastModifier(message: message))
    }
}
