import Foundation
#if os(iOS)
import AudioToolbox
#elseif os(macOS)
import AppKit
#endif

/// Plays the single sound effect this app needs: a small, satisfying click
/// that confirms nothing happened. Uses each platform's built-in system
/// sounds rather than bundling audio assets.
enum SoundPlayer {
    static func playClick() {
        #if os(iOS)
        AudioServicesPlaySystemSound(1104) // the standard iOS keyboard "tock"
        #elseif os(macOS)
        NSSound(named: "Tink")?.play()
        #endif
    }
}
