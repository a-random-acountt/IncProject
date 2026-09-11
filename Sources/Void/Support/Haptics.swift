import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A tiny wrapper so call sites don't need `#if os(iOS)` sprinkled everywhere.
/// Nothing happens on macOS - there is no haptic engine to speak of, and a
/// beep on every click of a "do nothing" button would be its own kind of joke.
enum Haptics {
    static func tap() {
        #if canImport(UIKit) && !os(visionOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    static func success() {
        #if canImport(UIKit) && !os(visionOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
}
